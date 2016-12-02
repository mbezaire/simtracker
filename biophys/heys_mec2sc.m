%% Subthreshold oscillation simulation
% Integrates H-, M-, persistent Na and leakage currents in a
% _single compartment model_ of an entorhinal cortex layer II stellate
% cell  (_Heys, J., Giocomo, L. and Hasselmo, M. E., 2009_).
% Plots and save results.

%% Main function entry point
% Integrate hyperpolarization and persistent sodium currents in a
% "single compartment model," plot and save results

function heys_mec2sc(varargin)
% args: { p y }
% p - structure with required parameters (default obtained from scm_parm)
% y - optional initial conditions vector (default computed from Vm(t=0))
% Results saved in 'heys_mec2sc.mat': time step vector, t; array of
% state variables, y, one row per time step, with columns:
% 1) membrane pot., 2) hyp'n channel fast and 3) slow actv'n, 
% and, if using Fransen/Heys voltage dependences (see subfunction
% heys_vdr [default], column 4 contains the persistent
% sodium inactivation; the ion currents as a struct array; the
% actual parameters used, p; and the figure (plot) graphic handle.
%%
  if ~isempty(varargin) || ~exist([ mfilename '.mat' ], 'file')
    [t y I p] = run(varargin);
    save(mfilename, 't', 'y', 'I', 'p');  
  else
    disp(['loading ' mfilename])
    load(mfilename);
  end
  g = do_plots(t, y, I);
end

function [t y I p] = run(args)
% run simulation given args which may contain parameters p (struct)
% and initial state y (vector); parameters default to scm_parm() and
% initial state is computed from p.V_0 = Vm(t=0)
% integration method given by p.solver may be any known
% integrator method, either Matlab ODE solver or other provided by user
% ('euler' and 'C_N' are defined below) 
  % set starting values of state vector and update parameter structure
  [y_0, p] = init(parse_cl(args));
  % display starting values
  disp(p)
  % fixed time steps, or let ODE solver choose
  if isfield(p,'dt') && p.dt > 0
    tspan = 0:p.dt:p.t_end;
  else
    tspan = [0 p.t_end];
  end
  % solver function arguments
  a = { @dydt tspan y_0 };
  use_ode = logical(strfind(p.solver, 'ode'));
  if use_ode
    a = [ a odeset('Refine', 1) ]; % ODE opts
  else
    assert(size(tspan,2) > 2, 'time step, 0 < dt < 1, required')
  end
  a = [ a p ];
  % handle to desired solver
  solver = str2func(p.solver);
  % integrate system
  clock_start = cputime;
  if use_ode
    s = solver(a{:});
    if size(tspan,2) > 2
      t = tspan;
      y = deval(s, t)';
    else
      t = s.x';
      y = s.y';
    end
  else
    [ t y ] = solver(a{:});
  end
  disp({ 'elapsed CPU:', cputime - clock_start });
  % display the final values
  y_end = struct('V', y(end,1), 'n', y(end,2), 'k', y(end,3), ...
                 'h', y(end,4), 's', y(end,5));
  % ion currents at evaluated time steps
  I = intg_current(y, p);
  y_end.I = I(end,:)
end

function g = do_plots(t, y, I)
% given time vector, state variable array (size(y,1) == length(t)) and
% currents array, plot Vm vs. t, current gates vs. t, currents vs. t
% and currents vs. Vm in a single figure, returning graphic handle
  sd = get(0,'ScreenSize');
  g = figure('Position', [sd(1), sd(4)-sd(4)/2, 0.6*sd(3), 0.6*sd(4)]);
  % membrane potential
  subplot(2,2,1);
  V = y(:,1);
  % assume Vm starts near rest, scale if in millivolts
  if abs(y(1,1)) < 1, V = 1000*V; end
  plot(t,V);
  xlabel('time (ms)'); ylabel('V_m (mV)');
  % current gates
  subplot(2,2,2);
  plot(t,y(:,2:5));
  xlabel('time (ms)'); ylabel('gating');
  % legend arguments are reversed with plotyy, who knows why?
  l = legend('n', 'k', 'h', 's'); 
  set(l, 'FontSize',8, 'Location', 'NorthWest');
  % ion currents
  subplot(2,2,3);
  plot(t, I);
  xlabel('time (s)'); ylabel('current');
  c = { 'I_H' 'I_NaP' 'I_M' };
  if size(I,2) > 3, c = [ c { 'I_S' } ]; end
  l = legend(c{:}); set(l, 'FontSize',8);
  % I-V curves
  subplot(2,2,4);
  plot(V,I);
  xlabel('Vm (mV)'); ylabel('current');
  l = legend('I_H', 'I_NaP', 'I_M'); set(l, 'FontSize',8);
end

function p = parse_cl(args)
% args: cell optionally containing param struct, initial state vector
% returns param structure (optional inital state is assigned to 'y_0')
  if ~isempty(args)
    p = args{1};
    if length(args) > 1
      p.y_0 = args{2};
    end
  else
    p = scm_parm('Heys');
  end
  assert(isstruct(p), help('heys_mec2sc'));
end

function [y, p] = init(p)
% initialize and return state vector and updated parameter
% (struct), given required parameter (struct); also sets initial
% ion currents 
  % voltage dependent rate functions
  if ~isfield(p, 'vdr')
    p.vdr = heys_vdr;
  else
    p.vdr = eval(p.vdr);  % name of alternate function
  end
  % initial state
  if isfield(p, 'y_0')
    y = p.y_0;
    assert(size(y, 2)==5, 'inital state vector length != 5')
  else
    V_0 = p.V_0;
    y(1) = V_0;
    vdr = p.vdr;
    y(2) = vdr.n_inf(V_0);
    y(3) = vdr.k_inf(V_0);
    y(4) = vdr.h_inf(V_0);  % Fransen integrates NaP inactiv'n only
    y(5) = vdr.s_inf(V_0);
    % Destexhe synaptic gating
    if isfield(p,'syn');
      y(6) = p.syn{1}.g; 
      y(7) = p.syn{2}.g; 
    end  
  end
  % noise signal
  T = 0:p.dt:p.t_end;
  %rand('twister', sum(fix(clock)));  % seed randomizer
  p.noise_sig = struct('t', T, 'x', [ randn(size(T)); randn(size(T)) ]);
end

%%% Difference Equations
% Method called by solver routines to integrate the dynamical
% system. The system variables are the membrane voltage (Vm), and
% conductances for persistent Na current inactivation, H-current (fast
% and slow) and M-current, and for synaptic input modeled as a point
% conductance (
% <http://www.ncbi.nlm.nih.gov/pubmed/11744242?dopt=abstract Destexhe
% 2001> ).  The gating variables depend on Vm and Vm depends on the
% currents determined by gating variables.
function dy = dydt(t, y, p)
% difference equations for model, may be called by Matlab ODE solver
% returns difference vector
% args:
% t -- current time
% y -- current state (column vector)
% p -- parameters (structure with fields as required below)
  V  = y(1);    % membrane potential
  vdr = p.vdr;  % voltage dependent rate functions

  % leakage current
  I_L = p.G_L * (V - p.V_L);
  % difference equations
  I = intg_current(y', p);
  assert(~hasInfNaN(I), [...
      'invalid current at t=' num2str(t) '; y=' num2str(y')]);
  % membrane potential
  dy(1,1) = (p.I_app - sum(I) - I_L) / p.C_m;
  % change in fast H-current gate
  dy(2,1) = (vdr.n_inf(V) - y(2)) / vdr.tau_n(V); 
  % change in slow H-current gate 
  dy(3,1) = (vdr.k_inf(V) - y(3)) / vdr.tau_k(V); 
  % change in persistent sodium inactivation 
  dy(4,1) = (vdr.h_inf(V) - y(4)) / vdr.tau_h(V);
  % change in M-current gate
  dy(5,1) = (vdr.s_inf(V) - y(5)) / vdr.tau_s(V);
  % Destexhe synaptic input noise
  if length(y) > 5
    % lookup a noise signal value based on current time
    dy(6,1) = (p.syn{1}.g - y(6)) / p.syn{1}.t + p.syn{1}.d * ...
              interp1(p.noise_sig.t, p.noise_sig.x(1,:), t);
    dy(7,1) = (p.syn{2}.g - y(7)) / p.syn{2}.t + p.syn{2}.d * ...
              interp1(p.noise_sig.t, p.noise_sig.x(2,:), t);
  end
end

function I = intg_current(y, p)
% return integrated currents array
  if size(y,2) > 5, n = 4; else n = 3; end
  I = zeros(size(y,1), n);
  m_inf = p.vdr.m_inf;
  for i = 1:size(I,1)
    V = y(i,1);
    % H current
    I(i,1) = (p.G_H_Fast_Max * y(i,2) + p.G_H_Slow_Max * y(i,3)) * (V - p.V_H);
    % persistent sodium current
    I(i,2) = p.G_NaP_Max * m_inf(V) * y(i,4) * (V - p.V_NaP);
    % K "M" current
    I(i,3) = p.G_M_Max * y(i,5) * (V - p.V_K);
    % Destexhe synaptic background noise
    if n > 3
      I(i,4) = (y(i,6) * (V - p.V_Se) + y(i,7) * (V - p.V_Si)) / p.cell_area;
    end
  end
end

function x = inj_current(t, p)
% return applied current value
% t -- current time
% p.I_app -- applied current value
% p.I_app_t -- optional [start end] injection interval times
  if isfield(p, 'I_app_t') && ~isempty(p.I_app_t)
    if length(p.I_app_t) == 1, p.I_app_t = [0 p.I_app_t]; end
    if p.I_app_t(1) <= t && t < p.I_app_t(2)
      x = p.I_app;
    else
      x = 0;
    end
  else
    x = p.I_app;
  end
end

%%% Direct integration methods
% Euler method integration
function [t y] = euler(fcn, T, y0, p)
% fcn - difference equations: @fcn(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% T - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to fcn
% returns time vector, state variable array
  if length(T) > 2
    t = T;
  else
    t = T(1):p.dt:T(2);
  end
  y = zeros(length(t), length(y0));
  y(1,:) = y0;
  n = length(t) - 1;
  for i = 1:n
    y(i+1,:) = y(i,:) + p.dt * fcn(t(i), y(i,:)', p)';
  end
end

%%%
% Crank-Nicolson
%
function [t y] = C_N(fcn, T, y0, p)
% Crank-Nicolson (two-stage) integration method
% fcn - difference equations: @fcn(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% T - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to fcn
% returns time vector, state variable array
  if length(T) > 2
    t = T;
  else
    t = T(1):p.dt:T(2);
  end
  y = zeros(length(t), length(y0));
  y(1,:) = y0;
  n = length(t) - 1;
  for i = 1:n
    v = y(i,:)';
    tmp = v + (p.dt/2) * fcn(t(i), v, p);
    y(i+1,:) = y(i,:) + p.dt * fcn(t(i), tmp, p)';
  end
end

%%% 
% *Voltage dependent parameter equations*
%
% Sets of nested functions that provide instantaneous values of system
% variables dependent only on the current membrane potential.
%

%%% Heys voltage dependent parameter equations
% Persistent sodium equations from Fransen'04, p. 372, scaled to mV
% H-current per Heys'09

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
    V = V/1000;
    inf = 1/(1 + exp(-(V + .0487)/.0044)); % "mP"
  end
  
  % persistent sodium current inactivation
  function a = alpha_NaP_inactv(V)
    V = V/1000;
    a = (-2.88*V - .0491)/(1 - exp((V - .0491)/.00463)); 
  end

  function b = beta_NaP_inactv(V)
    V = V/1000;
    b = (6.94*V + .447)/(1 - exp(-(V + .447)/.00263));  
  end

  function inf = NaP_inactv_inf(V)
    V = V/1000;
    inf = 1/(1+exp((V+.0488)/.00998));  % "hP"
  end

  % time constant in milliseconds
  function tau = tau_NaP_inactv(V)
    tau = 1/(alpha_NaP_inactv(V) + beta_NaP_inactv(V));
  end

  % hyperpolarization channel
  function inf = n_inf(V)
    inf = 1/(1 + exp((V + 68.08)/7.14));  % mH_Fast_inf
  end

  % time constant in milliseconds
  function tau = tau_n(V)
    tau = 38.6/(exp(-(V + 109.2)/28.2) + exp((V + 2.8)/21.3)); %mH_Fast_tau
  end

  function inf = k_inf(V)
    inf = 1/(1 + exp((V + 68.08)/7.14));  % mH_Slow_inf
  end
    
  % time constant in milliseconds
  function tau = tau_k(V)
    tau = 330/(exp((V + 38.2)/0.72) + exp(-(V + 112)/51.9));  % mH_Slow_tau
  end

  function a = alpha_s(V)
    a = exp(s * (V - v_2));
  end  

  function b = beta_s(V)
    b = exp(s * gm * (V - v_2));
  end

  function inf = s_inf(V)
    inf = 1 / (1 + alpha_s(V));
  end

  function tau = tau_s(V)
    tau = beta_s(V) / (ts * (1 + alpha_s(V)));
  end
end
