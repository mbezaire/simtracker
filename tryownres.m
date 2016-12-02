function [resFreq, Q, peakZ, f, Z]=tryownres(current,voltage,Fs,flim)


% take fft of each (and get f)
  [X, f] = fft_mag(current,Fs);
  Y = fft_mag(voltage,Fs);



% compute the Z
  Z = Y./repmat(X,size(Y,1),1);


% compute the peakZ, Q, and res
inds = find((f>flim(1)) & (f<flim(2)));
f2 =f(inds);Z2 = Z(inds);
[peakZ, resFreqIdx] = max(Z2);
resFreq = f2(resFreqIdx);

Q = peakZ/Z2(1);


function [F, f] = fft_mag(Vm,Fs)
% give array of waveforms in rows and optional sample rate
% returns array of FFTs in rows and optional frequency vector
  if nargin < 2, Fs = 1e4; end;
  L = size(Vm,2);
  N = 2^nextpow2(L);
  f = Fs/2*linspace(0,1,N/2+1);
  for k = 1:size(Vm,1)
    X = Vm(k,:)-mean(Vm(k,:));
    Y = fft(X,N)/L;
    F(k,:) = 2*abs(Y(1:N/2+1));
  end