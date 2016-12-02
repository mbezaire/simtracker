function [f, fft_results]=myfft(spikes,duration,varargin)

binst=0;
    if isempty(varargin)
        rez=1; % .1 is simulation resolution
    else
        rez=varargin{1};
        if length(varargin)>1
            binst=varargin{2};
        end
    end

    Fs = 1000/rez; % sampling frequency (per s)

    bins=[binst:rez:duration];
    y=histc(spikes,bins);
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));