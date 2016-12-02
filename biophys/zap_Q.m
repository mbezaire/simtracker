function [Q, F, M, E, zm] = zap_Q(Z,f,flim,m0)
rng(0,'twister')
% find the Q values for resonance peaks in ZAP responses (row array)
% runs simulation with fixed inputs to get Z(0) for dorsal and
% ventral cells
% args:
% Z -- impedance array
% f -- frequency vector (length same as Z)
% flim -- limit consideration within frequency limits flim
% m0 -- initial parameters [R Rl L C] (default in rlc_impedance_model)
% returns Q, resonance frequency, RLC model parameters, sq_err
  if nargin < 4, m0 = [1 10 100 1000]; end
  if nargin < 3 || isempty(flim), flim = [.5 20]; end
  w = min(find(f > flim(1))):max(find(f < flim(2)));
  max_trial = 8;
  t = 0;
  e = Inf;
  while t < max_trial
    t = t + 1;
    [M S] = rlc_impedance_model(pi*f(w)/f(end),Z(w),m0);
    if S(1).sqerr < 1e-2, break; end
    if S(1).sqerr < e
      M0 = M; S0 = S; e = S(1).sqerr;
    end
    if mod(t,2), m0 = m0 * t; else m0 = m0 / t; end
  end
  if t == max_trial
    M=M0; S=S0;
  end
  E = sqrt(S(1).sqerr/length(w));
  z = rlc_impedance_curve(M,pi*f(1:w(end))/f(end));
  [zm k] = max(z);
  Q = zm/z(1);
  F = f(k);
end
