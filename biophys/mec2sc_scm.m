%% Medial entorhinal cortex layer (MEC) II stellate cell single
% compartment model. Simulates subthreshold membrane potential
% oscillation (MPO).
% Integrates spiking, H-, M-, persistent Na and leakage currents in a
% _single compartment model_ of an entorhinal cortex layer II stellate
% cell  (_Heys, J., Giocomo, L. and Hasselmo, M. E., 2009_ [in press], and
% <http://www.ncbi.nlm.nih.gov/pubmed/1663538?dopt=abstract Traub
% 1991>; see also
% <http://www.ncbi.nlm.nih.gov/pubmed/15132436?dopt=abstract Fransen 2004>,
% <http://www.ncbi.nlm.nih.gov/pubmed/10498669?dopt=abstract
% Magistretti 1999>,
% <http://www.ncbi.nlm.nih.gov/pubmed/7608762?dopt=abstract
% Migliore 1995>).

% Main function entry point
% Integrate hyperpolarization and persistent sodium currents in a
% "single compartment model," plot and save results
function [p t y I] = mec2sc_scm(varargin)
% runs simulation, saves results in same named MAT file and plots results
% args: { p y mat }
% p - structure with required parameters (default obtained from scm_parm);
%     if empty struct, function returns system default parameters,
%     including handles to top level subfunctions
% y - optional initial conditions vector (default computed from Vm(t=0))
% mat - optional MAT file name for save (default: mfilename)
% Output results saved in MAT file: 
% time step vector, t; array of state variables, y, one row per time
% step, with columns: 1) membrane pot., 2) hyp'n channel fast and 3)
% slow actv'n, and, if using Fransen/Heys voltage dependences (see
% subfunction heys_vdr [default], column 4 contains the persistent
% sodium inactivation; the ion currents as a struct array; the actual
% parameters used, p; and the figure (plot) graphic handle.
  if nargin > 2
    matf = strrep(varargin{3},'.mat','');
  else 
    matf = mfilename;
  end
  if ((~isempty(varargin) && isstruct(varargin{1})) || ...
        ~exist([ matf '.mat' ], 'file'))
    [p t y I] = run(varargin);
    if ~nargout
      save(matf, 'p', 't', 'y', 'I');
    end
  else
    disp(['loading ' matf])
    load(matf);
    % make sure you can plot
    if isfield(p,'no_plot'), p = rmfield(p,'no_plot'); end
  end
%% Simulation plots
%
  if ~isempty(t) && ~isfield(p,'no_plot'), do_plots(t, y, I); end
  if ~nargout, clear p, end
end

function [p t y I] = run(args)
% run program, args may contain parameters p (struct, default to
% scm_parm()) and initial state (vector)
% if no args or first arg is not a struct or it is empty, then
% return a default parameter struct
% if the paramter field t_init is set to some milliseconds > 0
% runs an initial simulation, using the final state to run the
% final simulation
  % set starting values of state vector and update parameter structure
  t = []; y = []; I = [];
  p = parse_cl(args);
  if ~isempty(args) && (~isstruct(args{1}) || isempty(fieldnames(args{1})))
    return
  end
  [y0, p] = init(p);
  if p.t_init
    % first pass
    p0 = p;
    for m = {'zap','ramp','step'}
      if isfield(p,m), p0 = rmfield(p,m); end
    end
    p0.t_end = p.t_init;
    [t y I s] = simulate(y0, p0);
    if spiked(), return, end
    y0 = y(end,:);
  end
  [t y I s] = simulate(y0, p);
  %%
  function b = spiked
    b = ~p.allow_spiking;
    if b
      b = ((~isempty(s) && isfield(s, 'xe') && ~isempty(s.xe)) || ...
           max(y(:,1)) > p.spike_thld);
    end
  end
end

