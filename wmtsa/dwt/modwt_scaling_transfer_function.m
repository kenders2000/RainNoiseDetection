function Gt = modwt_scaling_transfer_function(f, wtfnamne, j)
% modwt_scaling_transfer_function -- Calculate transfer function for specified MODWT scaling filter.
%
%****f* wmtsa.dwt/modwt_scaling_transfer_function
%
% NAME
%   modwt_scaling_transfer_function -- Calculate transfer function for
%     frequencies f for specified MODWT scaling filter and (optionally) jth level.
%
% SYNOPSIS
%   Gt_j = modwt_scaling_transfer_function(f, wtfnamne, [j])
%
% INPUTS
%   f            - vector of sinsuoidal frequency.
%   wtfnamne      - name of a WMSTA-supported MODWT scaling filter.
%   j            - (optional) level (index) of scale.
%
% OUTPUTS
%   G            - vector of the transfer function values for MODWT scaling filter ht
%                  at frequencies f.
%   G_j          - vector of the transfer function values for MODWT scaling filter ht
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
%   See page 163 of WMTSA for Gt.
%   See page 169 of WMTSA for Gt_j.
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

% $Id: modwt_scaling_transfer_function.m 612 2005-10-28 21:42:24Z ccornish $
  

  usage_str = ['Usage:  [Gt] = ', mfilename, ...
               '(f, wtfnamne, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end

  if (exist('j', 'var'))
    Gt = scaling_transfer_function_j(f, wtfnamne, j);
  else
    Gt = scaling_transfer_function(f, wtfnamne);
  end

return

% Subfunction to calculate MODWT scaling transfer function.
function Gt = scaling_transfer_function(f, wtfname)

  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  the_sum = 0;
  for (l = 0:L-1)
    gtl = gt(l+1);
    the_sum = the_sum + gtl * exp( -i * 2 * pi * f * l);
  end

  Gt = the_sum;
  
return

% Subfunction to calculate MODWT scaling transfer function for jth level.
function Gt_j = scaling_transfer_function_j(f, wtfnamne, j)

  the_product = 1;
  for (l = 0:j-1)
    Gt = scaling_transfer_function(2^l * f, wtfnamne);
    the_product = the_product .* Gt;
  end

  Gt_j = the_product;
  
return
  
