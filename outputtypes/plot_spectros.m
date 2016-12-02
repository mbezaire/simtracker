function h=plot_spectros(hObject,handles)
global RunArray

h=[];
ind = handles.curses.ind;
%myflag=0;

tmp=deblank(handles.optarg);
rtmp={};



rez=RunArray(ind).lfp_dt;
for r=1:length(handles.curses.cells)    
    if strcmp(handles.curses.cells(r).name,'pyramidalcell')
        idx = find(handles.curses.spikerast(:,2)>=handles.curses.cells(r).range_st & handles.curses.spikerast(:,2)<=handles.curses.cells(r).range_en);
        idt = 1:length(idx); % find(handles.curses.spikerast(idx,1)>50);

        Fs = 1000/rez; % sampling frequency (per s)

        bins=[0:rez:RunArray(ind).SimDuration];
        y=histc(handles.curses.spikerast(idx(idt),1),bins);
        y = y-sum(y)/length(y);
        lfp(:,1)=bins;
        lfp(:,2)=y;
        hz=newmikkoscript(lfp);
        hm=plot_spectrogram(lfp(:,2),1000/rez);
        title('Pyramidal Spike Spectrogram')
    end
end

ht=newmikkoscript(handles.curses.lfp,1000/rez);

hw=plot_spectrogram(handles.curses.lfp(:,2),1000/rez);
title('Pyramidal LFP Spectrogram')

h=[hz hm ht hw];

function h=plot_spectrogram(data,srate)
% Written by Jesse Jackson, jc.jackson27@gmail.com
%you must have Chronux installed on your computer to get this to work http://chronux.org/
%also, play with the time-bandwidth product(4) and tapers (7) also try ([3 5]).  
% input: data is the time series of the LFP and srate is the sample rate
% note: for theta, it is best to downsample data to 1kHz to speed up
% processing, but not necessary
% data=data*1000;% from microV to mV
params=struct('tapers',[3 5],'pad',1,'Fs',srate,'fpass',[1 200],'err',[1 0.01],'trialave',0);%%% 
[S,t,f]=mtspecgramc(data,[4 .001],params);% here I use a 5 s analysis and sweep through in 0.1s chunks, but change this accordingly for faster propcessing
h=figure('Color','w');
imagesc(t,f,S');axis xy;ylim([1 25]);
xlabel('Time (s)')
ylabel('Frequency (Hz)')


function zh=newmikkoscript(lfp,fs)

% fs = 2000;
% t = 0:(1/fs):5-1/fs;
% s = 0.5*sin(2*pi*t*7) + sin(2*pi*t*15) + 0.125*sin(2*pi*t*40);

t = lfp(:,1)/1000;
s = lfp(:,2);
s = s - sum(s)/numel(s);


% theta

Fsfilter = 100;
np = 1000;

att = 60; % 60 dB down at f1 and f4

Dstop1 = 10^(-att/2/20);  % First Stopband Attenuation
Dpass  = 0.057501127785;                  % Passband Ripple
Dstop2 = 10^(-att/2/20);  % First Stopband Attenuation

  f1 = 3; f2 = 4; f3 = 12;  f4 = 13;
%  f1 = 14; f2 = 15; f3 = 25;  f4 = 26;

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([f1 f2 f3 f4]/(Fsfilter/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);
                         
flag   = 'scale';          % Sampling Flag
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);

zh(1)=figure('Color','w');
[h,f] = freqz(Hd.Numerator,1,np,Fsfilter);
plot(f,2*20*log10(abs(h)),'b','linewidth',2);
xlim([0 20]); ylim([-80 10]);
hold off
grid
Hd_theta_4_10 = Hd;


% ---------------------

% from 2k to 100
sl = decimate(s,20);

%filter fs = 100

slf = filtfilt(Hd_theta_4_10.Numerator,1,sl);

% from 100 back to 2k
sf = resample(slf,20,1);

zh(2)=figure('Color','w')
plot(t,s);
hold on
plot(t,sf(1:numel(s)),'r');
hold off

zh(3)=figure('Color','w')
plot(t,sf(1:numel(t)));



nfft = 1024; 
f1= 1; f2 =100;

    zh(4) = figure('Color','w');
    set(zh(4),'position',[100 100 1200 600]);
    
%     subplot(2,1,1)
    subplot('position',[0.05 0.5 0.79 0.4]);
    plot(t,s);
    
%     subplot(2,1,2)
    subplot('position',[0.05 0.05 0.85 0.4]);
    
    clear S; clear F, clear T, clear P;
    [S,F,T,P] = spectrogram(s,nfft,round(0.95*nfft),nfft,fs);
    set(zh(4),'Numbertitle','off');%,'toolbar','none','menubar','none');

    q =1+ round(nfft*f1/fs);
    r = round(nfft*f2/fs);

    surf(T,F(q:r),10*log10(P(q:r,:)),'edgecolor','none'); axis tight; 
    view(0,90);
    xlabel('Time (Seconds)'); ylabel('Hz');
    ylim([2 25])
    
    %    linkaxesInFigure('x');
%      subplot('position',[0.92 0.05 0.04 0.4]);

      colorbar
%      hg = tightfig(hg);





