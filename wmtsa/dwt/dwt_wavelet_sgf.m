function Hs = dwt_wavelet_sgf(f, wtfname, j)
% dwt_wavelet_sgf -- Calculate squared gain function for DWT wavelet filter.
%
%****f* wmtsa.dwt/dwt_wavelet_sgf
%
% NAME
%   dwt_wavelet_sgf -- Calculate squared gain function for specified DWT 
%     scaling filter at frequencies f and at (optionally) jth level.
%
% SYNOPSIS
%   Hs_j = dwt_wavelet_sgf(f, wtfname, [j])
%
% INPUTS
%   f            = vector of sinsuoidal frequency.
%   wtfname      = name of a WMSTA-supported MODWT scaling filter.
%   j            = (optional) level (index) of scale.
%
% OUTPUTS
%   Hs           = vector of squared gain function values for DWT wavelet
%                  filter h at frequencies f.
%   Hs_j         = vector of squared gain function values for DWT wavelet
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
%   See page  69 of WMTSA for Hs.
%   See page 154 of WMTSA for Hs_j.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   dwt_wavelet_transfer_function
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
%

% $Id: dwt_wavelet_sgf.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [Hs] = ', mfilename, ...
               '(f, wtfname, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end

  if (exist('j', 'var'))
    H = dwt_wavelet_transfer_function(f, wtfname, j);
  else
    H = dwt_wavelet_transfer_function(f, wtfname);
  end
  
  Hs = H .* conj(H);

return
