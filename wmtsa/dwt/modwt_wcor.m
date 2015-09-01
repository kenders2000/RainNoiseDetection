function [wcor, CI_wcor] = modwt_wcor(WJtX, WJtY, p)
% modwt_wcor -- Calculate the wavelet correlation of MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_wcor
%
% NAME
%   modwt_wcor -- Calculate the wavelet correlation of two sets of MODWT
%                 wavelet coefficients.
%
% SYNOPSIS
%   [wcor, CI_wcor] = modwt_wcor(WJtX, WJtY, [p])
%
% INPUTS
%   WJtX         - NxJ array containing MODWT-computed wavelet coefficients
%                  for X dataset
%                  where N  = number of time intervals,
%                        J = number of levels.
%   WJtY         - NxJ matrix containing MODWT-computed wavelet coefficients
%                  for Y dataset.
%   p            - (optional) percentage point for confidence interval.
%                  default: 0.025 ==> 95% confidence interval
%
% OUTPUTS
%   wcor         - Jx1 vector containing wavelet correlations.
%   CI_wcor      - Jx2 array containing confidence interval of wcor,
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
% NOTES
%
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

% $Id: modwt_wcor.m 612 2005-10-28 21:42:24Z ccornish $


%%
%% Compute wavelet correlation with approximate 95% confidence interval
%% -----------------------------------------------------------------------
%% Input: X  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%        Y  Matrix containing wavelet coefficients with appropriate 
%%           boundary condition
%%
%% Output: C  Matrix containing the wavelet correlation (column 1), lower 
%%            95% quantile for confidence interval, upper 95% quantile 
%%            for confidence interval
%%

  usage_str = ['Usage:  [wcor, CI_wcor] = ', mfilename, ...
               '(WJtX, WJtY, [p])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:2], 1, usage_str, 'struct'));

 set_default('p', 0.025);

  [N, J] = size(WJtX);
  
  WJtXY = WJtX .* WJtY;
  
  SSX  = NaN * zeros(J, 1);
  SSY  = NaN * zeros(J, 1);
  SSXY = NaN * zeros(J, 1);
  
  for (j = 1:J)
    WJtXNaN = WJtX(~isnan(WJtX(:,j)),j)';
    SSX(j) = sum(WJtXNaN.^2);
    WJtYNaN = WJtY(~isnan(WJtY(:,j)),j)';
    SSY(j) = sum(WJtYNaN.^2);
    WJtXYNaN = WJtXY(~isnan(WJtXY(:,j)),j)';
    SSXY(j) = sum(WJtXYNaN);
  end
  NX = sum(~isnan(WJtX),1)';
  COR = (SSXY./NX) ./ (sqrt(SSX./NX) .* sqrt(SSY./NX));
  
  % Return as column vector
  wcor = COR(:);
  
  if (nargout > 1)
    NDWT = floor(N ./ 2.^(1:J))';
  
    CI_wcor = zeros(J, 2);
    CI_wcor = [tanh(atanh(COR) - norminv(1-p) ./ sqrt(NDWT-3)), ...
               tanh(atanh(COR) + norminv(1-p) ./ sqrt(NDWT-3))];
  end
  

return
