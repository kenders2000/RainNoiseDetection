function [rwcov, CI_rwcov, indices] = modwt_running_wcov(TWJtX, TWJtY, range, step, span, p)
% modwt_running_wcov -- Calculate running wavelet covariance of circularly-shifted MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_running_wcov
%
% NAME
%   modwt_running_wcov -- Calculate running wavelet covariance of translated 
%       (circularly shifted) MODWT wavelet coefficients.
%
% SYNOPSIS
%   [rwcov, CI_rwcov] = modwt_running_wcov(TWJtX, TWJtY, [range], [step], [span], [p])
%                                     
%
% INPUTS
%   TWJtX        - NxJ array of circularly shifted (translated) MODWT 
%                  wavelet coefficents for X data series.
%   TWJtY        - NxJ array of circularly shifted (translated) MODWT 
%                  wavelet coefficents for Y data series.
%   range        - (optional) vector containing range of indices of
%                  translated wavelet coefficients over which to
%                  calculate wavelet variance.
%                  Default value: entire range = [1+span/2, N-span/2]
%   step         - (optional) increment at which to calculate wavelet
%                  variances.
%                  Default value: 1
%   span         - (optional) running segment over which to calculate
%                  wavelet variance.
%                  Default value: 2^J0
%   p            - (optional) percentage point for chi2square distribute
%                  Default value: 0.025 ==> 95% confidence interval
%
% OUTPUTS
%   rwcov        - N_rm x J array containing running wavelet covariances, 
%                  where N_rm is number of runnning means.
%   CI_rwcov     - N_rm x J x 2 array containing confidence intervals of
%                  running wavelet covariances with lower bound (column 1) 
%                  and upper bound (column 2).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   Function calculates the running wavelet covariance from the translated
%   (circularly shifted) MODWT wavelet coefficients.  User may specify
%   the range and steps of time points to over which to calculate wavelet
%   variances and number of continguous values (span) to calculate each
%   variance.  The running variance is computed for a span of values
%   center at the particular time point.
%
% EXAMPLE
%   [WJtX,  VJ0tX]      = modwt(X, 'la8', 9)
%   [WJtY,  VJ0tY]      = modwt(Y, 'la8', 9)
%   [TWJtX, TVJ0tX]     = modwt_cir_shift(WJtX, VJ0tX)
%   [TWJtY, TVJ0tY]     = modwt_cir_shift(WJtY, VJ0tY)
%   [rwcov, CI_rwcov] = modwt_running_wcov(TWJtX, TWJtY)
%
% WARNINGS
%
%
% ERRORS
%
%
% NOTES
%   1.  User must use circularly shift MODWT wavelet coefficients.
%       Use modwt_cir_shift prior to calculating running wavelet variances.
%   2.  The biased estimator (default option) should be used.
%
% BUGS
%
%
% TODO
%
%
% ALGORITHM
%
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_wcov, modwt_cir_shift
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-11-10
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

%   $Id: modwt_running_wcov.m 612 2005-10-28 21:42:24Z ccornish $
  
  
  usage_str = ['Usage:  [rwcov, CI_rwcov, indices] = ', mfilename, ...
               '(TWJtX, TWJtY, [range], [step], [span], [p])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:6], nargout, [0:3], 1, usage_str, 'struct'));

  [N, J] = size(TWJtX);
  
  %%  Set defaults
  set_default('step', 1);
  set_default('span', 2^J);
  set_default('p', 0.025;
  
  if (~exist('range', 'var') || isempty(range))
    start = 1 + span / 2;
    stop = N - span / 2;
    range = [start:stop];
  end
  
  if (range(1) < 1 + floor(span/2))
    error(['Start of range must be >= 1 + span/2']);
  end
  
  if (range(end) > N - floor(span/2))
    error(['End of range must be <= N - span/2']);
  end
  
  if (nargout < 2) 
    calc_ci = 0;
  else
    calc_ci = 1;
  end
  
  running_samples = [range(1):step:range(end)];
  rwcov = zeros(length(running_samples), J);
  
  
  half_span = floor(span/2);
  % If even span, subtract one from end of span
  if (mod(span,2) == 0)
    endspan = 1;
  else
    endspan = 0;
  end
  
  num_samples = length(running_samples);
  rwcov = NaN * zeros(num_samples,J);
  if (calc_ci)
    CI_rwcov = NaN * zeros(num_samples,J,2);
  end
  
  for (i = 1:length(running_samples))
    isample = running_samples(i);
  
    [wcov, CI_wcov] = ...
        modwt_wcov(TWJtX(isample-half_span:isample+half_span-endspan,:), ...
                   TWJtX(isample-half_span:isample+half_span-endspan,:));
  
    rwcov(i, :) = wcov';
    calc_ci = 0;
    if (calc_ci)
      CI_rwcov(i,:,:) = CI_wcov(:,:);
    end
    
  end
  
  if (nargout >= 3)
    indices = running_samples(:);
  end
  
return
