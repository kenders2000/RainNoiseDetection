function [rwvar, CI_rwvar, indices] = modwt_running_wvar(TWJt, range, step, span, ...
                                                  ci_method, estimator, wtfname, p)
% modwt_running_wvar -- Calculate running wavelet variance of circularly-shifted MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_running_wvar
%
% SYNOPSIS
%   modwt_running_wvar -- Calculate running wavelet variance of translated 
%       (circularly shifted) MODWT wavelet coefficients.
%
% USAGE
%   [rwvar, CI_rwvar] = modwt_running_wvar(TWJt, [range], [step], [span], ...
%                                     [ci_method], [estimator], [wtfname], [p])
%
% INPUTS
%   TWJt         = NxJ array of circularly shifted (advanced) MODWT 
%                  wavelet coefficents
%   range        = (optional) vector containing range of indices of
%                  translated wavelet coefficients over which to
%                  calculate wavelet variance.
%                  Default value: entire range = [1+span/2, N-span/2]
%   step         = (optional) increment at which to calculate wavelet
%                  variances.
%                  Default value: 1
%                  If = -1, use explicit indices passed by range.
%   span         = (optional) number of points in running segment 
%                  over which to calculate wavelet variance.
%                  Default value: 2^J0
%   ci_method    = (optional) method for calculating confidence interval
%                  valid values:  'gaussian', 'chi2eta1', 'chi2eta3'
%                  Default value: 'chi2eta3'
%   estimator    = (optional) type of estimator
%                  valid values:  'biased', 'unbiased'
%                  Default value: 'biased'
%   wtfname      = (optional) string containing name of a WMTSA-supported 
%                  MODWT wavelet filter.
%   p            = (optional) percentage point for chi2square distribute
%                  Default value: 0.025 ==> 95% confidence interval
%
% OUTPUTS
%   rwvar        = N_rm x J array containing running wavelet variances, 
%                  where N_rm is number of runnning means.
%   CI_rwvar     = N_rm x J x 2 array containing confidence intervals of
%                  running wavelet variances with lower bound (column 1) 
%                  and upper bound (column 2).
%   indices      = Indices of time points in original data series for which
%                  rwvar values are calculated.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   Function calculates the running wavelet variance from the translated
%   (circularly shifted) MODWT wavelet coefficients.  User may specify
%   the range and steps of time points to over which to calculate wavelet
%   variances and number of continguous values (span) to calculate each
%   variance.  The running variance is computed for a span of values
%   center at the particular time point.
%
% EXAMPLE
%   [WJt,  VJ0t]      = modwt(X, 'la8', 9)
%   [TWJt, TVJ0t]     = modwt_cir_shift(WJt, VJ0t)
%   [rwvar, CI_rwvar] = modwt_running_wvar(TWJt)
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
%   modwt_wvar, modwt_cir_shift
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

%   $Id: modwt_running_wvar.m 612 2005-10-28 21:42:24Z ccornish $
  
  
  usage_str = ['Usage:  [rwvar, CI_rwvar, indices] = ', mfilename, ...
               '(TWJt, [range], [step], [span], ', ...
               '[ci_method], [estimator], [wtfname], [p])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:7], nargout, [0:3], 1, usage_str, 'struct'));

[N, J] = size(TWJt);

  %%  Set defaults
  set_default('step', 1);
  set_default('span', 2^J);
  set_default('ci_method', 'chi2eta3');
  set_default('estimator', 'biased');
  set_default('wtfname', '');
  set_default('p', 0.025);
  

  if (~exist('range', 'var') || isempty(range))
    start = 1 + floor(span/2);
    stop = N - floor(span/2);
    range = [start:stop];g
  end
  
  if (range(1) < 1 + floor(span/2))
    error(['Start of range must be >= 1 + span/2']);
  end
  
  if (range(end) > N - floor(span/2))
    error(['End of range must be <= N - span/2']);
  end
  
  
  if (step > 0)
    running_samples = [range(1):step:range(end)];
  elseif (step == -1)
    running_samples = range;
  else
    error(['Invalid value for step']);
  end
  
  
  valid_ci_methods = {'gaussian', 'chi2eta1', 'chi2eta3', 'none'};
  valid_estimator_methods = {'biased', 'unbiased'};
  
  
  if (nargout < 2) 
    calc_ci = 0;
  else
    calc_ci = 1;
  end
  
  if (nargin > 1)
    if (~strmatch( ci_method, valid_ci_methods, 'exact'))
      error([ci_method, ' is not a valid confidence interval method.']);
    end
  end
  
  if (nargin > 2)
    if (~strmatch(estimator, valid_estimator_methods, 'exact'))
      error([estimator, ' is not a valid estimator.']);
    end
   
    if (strmatch(estimator, 'unbiased', 'exact'))
      if (~exist('wtfname', 'var') || isempty(wtfname))
        error(['Must specify a wtfname if using unbiased estimator']);
      end
    end
  end
  
  
  rwvar = zeros(length(running_samples), J);
  
  half_span = floor(span/2);
  % If even span, subtract one from end of span
  if (mod(span,2) == 0)
    endspan = 1;
  else
    endspan = 0;
  end
  
  num_samples = length(running_samples);
  rwvar = NaN * zeros(num_samples,J);
  
  if (calc_ci)
    CI_rwvar = NaN * zeros(num_samples,J,2);
  end
  
  
  for (i = 1:length(running_samples))
    isample = running_samples(i);
    il = isample - half_span;
    iu = il + span;
    
    [wvar, CI_wvar] = ...
        modwt_wvar(TWJt(il:iu,:), ...
                   ci_method, estimator, wtfname, p);
  
    rwvar(i,:) = wvar';
    if (calc_ci)
      CI_rwvar(i,:,:) = CI_wvar(:,:);
    end
  end
  
  if (nargout >= 3)
    indices = running_samples(:);
  end
  
return
