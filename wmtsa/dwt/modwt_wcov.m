function [wcov, CI_wcov, VARwcov, NJt] = modwt_wcov(WJtX, WJtY, ci_method, estimator, ...
                                                    wtfname, p, att)
% modwt_wcov -- Calculate the wavelet covariance from MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_wcov
%
% NAME
%   modwt_wcov -- Calculate the wavelet covariance of two sets of MODWT
%                 wavelet coefficients.
%
% SYNOPSIS
%   [wcov, CI_wcov, VARwcov] = modwt_wcov(WJtX, WJtY, [ci_method], [estimator],
%                                          [wtfname], [p])
%
% INPUTS
%   WJtX         = MODWT wavelet coefficients for X series (NxJ array).
%                  where N  = number of time intervals,
%                        J = number of levels.
%   WJtY         = MODWT wavelet coefficients for Y series (NxJ array).
%   ci_method    = (optional) method for calculating confidence interval
%                  valid values:  'gaussian', 'none'
%                  default: 'gaussian'
%   estimator    = (optional) type of estimator
%                  valid values:  'biased', 'unbiased', 'weaklybiased'
%                  default: 'biased'
%   wtfname      = (optional) name of wavelet filter (string, case-insensitive).
%                   required for 'biased' and 'weaklybiased' estimators.
%   p            = (optional) percentage point for confidence interval.
%                  default: 0.025 ==> 95% confidence interval
%
% OUTPUTS
%   wcov         = wavelet covariance (Jx1 vector).
%   CI_wcov      = confidence interval of wavelet covariance (Jx2 array).
%                  lower bound (column 1) and upper bound (column 2).
%   VARwcov      = variance of wcov (Jx1 vector).
%   NJt          = number of coefficients used calculate the wavelet variance at
%                  each level (integer).
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
% NOTES
%
%
% BUGS
%  1. This function has not been modified for multivariate datasets.
%
% ALGORITHM
%
%
% REFERENCES
%   Whitcher, B., P. Guttorp and D. B. Percival (2000)
%      Wavelet Analysis of Covariance with Application to Atmospheric Time
%      Series, \emph{Journal of Geophysical Research}, \bold{105}, No. D11,
%      14,941-14,962.
%
% SEE ALSO
%   modwt
%


% AUTHOR
%   Charlie Cornish
%   Brandon Whitcher
%
% CREATION DATE
%   2003-04-23
%
% Credits:
%   Based on original function wave_cov.m by Brandon Whitcher.
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***
%

% $Id: modwt_wcov.m 612 2005-10-28 21:42:24Z ccornish $


%%
%% Compute wavelet covariance with approximate 95% confidence interval
%% -----------------------------------------------------------------------
%% Input: X  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%        Y  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%
%% Output: C  Matrix containing the wavelet covariance (column 1), lower 
%%            95% quantile for confidence interval, upper 95% quantile 
%%            for confidence interval
%%

valid_ci_methods = {'gaussian', 'none'};
valid_estimator_methods = {'biased', 'unbiased', 'weaklybiased', 'none'};

default_ci_method = 'gaussian';
default_estimator = 'biased';
default_p = 0.025;

