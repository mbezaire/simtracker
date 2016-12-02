function [fmax, mp] = fft_peak(Vm, Fs, nfft)
% Give signal waveforms array, returns a struct of
% mean and std of frequency of max. FFT of waveforms, and average
% value of waveform, averaging corresponding rows in the waveform
% arrays of all cells
  n = size(Vm,1);
  df = 0.05;
  d = zeros(1,n);
  u = zeros(1,n);
  mp = zeros(1,n);
  if nargin < 3
    nfft = 512;
    if nargin < 2
      Fs = 1000; 
    end
  end
  for k = 1:n 
    x = Vm(k,:);
    mp(k) = mean(x);
    % Get a spectrogram, giving the amplitudes of the frequency
    % components over time
    s = spectrogram(x-mp(k), hamming(nfft), floor(.94*nfft), 0:df:40, Fs); 
    % Get the frequency that has the peak amplitude for each time window
    [mv mi] = max(abs(s));  % peak frequency for every window step
    % Get the mean and std. of these peaks for this trial
    f = df*mi;
    u(k) = mean(f);
    d(k) = std(f);
  end
  fmax = struct('mean', u, 'std', d);
end
