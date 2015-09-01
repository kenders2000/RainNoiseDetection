function Ht = modwt_wavelet_transfer_function(f, wtfname, j)
% modwt_wavelet_transfer_function -- Calculate transfer function for specified MODWT wavelet filter.
%
%****f* wmtsa.dwt/modwt_wavelet_transfer_function
%
% NAME
%   modwt_wavelet_transfer_function -- Calculate transfer function for
%     frequencies f for specified MODWT wavelet filter and (optionally) jth level.
%
% SYNOPSIS
%   Ht_j = modwt_wavelet_transfer_function(f, wtfname, [j])
%
% INPUTS
%   f            - vector of sinsuoidal frequency.
%   wtfname      - name of a WMSTA-supported MODWT scaling filter.
%   j            - (optional) level (index) of scale.
%
% OUTPUTS
%   Ht           - vector of the transfer function values for MODWT wavelet filter h
%                  at frequencies f.
%   Ht_j         - vector of the transfer function values for MODWT wavelet filter h
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
%   See page 163 of WMTSA for Ht.
%   See page 169 of WMTSA for Ht_j.
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

% $Id: modwt_wavelet_transfer_function.m 612 2005-10-28 21:42:24Z ccornish $
  

  usage_str = ['Usage:  [Ht] = ', mfilename, ...
               '(f, wtfname, [j])'];
  
  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));
  
  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end
  
  if (exist('j', 'var'))
    Ht = wavelet_transfer_function_j(f, wtfname, j);
  else
    Ht = wavelet_transfer_function(f, wtfname);
  end
  
return

% Subfunction to calculate MODWT wavelet transfer function.
function Ht = wavelet_transfer_function(f, wtfname)

  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;


  the_sum = 0;
  for (l = 0:L-1)
    htl = ht(l+1);
    the_sum = the_sum + htl * exp( -i * 2 * pi * f * l);
  end

  Ht = the_sum;
  
return

% Subfunction to calculate MODWT wavelet transfer function for jth level.
function Ht_j = wavelet_transfer_function_j(f, wtfname, j)

  Ht = wavelet_transfer_function(2^(j-1) * f, wtfname);

  the_product = 1;
  for (l = 0:j-2)
    Gt = modwt_scaling_transfer_function(2^l * f, wtfname);
    the_product = the_product .* Gt;
  end

  Ht_j = Ht .* the_product;
  
return

