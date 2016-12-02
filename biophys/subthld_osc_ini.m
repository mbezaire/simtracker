function v = subthld_osc_ini(f)
  % save or display default subthresh_oscilln initial conditions
  v = struct(...
      'V', -0.061, 'mH_Fast', 3e-6, 'mH_Slow', 0.1540, ...
      'hP', 0.7012, 'mNa', 0.1, 'hNa', .5, 'nK', 0.01 );
  if nargin
    save(f,'-struct', 'v')
  end

 
