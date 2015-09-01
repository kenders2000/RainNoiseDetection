function [Wout, Vout] = dwtjm(Vin, h, g, j)
% dwtjm -- Calculate jth level DWT coefficients (MATLAB implementation).
%
%****f* wmtsa.dwt/dwtjm
%
% NAME
%   dwtjm -- Calculate jth level DWT coefficients (MATLAB implementation).
%
% USAGE
%   [Wout, Vout] = dwtjm(Vin, h, g, j)
%
% INPUTS
%   * Vin         -- Input series for j-1 level (i.e. DWT scaling coefficients) 
%   * h           -- DWT wavelet filter coefficients.
%   * g           -- DWT scaling filter coefficients.
%   * j           -- level (index) of scale.
%
% OUTPUTS
%   * Wout        -- DWT wavelet coefficients for jth scale.
%   * Vout        -- DWT scaling coefficients for jth scale.
%
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   dwtjm is an implementation in MATLAB code of the DWT transform for 
%   the jth level, and is included in the toolkit for illustrative purposes 
%   to demonstrate the pyramid algothrim.
%
%   For speed considerations, the dwt function uses the C implementation of 
%   the DWT transform, modwtj, which linked in as a MEX function.
%
% EXAMPLE
%   X = wmtsa_data('ecg');
%   wtf = dwt_filter('haar');
%   % Compute the j = 1 level coefficients for ECG time series.
%   j = 1;
%   [Wout, Vout] = dwtjm(X, h, g, j);
%
% NOTES
%
%
% BUGS
%
%
% TODO
%
%
% ALGORITHM
%   See page 100-101 of WMTSA for DWT pyramid algorithm.
%
% REFERENCES
%
%
% SEE ALSO
%   dwtj, dwt, dwt_filter
%
% TOOLBOX
%   wmtsa
%
% CATEGORY
%   dwt
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-Sep-03
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
% MATLAB VERSION
%   7.0
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: dwtjm.m 612 2005-10-28 21:42:24Z ccornish $

%% Set Defaults
  
usage_str = ['[Wout, Vout] = ', mfilename, '(Vin, h, g, j)'];
  
%% Check arguments.
error(nargerr(mfilename, nargin, [4:4], nargout, [0:3], 1, usage_str, 'struct'));

M = length(Vin);
L = length(h);

Wout = repmat(NaN, [M/2, 1]);
Vout = repmat(NaN, [M/2, 1]);

for (t = 1:M/2)
  u = 2*t;
  Wout(t) = h(1) * Vin(u);
  Vout(t) = g(1) * Vin(u);

  for (n = 2:L)
    u = u - 1;
    if (u < 1)
      u = M;
    end
    Wout(t) = Wout(t) + h(n) * Vin(u);
    Vout(t) = Vout(t) + g(n) * Vin(u);
  end
end

return
