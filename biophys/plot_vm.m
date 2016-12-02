function plot_vm(abf, lbl)
  if nargin < 2, lbl = ''; end
  [data si] = abfload(abf);
  t = 0:si*1e-6:(length(data)-1)*si*1e-6;
  plot(t,data(:,1));
  xlabel('time (sec)');
  ylabel('mV');
  V = detrend(data(:,1));
  title(sprintf('ZAP response %s, V_{rms}=%.2f mV', lbl, sqrt(mean(V .* V,1))))
end