function [t y I s] = simulate(y0, p)
% run simulation given initial state y (vector) and parameters
% integration method given by p.solver may be any known
% integrator method, either Matlab ODE solver or other provided by user
% ('euler' and 'C_N' are defined below) 
% returns time vector, state variable array (time along first
% dimension), ionic currents array, and, if ODE used,
% integration solution object

  % display starting values
  disp(p)
  % fixed time steps, or let ODE solver choose
  if isfield(p,'dt') && p.dt > 0
    tspan = 0:p.dt:p.t_end;
  else
    tspan = [0 p.t_end];
  end
  % solver function arguments
  a = { @dydt tspan y0 };
  use_ode = logical(strfind(p.solver, 'ode'));
  if use_ode
    a = [ a odeset('Events', @spiking, ...
                   'Refine', 1, 'RelTol', 1e-4) ]; % ODE opts
  else
    assert(isfield(p,'dt') && p.dt < 1, 'time step, 0 < dt < 1, required')
  end
  a = [ a p ];
  % handle to desired solver
  solver = str2func(p.solver);
  % integrate system
  clock_start = cputime;
  if use_ode
    s = solver(a{:});  % solution from ODE
    r = spike_report(s);
    % Matlab bug: does not return solution at times given in tspan
    if size(tspan,2) > 2
      if ~p.allow_spiking && (r > 0 || ~isempty(s.xe))
        t = 0:p.dt:s.xe(1);
      else
        t = tspan;
      end
      y = deval(s, t)';
    else
      t = s.x';
      y = s.y';
    end
  else
    s = struct;
    [ t y ] = solver(a{:});
  end
  fprintf(1, 'elapsed CPU: %d', cputime - clock_start);
  % display the final values
  k = p.state_key;
  y_end = struct('V', y(end,k.V), 'n', y(end,k.n), 'k', y(end,k.k), ...
                 'h', y(end,k.h), 's', y(end,k.s));
  % ion currents at evaluated time steps
  I = intg_current(y, p);
  y_end.I = I(end,:)
end

function do_plots(t, y, I)
% given time vector, state variable array (size(y,1) == length(t)) and
% currents array, plot Vm vs. t, current gates vs. t, currents vs. t
% and currents vs. Vm in a single figure, returning graphic handle
  sd = get(0,'ScreenSize');
  set(0,'DefaultTextFontSize', 8, 'DefaultAxesFontSize', 8);
  figure('Color','white', ...
         'Position', [sd(1), sd(4)-sd(4)/5, 0.8*sd(3), 0.8*sd(4)]);
  % membrane potential
  subplot(7,3,[1 4 7]);
  V = y(:,1);
  % assume Vm starts near rest, scale if in millivolts
  if abs(y(1,1)) < 1, V = 1000*V; end
  plot(t,V);
  axis tight
  title('membrane potential trace');
  xlabel('time (ms)'); ylabel('V_m (mV)');
  % current gates
  c = { 'Hf' 'Hs' 'NaP' 'Na+' 'Na-' 'K' 'M' }; 
  for k = 1:7
    subplot(7,3,k*3-1);
    plot(t,y(:,1+k));
    set(gca,'ActivePositionProperty','OuterPosition');
    axis tight
    ylabel(c{k});
  end
  xlabel('time (ms)'); 
  % legend arguments are reversed with plotyy, who knows why?
  %l = legend('Hf', 'Hs', 'NaP', 'Na+','Na-','K','M'); 
  %set(l, 'FontSize',8, 'Location', 'NorthEastOutside');
  % ion currents
  c = { 'I_H' 'I_{NaP}' 'I_{Na}' 'I_K' 'I_M' 'I_S' };
  subplot(7,3,3);
  title('current vs. time');
  for k = 1:6
    subplot(7,3,k*3);
    plot(t, I(:,k));
    set(gca,'ActivePositionProperty','OuterPosition');
    axis tight
    ylabel(c{k})
  end
  xlabel('time (msec)'); 
  %l = legend(c{:}); 
  %set(l, 'FontSize',8,'Location','NorthEastOutside');
  % I-V curves
  subplot(7,3,[13 16 19]);
  mI = repmat(mean(I(:,[1 2 5])),size(I,1),1);
  plot(V,I(:,[1 2 5]) - mI);
  title('mean ion currents vs. membrane potential');
  xlabel('Vm (mV)'); ylabel('current');
  l = legend('I_H', 'I_{NaP}', 'I_M'); 
  set(l, 'FontSize',7,'Location','Best');
  legend boxoff
end

