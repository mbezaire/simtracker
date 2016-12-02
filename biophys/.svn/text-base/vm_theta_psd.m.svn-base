function [P F] = vm_theta_psd(V, sr, psdh, flim)
% theta band power spectra of voltage traces
% function [P F] = vm_theta_psd(V, sr)
% V - cell array of voltage traces (one per column)
% sr - sample rate (20 kHz)
% psdh - handle to Matlab PSD method (@periodogram)
% flim - [start end] frequency limit ([1 12])
% return values:
% P - double array of PSD column-wize
% F - frequency vector
% each data vector is detrended and windowed
  if nargin < 4 || isempty(flim), flim = [1 12]; end
  if nargin < 3, psdh = @periodogram; end
  if nargin < 2, sr = 20e3; end
  fi = functions(psdh);
  df = 0.25; % frequency resolution
  if strcmp(fi.function,'periodogram')
    fv = flim(1):df:flim(2);
    nfft = length(fv);
  else
    nfft = 2^nextpow2(sr/(2*df));
  end
  n = size(V,2);
  P = zeros(nfft,n);
  for k = 1:n
    L = length(V{k});
    if strcmp(fi.function,'periodogram')
      [p F] = psdh(detrend(V{k}),hamming(L),fv,sr);
    else
      if strcmp(fi.function,'pwelch')
        [p f] = psdh(detrend(V{k}),[],[],nfft,sr);
      else
        % pmtm size limit (undocumented)
        if length(V{k}) >= 2^20
          m = floor(length(V{k})/2);
          v = V{k}(m-2^18:m+2^18);
        else
          v = V{k};
        end
        [p f] = psdh(detrend(v),[],nfft,sr);
      end
      if k == 1
        r = min(find(f>=flim(1))):max(find(f<=flim(2)));
        F = f(r);
      end
      p = p(r);
    end
    % remove 1/f (noise?), normalize for signal length
    P(:,k) = detrend(10*log10(p/L)); 
  end
end
