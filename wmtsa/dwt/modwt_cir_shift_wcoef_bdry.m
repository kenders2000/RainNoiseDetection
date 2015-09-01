function [lower_bound, upper_bound] = modwt_cir_shift_wcoef_bdry(wtfname, N, J0)
% modwt_cir_shift_wcoef_bdry -- Calculate bounds of MODWT wavelet coefficients affected by circular shift.
%
%****f* wmtsa.dwt/modwt_cir_shift_wcoef_bdry
%
% NAME
%   modwt_cir_shift_wcoef_bdry -- Calculate lower and upper bounds of 
%       MODWT wavelet coefficients affected by circular shift for J0 levels.
%
% SYNOPSIS
%   [lower_bound, upper_bound] = modwt_cir_shift_wcoef_bdry(wtfname, N, J0)
%
% INPUTS
%   wtfname      - string containing name of a WMTSA-supported MODWT wavelet filter.
%   N            - number of data samples.
%   J0           - largest or partial level of MODWT.
%
% OUTPUTS
%   lower_bound  - J0x1 vector containing lower bound for each jth level.
%   upper_bound  - J0x1 vector containing upper bound for each jth level.
%
% SIDE EFFECTS
%   1.  wavelet is a WMTSA-supported wavelet, otherwise error.
%   2.  N > 0, otherwise error.
%   3.  J0 > 0, otherwise error.
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
%   See page 198 of WMTSA.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_filter, modwt_cir_shift_scaling_coef_bdry_indices
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
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_cir_shift_wcoef_bdry.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  [lower_bound, upper_bound] = ', mfilename, ...
             '(wtfname, N, J0)'];
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [3:3], nargout, [0:2], 1, usage_str, 'struct'));

% Check for valid wavelet and get wavelet filter coefficients
try
  wtf_s = modwt_filter(wtfname);
catch
  rethrow(lasterror);
end
h = wtf_s.h;
g = wtf_s.g;
L = wtf_s.L;

error(argterr(mfilename, J0, 'posint', [], 1, '', 'struct'));
error(argterr(mfilename, N, 'posint', [], 1, '', 'struct'));

% Find boundaries for MODWT wavelet coefficients for J0 levels.

for (j = 1:J0)
  [lower_boundary_indices, upper_boundary_indices] = ...
      modwt_cir_shift_wcoef_bdry_indices(wtfname, N, j);
  if (isempty(max(lower_boundary_indices)))
    lower_bound(j) = NaN;
  else
    lower_bound(j) = max(lower_boundary_indices);
  end;
  if (isempty(max(upper_boundary_indices)))
    upper_bound(j) = NaN;
  else
    upper_bound(j) = min(upper_boundary_indices);
  end;
end

return


