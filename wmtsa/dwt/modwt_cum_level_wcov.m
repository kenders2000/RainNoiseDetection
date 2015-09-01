function [clwcov, CI_clwcov] = modwt_cum_level_wcov(wcov, VARwcov, p)
% modwt_cum_level_wcov -- Compute cumulative level wavelet covariance.
%
%****f* wmtsa.dwt/modwt_cum_level_wcov
%
% NAME
%   modwt_cum_level_wcov -- Compute cumulative level wavelet covariance.
%
% SYNOPSIS
%   [clwcov, CI_clwcov] = modwt_cum_level_wcov(wcov, VARwcov, [p])
%
% INPUTS
%   wcov         = wavelet covariance (Jx1 vector).
%   VARwcov      = covariance of wcov (Jx1 vector).
%   p            = (optional) percentage point for confidence interval.
%                  default: 0.025 ==> 95% confidence interval
%
% OUTPUTS
%   clwcov       = cumulative level wavelet covariance (Jx1 vector)
%   CI_clwcov    = confidence interval of cumulative level wavelet covariance (Jx2 array).
%                  lower bound (column 1) and upper bound (column 2).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   
%
% EXAMPLE
%
%
% WARNINGS
%
%
% ERRORS
%
%
% NOTES
%
%
% BUGS
%
%
% TODO
%
%
% ALGORITHM
%    clwcov_m  = sum(wcov_j) for j = 1,m
%    VARclwcov_m  = sum(VARwcov_j) for j = 1,m
%
% REFERENCES
%
%
% SEE ALSO
%
%
% TOOLBOX
%
%
% CATEGORY
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%    2004-06-22
%
% COPYRIGHT
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: modwt_cum_level_wcov.m 612 2005-10-28 21:42:24Z ccornish $

  
  usage_str = ['Usage:  [clwcov, CI_clwcov] = ', mfilename, ...
               '(wcov, VARwcov, [p])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:3], nargout, [0:3], 1, usage_str, 'struct'));

  %%  Set defaults.
  set_default('p', 0.025);

  if (exist('VARwcov', 'var') && ~isempty(VARwcov))
    calc_ci = 1;
  else
    calc_ci = 0;
    if (nargout > 1)
      error('WMTSA:missingRequiredArgument', ...
             wmtsa_encode_errmsg('WMTSA:missingRequiredArgument', ...
                          'VARwcov', ...
                         [' when specifying output argument CI_clwcov.']));
    end
  end
  
  
  J = length(wcov);
  
  %% Initialize outputs
  
  clwcov = NaN * zeros(J,1);
  
  clwcov = cumsum(wcov);
  
  if (calc_ci)
    CI_clwcov = NaN * zeros(J,2);
  
    clVARwcov = cumsum(VARwcov);
    
    CI_clwcov(:,1) = clwcov - norminv(1-p) .* sqrt(clVARwcov);
    CI_clwcov(:,2) = clwcov + norminv(1-p) .* sqrt(clVARwcov);
    
  end
  
return
