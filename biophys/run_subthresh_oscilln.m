% script to run subthresh_oscilln.m
clear p v I

% edit total simulation time
T = 25;

% edit the fixed parameters here:
p.Cm = 1.00e-02;            % membrane capacitance constant 
p.Ie = 4.7200e-03;          % electrode current constant 
p.Rev_H = -2.00e-02;        % H-current reversal potential
p.Rev_K = -8.30e-02;        % delayed rectifier reversal potential
p.Rev_Leak = -8.30e-02;     % leakage reversal potential
p.Rev_Na = 5.00e-02;        % fast Na reversal potential
p.Rev_NaP = 8.70e-02;       % persistent Na reversal potential
p.dt = 1.00e-03;            % integration time step
p.gMax_H_Fast = 9.80e-01;   % max. fast H-current conductance
p.gMax_H_Slow = 5.30e-01;   % max. slow H-current conductance
p.gMax_K = 6.5200e-01;      % max. K delayed rectifier conductance
p.gMax_Leak = 5.80e-01;     % max. leakage conductance
p.gMax_Na = 4.00e-01;       % max. fast Na conductance
p.gMax_NaP = 5.00e-01;      % max. persistent Na conductance

% edit the initial conditions (starting values) here:

v.V = -6.1e-02;            % membrane voltage
v.mH_Fast = 7.64e-02;       % H-current fast activation
v.mH_Slow = 2e-1; %1.5400e-01;     % H-current slow activation
v.hP = 7.012e-01;          % persistent Na activation

% turn off fast HH currents
%v.mNa = 1.00e-01;           % fast Na activation (0 to remove fast Na)
%v.hNa = 5.00e-01;           % fast Na inactivation
%v.nK = 1.00e-02;            % K delayed rectifier activ'n (0 to remove fast K)

% saves new values
save subthld_osc_parm -struct p
save subthld_osc_ini -struct v

% function call arguments
args = { '-t', T, '-p', 'subthld_osc_parm', '-i', 'subthld_osc_ini'};

% option -s: argument solver function
%   choices are: 'euler', 'C_N', 'ode45', 'ode15s' and
% any other solver available in the userpath
args = [ args {'-s', 'ode45'} ];

% main function call runs the system
[t y I] = subthresh_oscilln(args);
% outputs:
% t is time step vector
% y array, index asgn per above v struct
% I struct, currents 'H', 'NaP', 'Na', 'K'

% plots membrane voltage by default

% addnl plots here:

% I_h and I_NaP
H = 1000*[I(:).H]'; NaP = 1000*[I(:).NaP]';
figure('Name','Oscillation Currents','Position',[100,400,800,400]);
subplot(1,2,1);
[a, h1, h2] = plotyy(t, H, t, NaP);
xlabel('time (sec)'); ylabel('current (pA)');
l = legend([h1 h2], 'I_H','I_NaP'); set(l, 'FontSize', 8);
% I-V plot
subplot(1,2,2);
V = 1000*y(:,1);
[a, h1, h2] = plotyy(V, H, V, NaP);
xlabel('V_m (mV)'); ylabel('current (pA)');
l = legend([h1 h2], 'I_H','I_NaP'); set(l, 'FontSize', 8);

