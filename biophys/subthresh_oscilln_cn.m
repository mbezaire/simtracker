function [t, y, I] = subthresh_oscilln_cn(t_end, parmf, inif)
% Simulate subthreshold oscillations of membrane potential
% Runs Crank-Nicolson integration of system subthld_osc_sys
% Arguments:
% t_end -- duration (msec) [25]
% parmf -- MAT file containing required fixed parameters (see in 
%   subthld_osc_sys) ['hh/subthld_osc_parm.mat']
% inif -- MAT file containing a structure giving initial values for
%   system variables (see init_var())
% Outputs:
% t -- vector of time steps, running from 0 to t_end, with dt as given in
%   the parameter file
% y -- array of system variable values (see init_var())
% I -- structure array, I(:).H and I(:).NaP, one set for each time step
%
% This function integrates a system simulating subthreshold oscillations
% using the parameter values determined from the voltage clamp data by
% Lisa Giocomo.  This is the best looking version of subthreshold
% oscillations obtained in this series of scripts.  Occasionally, there
% are large amplitude NaP spikes that occur, but the oscillations
% themselves should only be a couple of millivolts in amplitude. 

  % command line
  if nargin < 3
    if ~nargin
      t_end = 25
    elseif ischar(t_end)
      help subthresh_oscilln_cn
      return
    end
    if nargin < 2
      parmf = 'hh/subthld_osc_parm.mat';      
      inif = '';
    end
  end
  pars = load(parmf)

  % system variables
  vars = init_var(inif)
  y_0 = structfun(@(v) v, vars)';
  pars.key = var_idx(vars);
  pars.rCm = 1e3/pars.Cm;
  n_steps = length(0:pars.dt:t_end);

  global I;  % membrane currents in model
  I = struct('H', {0}, 'NaP', {0}, 'Na', {0}, 'K', {0});

  % handle to function with difference equations
  dydt = @(i, u, v) subthld_osc_sys(i, u, v, pars);
  % handle to function run once per C-N step
  dx = @(u) step_values(u, pars);

  % run Crank-Nicolson with this system and initial condition
  clock_start = cputime;
  [ t y ] = CN(dydt, [0 t_end], pars.dt, y_0, dx);
  disp({ 'elapsed CPU:', cputime - clock_start });

  % display the final values
  end_state = vars;
  f = fieldnames(vars);
  for i = 1:length(f), end_state.(f{i}) = y(i); end
  end_state

  V = y(:,pars.key.V)*1e3;
  figure('position',[10 10 500 500]);
  plot(t * pars.dt * 1e3, V); xlabel('time (s)'); ylabel('Vm (mV)');


% run numerical integration
function [ t y ] = CN(dydt, t_span, dt, y_0, stepfcn)
  t = t_span(1):dt:t_span(2);
  n = length(t);
  y = zeros(n, length(y_0));
  y(1,:) = y_0;
  for i = 1:n-1
    x = stepfcn(y(i,:));
    y(i+1,:) = y(i,:) + dt * dydt(...
        i, y(i,:) + (dt / 2) * dydt(i, y(i,:), x), x);
  end

function x = step_values(y, p)
  x = voltage_dependent_rates(y(p.key.V));
  % noise term for Leak conductance
  if rand(1) > .97, x.gL = 0.98; else x.gL = 1; end

function v = init_var(f)
  if nargin && length(f)
    v = load(f);
  else
    v = struct('V', -0.061, 'mH_Fast', 0.0764, 'mH_Slow', 0.1540, ...
               'hP', 0.7012, 'mNa', 0, 'hNa', 1, 'nK', 0.01 );
  end

function k = var_idx(s)
  w = fieldnames(s);
  for i = 1:length(w), k.(w{i}) = i; end

