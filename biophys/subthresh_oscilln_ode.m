function [t y] = subthresh_oscilln_ode(t_end, parmf)
% Single EF using ODE solver
% based on HeysSinglEFtoIanBoardman.m 
% This script creates subthreshold oscillations using the parameter values
% determined from the voltage clamp data by Lisa Giocomo.  This is the best
% looking version of subthreshold oscillations obtained in this series of
% scripts.  Occasionally, there are large amplitude NaP spikes that occur,
% but the oscillations themselves should only be a couple of millivolts in
% amplitude.
% supply total time t in seconds and optional parameter file

if nargin < 2
  if nargin < 1, t_end = 25; end
  parmf = 'hh/subthld_osc_parm';
end
params = load(parmf);

%%%%%%%%%%%%%%%%%%%%%%%%%%Initial Conditions%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to avoid initial transients by using as initial
% conditions variables set to values found after a long time

% default initial values (starting state)
V_0=-0.061; %-0.0566;
mH_Fast=0.0764; %0.0781; %0.0706
mH_Slow=0.24; %0.1575; %0.1428
m=0.1238; %0.1194; %0.1413
h=0.7012; %0.6859; %0.6776

% run ODE on oscillator system and plots result
y_0 = [V_0, mH_Fast, mH_Slow, m, h];
n_var = length(y_0);
vname = {'V', 'mH_Fast', 'mH_Slow', 'm', 'h'};
vi = struct();
for i = 1:n_var, vi.(vname{i}) = i; end
dydt = @(u, v) osc_sys(u, v, vi, params);

% odeplot is very slow
%options = odeset('OutputFcn', @odeplot, 'OutputSel', [1], 'Stats', 'on');
[ t y ] = ode45(dydt, [0 t_end], y_0);

for i = 1:n_var, end_state.(vname{i}) = y(end, i); end
end_state
figure('position',[10 10 500 500]);
plot(t, y(:,1)) 

%% %%%%%%%%%%%%%%%%%%%Subfunctions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for ode15s if used
function [jac] = init_jac(n)
% Specify fields important to the Jacobian of size n
jac = sparse(n, n);
jac(1,1:n+1) = 1;
for i = 2:n, jac(i, i) = 1; end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dy = osc_sys(t, y, l, p)
  % dynamical system equations passed to ODE
  % t -- time vector
  % y -- state variable vector
  % l -- struct with fields assigned to indices in y
  % p -- fixed parameters (struct)
  dy = zeros(size(y));
  V = y(l.V);
  r = voltage_dependent_rates(V);

  %%%%%%%%%%%%%%%%Difference equations%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  % difference equation for the voltage trace  
  dy(l.V) = diffeq_V(y(l.V), y(l.mH_Fast), y(l.mH_Slow), r.mP * y(l.h), p);

  % difference equation for the fast H-current gate
  dy(l.mH_Fast) = diffeq_m(y(l.mH_Fast), r.alpha_H_Fast, r.beta_H_Fast);
  % difference equation fr the slow H-current gate
  dy(l.mH_Slow) = diffeq_m(y(l.mH_Slow), r.alpha_H_Slow, r.beta_H_Slow);

  dy(l.m) = 0;

  % difference equation for the inactivation NaP gate 
  % h + delta_t*(alpha_inactivation_NaP*(1 - h) - h*beta_inactivation_NaP);
  dy(l.h) = (r.h_inf - y(l.h))/r.tau_h; 


function r = diffeq_V(V, mH_Fast, mH_Slow, gP, p) 
  % difference equation for voltage
  % V -- input V
  % mH_{fast,slow} -- hyperpolarization activation
  % gP -- persistent current gating product (m * h)
  % p -- required fixed parameters (struct)

  % noise term for Leak conductance
  g_l = p.gMax_Leak;
  if rand(1) > .97, g_l = g_l * 0.98; end

  r = p.rCm * (...
      -p.gMax_H_Fast * mH_Fast * (V - p.Rev_H) - ...
      p.gMax_H_Slow * mH_Slow * (V - p.Rev_H) - ...
      p.gMax_NaP * gP * (V - p.Rev_NaP) - ...
      g_l * (V - p.Rev_Leak) + p.Ie);


function r = diffeq_m(mH, alpha, beta)
  r = alpha * (1 - mH) - beta * mH; 


function r = voltage_dependent_rates(V) 
  % given current membrane voltage returns a struct containing
  % alpha and beta, fast and slow, 
  % steady-state persistant sodium inactivation h_inf and time
  % constant tau_h

  %Persistant Na activation 
  % alpha_actvn_NaP = (.091e6*(V + .038))/(1 - exp(-(V + .038)/.005)); 
  % beta_actvn_NaP = (-.062e6*(V + .038))/(1 - exp((V + .038)/.005)); 
  mP = 1/(1 + exp(-(V + .0487)/.0044)); 

  %Persistant Na inactivation 
  alpha_inactvn_NaP = (-2.88*V - .0491)/(1 - exp((V - .0491)/.00463));
  beta_inactvn_NaP = (6.94*V + .447)/(1 - exp(-(V + .447)/.00263)); 
  
  h_inf = 1/(1 + exp((V + .0488)/.00998));
  tau_h = 1/(alpha_inactvn_NaP + beta_inactvn_NaP);
  
  % H current gating variable steady state activation - fast component
  %mH_Fast_inf = 1/((1 + (exp((V + .0728)/.008)))); %^(1.36)); 
  mH_Fast_inf = 1/((1 + (exp((V + .10)/.003)))); %^(1.36)); 
                                                    
  % H current gating variable steady state activation - slow component
  mH_Slow_inf = 1/((1 + (exp((V + .00283)/.0159)))^(58.5)); 

  % H current time constant - fast component
  tauH_Fast = .00051/(exp((V - .0017)/.010) + exp(-(V + .34)/.52)); 

  % H current time constant - slow component
  tauH_Slow = .0056/(exp((V - .017)/.014) + exp(-(V + .26)/.043)); 

  alpha_H_Fast = mH_Fast_inf/tauH_Fast;
  beta_H_Fast = (1 - mH_Fast_inf)/tauH_Fast;
  alpha_H_Slow = mH_Slow_inf/tauH_Slow;
  beta_H_Slow = (1 - mH_Slow_inf)/tauH_Slow;
  r = struct('mP', mP, ...
             'alpha_H_Fast', alpha_H_Fast, 'beta_H_Fast', beta_H_Fast, ...
             'alpha_H_Slow', alpha_H_Slow, 'beta_H_Slow', beta_H_Slow, ...
             'h_inf', h_inf, 'tau_h', tau_h);
  