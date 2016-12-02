%%% Fransen voltage dependent parameter equations
% From Fransen'04, p. 372, by way of Jim Heys. N.b.: volts rather than
% millvolts. 
function h = fransen_vdr
% returns struct with function handles called from dydt()
  h = struct('tau_q', @tau_NaP_inactv, 'q_inf', @NaP_inactv_inf, ...
        'tau_rf', @tau_rf, 'rf_inf', @rf_inf, 'rf_inf0', @rf_inf0, ...
        'tau_rs', @tau_rs, 'rs_inf', @rs_inf, ...
        'p_inf', @p_inf, 'p', @p);

  function inf = p_inf(V)
   inf = 1 ./ (1 + exp(-(V + .0487) ./ .0044)); % "mP"
  end

  function a = alpha_NaP_inactv(V)
   a = (-2.88*V - .0491) ./ (1 - exp((V - .0491) ./ .00463));
  end

  function b = beta_NaP_inactv(V)
   b = (6.94*V + .447) ./ (1 - exp(-(V + .447) ./ .00263));
  end

  function inf = NaP_inactv_inf(V)
   inf = 1 ./ (1+exp((V+.0488) ./ .00998)); % "hP"
  end

  function tau = tau_NaP_inactv(V)
   tau = 1 ./ (alpha_NaP_inactv(V) + beta_NaP_inactv(V));
  end

  function p = p(V, q)
   p = p_inf(V) * (NaP_inactv_inf(V) - q) ./ tau_NaP_inactv(V);
  end

  % hyperpolarization channel
  function inf = rf_inf(V)   % Jim's form
   inf = 1 ./ (1 + (exp((V + .100) ./ .003)));
  end

  function inf = rf_inf0(V)  % Fransen's form
    inf = (1 + exp((V + .0742) ./ 0.00978)).^(-1.36);      % mH_Fast_inf
  end

  function tau = tau_rf(V)
   tau = 0.00051 ./ (exp((V - .0017) ./ .01) + exp(-(V+.34) ./ .52)); % tauH_Fast
  end

  function inf = rs_inf(V)
   inf = (1 + exp((V + .00283) ./ .0159)).^(-58.5);      % mH_Slow_inf
  end

  function tau = tau_rs(V)
   tau = 0.0056 ./ (exp((V - .017) ./ .014) + exp(-(V+.260) ./ .043));   % tauH_Slow
  end
end
