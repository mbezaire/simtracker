function y=gausseq(sigma,mu,x)

y = 1/(sigma*sqrt(2*pi))*exp(-((x-mu).^2/(2*sigma^2)));