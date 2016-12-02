function [Z, f] = impedance(I, V, Fs, no_null)
% give input current vector, response voltage signal array (by rows) and sample
% rate, returns impedance array and frequency vector
% nulls DC value (first element of impedance), set optional 4th arg. to disable
  [X f] = fft_mag(I,Fs);
  Y = fft_mag(V,Fs);
  Z = Y./repmat(X,size(Y,1),1);
  if nargin < 4 || ~no_null, Z(:,1) = 0; end
end
