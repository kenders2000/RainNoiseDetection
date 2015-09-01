function svar = ts_sample_variance(X)
% ts_sample_variance -- Compute the sample variance of a time-series data set (vector or array).
%
% Usage:
%   svar = sample_variance(X)
%
% Inputs:
%    X           = vector of N observations 
%                  or NxM array of M sets of N data observations
%
% Outputs:
%   svar         = scalar or 1xM vector containing sample variance
%
% Description:
%    sample_variance is a convenience function wrapping the built-in MATLAB
%    var function.  It ensures that the correct version of var is used.
%
%    The sample variance of a vector X of length N is defined as:
%
%       sigma_square = 1/N sum( Xt - Xmean), for all t = 0 to N-1
%
% See Also:
%    var

% $Id: ts_sample_variance.m 612 2005-10-28 21:42:24Z ccornish $

  
svar = var(X,1);

return

