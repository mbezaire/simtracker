function [tau, minval]=linear_fit(t,I,varargin)

A=1; %1e-150;
if ~isempty(varargin)
    maxr=varargin{1}*100;
    if length(varargin)>1
        A=varargin{2};
    end
else
    maxr=300;
end

for r=1:maxr
    tau=0.01*r;
    myI = A*(1-exp(t./tau)).^4; % nA
    er(r)=sqrt(sum((myI-I).^2));
end
[minval, mini]=min(er);
tau=0.01*mini; 




function [a, b]=linear_fitb(X, Y)
% www.usciences.edu/~lvas/Math422/Regressions_in_Matlab.pdf?
sx=0; %%(sx is a variable for sum of x-values)
sy=0; %(sy is a variable for sum of y-values)
sxy=0; %(sxy is a variable for sum of products of x and y-values)
sxsq=0; %(sxsq is a variable for sum of squares of x-values)
sysq=0; %(sysq is a variable for sum of squares of y-values)
m=size(X, 2); %(m is the number of x and y values)
for i=1:m
sx=sx+X(i);
sy=sy+Y(i);
sxsq=sxsq+X(i)^2;
sysq=sysq+Y(i)^2;
sxy=sxy+X(i)*Y(i);
end
a=(m*sxy-sx*sy)/(m*sxsq-sx^2);
b=(sxsq*sy-sxy*sx)/(m*sxsq-sx^2);

function a=proportion(X, Y)
sxsq=0; %(sxsq is a variable for sum of squares of x-values)
sxy=0; %(sxy is a variable for sum of products of x and y-values)
m=size(X, 2); %(m is the number of x and y values)
for i=1:m
sxsq=sxsq+X(i)^2;
sxy=sxy+X(i)*Y(i);
end
a=sxy/sxsq;


% I = A*(1-exp(t./tau)).^4; % nA
% 
% log(I/A) = 4*log((1-exp(t./tau)))
% 
% log(I/A)/4 = log((1-exp(t./tau)))
% 
% exp(log(I/A)/4) = 1-exp(t./tau)
% 
% 1-exp(log(I/A)/4) = exp(t./tau)
% 
% log(1-exp(log(I/A)/4)) = t/tau
% 
% t/log(1-exp(log(I/A)/4)) = tau
% 
% 
% 
% log(I)-log(A) = 4*log(1-exp(t./tau))
% 
% .25*log(I)-.25*log(A) = log(1-exp(t./tau))
% 
% exp(.25*log(I)-.25*log(A)) = 1-exp(t./tau)
% 
% 1-exp(.25*log(I)-.25*log(A)) = t/tau
% 
% t/(1-exp(.25*log(I)-.25*log(A))) = tau
% 
% 0.4024
% 
% t/(1-exp(.25*log(I)-0.4024)) = tau
% 
% t/(1-exp(.25*log(I))*exp(-0.4024)) = tau
% 
% t/(1-0.6687*exp(.25*log(I))) = tau
% 
% t/(1-0.6687*exp(log(I^.25))) = tau
% 
% t./(1-0.6687*(I^.25)) = tau


