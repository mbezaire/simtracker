function scm_hh(p)
% Integrate Hodgkin-Huxley currents in a single compartment model
% p - (optional) structure with required parameters (default is
% that returned by scm_parm()).
% Results saved in 'scm_hh.mat': time step vector, t; array of
% state variables, y, one row per time step, columns: 
%  V m h n
% (membrane pot., sodium channel activ'n, sodium channel inactiv'n,
% potassium channel activ'n); currents I (fast Na and K); actual
% parameters used, p; and a handle to the plot figure
% Example:
%  Use squid axon params, and change simulation time: 
%  p=scm_parm(0); p.t_end=100; scm_hh(p); 
%  load scm_hh
%  (run 'whos' to see the result arrays loaded into the workspace)
%  (optionally, clf or close(g) to clear previous figure)
%  plot(y(:,2),y(:,3)) % plot activation vs. inactivation variables

  clear global I;
  global I; 
  I = struct(); % must set its type immediately
  if nargin < 1
    p = scm_parm(1);
  end
  
  [t y p] = run(p);
  g = do_plots(t, y, I);
  save scm_hh t y I p g;
end

function [t y p] = run(parm)
% run integration method given by parm.solver, which may be any known
% integrator method, either Matlab ODE solver or other provided by user
% ('euler' and 'C_N' are defined below) 
  [y_0 p] = init(parm); % starting values
  a = { @dydt [0 p.t_end] y_0 };
  if strfind(p.solver, 'ode')
    % ODE will update global ion current struct after ea. time step
    a{end+1} = odeset('OutputFcn', @save_current, 'Refine', 1);  % options
  end
  % display starting values
  disp(p)
  y0 = struct('V', y_0(1), 'm', y_0(2), 'h', y_0(3), 'n',  y_0(4))

  % solver function arguments
  a = [ a p ];
  solver = str2func(p.solver);
  % integrate using method with args
  clock_start = cputime;
  [ t y ] = solver(a{:});
  disp({ 'elapsed CPU:', cputime - clock_start });
  % display the final values
  y_end = struct('V', y(end,1), 'm', y(end,2), 'h', ...
                 y(end,3), 'n', y(end,4))
end

function g = do_plots(t, y, I)
  sd = get(0,'ScreenSize');
  g = figure('Position', [sd(1),sd(4)-sd(4)/2, .6*sd(3), .6*sd(4)]);
  subplot(2,2,1);
  plot(t,y(:,1));
  xlabel('Time (ms)'); ylabel('V_m (mV)');
  subplot(2,2,2);
  plot(t,y(:,2:4));
  xlabel('time (ms)'); ylabel('gating');
  l = legend('m', 'h', 'n'); set(l, 'FontSize',8);
  subplot(2,2,3);
  [a, h1, h2] = plotyy(t, [I(:).Na], t, [I(:).K]);
  xlabel('time (ms)'); ylabel('current');
  l = legend([h1 h2], 'I_Na', 'I_K'); set(l, 'FontSize',8);
  subplot(2,2,4);
  [a h1 h2] = plotyy(y(:,1), [I(:).Na], y(:,1), [I(:).K]);
  xlabel('Vm (mV)'); ylabel('current');
  l = legend([h1 h2], 'I_Na','I_K'); set(l, 'FontSize',8);
end

function [y p] = init(p)
  global I;
  V_0 = p.V_0;
  y = zeros(1,4);
  y(1) = V_0;
  % conductance gating parameters
  y(2) = m_inf(V_0);
  y(3) = h_inf(V_0);
  y(4) = n_inf(V_0);
  % init ionic currents
  p.set_current = @current;  % function to save latest ion currents
  dydt(0, y, p);  
  I = current;  
end

function dy = dydt(t, y, p)
% difference equations for model
% returns difference vector
% t - current time
% y - current state variables vector 
% p - parameter structure
  % state variables
  V      = y(1);
  m      = y(2);
  h      = y(3);
  n      = y(4);
  % ionic currents
  I_Na   = p.G_Na_Max * m^3 * h * (V - p.V_Na); %y(5);
  I_K    = p.G_K_Max * n^4 * (V - p.V_K); % y(6);
  % applied current
  I_app = inj_current(t, p);
  % difference equations
  dy = [
    (I_app - (I_Na + I_K + p.G_L*(V - p.V_L)))/p.C_m;  % membrane potential
    (m_inf(V) - m)/tau_m(V);  % sodium channel actvn
    (h_inf(V) - h)/tau_h(V);  % sodium channel inactvn
    (n_inf(V) - n)/tau_n(V);  % potassium channel actvn
    ];
  % save the current values
  p.set_current(struct('Na', I_Na, 'K', I_K));
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

function r = current(s)
% save argument for later retrieval
  persistent c;
  if nargin
    c = s;
  end
  r = c;
end

function r = save_current(varargin)
% appends last save value to ion current array
  global I;
  if nargin < 3 || isempty(varargin{3})
    I(end+1) = current;
  end
  r = 0;
end

function [t y] = euler(fcn, T, y0, p)
% Euler method integration
% fcn - difference equations: @fcn(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% T - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to fcn
  n_var = length(y0);
  dt = p.dt;
  n_step = (T(2)-T(1))/dt;
  t = zeros(n_step,1);
  t(1) = T(1);
  y = zeros(n_step, n_var);
  y(1,:) = y0;
  for i = 1:n_step
    y(i+1,:) = y(i,:) + dt * fcn(t(i), y(i,:), p)';
    t(i+1) = t(i) + dt;
    save_current;
  end
end

function [t y] = C_N(fcn, T, y0, p)
% Crank-Nicolson (two-stage) integration method
% fcn - difference equations: @fcn(t, y, p), where t is current time,
%   y is current state (vector), and p (struct) holds parameters
% T - [start end] time
% y0 - initial conditions (vector)
% p - parameters passed to fcn
  n_var = length(y0);
  dt = p.dt;
  n_step = (T(2)-T(1))/dt;
  t = zeros(n_step,1);
  t(1) = T(1);
  y = zeros(n_step, n_var);
  y(1,:) = y0;
  for i = 1:n_step
    tmp = y(i,:) + (dt/2) * fcn(t(i), y(i,:), p)';
    y(i+1,:) = y(i,:) + dt * fcn(t(i), tmp, p)';
    t(i+1) = t(i) + dt;
    save_current;
  end
end

function a = alpha_m(V)
  a = -0.1*(V+40)/(exp(-(V+40)/10)-1);
end

function b = beta_m(V)
  b = 4*exp(-(V+65)/18);
end

function a = alpha_h(V)
  a = 0.07*exp(-(V+65)/20);
end

function b = beta_h(V)
  b = 1/(1+exp(-(V+35)/10));
end

function a = alpha_n(V)
  a = -0.01*(V+55)/(exp(-(V+55)/10)-1);
end

function b = beta_n(V)
  b = 0.125*exp(-(V+65)/80);
end

function inf = m_inf(V)
  inf = alpha_m(V)*tau_m(V);
end

function tau = tau_m(V)
  tau = 1/(alpha_m(V)+beta_m(V));
end

function inf = h_inf(V)
  inf = alpha_h(V)*tau_h(V);
end

function tau = tau_h(V)
  tau = 1/(alpha_h(V)+beta_h(V));
end

function inf = n_inf(V)
  inf = alpha_n(V)/(alpha_n(V)+beta_n(V));
end

function tau = tau_n(V)
  tau = 1/(alpha_n(V)+beta_n(V));
end
