function H = dwt_wavelet_transfer_function(f, wtfname, j)
% dwt_wavelet_transfer_function -- Calculate transfer function for specified DWT wavelet filter.
%
%****f* wmtsa.dwt/dwt_wavelet_transfer_function
%
% NAME
%   dwt_wavelet_transfer_function -- Calculate transfer function for
%     frequencies f for specified DWT wavelet filter and (optionally) jth level.
%
% SYNOPSIS
%   H_j = dwt_wavelet_transfer_function(f, wavelet, [j])
%
% INPUTS
%   f            - vector of sinsuoidal frequency.
%   wtfname      - name of a WMSTA-supported MODWT scaling filter.
%   j            - (optional) level (index) of scale.
%
% OUTPUTS
%   H            - vector of the transfer function values for DWT wavelet filter h
%                  at frequencies f.
%   H_j          - vector of the transfer function values for DWT wavelet filter h
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
%   See page 69 of WMTSA for H.
%   See page 96 of WMTSA for H_j.
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

% $Id: dwt_wavelet_transfer_function.m 612 2005-10-28 21:42:24Z ccornish $

  usage_str = ['Usage:  [H] = ', mfilename, ...
               '(f, wtfname, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end
  
  if (exist('j', 'var'))
    H = wavelet_transfer_function_j(f, wtfname, j);
  else
    H = wavelet_transfer_function(f, wtfname);
  end
  
return

function H = wavelet_transfer_function(f, wtfname)
% wavelet_transfer_function -- Calculate DWT wavelet transfer function.

  wtf_s = dwt_filter(wtfname);
  h = wtf_s.h;
  g = wtf_s.g;
  L = wtf_s.L;

  the_sum = 0;
  for (l = 0:L-1)
    hl = h(l+1);
    the_sum = the_sum + hl * exp( -i * 2 * pi * f * l);
  end

  H = the_sum;
  
return

function H_j = wavelet_transfer_function_j(f, wtfname, j)
% wavelet_transfer_function_j -- Calculate DWT wavelet transfer function for jth level.

  H = wavelet_transfer_function(2^(j-1) * f, wtfname);

  the_product = 1;
  for (l = 0:j-2)
    G = dwt_scaling_transfer_function(2^l * f, wtfname);
    the_product = the_product .* G;
  end

  H_j = H .* the_product;
  
return
  
