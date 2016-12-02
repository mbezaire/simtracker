function dy = subthld_osc_sys(t, y, p)
% dynamical system equations passed to ODE
% t -- current time step
% y -- state variable vector
% p -- fixed parameters (struct)
  global I; % defined in subthresh_oscilln
  
  x = p.step_fcn(y, p);
  dy = zeros(length(y),1);

  % currents G * diff(V)
  
  % hyperpolarizing current
  if isfield(p.key, 'mH_Fast') && isfield(p.key, 'mH_Slow')
    I_H = (p.gMax_H_Fast * y(p.key.mH_Fast) + ...
           p.gMax_H_Slow * y(p.key.mH_Slow)) * (y(p.key.V) - p.Rev_H);
    % change in fast H-current gate
    dy(p.key.mH_Fast,1) = x.alpha_H_Fast * (1 - y(p.key.mH_Fast)) - ...
        x.beta_H_Fast * y(p.key.mH_Fast);  
    % change in slow H-current gate
    dy(p.key.mH_Slow,1) = x.alpha_H_Slow * (1 - y(p.key.mH_Slow)) - ...
        x.beta_H_Slow * y(p.key.mH_Slow);
  else
    I_H = 0;
  end

  % persistent sodium current
  if isfield(p.key, 'hP')
    I_NaP = p.gMax_NaP * x.mP * y(p.key.hP) * (y(p.key.V) - p.Rev_NaP);
    % change in inactivation of NaP gate 
    dy(p.key.hP,1) = (x.hP_inf - y(p.key.hP)) * x.r_tau_hP; 
  else
    I_NaP = 0;
  end

  % change in fast Na current
  if isfield(p.key, 'mNa')
    I_Na = p.gMax_Na * y(p.key.mNa)^2 * y(p.key.hNa) * (y(p.key.V) - p.Rev_Na);
    dy(p.key.mNa,1) = x.alpha_m_Na * ...
        (1 - y(p.key.mNa)) - x.beta_m_Na * y(p.key.mNa);
    dy(p.key.hNa,1) = x.alpha_h_Na * ...
        (1 - y(p.key.hNa)) - x.beta_h_Na * y(p.key.hNa);
  else
    I_Na = 0;
  end

  % change in fast K current
  if isfield(p.key, 'nK')
    I_K = p.gMax_K * y(p.key.nK) * (y(p.key.V) - p.Rev_K);
    dy(p.key.nK,1) = x.alpha_n_K * ...
        (1 - y(p.key.nK)) - x.beta_n_K * y(p.key.nK);
  else
    I_K = 0;
  end

  % leakage current
  I_L = x.gL * p.gMax_Leak * (y(p.key.V) - p.Rev_Leak);

  % change in voltage
  if ~isfield(p, 'Ie_intv') || (t > p.Ie_intv(1) && t <= p.Ie_intv(2))
    I_e = p.Ie;
  else
    I_e = 0;
  end
  
  dy(p.key.V,1) = (I_e - (I_H + I_NaP + I_Na + I_K + I_L)) / p.Cm;
  p.set_current(struct('H', I_H, 'NaP', I_NaP, 'Na', I_Na, 'K', I_K));
