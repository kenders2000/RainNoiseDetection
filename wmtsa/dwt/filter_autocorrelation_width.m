function [width_a] = filter_autocorrelation_width(wtfname, j, method)
% filter_autocorrelation_width - Calculate autocorrelation width of scaling filter.
%
%****f* wmtsa.dwt/filter_autocorrelation_width
%
% NAME
%   filter_autocorrelation_width - Calculate autocorrelation width o scaling filter.
%
% SYNOPSIS
%   [width_a] = filter_autocorrelation_width(wtfname, j, [method])
%
% INPUTS
%   wtfname      = string containing name of a WMTSA-supported MODWT wavelet
%                  filter, case-insensitve
%   j            = jth level (index) of scale or a range of j levels of scales
%                  (integer or vector of integers).
%   method       = (optional) name of method to use for calculations.
%
% OUTPUTS
%   width_a      = filter autocorrelation width for specified levels
%                  (integer or Jx1 vector of integers).
%
% SIDE EFFECTS
%   1.  j > 0, otherwise error.
%
% DESCRIPTION
%   The function calculates the filter autocorrelation width of 
%   scaling filters for the specified wavelet.
% 
%   The user may optionally specify one of two methods of calculation:
%     'quick'  - width_a = 2^j (default)
%     'long'   - Equation 103 of WMTSA (see ALGORTHIM section.
%
% EXAMPLE
%   [width_a] = filter_autocorrelation_width('haar', 5,)
%   [width_a] = filter_autocorrelation_width('la8', 1:10, 'quick')
%   [width_a] = filter_autocorrelation_width('d4', [2,3,5,7], 'long')
%
% ALGORITHM
%   width_a {g_j,l} = (sum(g_j,l))^2 / sum(g_j,l^2)
%   See equation 103 of WMTSA.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   dwt_equivalent_filter, dwt_filter
%
% TOOLBOX
%   WMTSA
%
% CATEGORY
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-12-24
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

%   $Id: filter_autocorrelation_width.m 612 2005-10-28 21:42:24Z ccornish $

  
  usage_str = ['Usage:  [width_a] = ', mfilename, ...
               '(wtfname, j, method)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  set_default('method', 'quick');

  switch method
   case 'quick'
    width_a = auto_width_quick(j);
   case 'long'
    width_a = auto_width_long(wtfname, j);
   otherwise
    error('Unknown method');
  end
  
  % Return as column vector
  width_a = width_a(:);
  
return

function width_a = auto_width_quick(j)
% auto_width_quick(j) -- Fast method for calculating acw.
  
  width_a = 2.^j;
  
return
  
function width_a = auto_width_long(wtfname, j)
% auto_width_long(j) -- Long (formal) method for calculating acw.

  J = max(j);
  [hJ, gJ, LJ, name] = dwt_equivalent_filter(wtfname, J);

  width_a = [];
  for (i = 1:length(j))
    jj = j(i);
    gj = gJ{jj};
    width_a(i) = sum(gj)^2 / sum(gj.^2);
  end
  
return
