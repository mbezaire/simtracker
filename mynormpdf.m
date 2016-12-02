function Y=mynormpdf(X,varargin)
% Y=mynormpdf(X,mu,sigma)
% X = data points
% mu = mean
% sigma = std

if isempty(varargin)
    mu=mean(X);
    sigma=std(X);
elseif length(varargin)==1
    mu=varargin{1};
    sigma=std(X);
else
    mu=varargin{1};
    sigma=varargin{2};
end

expval=(-(X-mu).^2)./(2*sigma^2);
Y=1/(sigma*sqrt(2*pi))*exp(expval);

