function ShowSpectroResults()

% 8 Hz sin wave
t=[0:.5:5000];
y=100*sin(50.266*t/1000); % 8 Hz oscillation
lfp=[];
lfp(:,1)=t;lfp(:,2)=y;
zh=newmikkoscript(lfp);
close(zh(1:end-1))
figure(zh(end));title('8 Hz sin wave')

% Top half of sin wave only
y2=y;
zz=find(y2<90);
y2(zz)=90;
lfp(:,2)=y2;
zh=newmikkoscript(lfp);
close(zh(1:end-1))
figure(zh(end));title('8 Hz sin wave with y<90 -> y=90')

% Top half of sin wave + gamma
z1=.6*sin(408.407*t/1000); % 65 Hz oscillation
%z2=.05*sin(188.496*t/1000); % 35 Hz oscillation
z = z1+y2;
lfp(:,2)=z;
zh=newmikkoscript(lfp);
close(zh(1:end-1))
figure(zh(end));title('8 Hz sin wave with y<90 -> y=90 and a low amplitude 65 Hz gamma wave added')


function zh=newmikkoscript(lfp)

fs = 2000;
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
    
%     subplot(2,1,2)
    tax=subplot('position',[0.05 0.05 0.85 0.4]);
    
    clear S; clear F, clear T, clear P;
    [S,F,T,P] = spectrogram(s,nfft,round(0.95*nfft),nfft,fs);
    set(zh(4),'Numbertitle','off');%,'toolbar','none','menubar','none');

    q =1+ round(nfft*f1/fs);
    r = round(nfft*f2/fs);

    surf(T,F(q:r),10*log10(P(q:r,:)),'edgecolor','none'); axis tight; 
    view(0,90);
    xlabel('Time (Seconds)'); ylabel('Hz');
    
    
    %    linkaxesInFigure('x');
%      subplot('position',[0.92 0.05 0.04 0.4]);

      colorbar
%      hg = tightfig(hg);

    
%     subplot(2,1,1)
    subplot('position',[0.05 0.5 0.79 0.4]);
    plot(t,s);
    tx=xlim;
    set(tax,'xLim',tx);


