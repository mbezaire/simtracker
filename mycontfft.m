function [f, fft_results]=mycontfft(time,voltage)

    rez=time(2)-time(1);

    Fs = 1000/rez; % sampling frequency (per s)

    y=voltage;
    y = y-sum(y)/length(y);

    NFFT = 2^(nextpow2(length(y))+2); % Next power of 2 from length of y
    Y = fft(y,NFFT)/length(y);
    f = Fs/2*linspace(0,1,NFFT/2+1);
    fft_results = 2*abs(Y(1:NFFT/2+1));