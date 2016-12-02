function varargout = rate_const(V)
% plot voltage dependence of rate constants controlling the 
% gating of hyperpolarizing current Ih
% empirically fit parameters, from Dickson, et. al (2000), Fig. 11
% returns a 4 x N array, c, where N is length of Voltage vector V
% if no V, default is N=8 vector from -110 to -40 mV, and function
% returns [V, c]

alpha(1:2) = struct('a', {-2.89e-3, -3.18e-3}, ...
                    'b', {-.445, -.695}, 'k', {24.02, 26.72});
beta(1:2) = struct('a', {2.71e-2, 2.16e-2}, ...
                   'b', {-1.024, -1.06}, 'k', {-17.4, -14.25});
rc = [alpha, beta];

if nargin == 0
  V = [-110:10:-40];
end

% compute the 4 rate constants as a function of voltage
cv = @(v) rate_const_v(v, rc);
c = arrayfun(cv, V, 'UniformOutput', 0);
% reorganize as a 4 x N array row 1 for alpha_1, row 2 for beta_1,
% row 3 for alpha_2 and row 4 for beta_2
c = reshape([c{:}], length(rc), length(V));
s = 1e3;  % millisec per sec
varargout(1) = {c*s};
if nargin == 0
  varargout(2) = varargout(1);
  varargout(1) = {V};
end


function ca = rate_const_v(v, rc)
cv = @(c) (v * c.a + c.b) * power((1 - exp((v + c.b/c.a)/c.k)), -1);
ca = arrayfun(cv, rc);

