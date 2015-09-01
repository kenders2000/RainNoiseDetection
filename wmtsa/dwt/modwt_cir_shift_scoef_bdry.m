function [lower_bound, upper_bound] = modwt_cir_shift_scoef_bdry(wtfname, N, J0)
% modwt_cir_shift_scoef_bdry -- Calculate circular shift boundaires for MODWT scaling coefficients at level J0.
%
%****f* wmtsa.dwt/modwt_cir_shift_scoef_bdry
%
% NAME
%   modwt_cir_shift_scoef_bdry -- Calculate lower and upper bounds of 
%         MODWT scaling coefficients affected by circular shifting for level J0.
%
% SYNOPSIS
%   [lower_bound, upper_bound] = modwt_cir_shift_scoef_bdry(wtfname, N, J0)
%
% INPUTS
%   wtfname      - string containing name of a WMTSA-supported MODWT wavelet filter.
%   N            - number of data samples.
%   J0           - largest or partial level of MODWT.
%
% OUTPUTS
%   lower_bound  -  lower bound index at level J0.
%   upper_bound  -  upper bound index at level J0.
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
%   modwt_filter, modwt_cir_shift_wavelet_coef_bdry_indices
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

% $Id: modwt_cir_shift_scoef_bdry.m 612 2005-10-28 21:42:24Z ccornish $
  
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


% Find boundaries for MODWT scaling coefficient at J0 level.
[lower_boundary_indices, upper_boundary_indices] = ...
      modwt_cir_shift_scoef_bdry_indices(wtfname, N, J0);
if (isempty(max(lower_boundary_indices)))
  lower_bound = NaN;
else
  lower_bound = max(lower_boundary_indices);
end;
if (isempty(max(upper_boundary_indices)))
  upper_bound = NaN;
else
  upper_bound = min(upper_boundary_indices);
end

return


