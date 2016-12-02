function r = voltage_dependent_rates(V) 
% given current membrane voltage returns a struct containing
% alpha and beta, fast and slow, 
% steady-state persistant sodium inactivation h_inf and time
% constant tau_h

  % fast Na activation (Traub '91)
  r.alpha_m_Na = 0.32*(V - .00131)/(1 - exp(-(V - .00131)/.004));
  r.beta_m_Na = -0.28*(V - .0401)/(1 - exp((V - .0401)/.005));

  % fast Na inactivation (Traub '91)
  r.alpha_h_Na = -.128*exp(-(V - .017)/.018);
  r.beta_h_Na = 4/(1 + exp(-(V - .040)/.005));

  % K activation (delayed rectification)
  r.alpha_n_K = .016 * (V - 0.0351)/(1 - exp(-(V - 0.0351)/.005));
  r.beta_n_K = .25 * exp(-(V - 0.02)/.04);

  %Persistant Na activation 
  %alpha_actvn_NaP = (.091e6*(V + .038))/(1 - exp(-(V + .038)/.005)); 
  %beta_actvn_NaP = (-.062e6*(V + .038))/(1 - exp((V + .038)/.005)); 
  r.mP = 1/(1 + exp(-(V + .0487)/.0044)); 
  %r.r_tau_mP = alpha_actvn_NaP + beta_actvn_NaP;

  %Persistant Na inactivation 
  alpha_NaP_inactvn = (-2.88*V - .0491)/(1 - exp((V - .0491)/.00463));
  beta_NaP_inactvn = (6.94*V + .447)/(1 - exp(-(V + .447)/.00263)); 
  
  r.hP_inf = 1/(1 + exp((V + .0488)/.00998));
  r.r_tau_hP = alpha_NaP_inactvn + beta_NaP_inactvn;
  
  % Fransen '04
  % H current gating variable steady state activation - fast component
  %mH_Fast_inf = 1/((1 + (exp((V + .0728)/.008)))); %^(1.36)); 
  mH_Fast_inf = 1/(1 + (exp((V + .10)/.003))); %^(1.36)); 
                                                    
  % H current gating variable steady state activation - slow component
  mH_Slow_inf = (1 + (exp((V + .00283)/.0159)))^(-58.5); 

  % H current time constant - fast component
  r_tauH_Fast = (exp((V - .0017)/.010) + exp(-(V + .34)/.52))/.00051; 

  % H current time constant - slow component
  r_tauH_Slow = (exp((V - .017)/.014) + exp(-(V + .26)/.043))/.0056; 

  r.alpha_H_Fast = mH_Fast_inf * r_tauH_Fast;
  r.beta_H_Fast = (1 - mH_Fast_inf) * r_tauH_Fast;
  r.alpha_H_Slow = mH_Slow_inf * r_tauH_Slow;
  r.beta_H_Slow = (1 - mH_Slow_inf) * r_tauH_Slow;
