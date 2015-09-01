function Gst = modwt_scaling_sgf(f, wtfname, j)
% modwt_scaling_sgf -- Calculate squared gain function for MODWT scaling filter.
%
%****f* wmtsa.dwt/modwt_scaling_sgf
%
% NAME
%   modwt_scaling_sgf -- Calculate squared gain function for
%     frequencies f for specified MODWT scaling filter and (optionally) jth level.
%
% SYNOPSIS
%   Gst_j = modwt_scaling_sgf(f, wtfname, [j])
%
% INPUTS
%   f            = vector of sinsuoidal frequency.
%   wtfname      = name of a WMSTA-supported MODWT scaling filter.
%   j            = (optional) level (index) of scale.
%
% OUTPUTS
%   Gst          = vector of squared gain function values for MODWT scaling filter h
%                  at frequencies f.
%   Gst_j        = vector of squared gain function values for MODWT scaling filter h
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
%   See page 163 of WMTSA for Gst.
%   See page 202 of WMTSA for Gst_j.
%
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_scaling_transfer_function
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


% $Id: modwt_scaling_sgf.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [Gst] = ', mfilename, ...
               '(f, wtfname, [j])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str, 'struct'));

  if (nargin > 2)
    error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));
  end

  if (exist('j', 'var'))
    Gt = modwt_scaling_transfer_function(f, wtfname, j);
  else
    Gt = modwt_scaling_transfer_function(f, wtfname);
  end
  
  Gst = Gt .* conj(Gt);
  
return
