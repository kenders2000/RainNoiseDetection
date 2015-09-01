function svar = modwt_wavelet_sample_variance(WJ, VJ0, X)
% modwt_wavelet_sample_variance -- Compute sample variance from MODWT wavelet decomposition and orignal data series.
%
% Usage:
%   s2 = wavelet_sample_variance(WJ, VJ0, X)
%
% Inputs:
%   WJ           =  NxJ array of MODWT wavelet coefficents
%   VJ0          =  Nx1 vector of MODWT scaling coefficients
%   X            =  original data series
%
% Outputs:
%   svar         = sample variance computed from wavelet decomposition.
%
% SideEffects:
%
%
% Description:
%
%
% Examples:
%
%
% Notes:
%
%
% Algorithm:
%   See equations 104b pg. 104 and 171a pg. 171 of WMTSA.
%
% See Also:
%
%
% References
%   Percival, Donald B., and Andrew T. Walden (2000). Wavelet Methods 
%     for Time Series Analysis, Cambridge University Press.

% $Id: modwt_wavelet_sample_variance.m 612 2005-10-28 21:42:24Z ccornish $
%
% Author:
%   Charlie Cornish
%
% Date:
%   2003-04-23
%
% Credits:
%
%

  global VERBOSE;

  usage_str = ['Usage:  [svar]  = ', mfilename, ...
               '(WJ, VJ0, X)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [3:3], nargout, [0:1], 1, usage_str, 'struct'));


  N = length(X);
  
  svar = ( sum(sum(WJ.^2)) / N ) + ...
         ( sum(VJ0.^2)     / N ) - ...
         ( mean(X).^2 );
  
return
