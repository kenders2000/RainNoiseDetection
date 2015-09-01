function [lower_boundary_indices, upper_boundary_indices] = modwt_cir_shift_scoef_bdry_indices(wtfname, N, j)
% modwt_cir_shift_scoef_bdry_indices - Return indices of the MODWT scaling coefficients at boundaries affected by circularity conditions.
%
%****f* wmtsa.dwt/modwt_cir_shift_scoef_bdry_indices
%
% NAME
%   modwt_cir_shift_scoef_bdry_indices - Return indices of the MODWT 
%        scaling coefficients at boundaries affected by circularly shifting
%        for the jth level.
%
% SYNOPSIS
%   [lower_boundary_indices, upper_boundary_indices] = modwt_cir_shift_scoef_bdry_indices(wtfname, N, j)
%
% INPUTS
%   wtfname      - string containing name of a WMTSA-supported MODWT wavelet filter.
%   N            - number of data samples.
%   j            - level (index) of scale
%
% OUTPUTS
%   lower_boundary_indices - vector containing indices of circularly shifted 
%                            MODWT scaling coefficients at lower boundary.
%   upper_boundary_indices - vector containing indices of circularly shifted 
%                            MODWT scaling coefficients at upper boundary.
%
% SIDE EFFECTS
%   1.  wtfname is a WMTSA-supported wavelet, otherwise error.
%   2.  N > 0, otherwise error.
%   3.  j > 0, otherwise error.
%
% DESCRIPTION
%
%
% EXAMPLE
%
%
% NOTES
%   1. MATLAB uses an array indexing scheme starting at 1 whereas WMTSA
%      uses zero-based arrays.  Use an offset to shift array indices values.
%
% ALGORITHM
%   lower_boundary = [0,  L_j - 2 - |nuG_j|]  (equation 198c of WMSTA)
%   upper_boundary = [N - |nuG_j|, N - 1]    (equation 198c of WMSTA)
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_filter, advance_scaling_filter
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

% $Id: modwt_cir_shift_scoef_bdry_indices.m 612 2005-10-28 21:42:24Z ccornish $


usage_str = ['Usage:  [lower_boundary_indices, upper_boundary_indices] = ', ...
             mfilename, '(wavelet, N, j)'];

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

error(argterr(mfilename, N, 'posint', [], 1, '', 'struct'));
error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));

% Calculate circularly shifted scaling coefficient boundary indices at jth level

% Note: Matlab uses an array indexing scheme starting at 1 whereas WMTSA
%       uses zero based schema.  Use an offset to shift array indices values.
offset = 1;

nuG_j = advance_scaling_filter(wtfname, j);
L_j = equivalent_filter_width(L, j);

lower_bound_min = offset;
lower_bound_max = L_j - 2 - abs(nuG_j) + offset;

lower_boundary_indices = [lower_bound_min:1:lower_bound_max];

upper_bound_min = N - abs(nuG_j) + offset;
upper_bound_max = N - 1 + offset;

upper_boundary_indices = [upper_bound_min:1:upper_bound_max];

return
