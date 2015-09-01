function [WJt, VJ0t] = modwt_inv_cir_shift(TWJt, TVJ0t, wtfname, J0)
% modwt_inv_cir_shift --  Inverse circularly shift (advance) MODWT coefficients.
%
%****f* wmtsa.dwt/modwt_inv_cir_shift
%
% NAME
%   modwt_inv_cir_shift --  Inverse circularly shift (advance) MODWT coefficients.
%
% SYNOPSIS
%
% INPUTS
%   TWJt         -  NxJ array of circularly-shifted MODWT wavelet coefficents.
%                   where N = number of time intervals.
%                         J = number of levels.
%   TVJ0t        -  Nx1 vector of circularly-shifted MODWT scaling
%                   coefficients at level J0.
%   wtfname      -  name of a supported WMSTA wavelet filter.
%   J0           -  largest or partial level of MODWT.
%
% OUTPUTS
%   WJt          -  NxJ array of MODWT wavelet coefficents.
%   VJ0t         -  Nx1 vector of MODWT scaling coefficients at level J0.
%
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
%   If WJ is not supplied, user must supply value of J0.
%
%
% ALGORITHM
%   See pages 114-115 equation 114b of WMTSA.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%  advance_scaling_filter, advance_wavelet_filter,
%  advance_time_series_filter, modwt
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-24
%
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_inv_cir_shift.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [WJt, VJ0t] = ', mfilename, ...
               '(TWJt, TVJ0t, wtfname, J0)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [3:4], nargout, [0:2], 1, usage_str, 'struct'));


  if (~exist('wtfname', 'var') || isempty(wtfname))
    error('Must provide a value for wtfname argument');
  end
  

WJt = [];

if (exist('TWJt', 'var') && ~isempty(TWJt) )

  [N, J] = size(TWJt);
  WJt = zeros(size(TWJt));

  for (j = 1:J)
    nuHj = advance_wavelet_filter(wtfname, j);
    inv_nuHj = -nuHj;
    WJt(:,j) = circshift(TWJt(:,j), inv_nuHj);
  end

end  

if (exist('TVJ0t', 'var') && ~isempty(TVJ0t) )
  if (exist('J', 'var'))
    J0 = J;
  else
    if (~exist('J0', 'var') || ~isempty(J0))
      error(['Must specify J0 if supplying only scaling coefficients ' ...
             'J0']);
    end
  end
  
  nuGj = advance_scaling_filter(wtfname, J0);

  inv_nuGj = -nuGj;

  VJ0t = circshift(TVJ0t, inv_nuGj);

end

return