usage_str = ['Usage:  [wcov, CI_wcov, VARwcov] = ', mfilename, ...
             '(WJtX, WJtY, [ci_method], [estimator], [wtfname], [p])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [2:7], nargout, [0:5], 1, usage_str, 'struct'));

if (~exist('ci_method', 'var') || isempty(ci_method))
  if (nargout < 3)
    ci_method = 'none';
  else
    ci_method = default_ci_method;
  end
else
  if (isempty(strmatch( ci_method, valid_ci_methods, 'exact')))
    error('WMTSA:WCOV:InvalidCIMethod', ...
          [ci_method, ' is not a valid confidence interval method.']);
  end
end

if (~exist('estimator', 'var') || isempty(estimator))
  estimator = default_estimator;
else
  if (isempty(strmatch(estimator, valid_estimator_methods, 'exact')))
    error('WMTSA:WCOV:InvalidEstimator', ...
          [estimator, ' is not a valid estimator.']);
  end
  
  if (strmatch(estimator, {'unbiased', 'weaklybiased'}, 'exact'))
    if (~exist('wtfname', 'var') || isempty(wtfname))
      error('WMTSA:missingRequiredArgument', ...
            wmtsa_encode_errmsg('WMTSA:missingRequiredArgument', ...
                        'wtfname', ...
                       [' when specifying estimator (', estimator,').']));
    end
  end
end

if (~exist('wtfname', 'var') || isempty(wtfname))
  wtfname = '';
end

if (~exist('p', 'var') || isempty(p))
  p = default_p;
end

if (strcmp(ci_method, 'none'))
  calc_ci = 0;
else
  calc_ci = 1;
end

% Initialize output arguments
% [N, J] = size(WJtX);
sz = size(WJtX);

if (exist('att', 'var') && ~isempty(att))
  wtfname = att.wavelet;
  NX = att.NX;
  NW = att.NW;
  J = att.J0;
  boundary = att.Boundary;
else
  N = sz(1);
  NX = N;
  J = sz(2);
  boundary = '';
end



NJt = zeros(J,1) * NaN;
wcov = zeros(J,1) * NaN;

VARwcov = [];
CI_wcov = [];



% Calculate wcov
switch estimator
 case 'unbiased'
  % Unbiased estimator of wtfname covariance
  % Sum of squares of coefficients from L_j to N
  % For unbiased estimator, do not included wtfnames coefficients affected by 
  % circularity assumption.
  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L  = wtf_s.L;
  name = wtf_s.Name;
  

  NJt = modwt_num_nonboundary_coef(wtfname, N, 1:J);
%  NJt = NJt(:);
  LJ = equivalent_filter_width(L, 1:J);

  WJtXY = WJtX .* WJtY;

  for (j = 1:J)
    wcov(j) = sum(WJtXY(LJ(j):N,j),1) / NJt(j);
  end

  if (calc_ci)
    lb = LJ;
    ub = ones(1, J) * N;
    [CI_wcov, VARwcov, AJ] = ...
        modwt_wcov_ci(wcov, NJt, ci_method, ...
                      WJtX, WJtY, lb, ub, p);
  end

 case 'biased'
  % Biased estimator of wavelet variance (equation 306c)
  % Use all coefficients.
  NW = size(WJtX, 1);
  NJt = ones(J,1) * NW;
  WJtXY = WJtX .* WJtY;

  for (j = 1:J)
    wcov(j) = sum(WJtXY(:,j)) / NW;
  end 

  if (calc_ci)
    lb = ones(J,1);
    ub = ones(J,1) * NW;
    [CI_wcov, VARwcov, AJ] = ...
        modwt_wcov_ci(wcov, NJt, ci_method, ...
                      WJtX, WJtY, lb, ub, p);
  end
  
 case 'weaklybiased'
  % Weakly Biased estimator
  % Use wavelet coefficients that are 1/2 the filter autocorrelation width
  % away from time series boundary.   Over half of signal contribution comes
  % from coefficients within autocorrelation width.
  % This is less retrictive than unbiased estimator but more so biased one.
  % This is equivalent to using circular shifting wavelet coefficients for
  % time alignment and then not including boundary coefficients for Haar
  % filter, since L_j = w_a_j for Haar.

  nuHJ = advance_wavelet_filter(wtfname, 1:J);
  acw = filter_autocorrelation_width(wtfname, 1:J);
  
  % For weaklybiased, NJt is same as modwt_num_nonboundary_coef('haar', N, 1:J);
  NJt = modwt_num_nonboundary_coef('haar', N, 1:J);
%  NJt = NJt(:);

  lb = acw / 2;
  ub = N - acw / 2;

  WJtXY = WJtX .* WJtY;
  for (j = 1:J)
    if (NJt(j) > 0)
      TWJtXY_j = circshift(WJtXY(:,j), nuHJ(j));
      wcov(j) = (sum(TWJtXY_j(lb(j):ub(j)))) / NJt(j);
    else
      wcov(j) = NaN;
    end
  end

  if (calc_ci)
    for (j = 1:J)
      if (NJt(j) > 0)
        TWJtX(:,j) = circshift(WJtX(:,j), nuHJ(j));
        TWJtY(:,j) = circshift(WJtY(:,j), nuHJ(j));
      end
    end

    lb = lb;
    ub = ub;
    [CI_wcov, VARwcov, AJ] = ...
        modwt_wcov_ci(wcov, NJt, ci_method, ...
                      TWJtX, TWJtY, lb, ub, p);
  end
  
 otherwise
  error(['Unsupported estimator (', estimator, ')']);
end



return

function [CI_wcov, VARwcov, AJ] = modwt_wcov_ci(wcov, NJt, ci_method, ...
                                                 WJtX, WJtY, lb, ub, p)
% Calculate wcov confidence interval using Gaussian method.


  J = length(NJt);
  XACVS = [];
  YACVS = [];
  SUMXYCCVS = [];
  AJ = zeros(J,1);

  for (j = 1:J)

    XACVS = wmtsa_acvs(WJtX(lb(j):ub(j),j), 'biased', 0);
    YACVS = wmtsa_acvs(WJtY(lb(j):ub(j),j), 'biased', 0);
    XYCCVS = wmtsa_ccvs(WJtX(lb(j):ub(j),j), WJtY(lb(j):ub(j),j), 'biased', 0);

    % Get lags for tau >= 0.
    XACVS = XACVS(NJt(j):2*NJt(j)-1);
    YACVS = YACVS(NJt(j):2*NJt(j)-1);
    XYCCVS = XYCCVS(NJt(j):2*NJt(j)-1);

    AJ(j) = sum(XACVS .* YACVS + XYCCVS .^ 2 );
    
  end
  
  VARwcov = AJ ./ (2 .* NJt);
  
  CI_wcov = zeros(J,2);
  CI_wcov(:,1) = wcov - norminv(1-p) .* sqrt(VARwcov);
  CI_wcov(:,2) = wcov + norminv(1-p) .* sqrt(VARwcov);
  
return  
