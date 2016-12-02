% plot impedance from ZAP responses
% plot_imp(Z,sr,M)
% Z -- impedance vector
% sr -- sample rate (Hz)
% M -- (optional) RLC model parameters (4 element vector)
% first load zap_res.mat
% choose a file, subtract one from its spreadsheet row number
function plot_imp(Z,sr,flim,M)
  if nargin < 3 || ~numel(flim), flim = [0 20]; end
  f = linspace(0,sr/2,size(Z,1));
  w=min(find(f>=flim(1))):max(find(f<=flim(2))); % frequencies in range
  if nargin > 2 && size(M,2) == 4
    
    plot(f(w),[Z(w,:) rlc_impedance_curve(M,pi*f(w)/f(end))'])
  else
    plot(f(w),Z(w,:))
  end
end
