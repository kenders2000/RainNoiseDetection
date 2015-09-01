function h = wavelet_filter(g)
% wavelet_filter -- Compute wavelet filter coefficents from scaling filter coefficients.
%
%****f* wmtsa.dwt/wavelet_filter
%
% NAME
%   wavelet_filter -- Compute wavelet filter coefficents from scaling filter coefficients.
%
% SYNOPSIS
%   h = wavelet_filter(g)
%
% INPUTS
%   g            - vector of scaling filter coefficeints
%
% OUTPUTS
%   h            - vector of wavelet filter coefficeints
%
% DESCRIPTION
%
%
% ALGORITHM
%   See equation 75a of WMTSA.
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
%   2003-10-01
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

%   $Id: wavelet_filter.m 612 2005-10-28 21:42:24Z ccornish $

  
  usage_str = ['Usage:  [h] = ', mfilename, ...
               ' (g)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:2], nargout, [0:1], 1, usage_str, 'struct'));

  L = length(g);
  
  for (i = 1:L)
    l = i-1;
    h(i) = (-1)^l * g(L-i+1);
  end
  
return
