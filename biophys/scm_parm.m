function p = scm_parm(s)
% return struct containing set of parameters for simulating
% membrane channel currents
% default parameters from Fransen'04 (H- and persistent sodium currents only)
% s -- select parameter set:
% "Fransen"/"Heys" or "Rotstein/ Acker", or (fast Na and K currents only:)
% "HH" (squid axon) or "Traub" (1991)

  % operational
  p.t_end    = 20; % total simulation time (sec)
  p.solver   = 'C_N';
  p.dt       =  0.001;  % used by Euler method

  % biophysical
  p.C_m      = 1; % uF/cm^2

  if nargin
    if isnumeric(s)
      if s == 0
        s = 'HH';
      else
        s = 'Traub';
      end
    elseif ischar(s)
      assert(length(s) > 1 || strcmpi(s(1),'h')==0, ...
             'ambiguous argument, use either "HH" or "Heys"')
    end
  else
    s = 'Fransen';
  end
  
  if strcmpi(s(1), 'f')
    % Fransen 
    % subthreshold oscillation H and NaP currents only
    p.vdr = 'fransen_vdr';

    p.C_m   =   0.01;
    p.I_app =   0.00472;  % injected current
    p.V_0   = -.060; % initial Vm
    %p.y_0   = [p.V_0 2e-4 0.22 0.76];

    % Fransen Hippoc'04 Table 1
    p.V_H  = -.020;
    p.V_L  = -.083;
    p.V_NaP = .087; 

    p.G_H_Fast_Max = .98; % mS/cm^2
    p.G_H_Slow_Max = .53;
    p.G_L          = .58;
    p.G_NaP_Max    = .5;  % Fransen: .38

  elseif strncmpi(s, 'he', 2) 
    % Fransen / Heys MEC II SC
    % subthreshold oscillation H, NaP and M currents
    p.t_end = 5e3; % msec
    p.dt = 1; % msec
    p.vdr = 'heys_vdr';

    p.C_m   =  1;
    p.I_app =  0.2;  % injected current uA (?)
    p.V_0   = -60; % initial Vm (mV)
    %p.y_0   = [p.V_0 2e-4 0.22 0.76];

    p.V_H   = -20;
    p.V_K   = -91;
    p.V_L   = -90;
    p.V_NaP =  87;
    p.V_Se  = 0; % excititory synaptic channel reversal potential
    p.V_Si  = -75; % inhibitory synaptic channel reversal potential

    p.G_H_Fast_Max = .13; % mS/cm^2
    p.G_H_Slow_Max = .079;
    p.G_L          = .08;
    p.G_M_Max      = .07;
    p.G_NaP_Max    = .06;

    % Destexhe '01, Table 1 (Layer III)
    % synaptic noise
    p.cell_area = 2e-4; % cm^2
    p.syn = { struct('g', 6e-6, 't', 7.8, ...
                     'd', 1.9e-6*sqrt(2/7.8));
              struct('g', 44e-6, 't', 8.8, ...
                     'd', 6.9e-6*sqrt(2/8.8)) ...
            };

  elseif strcmpi(s(1),'r') || strcmpi(s(1),'a')
    % Rotstein / Acker MEC II SC
    % Hodgkin-Huxley and subthreshold oscillation currents
    p.vdr = 'rotstein_vdr';

    p.I_app = -2.5;  % injected current

    % biophysical
    p.V_0 = -65; % initial Vm

    % reversal potentials
    % Rotstein '06, Acker '03
    p.V_Na = 55; 
    p.V_K  = -90; 
    p.V_L  = -65;

    p.G_Na_Max = 52; % mS/cm^2
    p.G_K_Max = 11;
    p.G_L =  0.5;

    p.V_H = -20; % for hyp'n current
    p.V_NaP = 55;  % sodium reversal pot.

    p.G_H_Fast_Max = 1.5*0.65; % mS/cm^2
    p.G_H_Slow_Max = 1.5*0.35;
    p.G_NaP_Max    = 0.5;

  elseif (isnumeric(s) && s == 0) || strcmpi(s(1), 'h')
    % Hodgkin-Huxley squid axon (single_compartment_model.m)
    p.I_app = 10;  % injected current

    p.V_0 = -65; % initial Vm
    p.V_Na = 50;
    p.V_K  = -77;
    p.V_L  = -54.4;

    p.G_Na_Max = 120; % mS/cm^2
    p.G_K_Max  =  36;
    p.G_L      =   0.3;

  elseif (isnumeric(s) && s == 1) || strcmpi(s(1), 't')
    % Traub JNP'91, guinea pig CA3
    p.I_app    =  10;  % injected current
    p.V_0      = -60; % initial Vm
    p.V_Na     =  55;
    p.V_K      = -75;
    p.V_L      = -60;

    %  Table 3 
    p.G_Na_Max = 30; % mS/cm^2
    p.G_K_Max  = 15;
    p.G_L      = 0.1;
  else
    error 'scm_parm', { 'unknown parameter set selection: ' s }
  end
