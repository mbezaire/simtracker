function results = thetafilter(varargin)
% results = thetafilter(timevec,signalvec,freq)
% timevec = vector of the sampling times
% signalvec = vector of the signal values
% freq = frequency of interest (default 8 Hz)
%
% if this function is called with no arguments,
% an example signal with noise is created, an 8.2 Hz sin wave
%
% This function contains a results structure:
% results.rms: the root mean squared amplitude
% results.peak: the rms * sqrt(2)
% results.filtsig: the downsampled, filtered signal
% results.filtime: the downsampled time vector
% results.peaks: the indices of the peaks in the signal


sigint = 8;

if isempty(varargin)
    % sg = importdata('v.txt');
    % s = sg(:,2);
    fs = 10000;
    ts = 1/fs;
    t = 0:ts:5-ts;


    nse = -0.5 + rand(length(t),1)';


    s = sin(2*pi*8.2*t);

    s = s + 0.5*nse;
else
    t = varargin{1};
    s = varargin{2};
    if length(varargin)>2
        sigint=varargin{3};
    end
end

% s is the input signal array

% figure(1)
% plot(t,s)
% title('original signal fs = 10 kHz');

sd = decimate(s,20);
td = decimate(t,20);

% figure(2)
% plot(td,sd)
% title('downsampled signal fs = 500 Hz');

Fs = 500;  % Sampling Frequency

Fstop1 = sigint-1.75;               % First Stopband Frequency
Fpass1 = sigint-0.75;               % First Passband Frequency
Fpass2 = sigint+0.75;               % Second Passband Frequency
Fstop2 = sigint+1.75;              % Second Stopband Frequency
Dstop1 = 0.1;             % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.1;             % Second Stopband Attenuation
flag   = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);



% % 
% % % Filter Design
% % 
% % Fs = 500;  % Sampling Frequency
% % 
% % Fstop1 = 3;                % First Stopband Frequency
% % Fpass1 = 4;                % First Passband Frequency
% % Fpass2 = 10;               % Second Passband Frequency
% % Fstop2 = 11;               % Second Stopband Frequency
% % Dstop1 = 0.0031622776602;  % First Stopband Attenuation
% % Dpass  = 0.057501127785;   % Passband Ripple
% % Dstop2 = 0.0031622776602;  % Second Stopband Attenuation
% % flag   = 'scale';          % Sampling Flag
% % 
% % % Calculate the order from the parameters using KAISERORD.
% % [N,Wn,BETA,TYPE] = kaiserord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 ...
% %                              1 0], [Dstop1 Dpass Dstop2]);
% % 
% % % Calculate the coefficients using the FIR1 function.
% % b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
% % Hd = dfilt.dffir(b);
% % 
% % 


% [h f ] = freqz(Hd.Numerator,1,10000,500);
% figure(3)
% plot(f(1:1000),20*log10(abs(h(1:1000))));
% grid
% title('theta filter');

sf = filtfilt(Hd.Numerator,1,sd);


figure('Color','w')
plot(td,sf)
title(' filtered signal fs = 500 Hz');


% figure(5)
%  hs = spectrum.periodogram;
%  psd(hs,s,'Fs',10000,'NFFT',8096);
% title('spectrum of unfiltered signal fs = 10kHz');
% 
% figure(6)
%  hs = spectrum.periodogram;
%  psd(hs,sd,'Fs',500,'NFFT',8096);
% title('spectrum of unfiltered signal fs = 500 Hz');
% 
% figure(7)
%  hs = spectrum.periodogram;
%  psd(hs,sf,'Fs',500,'NFFT',8096);
% title('spectrum of filtered signal fs = 500 Hz');


%[locs peakvalues] = findpeaks(sf,'minpeakheight',0.5,'minpeakdistance',30);

sfrms = sqrt(sum((sf.*sf))/length(sf));

sfpeak = sfrms*sqrt(2);

results.rms = sfrms;
results.peak = sfpeak;
results.filtsig = sf;
results.filtime = td;
%results.peaks = findpeaks(sf,sfrms); % has some error, expecting
%parameter/value pairs instead of a single number for sfrms

aa=0;

