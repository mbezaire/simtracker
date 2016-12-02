function [freq peak] = peak_freq(Vm, Fs, tr)
% find peak frequency in membrane potential array
% Vm - signal array, one per row
% Fs - sampling frequency (Hz)
% tr - optional analysis range [1 12] (Hz)
  df = 0.05;
  if nargin < 3
    tr = [1 12];  % theta freq. range
    if nargin < 2
      Fs = 1e4;
    end
  end
  fv = tr(1):df:tr(2);
  W = hamming(length(Vm));
  for k = 1:size(Vm,1)
    [P F] = periodogram(detrend(Vm(k,:)),W,fv,Fs);
    [m i] = max(P);
    peak(k) = m;
    freq(k) = F(i);
  end
end
