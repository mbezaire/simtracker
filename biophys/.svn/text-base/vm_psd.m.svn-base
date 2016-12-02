function [P F Y] = vm_psd(V, sr, b, a)
% power spectra of voltage traces
% function [P F Y] = vm_psd(V, sr, ti, b, a)
% V - cell array of voltage traces (one per column)
% sr - sample rate (20 kHz)
% b, a - optional filter coefficients; default gives 4th order
% Chebyshev, stop band edge at 20 Hz, stop band ripple 60 dB
% return values:
% P - cell array of PSD
% F - frequency vector
% Y - low-pass filtered input
  if nargin < 2, sr = 20e3; end
  if nargin < 4
    [b a] = cheby2(4,60,40/(sr/2),'low');
  end
  freq = 0:.025:10;
  n = size(V,2);
  for k = 1:n
    Y{k} = filter(b,a,V{k}-mean(V{k}));
    [P{k} F] = periodogram(Y{k},[],freq,sr);
  end
end
