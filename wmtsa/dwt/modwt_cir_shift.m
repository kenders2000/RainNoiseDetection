function [TWJt, TVJ0t] = modwt_cir_shift(WJt, VJ0t, wtfname, J0)
% modwt_cir_shift -- Circularly shift (advance) MODWT coefficients for alignment with original time series.
%
%****f* wmtsa.dwt/modwt_cir_shift
%
% NAME
%   modwt_cir_shift -- Circularly shift (advance) MODWT coefficients for alignment with original time series.
%
% SYNOPSIS
%   [TWJt]        - modwt_cir_shift(WJt, [], wtfname)
%   [TVJ0t]       - modwt_cir_shift([], VJ0t, wtfname, J0)
%   [TWJt, TVJ0t] - modwt_cir_shift(WJt, VJ0t, wtfname)
%
% INPUTS
%   WJt           - NxJ array of MODWT wavelet coefficents
%                   where N = number of time intervals
%                          J = number of levels
%   VJ0t          - Nx1 vector of MODWT scaling coefficients at level J0.
%   wtfname       - name of a WMSTA-supported MODWT wavelet filter.
%   J0            - largest or partial level of MODWT.
%
% OUTPUTS
%   TWJt          -  NxJ array of circularly shifted (advanced) MODWT 
%                    wavelet coefficents
%   TVJ0t         -  Nx1 vector of circularly advanced MODWT scaling
%                    coefficients at level J0.
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
%   If WJt is not supplied, user must supply value of J0.
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
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_cir_shift.m 612 2005-10-28 21:42:24Z ccornish $
  

  usage_str = ['Usage:  [TWJt, TVJ0t] = ', mfilename, ...
               '(WJt, VJ0t, wtfname, J0)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [3:4], nargout, [0:2], 1, usage_str, 'struct'));


  % Check for valid wavelet and get wavelet filter coefficients
  try
    wtf_s = modwt_filter(wtfname);
  catch
    rethrow(lasterror);
  end
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;


  if (exist('WJt', 'var') && ~isempty(WJt) )
  
    [N, J] = size(WJt);
    TWJt = zeros(N, J);

    for (j = 1:J)
      nuH_j = advance_wavelet_filter(wtfname, j);
      TWJt(:,j,:) = circshift(WJt(:,j,:), nuH_j);
    end

  else
    TWJt = [];
  end



  if (exist('VJ0t', 'var') && ~isempty(VJ0t) )
    if (exist('J', 'var'))
      J0 = J;
    else
      if (~exist('J0', 'var') || isempty(J0))
        error(['Must specify J0 if supplying only scaling coefficients ' ...
               'J0']);
      end
  end

  nuG_j = advance_scaling_filter(wtfname, J0);
  TVJ0t = circshift(VJ0t, nuG_j);

end

return



