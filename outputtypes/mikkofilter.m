function filteredlfp=mikkofilter(lfp,fs,varargin)


if isempty(varargin)
    filtrange=[5 10];
else
    filtrange=varargin{1}; %[25 80];
end

% t = 0:(1/fs):5-1/fs;
% s = 0.5*sin(2*pi*t*7) + sin(2*pi*t*15) + 0.125*sin(2*pi*t*40);

t = lfp(:,1)/1000;
s = lfp(:,2);
s = s - sum(s)/numel(s);
s=s(1:end-1);
t=t(1:end-1);

 ll1 = mod(length(s),1000);
 if ll1 == 0
     ll1 = 200;
 end
 s(end-ll1+2:end,:) = [];
 t(end-ll1+2:end,:) = [];


  %f1 = 3; f2 = 4; f3 = 12;  f4 = 13;
  %f1 = 7; f2 = 8; f3 = 8;  f4 = 9;
% frequency band edges  2 to 10
 f1 = filtrange(1)-1; f2 = filtrange(1); f3 = filtrange(2);  f4 = filtrange(2)+1;

% theta

%Fsfilter = 100; %100;
FsfiltDownFactor = 100; %100;
Fsfilter=fs/FsfiltDownFactor;
while Fsfilter/2<=max([f1 f2 f3 f4])
    FsfiltDownFactor = FsfiltDownFactor/2; %100;
    Fsfilter=fs/FsfiltDownFactor;
end
np = 1000;

%att = 60; % 60 dB down at f1 and f4
att = 35; % 30 dB down at f1 and f4

Dstop1 = 10^(-att/2/20);  % First Stopband Attenuation
Dpass  = 0.057501127785;                  % Passband Ripple
Dstop2 = 10^(-att/2/20);  % First Stopband Attenuation

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([f1 f2 f3 f4]/(Fsfilter/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);
                         
flag   = 'scale';          % Sampling Flag
% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);

% zh(1)=figure('Color','w');
% [h,f] = freqz(Hd.Numerator,1,np,Fsfilter);
% plot(f,2*20*log10(abs(h)),'b','linewidth',2);
% xlim([0 20]); ylim([-80 10]);
% hold off
% grid
Hd_theta_4_10 = Hd;


% ---------------------

% from higher to lower resolution
sl = decimate(s,FsfiltDownFactor); % fs/Fsfilter

%filter fs = lowerres

slf = filtfilt(Hd_theta_4_10.Numerator,1,sl);

% from lower back to higher resolution
sf = resample(slf,FsfiltDownFactor,1); % fs/Fsfilter

filteredlfp=[reshape(t,length(t),1)*1000 reshape(sf(1:numel(s)),length(s),1)];