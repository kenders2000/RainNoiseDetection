function y=QChisq(p, nu)
%
% computes the  abscissae y for given probability p (upper tail)
% for a chi square distribution with nu >=2 degrees
% of freedom, NOT NECESSARILY AN INTEGER. Based on
% Goldstein, R.B., Collected Algorithms for Computer Machinery,
% 16, 483-485.
%
%  p: real col vector of right-tail probs
%  nu: possibly non-integer deg of freedom
%  y: real column vector of abscissae
%
% Author: Andrew Walden

%   $Id$  
  
      c=[1.565326e-3,1.060438e-3,-6.950356e-3,-1.323293e-2,2.277679e-2,...
	  -8.986007e-3,-1.513904e-2,2.530010e-3,-1.450117e-3,5.169654e-3,...
      -1.153761e-2,1.128186e-2,2.607083e-2,-0.2237368,9.780499e-5,-8.426812e-4,...
      3.125580e-3,-8.553069e-3,1.348028e-4,0.4713941,1.0000886];
%
      a=[1.264616e-2,-1.425296e-2,1.400483e-2,-5.886090e-3,...
      -1.091214e-2,-2.304527e-2,3.135411e-3,-2.728484e-4,...
      -9.699681e-3,1.316872e-2,2.618914e-2,-0.2222222,...
      5.406674e-5,3.483789e-5,-7.274761e-4,3.292181e-3,...
      -8.729713e-3,0.4714045,1.0];
%
%  I HAVE RESTRICTED TO Nu>=2 SO THAT CAN MAKE Nu REAL.
%
if (nu < 2) 
  error('QChisq ERROR: degrees of freedom < 2') 
end 
if nu==2
	y=-2.*log(p);
else % nu >2
	f=nu;
	f1=1./f;
    t=QGauss(p); % upper tail area p
	f2=sqrt(f1).*t;
	if nu < 2.+fix(4.*abs(t))
		y=(((((((c(1).*f2+c(2)).*f2+c(3)).*f2+c(4)).*f2...
        +c(5)).*f2+c(6)).*f2+c(7)).*f1+((((((c(8)+c(9).*f2).*f2...
        +c(10)).*f2+c(11)).*f2+c(12)).*f2+c(13)).*f2+c(14))).*f1...
        +(((((c(15).*f2+c(16)).*f2+c(17)).*f2+c(18)).*f2...
        +c(19)).*f2+c(20)).*f2+c(21);
	else
		y=(((a(1)+a(2).*f2).*f1+(((a(3)+a(4).*f2).*f2...
       +a(5)).*f2+a(6))).*f1+(((((a(7)+a(8).*f2).*f2+a(9)).*f2...
       +a(10)).*f2+a(11)).*f2+a(12))).*f1+(((((a(13).*f2...
       +a(14)).*f2+a(15)).*f2+a(16)).*f2+a(17)).*f2.*f2...
       +a(18)).*f2+a(19);
	end
	y=(y.^3).*f;
end
