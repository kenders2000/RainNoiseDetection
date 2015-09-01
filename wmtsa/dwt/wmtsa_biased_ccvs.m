function CCVS = wmtsa_biased_ccvs(X, Y)
% wmtsa_biased_ccvs -- Calculate the biased cross covariance sequence (CCVS) of two data series.
%
%****f* wmtsa.dwt/wmtsa_biased_ccvs
%
% NAME
%   wmtsa_biased_ccvs -- Calculate the biased cross covariance sequence (CCVS)
%      of two data series.
%
% SYNOPSIS
%   CCVS = wmtsa_biased_ccvs(X, Y)
%
% INPUTS
%   X            - vector of observations.
%   Y            - vector of observations.
%
% OUTPUTS
%   CCVS         - cross covariance sequence (CCVS) of X and Y.
%
% DESCRIPTION
%
%
% EXAMPLE
%
%
% ALGORITHM
%   See page 269 of WMTSA.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-04-23
%
% Credits:
%   Based on original function myACF.m by Brandon Whitcher.
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: wmtsa_biased_ccvs.m 612 2005-10-28 21:42:24Z ccornish $
  
  
  usage_str = ['Usage:  [acvs] = ', mfilename, ...
               '(X, Y)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:2], nargout, [0:1], 1, usage_str, 'struct'));

  X = X(:);
  Y = Y(:);
  
  CCVS = xcov(X(~isnan(X)), Y(~isnan(Y)), 'biased');
  CCVS = CCVS(:);
  
return