function p = parse_cl(args)
% args: cell optionally containing param struct, initial state vector
% returns param structure (optional inital state is assigned to 'y0')
  if ~isempty(args) && isstruct(args{1}) && ~isempty(fieldnames(args{1}))
    p = args{1};
    if length(args) > 1 && ~isempty(args{2})
      assert(isrealvec(args{2}), help(mfilename));
      p.y0 = args{2};
    end
  else
    p = scm_parm;
  end
  assert(isstruct(p), help(mfilename));
end

%% Default parameters

% default rejects spiking to save computation
function p = dft_spiking(p)
  p.allow_spiking = 0;
  p.spike_thld = -40;
  p.spike_shift = -54;
end

% default values; generate spikes when fast currents enabled, smpo
% when fast currents disabled
function p = scm_parm
% return struct with Fransen / Heys MEC II SC simulation parameters
% for subthreshold oscillation model using H, NaP and M and spiking currents
  p.t_end = 1e3; % msec
  p.t_init = 1e3;
  p.dt = .1; % msec
  p.chnl_par = default_channel_params();
  p.vdr = 'mec2sc_vdr(p)';
  p.solver = 'ode15s';
  p = dft_spiking(p);

  p.C_m   =  1; % uF/cm^2
  p.I_app =  1;  % injected current uA (?)
  p.V_0   = -60; % initial Vm (mV)
  %p.y0   = [p.V_0 2e-4 0.22 0.76];

  p.V_H   = -20;
  p.V_K   = -83; %  Fransen '04; Traub: -75; Migliore '95: -91
  p.V_L   = -90;
  p.V_Na  =  87;
  p.V_NaP =  87;
  p.V_Se  = 0; % excititory synaptic channel reversal potential
  p.V_Si  = -75; % inhibitory synaptic channel reversal potential

  p.G_H_Fast_Max = .13; % mS/cm^2
  p.G_H_Slow_Max = .079;
  p.G_L          = .07;  % IB, 0.08 Heys '10
  p.G_M_Max      = .07;
  p.G_NaP_Max    = .065; % IB, 0.06 Heys '10
  p.G_Na_Max     = 3.8; % Fransen; Traub Tbl 3: 30;  mS/cm^2
  p.G_K_Max      = 10.7; % Fransen; Traub Tbl 3: 15

  % Destexhe '01, per Heys '09
  diam = 20e-4; % cm
  % p.cell area = pi * diam^2; area of sphere
  hgt = 20e-4;
  rad = diam/2;
  p.cell_area = pi * rad^2 + pi * rad * sqrt(hgt^2 + rad^2); % cm^2, conical
  te = 2.728; ti = 10.49;  % time constants (msec), excitatory, inhibitory
  p.syn = struct('g', 9e-9, 't', {te,ti}, ...
                 'd', {1e-9*sqrt(2/te), 1e-9*sqrt(2/ti)});
end

function [y, p] = init(p)
% initialize and return state vector and updated parameter
% (struct), given required parameter (struct); also sets initial
% ion currents 
  % voltage dependent rate functions
  if ~isfield(p, 'vdr')
    p.vdr = 'mec2sc_vdr(p)';
  end
  % keys for state variable indexing
  p.state_key = struct('V',1,'n',2,'k',3,'h',4,...
                       'Na1',5,'Na0',6,'K',7,'s',8,'S1',9,'S0',10);
  k = p.state_key;
  % keys for current array indexing
  p.currents = struct('H',1,'NaP',2,'Na',3,'K',4,'M',5,'SN',6);
  % default initial state based on starting membrane potential
  V_0 = p.V_0;
  y(k.V) = V_0;
  vdr = eval(p.vdr);
  y(k.n) = vdr.n_inf(V_0);  % H fast activ'n
  y(k.k) = vdr.k_inf(V_0);  % H slow activ'n
  y(k.h) = vdr.h_inf(V_0);  % Fransen integrates NaP inactiv'n only
  y(k.Na1) = vdr.Na1_inf(V_0);  % fast Na activ'n
  y(k.Na0) = vdr.Na0_inf(V_0);  % fast Na inactiv'n
  y(k.K) = vdr.K_inf(V_0);   % fast K activn'
  y(k.s) = vdr.s_inf(V_0);  % M activ'n

  p1 = dft_spiking(p);
  if ~isfield(p,'spike_thld')
    p.spike_thld = p1.spike_thld;
  end
  if ~isfield(p,'allow_spiking')
    p.allow_spiking = p1.allow_spiking;
  end

  % Destexhe synaptic gating
  if isfield(p,'syn');
    y(k.S1) = p.syn(1).g; 
    y(k.S0) = p.syn(2).g; 
    % noise signal
    %rand('twister', sum(fix(clock)));  % seed randomizer
    tmax = max(p.t_init,p.t_end);
    if ~isfield(p,'noise_sig') || isempty(p.noise_sig) || ...
          length(p.noise_sig.t) < tmax/p.dt
      T = 0:p.dt:tmax;
      p.noise_sig = struct('t', T, 'x', ...
                           [randn(size(T)); randn(size(T))]);
    end
  end  
  % update with initial state values from user
  if isfield(p, 'y0')
    for k=1:length(p.y0)
      y(k) = p.y0(k);
    end
  end
  % optional AC input signal
  if isfield(p,'zap')
    T = 0:p.dt:p.t_end;
    p.zap_sig = zap_current(p.zap.ampl, zap_freq(p.zap.freq, T), T);
  end
