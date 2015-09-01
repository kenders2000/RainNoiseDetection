function G = dwt_scaling_transfer_function(f, wtfname, j)
% dwt_scaling_transfer_function -- Calculate transfer function for specified DWT scaling filter.
%
%****f* wmtsa.dwt/dwt_scaling_transfer_function
%
% NAME
%   dwt_scaling_transfer_function -- Calculate transfer function for
%     frequencies f for specified DWT scaling filter and (optionally) jth level.
%
% SYNOPSIS
%   G_j = dwt_scaling_transfer_function(f, wtfname, [j])
%
% INPUTS
%   f            - vector of sinsuoidal frequency.
%   wtfname      - name of a WMSTA-supported DWT scaling filter.
%   j            - (optional) level (index) of scale.
%
% OUTPUTS
%   G            - vector of the transfer function values for DWT scaling filter h
%                  at frequencies f.
%   G_j          - vector of the transfer function values for DWT scaling filter h
%                  at frequencies f at jth level.
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
%   See page 76 of WMTSA for G.
%   See page 97 of WMTSA for G_j.
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
%   2003-10-08
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: dwt_scaling_transfer_function.m 612 2005-10-28 21:42:24Z ccornish $


  usage_str = ['Usage:  [G] = ', mfilename, ...
               '(f, wtfname, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end
  
  if (exist('j', 'var'))
    G = scaling_transfer_function_j(f, wtfname, j);
  else
    G = scaling_transfer_function(f, wtfname);
  end
  
return

% Subfunction to calculate DWT scaling transfer function.
function G = scaling_transfer_function(f, wtfname)

  wtf_s = dwt_filter(wtfname);
  h = wtf_s.h;
  g = wtf_s.g;
  L = wtf_s.L;

  the_sum = 0;
  for (l = 0:L-1)
    gl = g(l+1);
    the_sum = the_sum + gl * exp( -i * 2 * pi * f * l);
  end

  G = the_sum;
  
return

% Subfunction to calculate DWT scaling transfer function for jth level.
function G_j = scaling_transfer_function_j(f, wtfname, j)

  the_product = 1;
  for (l = 0:j-1)
    G = scaling_transfer_function(2^l * f, wtfname);
    the_product = the_product .* G;
  end

  G_j = the_product;
  
return
  
