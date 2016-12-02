function varargout = mikkoscript(s,inFs,varargin)
%  varargout = mikkoscript(s,inFs,[theta range])  Written by Mikko Ojala
% s is the input signal array
% inFs is the input signal sampling frequency
% thetarange (optional) is a two element array with the bounds of the theta range
% this function filters the data to include only frequencies in the
% theta range, default from 4 - 10 Hz
%
% optional output argument is the results object, the downsampled,
%  filtered signal
showfigs=0;
if ~isempty(varargin)
    thetarange=varargin{1};
    if length(varargin)>1
        showfigs=varargin{2};
    end
else
    thetarange=[4 10];
end

Fs = 500;  % Sampling Frequency

%if nargout==0
if showfigs==1
    figure;%(1)
    plot(s)
    title(['original signal fs = ' num2str(inFs) ' Hz']);
end

sd = decimate(s,inFs/Fs);

%if nargout==0
if showfigs==1
    figure;%(2)
    plot(sd)
    title(['downsampled signal fs = ' num2str(Fs) ' Hz']);
end

% Filter Design


Fstop1 = thetarange(1)-1;                % First Stopband Frequency
Fpass1 = thetarange(1);                % First Passband Frequency
Fpass2 = thetarange(2);               % Second Passband Frequency
Fstop2 = thetarange(2)+1;               % Second Stopband Frequency
Dstop1 = 0.0031622776602;  % First Stopband Attenuation
Dpass  = 0.057501127785;   % Passband Ripple
Dstop2 = 0.0031622776602;  % Second Stopband Attenuation
flag   = 'scale';          % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);




[h f ] = freqz(Hd.Numerator,1,10000,500);
%if nargout==0
if showfigs==1
    figure;%(3)
    plot(f(1:1000),20*log10(abs(h(1:1000))));
    grid
    title('theta filter');
end

sf = filtfilt(Hd.Numerator,1,sd);


%if nargout==0
if showfigs==1
    figure;%(4)
    plot(sf)
    title(' filtered signal fs = 500 Hz');
end

%if nargout==0
if showfigs==1
    figure;%(5)
    hs = spectrum.periodogram;
    psd(hs,s,'Fs',inFs,'NFFT',8096);
    title(['spectrum of unfiltered signal fs = ' num2str(inFs) '  Hz']);

    figure;%(6)
    hs = spectrum.periodogram;
    psd(hs,sd,'Fs',500,'NFFT',8096);
    title('spectrum of unfiltered signal fs = 500 Hz');

    figure;%(7)
    hs = spectrum.periodogram;
    psd(hs,sf,'Fs',500,'NFFT',8096);
    title('spectrum of filtered signal fs = 500 Hz');
end
if nargout==1
    hs = spectrum.periodogram;
    %varargout{1} = psd(hs,sf,'Fs',500,'NFFT',8096);
    try
    varargout{1}=[[0:(1/500):((length(sf)-1)/500)]' sf'];
    catch
    varargout{1}=[[0:(1/500):((length(sf)-1)/500)]' sf];
    end
end