end

%% Difference Equations
% Method called by solver routines to integrate the dynamical
% system. The system variables are the membrane voltage (Vm), and
% conductances for persistent Na current inactivation, H-current (fast
% and slow; _Fransén 2004_) and M-current (
% <http://www.ncbi.nlm.nih.gov/pubmed/7608762?dopt=abstract
% Migliore 1995>), fast (spiking) Na and K currents (_Traub 1991_)
% and synaptic input modeled as a point conductance (
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
  vdr = eval(p.vdr);  % voltage dependent rate functions
  k = p.state_key;
  if isfield(p,'is_ventral')
    cell_pos = p.is_ventral;
  else
    cell_pos = 0;  % use default (dorsal)
  end
  % leakage current
  I_L = p.G_L * (V - p.V_L);
  % sum ionic currents
  I = intg_current(y', p);
  assert(~hasInfNaN(I), [...
      'invalid current at t=' num2str(t) '; y=' num2str(y')]);
  ti = 1+floor(t/p.dt);
  I_inj = p.I_app;
  if isfield(p,'zap')
    I_inj = I_inj + p.zap_sig(ti);
  end
  if isfield(p,'step')
    I_inj = I_inj + step_current(t, p);
  end
  if isfield(p,'ramp')
    I_inj = I_inj + p.ramp(1) + diff(p.ramp) * t / p.t_end;
  end

  % difference equations
  % membrane potential
  dy(k.V,1) = (I_inj - sum(I) - I_L) / p.C_m;
  % change in fast H-current gate
  if p.G_H_Fast_Max > 0
    dy(k.n,1) = (vdr.n_inf(V, cell_pos) - y(k.n)) / vdr.tau_n(V, cell_pos);
  else
    dy(k.n,1) = 0;
  end
  % change in slow H-current gate 
  if p.G_H_Slow_Max > 0
    dy(k.k,1) = (vdr.k_inf(V, cell_pos) - y(k.k)) / vdr.tau_k(V, cell_pos); 
  else
    dy(k.k,1) = 0;
  end
  % change in persistent sodium inactivation 
  if p.G_NaP_Max > 0
    dy(k.h,1) = (vdr.h_inf(V) - y(k.h)) / vdr.tau_h(V);
  else
    dy(k.h,1) = 0;
  end
  % change in fast sodium activation
  if p.G_Na_Max > 0
    dy(k.Na1,1) = (vdr.Na1_inf(V) - y(k.Na1)) / vdr.tau_Na1(V);
    % change in fast sodium inactivation
    dy(k.Na0,1) = (vdr.Na0_inf(V) - y(k.Na0)) / vdr.tau_Na0(V);
  else
    dy(k.Na1,1) = 0; dy(k.Na0,1) = 0;
  end
  % change in fast potassium activation
  if p.G_K_Max > 0
    dy(k.K,1) = (vdr.K_inf(V) - y(k.K)) / vdr.tau_K(V);
  else
    dy(k.K,1) = 0;
  end
  % change in M-current gate
  if p.G_M_Max > 0
    dy(k.s,1) = (vdr.s_inf(V) - y(k.s)) / vdr.tau_s(V);
  else
    dy(k.s,1) = 0;
  end
  % Destexhe synaptic input noise
  if isfield(p, 'syn')
    dy(k.S1,1) = (p.syn(1).g - y(k.S1)) / p.syn(1).t + p.syn(1).d * ...
        p.noise_sig.x(1,ti);
    dy(k.S0,1) = (p.syn(2).g - y(k.S0)) / p.syn(2).t + p.syn(2).d * ...
        p.noise_sig.x(2,ti);
  end
end

function I = intg_current(y, p)
% return integrated currents array
  if isfield(p, 'syn') && p.cell_area > 1e-8, n = 6; else n = 5; end
  k = p.state_key;
  c = p.currents;
  I = zeros(size(y,1), 6);
  vdr = eval(p.vdr);
  m_inf = vdr.m_inf;
  for i = 1:size(I,1)
    V = y(i,k.V);
    % H current
    I(i,c.H) = (p.G_H_Fast_Max * y(i,k.n) + ...
                p.G_H_Slow_Max * y(i,k.k)) * (V - p.V_H);
    % persistent sodium current
    I(i,c.NaP) = p.G_NaP_Max * m_inf(V) * y(i,k.h) * (V - p.V_NaP);
    % fast Na current (Traub '91)
    I(i,c.Na) = p.G_Na_Max * y(i,k.Na1)^2 * y(i,k.Na0) * (V - p.V_Na);
    % fast K current
    I(i,c.K) = p.G_K_Max * y(i,k.K) * (V - p.V_K);
    % "M" current
    I(i,c.M) = p.G_M_Max * y(i,k.s) * (V - p.V_K);
    % Destexhe synaptic background noise
    if n > 5
      I(i,c.SN) = (y(i,k.S1) * (V - p.V_Se) + ...
                   y(i,k.S0) * (V - p.V_Si)) / p.cell_area;
    end
  end
end

function x = step_current(t, p)
% return applied current value
% t -- current time
% p.I_app -- applied current value
% p.I_app_t -- optional [start end] injection interval times
  if isfield(p, 'step')
    if length(p.step.time) == 1, p.step.time = [0 p.step.time(1)]; end
    if p.step.time(1) <= t && t < p.step.time(2)
      x = p.step.ampl;
    else
      x = 0;
    end
  end
end

function f = zap_freq(f, t)
% args: f ([min=0] max), t time vector (msec)
  if length(f) < 2, f = [0 f]; end
  f = f(1) + t*1e-3*(f(2) - f(1))/(2e-3*t(end));
end

function I = zap_current(I0, f, t)
% args: I0 (ampl.), f(t) (freq), time vector (msec)
  I = I0 * sin(2e-3*pi*f.*t);
end

function [value,isterminal,direction] = spiking(t, y, p)
% ode events function reports spiking events
  value = y(1) - p.spike_thld;
  isterminal = ~p.allow_spiking;
  direction = 1;
end

function r = spike_report(s)
% arg - ode solution, events assumed to be configured to occur on
% spikes; returns firing rate
  r = 0;
  if isfield(s,'xe') && ~isempty(s.xe)
    fprintf(1, 'spiking ');
    if numel(s.xe) > 1
      r = 1000/mean(diff(s.xe));
      if r > 2
        fprintf(1, 'avg. rate %.3g Hz, ', r);
      end
    end
    fprintf(1, 'started at %g msec\n', s.xe(1));
  end
end


% Direct integration methods
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
    if ~p.allow_spiking && (y(i,1) > p.spike_thld); break, end
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
    if ~p.allow_spiking && (y(i,1) > p.spike_thld); break, end
    tmp = v + (p.dt/2) * fcn(t(i), v, p);
    y(i+1,:) = y(i,:) + p.dt * fcn(t(i), tmp, p)';
  end
end

%% Voltage dependent parameter equations
%
% Sets of nested functions that provide instantaneous values of system
% variables dependent only on the current membrane
% potential. Retuns a struct containing handles to all the functions.
%
% Persistent sodium equations from _Fransen '04_, p. 372, scaled to mV;
% H current per _Heys '09_, M current per _Migliore '95_, fast Na
% and K from _Traub '91_ 

function h = mec2sc_vdr(p)
% returns struct with function handles to voltage dependent
% functions of channel time constants and steady state
% probabilities; optional argument contains a structure field named
% 'chnl_par' or else is assumed itself to be the channel parameter
% structure 
  if nargin
    if isfield(p,'chnl_par'), chnl_par = p.chnl_par; else chnl_par = p; end
  else
    chnl_par = default_channel_params();
  end

  if ~isfield(p,'spike_shift'), p.spike_shift = -54; end
  spike_shift = p.spike_shift; % Fransen 2004

  h = struct('m_inf', @NaP_actv_inf, ...
             'tau_h', @tau_NaP_inactv, 'h_inf', @NaP_inactv_inf, ...
             'tau_Na1', @tau_Na_actv, 'Na1_inf', @Na_actv_inf, ...
             'tau_Na0', @tau_Na_inactv, 'Na0_inf', @Na_inactv_inf, ...
             'tau_K', @tau_K_actv, 'K_inf', @K_actv_inf, ...
             'tau_n', @tau_n, 'n_inf', @n_inf, ...
             'tau_k', @tau_k, 'k_inf', @k_inf, ...
             'tau_s', @tau_s, 's_inf', @s_inf);

  % fast Na activation (Traub '91, Alonso '93, Fransen '94)
  function a = alpha_Na_actv(V)
    V = V - spike_shift;
    a = 0.32 * (V - 13.1)./(1 - exp(-(V - 13.1)./4));
  end
  
  function b = beta_Na_actv(V)
    V = V - spike_shift;
    b = -0.28 * (V - 40.1)./(1 - exp((V - 40.1)./5));
  end

  function tau = tau_Na_actv(V)
    tau = 1./(alpha_Na_actv(V) + beta_Na_actv(V));
  end

  function inf = Na_actv_inf(V)
    inf = alpha_Na_actv(V) .* tau_Na_actv(V);
  end

  % fast Na inactivation (Traub '91, Alonso '93, Fransen '94)
  function a = alpha_Na_inactv(V)
    V = V - spike_shift;
    a = 0.128 * exp(-(V - 17)./18);
  end
  
  function b = beta_Na_inactv(V) 
    V = V - spike_shift;
    b = 4./(1 + exp(-(V - 40)./5));
  end
  
  function tau = tau_Na_inactv(V)
    tau = 1./(alpha_Na_inactv(V) + beta_Na_inactv(V));
  end

  function inf = Na_inactv_inf(V)
    inf = alpha_Na_inactv(V) .* tau_Na_inactv(V);
  end

  % K activation (delayed rectification; Traub '91, Alonso '93, Fransen '94)
  function a = alpha_K_actv(V)
    V = V - spike_shift;
    a = 0.016 * (V - 35.1)./(1 - exp(-(V - 35.1)./5));
  end

  function b = beta_K_actv(V)
    V = V - spike_shift;
    b = 0.25 * exp(-(V - 20)./40);
  end

  function tau = tau_K_actv(V)
    tau = 1./(alpha_K_actv(V) + beta_K_actv(V));
  end

  % fast potassium current activation
  function inf = K_actv_inf(V)
    inf = alpha_K_actv(V) .* tau_K_actv(V);
  end

  % Magistretti & Alonso 1999
  % persistent sodium current activation
  function inf = NaP_actv_inf(V)
    V = V./1000;
    p = chnl_par.NaP.actv_steady_state;
    inf = 1./(1 + exp(-(V + p(1))./p(2))); % "mP", not integrated
  end
  % persistent sodium current inactivation
  function a = alpha_NaP_inactv(V)
    V = V./1000;
    p = chnl_par.NaP.inactv.alpha;
    a = (p(1)*V + p(2))./(1 - exp((V + p(2)/p(1))./p(3))); 
  end

  function b = beta_NaP_inactv(V)
    V = V./1000;
    p = chnl_par.NaP.inactv.beta;
    b = (p(1)*V + p(2))./(1 - exp(-(V + p(2)/p(1))./p(3)));  
  end

  function inf = NaP_inactv_inf(V)
    V = V./1000;
    p = chnl_par.NaP.inactv.steady_state;
    inf = 1./(1+exp((V+p(1))./p(2)));  % "hP"
  end

  % time constant in milliseconds
  function tau = tau_NaP_inactv(V)
    tau = 1./(alpha_NaP_inactv(V) + beta_NaP_inactv(V));
  end

  % hyperpolarization channel
  function tau = tau_n(V, m)
    if nargin > 1 && m > 0 
      tau = tau_n_v(V);
    else
      p = chnl_par.H.tau_fast;  % mH_Fast_tau dorsal
      tau = p(1)./(exp(-(V + p(2))./p(3)) + exp((V + p(4))./p(5))); 
    end
  end

  function inf = n_inf(V, m)
    if nargin > 1 && m > 0 
      inf = n_inf_v(V);
    else
      p = chnl_par.H.inf_fast;
      inf = 1./(1 + exp((V + p(1))./p(2)));  % mH_Fast_inf dorsal
    end
  end

  % time constant in milliseconds
  %dorsal
  function tau = tau_n_d(V)
    %mH_Fast_tau, fit by ISB to Giocomo (2007) data on 10/15/09
    %using Matlab cftool
    tau = 29.53./(exp(-(V + 98.99)./15.39) + exp((V + 25.07)./9.643)); 
  end

  function inf = n_inf_d(V)
    inf = 1./(1 + exp((V + 68.08)./7.14));  % mH_Fast_inf dorsal
  end

  %ventral
  function tau = tau_n_v(V)
    tau = 327.2./(exp((V + 40.1)./13.6) + exp((V + 70.2)./-23.8)); %mH_Fast_tau
  end

  function inf = n_inf_v(V)
    inf = 1./(1 + exp((V + 68.08)./5.46));  % mH_Fast_inf ventral
  end

  % time constant in milliseconds
  function tau = tau_k(V, m)
    if nargin > 1 && m > 0 
      tau = tau_k_v(V);
    else
      p = chnl_par.H.tau_slow;
      tau = p(1)./(exp((V + p(2))./p(3)) + exp(-(V + p(4))./p(5))); 
    end
  end

  function inf = k_inf(V, m)
    if nargin > 1 && m > 0
      inf = k_inf_v(V);
    else
      p = chnl_par.H.inf_slow;
      inf = 1./(1 + exp((V + p(1))./p(2)));
    end
  end

  function tau = tau_k_d(V)
    %mH_Slow_tau, fit by ISB to Giocomo (2007) data on 10/16/09
    %using Matlab cftool 
    tau = 357.1./(exp((V + 30.62)./5.995) + exp(-(V + 115.6)./41.03)); 
  end

  function inf = k_inf_d(V)
    inf = 1./(1 + exp((V + 68.08)./7.14));  % mH_Slow_inf
  end
    
  function tau = tau_k_v(V)
    tau = 458.8./(exp((V + 39.5)./6.1) + exp(-(V + 90.6)./13.8));  % mH_Slow_tau
  end

  function inf = k_inf_v(V)
    inf = 1./(1 + exp((V + 68.08)./5.46));  % mH_Slow_inf
  end

  % Migliori (1995) M current channel
  function inf = s_inf(V)
    vs = chnl_par.M.s * (V - chnl_par.M.v_2);
    inf = 1 ./ (1 + exp(vs));
  end

  function tau = tau_s(V)
    vs = chnl_par.M.s * (V - chnl_par.M.v_2);
    tau = exp(chnl_par.M.gm * vs) ./ (chnl_par.M.ts * (1 + exp(vs)));
  end
end


function p = default_channel_params()
  p = struct();
  p.temp = 37;  % physiologic, Celsius
  p.H = struct(...  % ISB fits to Giocomo (2007) for dorsal time constants
      'tau_fast', [29.53 98.99 15.39 25.07 9.643],...
      'inf_fast', [68.08 7.14],...
      'tau_slow', [357.1 30.62 5.995 115.6 41.03],...
      'inf_slow', [68.08 7.14]);
  p.NaP = struct(...
      'actv_steady_state', [0.0487 0.0044],...
      'inactv', struct(...
          'alpha', [-2.88 -0.0491 0.00463],...
          'beta', [6.94 0.447 0.00263],...
          'steady_state', [0.0488 0.00998]) );
  p.M_chnl_par = 'M_chnl_par';
  p.M = eval([p.M_chnl_par '(p.temp)']);
end

function s = M_chnl_par(T)
  if nargin < 1, T = 37; end
  s = struct(...
      'v_2', -55, 's', -7e-3 * 9.648e4 / (8.315 * (273.16 + T)),...
      'gm', 0.8, 'ts', 2e-4 * 5^((T - 22)/10));
end
