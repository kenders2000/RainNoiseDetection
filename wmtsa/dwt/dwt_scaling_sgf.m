function Gs = dwt_scaling_sgf(f, wtfname, j)
% dwt_scaling_sgf -- Calculate squared gain function for DWT scaling filter.
%
%****f* wmtsa.dwt/modwt_scaling_sgf
%
% NAME
%   modwt_scaling_sgf -- Calculate squared gain function for
%     frequencies f for specified DWT scaling filter and (optionally) jth level.
%
% SYNOPSIS
%   Gs_j = dwt_scaling_sgf(f, wtfname, [j])
%
% INPUTS
%   f            = vector of sinsuoidal frequency.
%   wtfname      = name of a WMSTA-supported DWT scaling filter.
%   j            = (optional) level (index) of scale.
%
% OUTPUTS
%   Gs           = vector of squared gain function values for DWT scaling filter h
%                  at frequencies f.
%   Gs_j         = vector of squared gain function values for DWT scaling filter h
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
%   See page  76 of WMTSA for Gs.
%   See page 154 of WMTSA for Gs_j.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   dwt_scaling_transfer_function
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

% $Id: dwt_scaling_sgf.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [Gs] = ', mfilename, ...
               '(f, wtfname, [j])'];
  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end

  if (exist('j', 'var'))
    G = dwt_scaling_transfer_function(f, wtfname, j);
  else
    G = dwt_scaling_transfer_function(f, wtfname);
  end
  
  Gs = G .* conj(G);
  
return
