% function flt(fn)
runname='';
if isempty(runname) || isempty(mypath) || isempty(sl)
    msgbox('No run specified or other info missing')
else
        load([mypath sl 'data' sl 'myrepos.mat'],'myrepos')
        q=find([myrepos.current]==1);

fn = [myrepos(q).dir 'results' sl runname sl 'lfp.dat'];
%fn = 'lfp_27.dat';
% s = rand(numel(t),1);
w = textread(fn);
% s = 0.5*sin(2*pi*t*7) + sin(2*pi*t*15) + 0.125*sin(2*pi*t*40);
w= w(1:end-1,:);
t = w(:,1)/1000;
s = w(:,2);
 
%  
% adjust  length so it works when doing downsampling/upsampling
%  
 ll1 = mod(length(s),1000);
 if ll1 == 0
     ll1 = 200;
 end
 s(end-ll1+2:end,:) = [];
 t(end-ll1+2:end,:) = [];
 
%       remove 0 frequency
s = s - sum(s)/numel(s);

% sampling rate
fs = 1/t(2);

%downsampling factor
dfc = 100;

% sampling rate during filtering
Fsfilter = fs/dfc;
np = 1000;

att = 35; % 30 dB down at f1 and f4

Dstop1 = 10^(-att/2/20);  % First Stopband Attenuation
Dpass  = 0.57501127785;                  % Passband Ripple
Dstop2 = 10^(-att/2/20);  % First Stopband Attenuation

% frequency band edges  2 to 10
 f1 = 1; f2 = 2; f3 = 10;  f4 = 11;

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([f1 f2 f3 f4]/(Fsfilter/2), [0 1 0], [Dstop1 Dpass Dstop2]);
                         
flag   = 'scale';          % Sampling Flag
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);
 %length(Hd.Numerator)
% figure(29)
% stem(Hd.Numerator);
% 

% plot filter 
figure
[h,f] = freqz(Hd.Numerator,1,np,Fsfilter);
plot(f,2*20*log10(abs(h)),'b','linewidth',2);
xlim([0 20]); ylim([-80 10]);
hold off
grid
title('filter characteristics');
Hd_theta_4_10 = Hd;


% ---------------------

% fdownsample from 10k to 100
sl = decimate(s,dfc);

% do filtering in both directions  fs = 100
slf = filtfilt(Hd_theta_4_10.Numerator,1,sl);

% from 100 back to 10k
sf = resample(slf,dfc,1);

figure
plot(t,s);      % plot raw
hold on
plot(t,sf(1:numel(s)),'r','linewidth',2); % plot filtered
hold off
ylim([-5 5]);

title('raw signal (blue) filtered signal (red)');

% plot filtered
figure
plot(t,sf(1:numel(t)));
title('filtered signal');
end
