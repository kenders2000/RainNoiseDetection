function MJ = modwt_num_nonboundary_coef(wtfname, N, j)
% modwt_num_nonboundary_coef -- Calculate number of nonboundary MODWT coefficients for jth level.
%
%****f* wmtsa.dwt/modwt_num_nonboundary_coef
%
% NAME
%   modwt_num_nonboundary_coef -- Calculate number of nonboundary MODWT coefficients for jth level.
%
% USAGE
%   MJ = modwt_num_nonboundary_coef(wtfname, N, j)
%
% INPUTS
%   * wtfname    -- name of wavelet transform filter (string).
%   * N          -- number of samples (integer).
%   * j          -- jth level (index) of scale or range of j levels.
%                   (integer or vector of integers).
%
% OUTPUTS
%   * MJ         -- number of nonboundary MODWT coefficients for specified
%                   levels (integer or Jx1 vector of integers).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   N-Lj+1 can become negative for large j, so set MJ = min(MJ, 0).
%
% EXAMPLE
%
%
% NOTES
%
%
% ALGORITHM
%   M_j = N - Lj + 1
%
%   see page 306 of WMTSA for definition.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University _roPress.
%
% SEE ALSO
%   modwt_filter, equivalent_filter_width
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-24
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

% $Id: modwt_num_nonboundary_coef.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  MJ = ', mfilename, '(wtf, N, j)'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [3:3], nargout, [0:1], 1, usage_str, 'struct'));

% Check for valid wtf and get wtf filter coefficients
try
  [wtf] = modwt_filter(wtfname);
catch
  rethrow(lasterror);
end

L = wtf.L;

error(argterr(mfilename, N, 'int0', [], 1, '', 'struct'));
error(argterr(mfilename, j, 'int0', [], 1, '', 'struct'));
 
% Calculate MJ
Lj = equivalent_filter_width(L, j);
MJ = N - Lj + 1;
MJ = max(MJ, 0);

% Return as column vector
MJ = MJ(:);

return








