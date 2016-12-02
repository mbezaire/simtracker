function [t, y, I] = subthresh_oscilln(varargin)
% Simulate subthreshold oscillations of membrane potential
% Runs Crank-Nicolson integration of system subthld_osc_sys
% Arguments:
% {'-t' t_end} -- duration (msec) [25]
% {'-p' parmf} -- MAT file containing required fixed parameters (see in 
%   subthld_osc_sys) ['hh/subthld_osc_parm.mat']
% {'-i' inif} -- MAT file containing a structure giving initial values for
%   system variables (see init_var())
% Outputs:
% t -- vector of time steps, running from 0 to t_end, with dt as given in
%   the parameter file
% y -- array of system variable values, length and index assignment
%   as given by structure in inif (see init_var())
% I -- structure array, fields: H, NaP, Na, K, one set for each
% time step 
%   Note: if optional ini file is used (see above) and mNa or nK are
% not initialized, then I(:).Na or I(:).K, respectively, will be zero
%
% This function integrates a system simulating subthreshold oscillations
% using the parameter values determined from the voltage clamp data by
% Lisa Giocomo.  This is the best looking version of subthreshold
% oscillations obtained in this series of scripts.  Occasionally, there
% are large amplitude NaP spikes that occur, but the oscillations
% themselves should only be a couple of millivolts in amplitude. 

  clear global I;
  global I;  % membrane currents, assign values in
             % difference equations routine

  % command line
  [t_end, parf, inif, solv] = parse_cl(varargin{:});
  if ~t_end, return; end
  pars = load(parf)

  % system variables
  vars = init_var(inif)
  y_0 = struct2array(vars)';  % index assignment per field order in vars
  pars.key = var_idx(vars);   % map field names to array index
  n_steps = ceil(t_end/pars.dt);

  % function run once per integration step to get current values
  pars.step_fcn = @step_values;
  % function run once per integration step to save currents
  pars.set_current = @current;
  % solver args
  args = { @subthld_osc_sys [0 t_end] y_0 };
  % handle to integration method
  solver = str2func(solv);
  if strfind(solv, 'ode')
    opts = odeset('OutputFcn', @save_current, 'Refine', 1);
    args = [ args opts ];
  end
  args = [ args pars ];

  % sets initial current
  I = struct('H', 0, 'NaP', 0, 'Na', 0, 'K', 0);
  subthld_osc_sys(0, y_0, pars); 
  I(1) = current;

  % run integrator on this system
  clock_start = cputime;
  [ t y ] = solver(args{:});
  disp({ 'elapsed CPU:', cputime - clock_start });

  % display the final values
  end_state = vars;
  f = fieldnames(vars);
  for i = 1:length(f), end_state.(f{i}) = y(end,i); end
  end_state

  V = y(:,pars.key.V)*1e3;
  figure('position',[10 10 500 500]);
  plot(t, V); xlabel('time (s)'); ylabel('Vm (mV)');


function [t_end, parf, inif, solv] = parse_cl(args)
% parse command line or function args
% -i -- ini file, initial values for system variables
% -p -- parameter file, constants
% -s -- solver method: "C_N" or Matlab ode*
% -t -- total simulation duration in seconds
% function form args: { t_end, parf, inif, solver }

  % defaults
  dft = {'25', 'hh/subthld_osc_parm', '', 'C_N'};  
  [t_end, parf, inif, solv] = deal(dft{:});

  narg = length(args);
  if narg
    % if command line switches with args, accepts -x or --xxx
    if ischar(args{1}) && strcmp(args{1}(1), '-')
      for i = 1:2:length(args)
        k = strrep(args{i},'-','');
        if narg > i, v = args{i+1}; end
        switch k(1)
         case 'h'
          help subthresh_oscilln
          t_end = 0;
          return
         case 'i'
          inif = v;
         case 'p'
          parf = v;
         case 's'
          solv = v;
         case 't'
          t_end = v;
        end
      end
    else
      % function form
      x = { args{:} dft{narg+1:4} };
      [t_end, parf, inif, solv] = deal(x{:});
    end
  end
  if ischar(t_end)
    t_end = eval(t_end); % numerical value
  end


function v = init_var(f)
% initialize system variables from structure in MAT file
% possible set is { V, mH_Fast, mH_Slow, hP, mNa, hNa, nK }
% actual set determined by given structure
  if nargin && length(f)
    v = load(f);
  else
    v = subthld_osc_ini;
  end


function k = var_idx(s)
  w = fieldnames(s);
  for i = 1:length(w), k.(w{i}) = i; end


% run numerical integration
function [ t y ] = C_N(dydt, t_span, y_0, p)
% Crank-Nicolson (two-stage) integration method
% dydt - difference equations: @dydt(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% t_span - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to dydt
  dt = p.dt;
  t = t_span(1):dt:t_span(2);
  n = length(t);
  y = zeros(n, length(y_0));
  y(1,:) = y_0;
  for i = 1:n-1
    v = y(i,:);
    y(i+1,:) = v + dt * dydt(t(i), ...
                             v + (dt / 2) * dydt(t(i), v, p)', p)';
    save_current(t(end), y(end,:), [], p);
  end

function [ t y ] = euler(dydt, t_span, y_0, p)
% Euler integration method
% dydt - difference equations: @dydt(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% t_span - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to dydt
  dt = p.dt;
  t = t_span(1):dt:t_span(2);
  n = length(t);
  y = zeros(n, length(y_0));
  y(1,:) = y_0;
  for i = 1:n-1
    v = y(i,:);
    y(i+1,:) = v + dt * dydt(t(i), v, p)';
    save_current(t(end), y(end,:), [], p);
  end


function x = step_values(y, p)
  x = voltage_dependent_rates(y(p.key.V));
  % noise term for Leak conductance
  if rand(1) > .97, x.gL = 0.98; else x.gL = 1; end


function r = current(s)
% save argument for later retrieval
  persistent c;
  if nargin
    c = s;
  end
  r = c;

function r = save_current(t, y, flg, p)
% appends last save value to current array
  global I;
  if isempty(flg)
    I(end+1) = current;
  end
  r = 0;

