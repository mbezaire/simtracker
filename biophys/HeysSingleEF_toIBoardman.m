%HeysSinglEFtoIanBoardman.m 
%This script creates subthreshold oscillations using the parameter values
%determined from the voltage clamp data by Lisa Giocomo.  This is the best
%looking version of subthreshold oscillations obtained in this series of
%scripts.  Occasionally, there are large amplitude NaP spikes that occur,
%but the oscillations themselves should only be a couple of millivolts in
%amplitude.

%HeyssingleEBfromAHwithLisaData.m - This script uses the somewhat more
%hyperpolarized values from Lisa's data and also adds small amplitude
%noise.  It gives relatively nice amplitude oscillations in conditions
%where the large spikes do not appear.

%HeyssingleCompWithNoiseMikeAHincreaseNaP.m - Works with a range of
%different increased values of NaP (and reduced current injection Ie).
%%%Good at NaP=0.5 Ie=.000002623; 
%Okay at NaP 0.52 Ie=0.00000233
%Comopare with NaP=0.54 and Ie=0.000002
%Good at NaP=0.48, Ie=0.00000293.  %Increased from 0.38
%Used faster time steps:
%ctr = 5000;  %number of time steps
%delta_t =  .001;

%HeyssingleCompWithNoiseMikeAGtryReducedNaP.m - Reduced NaP does NOT work,
%but increased NaP to 0.48 does work pretty well!


%HeyssingleCompWithNoiseMikeAE.m - Should probably add some actual dimensions of
%the membrane.  20 um length, 15 um diameter.  about 49*3 + 45*20 = 150 +
%1000 = 1150 sq*um ,  1150*10-6 = 0.001150 square meters.  Divide
%everything by about 0.001 = multiply everything by 1000.

%HeyssingleCompWithNoiseMikeAD.m - Try to reduce the time step.

%HeyssingleCompWithNoiseMikeAC.m - Tried to reduce need for long
%simulation periods by inserting final steady state parameters as
%initial conditions.  Got oscillatory dynamics in first short period.

clear all
clc
close all
%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%
ctr = 40000;  %number of time steps
delta_t =  .001; %size of time step - Reduced time step because still looks same 0
%Looks almost the same with 0.00001


%%%%%%%%%%%%%%%%%%%%%%%setup%%%%%%%%%% %%%%%%%%%%%%%%%%%%%
V = zeros(ctr,1);

Cm = .01;
%%%%%%conductances%%%%%%%%
gMax_H_Fast = .98; 
gMax_H_Slow = .53;
gMax_NaP = .5;  %Good at NaP=0.5 Ie=.000002623; 
%Okay at NaP 0.52 Ie=0.00000233
%Comopare with NaP=0.54 and Ie=0.000002
%Good at NaP=0.48, Ie=0.00000293.  %Increased from 0.38
gMax_Leak = .58;

%%%%Reverasal Potentials%%%%%
Rev_H = -.020;
Rev_Leak = -.083;
Rev_NaP = .087;

%Ie = 0.0000011; %With Depol mH_Fast. 
Ie = 0.00000472; %%623 %.00431;  %0.0043 % applied current
%Ie=0; %
%%%%%%%%%%%%%%%%%%%%%%%%%%Initial Conditions%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V(1) = -.054;

