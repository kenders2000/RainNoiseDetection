function y=QGauss(x)
%
% computes the  abscissae y for given probability x
% for a standard Gaussian
% this is 1-F(x)
%
%  x: real col vector of right-tail probs
%  y: real column vector of abscissae
%
% [0.5 0.1587 0.0228]' should give [0 0.9998 1.9991]'
%
y=sqrt(2).*erfinv(1-2.*x);
