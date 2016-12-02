% Irina Erchova, et al. (2004) Eq. A9, 
% impedance curve for stellate cell membrane
% provide circuit parameter vector of length 4 and frequency vector
function z = rlc_impedance_curve(x,W)
% x: [R Rl L C]
% W: frequency vector in radians
assert(size(x,2)==4, 'missing parameters')
z = zeros(1,length(W));
ci = 1/x(4);
for ipoint=1:length(W)
  w=W(ipoint);
  % numerator
  up=w*w*x(3)*x(3)+x(2)*x(2);  
  % denominator
  down=((x(3)/x(1)*ci+x(2))^2)*w*w + (ci*(1+x(2)/x(1)) - w*w*x(3))^2; 
  z(ipoint) = ci*sqrt((up/down));
end
