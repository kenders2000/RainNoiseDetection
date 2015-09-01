function Hst = modwt_wavelet_sgf(f, wtfname, j)
% modwt_wavelet_sgf -- Calculate squared gain function for MODWT wavelet filter.
%
%****f* wmtsa.dwt/modwt_wavelet_sgf
%
% NAME
%   modwt_wavelet_sgf -- Calculate squared gain function for
%     specified MODWT scaling filter at frequencies f and at (optionally) jth level.
%
% SYNOPSIS
%   Hst   = modwt_wavelet_sgf(f, wtfname)
%   Hst_j = modwt_wavelet_sgf(f, wtfname, j)
%
% INPUTS
%   f            = vector of sinsuoidal frequency.
%   wtfname      = name of a WMSTA-supported MODWT scaling filter.
%   j            = (optional) level (index) of scale.
%
% OUTPUTS
%   Hst          = vector of squared gain function values for MODWT wavelet
%                  filter h at frequencies f.
%   Hst_j        = vector of squared gain function values for MODWT wavelet
%                  filter h at frequencies f at jth level.
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
%   See page 163 of WMTSA for Hst.
%   See page 202 of WMTSA for Hst_j.
%
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_wavelet_transfer_function
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

% $Id: modwt_wavelet_sgf.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [Hst] = ', mfilename, ...
               '(f, wtfname, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end

  if (exist('j', 'var'))
    Ht = modwt_wavelet_transfer_function(f, wtfname, j);
  else
    Ht = modwt_wavelet_transfer_function(f, wtfname);
  end
  
  Hst = Ht .* conj(Ht);
  
return
