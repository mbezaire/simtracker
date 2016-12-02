% generate ZAP resonance analysis for all ABF data files in argument list

function zap_res(zapf,matf)
% zapf - list of ZAP recording files in ABF format, or file containing list
% matf - output MAT filename (zap_res)  
  if nargin < 2, matf = mfilename; end
  if ischar(zapf) && exist(zapf,'file')
    c = textscan(fopen(zapf),'%s','delimiter','');
    zapf = c{1};
  end
  n = length(zapf);
  F=zeros(n,1);
  Q=zeros(n,1);
  Zr=zeros(n,1);
  for k=1:n
    [data si] = abfload(zapf{k});
    sr(k) = 1e6/si;
    Z{k} = impedance(data(:,2)',data(:,1)',sr(k),1)';
    [M(k,:) F(k) Q(k) rmse(k)] = rlc_fits(Z{k},sr(k));
    Zr(k) = Q(k)*rlc_impedance_curve(M(k,:),0);
  end
  save(matf,'zapf','sr','Z','M','Zr','F','Q','rmse')
  res_csv(matf);
end
