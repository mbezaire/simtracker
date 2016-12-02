% Fitting response to ZAP input impedance curves
% Irina Erchova, 11/09
% modified by Ian Boardman, 11/09
%
% args: Frequency (radians) vector, impedance curve computed from
% membrane potential response to ZAP input:
%   Z(f) = abs(fft(U-mean(U)))./abs(fft(I-mean(I)))
% where U = membrane potential Vm(t), I(t) is input current.
% Z can be an array of impedance where length(Z) = length(W).
% Optional vector argument scales rand(1,4) starting parameters,
% (default [1 1 1000 1]).
% Returns first output argument of lsqcurvefit -- the model
% parameters -- and a structure containing the additional output
% arguments (see Matlab doc) 

function [M, S] = rlc_impedance_model(W, Z, o, no_fit, self_call)
  sz = size(Z);
    [m, d]=min(sz);
%    n=max(sz); - don't need this line if not using n to size S later


% marianne.bezaire@gmail.com - 20160304
% Decided to update these three lines below as pretty sure this is not what was intended:    
%       d = find(min(sz));
%       m = sz(d);
%       n = sz(find(max(sz)));
%
% Here's my reasoning:

% FYI I found that updating the code as follows did not affect the results
% for cases where these two conditions are true: 1) the current and voltage
% arguments to res_freq are vectors and 2) there are no spikes in the
% voltage trace.
% 
% If there are spikes in the voltage trace, one of the arguments to the
% rlc_impedance_model function has a dimension of  length 0, which causes
% an error when that value is later used as an index into an array. In the
% calling function, this error is caught and taken to mean that there are
% spikes. I'm sure there is a more robust way to organize the calling
% function & test for spikes, but this seems to work.
% 
% I don't know what would happen (or if it's even possible) for the current
% and voltage arguments to be matrices (say, traces of multiple ZAP
% injections to one cell), but I would recommend inspecting the behavior of
% rlc_impedance_model if you were to use the res_freq function in that way.

  
  M = zeros(m,4);
    S(m,1) = struct('sqerr',0,'err',[],'flag',0,'info',struct([]));
%     S(n,1) = struct('sqerr',0,'err',[],'flag',0,'info',struct([]));
  o_dft = [1 1 1e4 1];
  if nargin < 5
    self_call=0;
    if nargin < 4
      no_fit = [];
      if nargin < 3
        o = o_dft;
      end
    end
  end
  if isempty(o), o = o_dft; end
  zl = 1:m;
  for k = zl(~ismember(zl,no_fit))
    %% parameter setting
    % parameters are [R Rl L C]
    %Initial values of the parameters are random within established limits
    par = o .* rand(1,4);

 % marianne.bezaire@gmail.com 20160304 -
%  
% This optimization algorithm that is used to search for the resonance
% frequency behaves oddly. It is initialized with random conditions. This
% makes sense since it has to be called repeatedly if the error cannot be
% brought low enough during the previous search. However, the random number
% generator is not initialized prior to the start of this chain of events,
% which means that the res_freq function can actually return different
% resonance frequencies for the same input, when run different times. I
% think that is a bad idea - if you put the same data file through the same
% analysis code multiple times, it should return the same result each time.
% To fix this, I reset the random number generator prior to the first call
% to rlc_impedance_model, using the code: 
% >> rng(0,'twister')
% 
% There may also be a deeper issue of the range of values that are allowed
% to be used to initialize the search algorithm or with the search
% algorithm itself - before I added the code to start the random number
% generator at the same condition with each call to res_freq, it was
% returning the following different answers for repeated calculations of
% the resonance frequency for my model cell data (and I was using the same
% exact current/voltage data each time):  0.14 Hz, 6.2 Hz, 9.97 Hz. If you
% want to reproduce this for yourself, I've attached the data and a script
% here. In the context of what we use this analysis for, with the theta
% range being 4-12 or 5-10 or whatever, and especially with the interest in
% the dorsal-ventral gradient, it seems unacceptable that frequency found
% by the analysis could be at the high end of the theta range, or at the
% low end, or completely out of range just because of the particular seed
% at which the random number generator started.
% 



    
    
    
    
    
    impfun = @rlc_impedance_curve;
    % limits on parameters to fit a single solution
    LB=[0, -inf, 0, 1e-6]; UB=[inf, inf, inf, 100]; 
    % curve fit options
    fit_opts = optimset('MaxFunEvals',1e7,'MaxIter',1e6,...
                       'TolFun',1e-7,'TolCon',1e-2,'Display','off');
    % function that returns fit to current parameters
    if d == 1, z = Z(k,:); else z = Z(:,k); end
    [paroptim,sqerr,toterror,exit_flag,opt_info] = ...
        lsqcurvefit(impfun,par,W,z,LB,UB,fit_opts);
    fprintf('%d model: %s, sq_err=%.5g\n', k, ...
            sprintf('%.5g ', paroptim), sqerr);
    if sqerr > 5e4 && (nargin < 4 || self_call < 4)
      disp('large error, evaluate with different starting value')
      if self_call > 2, o = [10 10 1e4 10]; end
      [M(k,:), S(k)] = rlc_impedance_model(W, z, o, [], self_call+1);
    else
      M(k,:) = paroptim;
      S(k) = struct('sqerr',sqerr,'err',toterror,'flag',...
                    exit_flag,'info',opt_info);
    end
  end
end

