function [M F Q E] = rlc_fits(Z,Fs,flim)
% get RLC model parameters, resonance frequency and Q value
% Z -- array of ZAP impedance (file index in column)
% Fs -- sample rate (1kHz)
  n = size(Z,2);
  Q = zeros(n,1);
  F = zeros(n,1);
  M = zeros(n,4);
  E = zeros(n,1);
  if nargin < 3, flim = [1 20]; end
  f = linspace(0,Fs/2,size(Z,1));
  for k=1:n
    [Q(k) F(k) M(k,:) E(k)] = zap_Q(Z(:,k)',f,flim);
    if abs(F(k) - flim(2)) < 1
      fprintf(2,['warning: impedance vector %d; ' ...
                 'model peak frequency (%g) near range limit (%g)\n'],...
              k,F(k),flim(2));
    end
  end
end
