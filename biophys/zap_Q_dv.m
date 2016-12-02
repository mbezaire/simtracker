function Q = zap_Q_dv(p,Z,f)
% find the Q values for resonance peaks in ZAP responses Vm (row array)
% runs simulation with fixed inputs to get Z(0) for dorsal and
% ventral cells
% args:
% parameters used in simulation
% Z -- impedance, row array
% f -- frequency vector (length same as Z)
  % find Vm for fixed injection
  Z0 = sim_Z0(p);
  % Q values
  m = size(Z,1)/2;
  b = intersect(find(f > 1), find(f <= p.zap.freq));
  for k = 1:2
    a = sub2ind([m 2], 1:m, repmat(k,1,m));
    Q(a) = max(Z(a,b)')/Z0(k);
  end
end

function Z0 = sim_Z0(p)
  zap = p.zap;
  p = rmfield(p,'zap');
  p.t_init=0;
  p.t_end=1e3;
  for k=1:2
    p.is_ventral=k-1;
    p.I_app=0;
    mec2sc_scm(p);
    load mec2sc_scm
    V0(k) = y(end,1);  % resting potential
    p.I_app = zap.ampl;
    mec2sc_scm(p);
    load mec2sc_scm
    Z0(k) = (y(end,1) - V0(k))/p.I_app;
  end
end
