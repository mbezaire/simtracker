function singleEF_ode(t_end, parmf)
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
  parmf = 'singleEF.mat';
  save_params();
end
params = load(parmf);

%%%%%%%%%%%%%%%%%%%%%%%%%%Initial Conditions%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Try to avoid initial transients by using as initial
% conditions variables set to values found after a long time

% default initial values (starting state)
V_0=-0.061; %-0.0566;
mH_Fast=0.0764; %0.0781; %0.0706
mH_Slow=0.1540; %0.1575; %0.1428
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

v = struct();
for i = 1:n_var, v.(vname{i}) = y(end, i); end
v
do_plot(t, y(:, 1))


%% %%%%%%%%%%%%%%%%%%%Subfunctions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = save_params()
Cm = .01;  % membrane capacitance
rCm = 1e3/Cm; % scaled reciprocal Cm
%%%%%%conductances%%%%%%%%
gMax_H_Fast = .98e-3; % scaled by 0.001
gMax_H_Slow = .53e-3; % scaled by 0.001
gMax_NaP = .5e-3; % scaled by 0.001  %Good at NaP=0.5 Ie=.000002623; 
%Okay at NaP 0.52 Ie=0.00000233
%Comopare with NaP=0.54 and Ie=0.000002
%Good at NaP=0.48, Ie=0.00000293.  %Increased from 0.38
gMax_Leak = .58e-3; % scaled by 0.001
%%%%Reverasal Potentials%%%%%
Rev_H = -.020;
Rev_NaP = .087;
Rev_Leak = -.083;
% applied current
%Ie = 0.0000011; %With Depol mH_Fast. 
Ie = 4.72e-6; %%623 %.00431;  %0.0043 
f = strcat(mfilename, '.mat');
if ~exist(f) save(f), end

function do_plot(t, V)
figure('position',[10 10 500 500]);
plot(t, V) 

% for ode15s if used
function [jac] = init_jac(n)
% Specify fields important to the Jacobian of size n
jac = sparse(n, n);
jac(1,1:n+1) = 1;
for i = 2:n, jac(i, i) = 1; end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dy = osc_sys(t, y, l, p)
% dynamical system equations passed to ODE
% t -- current time
% y -- state variable vector
% l -- struct with fields assigned to indices in y
% p -- fixed parameters (struct)
dy = zeros(size(y));

V = y(l.V);
%Persistant Na activation 
alpha_activation_NaP = (.091e6*(V + .038))/(1 - exp(-(V + .038)/.005)); 
beta_activation_NaP = (-.062e6*(V + .038))/(1 - exp((V + .038)/.005)); 

%Persistant Na inactivation 
alpha_inactivation_NaP = (-2.88*V - .0491)/(1 - exp((V - .0491)/.00463));
beta_inactivation_NaP = (6.94*V + .447)/(1 - exp(-(V + .447)/.00263)); 

% NaP activation gate 
% alpha_activation_NaP/(alpha_activation_NaP + beta_activation_NaP)     
% m + delta_t*(alpha_activation_NaP*(1 - m) - beta_activation_NaP*m);
m = 1/(1 + exp(-(V + .0487)/.0044)); 

hinf = 1/(1 + exp((V + .0488)/.00998));
tauh = 1/(alpha_inactivation_NaP + beta_inactivation_NaP);

% H current gating variable steady state activation - fast component
%mH_Fast_inf = 1/((1 + (exp((V(i) + .0728)/.008)))); %^(1.36)); 
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

%%%%%%%%%%%%%%%%Difference equations%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% difference equation for the voltage trace  
dy(l.V) = diffeq_V(y(l.V), y(l.mH_Fast), y(l.mH_Slow), m * y(l.h), p);

% difference equation for the fast H-current gate
dy(l.mH_Fast) = diffeq_m(y(l.mH_Fast), alpha_H_Fast, beta_H_Fast);
% difference equation fr the slow H-current gate
dy(l.mH_Slow) = diffeq_m(y(l.mH_Slow), alpha_H_Slow, beta_H_Slow);

dy(l.m) = 0;

% difference equation for the inactivation NaP gate 
% h + delta_t*(alpha_inactivation_NaP*(1 - h) - h*beta_inactivation_NaP);
dy(l.h) = (hinf - y(l.h))/tauh; 


function r = diffeq_V(V, mH_Fast, mH_Slow, aP, p) 
% difference equation for voltage
% V -- input V
% mH_{fast,slow} -- hyperpolarization activation
% aP -- persistent current gating product (m * h)
% p -- required fixed parameters (struct)

% noise term for Leak conductance
if rand(1) > .97
  lk_frac = 0.98;
else
  lk_frac = 1;
end

r = p.rCm * (...
    -p.gMax_H_Fast * mH_Fast * (V - p.Rev_H) - ...
    p.gMax_H_Slow * mH_Slow * (V - p.Rev_H) - ...
    p.gMax_NaP * aP * (V - p.Rev_NaP) - ...
    lk_frac * p.gMax_Leak * (V - p.Rev_Leak) + p.Ie);


function r = diffeq_m(mH, alpha, beta)
r = alpha * (1 - mH) - beta * mH; 