mH_Fast = 1/((1 + (exp((V(1) + .10)/.003)))); %^(1.36)); %mH_Fast is the H-current fast acting gating variable
%mH_Fast = 1/((1 + (exp((V(1) + .0728)/.008)))); %^(1.36)); %mH_Fast is the H-current fast acting gating variable
mH_Slow = 1/((1 + (exp((V(1) + .00283)/.0159)))^(58.5)); %mH_Slow is the H-current slow acting gating variable
m = 1/(1 + exp(-(V(1) + .0487)/.0044));  % m is the NaP activation gating variable
h = 1/(1 + exp((V(1) + .0488)/.00998)); %h is the NaP inactivation gating variable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%model%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:ctr-1
    alpha_activation_NaP = (.091*(10^6)*(V(i) + .038))/(1 - exp(-(V(i) + .038)/.005)); %Persistant Na activation 
    beta_activation_NaP = (-.062*(10^6)*(V(i) + .038))/(1 - exp((V(i) + .038)/.005)); 
    
    alpha_inactivation_NaP = (-2.88*V(i) - .0491)/(1 - exp((V(i) - .0491)/.00463)); %Persistant Na inactivation 
    beta_inactivation_NaP = (6.94*V(i) + .447)/(1 - exp(-(V(i) + .447)/.00263)); 
    hinf = 1/(1 + exp((V(i) + .0488)/.00998));
    tauh = 1/(alpha_inactivation_NaP + beta_inactivation_NaP);
    
    mH_Fast_inf = 1/((1 + (exp((V(i) + .10)/.003)))); %^(1.36)); % H current gating variable steady state activation - fast component
    %mH_Fast_inf = 1/((1 + (exp((V(i) + .0728)/.008)))); %^(1.36)); % H current gating variable steady state activation - fast component
    mH_Slow_inf = 1/((1 + (exp((V(i) + .00283)/.0159)))^(58.5)); % H current gating variable steady state activation - slow component

    tauH_Fast = .00051/(exp((V(i) - .0017)/.010) + exp(-(V(i) + .34)/.52)); % H current time constant - fast component
    tauH_Slow = .0056/(exp((V(i) - .017)/.014) + exp(-(V(i) + .26)/.043)); % H current time constant - slow component

    alpha_H_Fast = mH_Fast_inf/tauH_Fast;
    beta_H_Fast = (1 - mH_Fast_inf)/tauH_Fast;
    alpha_H_Slow = mH_Slow_inf/tauH_Slow;
    beta_H_Slow = (1 - mH_Slow_inf)/tauH_Slow;

%%%%%%%%%%%%%%%%%%noise term for Leak conductance%%%%%%%%%%%%%%%%%%%%    
    y = rand(1);
    if y>.97
        x = 0.98;
    else
        x = 1; %Changed from 1.0
    end
% x = 1;
%%%%%%%%%%%%%%%%Difference equations%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
if i==1;
%Try to avoid initial transients by using as initial conditions variables from end V(10000000)=-0.0566
%V(i)=-0.0573; %-0.0566;
mH_Fast=0.0764; %0.0781; %0.0706
mH_Slow=0.1540; %0.1575; %0.1428
m=0.1238; %0.1194; %0.1413
h=0.7012; %0.6859; %0.6776
V(i)=-0.06; %-0.0566;
%mH_Fast=0.764; %0.0781; %0.0706
%mH_Slow=0.15; %0.1575; %0.1428
%m=0.1; %0.1194; %0.1413
%h=0.6; %0.6859; %0.6776
end
    
    V(i+1) = V(i) + delta_t*((0.001*Cm)^(-1)*( -gMax_H_Fast*mH_Fast*0.001*(V(i) - Rev_H)- gMax_H_Slow*mH_Slow*0.001*(V(i) - Rev_H) - gMax_NaP*0.001*m*h*(V(i) - Rev_NaP) - x*(gMax_Leak)*0.001*(V(i) - Rev_Leak) + Ie)); %difference equation for the voltage trace  
    
    mH_Fast = mH_Fast + delta_t*(alpha_H_Fast*(1 - mH_Fast) - beta_H_Fast*mH_Fast); %difference equation for the fast H-current gate
    mH_Slow = mH_Slow + delta_t*(alpha_H_Slow*(1 - mH_Slow) - beta_H_Slow*mH_Slow); % difference equation fr the slow H-current gate

    m =   1/(1 + exp(-(V(i) + .0487)/.0044)); % equation for the NaP activation gate alpha_activation_NaP/(alpha_activation_NaP + beta_activation_NaP)     m + delta_t*(alpha_activation_NaP*(1 - m) - beta_activation_NaP*m);
    h = h + delta_t*((hinf - h)/tauh); %difference equation for the inactivation NaP gate h + delta_t*(alpha_inactivation_NaP*(1 - h) - h*beta_inactivation_NaP);
end

%%%%%%%%%%%%%%%%%%%%%Graphs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 1:ctr;
figure('position',[10 10 500 500]);
plot(t*delta_t,V) %Multiply to plot time on x axis in seconds.


%At end V(10000000)=-0.0566
%mH_Fast=0.0706;
%mH_Slow=0.1428;
%m=0.1413
%h=0.6776
V(i+1)
mH_Fast
mH_Slow
m
h



