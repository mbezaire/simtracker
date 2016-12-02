%%% Fransen voltage dependent parameter equations
% From Fransen'04, p. 372, by way of Jim Heys. N.b.: volts rather than
% millvolts. 
function h = heys_vdr
% returns struct with function handles called from dydt()
  h = struct('m_inf', @NaP_actv_inf, ...
             'tau_h', @tau_NaP_inactv, 'h_inf', @NaP_inactv_inf, ...
             'tau_n', @tau_n, 'n_inf', @n_inf, ...
             'tau_k', @tau_k, 'k_inf', @k_inf, ...
             'tau_s', @tau_s, 's_inf', @s_inf);
  c = 37;
  z = -7e-3;
  v_2 = -55;
  s = z * 9.648e4 / (8.315 * (273.16 + c));
  gm = 0.8;
 ts = 2e-4 * 5^((c-22)/10);

 % persistent sodium current activation
 function inf = NaP_actv_inf(V)
  V = V ./ 1000;
  inf = 1 ./ (1 + exp(-(V + .0487) ./ .0044)); % "mP"
 end
 
 % persistent sodium current inactivation
 function a = alpha_NaP_inactv(V)
  V = V ./ 1000;
  a = (-2.88*V - .0491) ./ (1 - exp((V - .0491) ./ .00463));
 end

 function b = beta_NaP_inactv(V)
  V = V ./ 1000;
  b = (6.94*V + .447) ./ (1 - exp(-(V + .447) ./ .00263));
 end

 function inf = NaP_inactv_inf(V)
  V = V ./ 1000;
  inf = 1 ./ (1+exp((V+.0488) ./ .00998)); % "hP"
 end

 function tau = tau_NaP_inactv(V)
  tau = 1 ./ (alpha_NaP_inactv(V) + beta_NaP_inactv(V));
 end

 % hyperpolarization channel
 function inf = n_inf(V)
  inf = 1 ./ (1 + exp((V + 68.08) ./ 7.14)); % mH_Fast_inf
 end

 function tau = tau_n(V)
  tau = 38.6 ./ (exp(-(V + 109.2) ./ 28.2) + exp((V + 2.8) ./ 21.3));
 end

 function inf = k_inf(V)
  inf = 1 ./ (1 + exp((V + 68.08) ./ 7.14)); % mH_Slow_inf
 end
  
 function tau = tau_k(V)
  tau = 330 ./ (exp((V + 38.2) ./ 0.72) + exp(-(V + 112) ./ 51.9)); % tauH_Slow
 end

 function a = alpha_s(V)
  a = exp(s * (V - v_2));
 end 

 function b = beta_s(V)
  b = exp(s * gm * (V - v_2));
 end

 function inf = s_inf(V)
  inf = 1 ./ (1 + alpha_s(V));
 end

 function tau = tau_s(V)
  tau = beta_s(V) ./ (ts * (1 + alpha_s(V)));
 end
end

