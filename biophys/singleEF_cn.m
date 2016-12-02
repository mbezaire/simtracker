function singleEF_cn(t_end)
%HeysSinglEFtoIanBoardman.m 
%This script creates subthreshold oscillations using the parameter values
%determined from the voltage clamp data by Lisa Giocomo.  This is the best
%looking version of subthreshold oscillations obtained in this series of
%scripts.  Occasionally, there are large amplitude NaP spikes that occur,
%but the oscillations themselves should only be a couple of millivolts in
%amplitude.
% moved from Euler method to Crank-Nicolson, ISB 5/09

param_mat = 'hh/subthld_osc_parm';

%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%
%size of time step - Reduced time step because still looks same 0
delta_t =  .001; 
if ~nargin, t_end = 40; end
n_steps = t_end / delta_t;

%%%%%%%%%%%%%%%%%%%%%%%setup%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
load(param_mat); % fixed parameters

V = zeros(n_steps, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%Initial Conditions%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Try to avoid initial transients by using as initial
%conditions variables from end V(10000000)=-0.0566
V(1) = -0.058; %-0.0566;
mH_Fast = 0.0764; %0.0781; %0.0706
mH_Slow = 0.1540; %0.1575; %0.1428
%m = 0.1238; %0.1194; %0.1413
h = 0.7012; %0.6859; %0.6776
var = { 'm' 'h_inf' 'tau_h' 'alpha_H_Fast' 'beta_H_Fast' ...
        'alpha_H_Slow' 'beta_H_Slow' };
for i = 1:length(var), r.(var{i}) = 0; end

clock_start = cputime;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:n_steps-1
  % update voltage dependent activation rates
  r = volt_dep_rates(r, V(i));

  g_l = gMax_Leak;
  % noise term for Leak conductance
  if rand(1) > .97, g_l = 0.98 * g_l; end

  % Difference equations
  % voltage trace  
  Vh = V(i) + (delta_t / 2) * rCm * ...
       (-gMax_H_Fast * mH_Fast * (V(i) - Rev_H) - ...
        gMax_H_Slow * mH_Slow * (V(i) - Rev_H) - ...
        gMax_NaP * r.m * h * (V(i) - Rev_NaP) - ...
        g_l * (V(i) - Rev_Leak) + Ie);
  V(i+1) = V(i) + delta_t * rCm * ...
           (-gMax_H_Fast * mH_Fast * (Vh - Rev_H) - ...
            gMax_H_Slow * mH_Slow * (Vh - Rev_H) - ...
            gMax_NaP * r.m * h * (Vh - Rev_NaP) - ...
            g_l * (Vh - Rev_Leak) + Ie);

  % difference equation for the fast H-current gate
  mh = mH_Fast + (delta_t / 2) * (r.alpha_H_Fast * (1 - mH_Fast) - ...
                                  r.beta_H_Fast * mH_Fast); 
  mH_Fast = mH_Fast + delta_t * (r.alpha_H_Fast * (1 - mh) - ...
                                 r.beta_H_Fast * mh); 
  
  % difference equation fr the slow H-current gate
  mh = mH_Slow + (delta_t / 2) * (r.alpha_H_Slow * (1 - mH_Slow) - ...
                                  r.beta_H_Slow * mH_Slow);
  mH_Slow = mH_Slow + delta_t * (r.alpha_H_Slow * (1 - mh) - ...
                                 r.beta_H_Slow * mh);  

  % difference equation for the inactivation NaP gate 
  % h + delta_t*(alpha_inactivation_NaP*(1 - h) - h*beta_inactivation_NaP);
  hh = h + (delta_t / 2) * ((r.h_inf - h)/r.tau_h);
  h = h + delta_t * ((r.h_inf - hh)/r.tau_h);

end
disp({ 'elapsed CPU', cputime - clock_start });

%%%%%%%%%%%%%%%%%%%%%Graphs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 1:n_steps;
figure('position',[10 10 500 500]);
plot(t*delta_t,V) %Multiply to plot time on x axis in seconds.

%At end V(10000000)=-0.0566
%mH_Fast=0.0706;
%mH_Slow=0.1428;
%m=0.1413
%h=0.6776
end_state = struct('V', V(i+1), 'mH_Fast', mH_Fast, 'mH_Slow', ...
                   mH_Slow, 'm', r.m, 'h', h)

%% Sub-functions 
function r = volt_dep_rates(r, V) 
  % given current membrane voltage returns a struct containing
  % alpha and beta, fast and slow, 
  % steady-state persistant sodium inactivation h_inf and time
  % constant tau_h

  %Persistant Na activation 
  %alpha_actvn_NaP = (.091e6*(V + .038))/(1 - exp(-(V + .038)/.005)); 
  %beta_actvn_NaP = (-.062e6*(V + .038))/(1 - exp((V + .038)/.005)); 
  r.m = 1/(1 + exp(-(V + .0487)/.0044)); 

  %Persistant Na inactivation 
  alpha_inactvn_NaP = (-2.88*V - .0491)/(1 - exp((V - .0491)/.00463));
  beta_inactvn_NaP = (6.94*V + .447)/(1 - exp(-(V + .447)/.00263)); 
  
  r.h_inf = 1/(1 + exp((V + .0488)/.00998));
  r.tau_h = 1/(alpha_inactvn_NaP + beta_inactvn_NaP);
  
  % H current gating variable steady state activation - fast component
  %mH_Fast_inf = 1/((1 + (exp((V + .0728)/.008)))); %^(1.36)); 
  mH_Fast_inf = 1/((1 + (exp((V + .10)/.003)))); %^(1.36)); 
                                                    
  % H current gating variable steady state activation - slow component
  mH_Slow_inf = 1/((1 + (exp((V + .00283)/.0159)))^(58.5)); 

  % H current time constant - fast component
  tauH_Fast = .00051/(exp((V - .0017)/.010) + exp(-(V + .34)/.52)); 

  % H current time constant - slow component
  tauH_Slow = .0056/(exp((V - .017)/.014) + exp(-(V + .26)/.043)); 

  r.alpha_H_Fast = mH_Fast_inf/tauH_Fast;
  r.beta_H_Fast = (1 - mH_Fast_inf)/tauH_Fast;
  r.alpha_H_Slow = mH_Slow_inf/tauH_Slow;
  r.beta_H_Slow = (1 - mH_Slow_inf)/tauH_Slow;
  