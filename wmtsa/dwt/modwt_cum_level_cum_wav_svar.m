function [clcwsvar] = modwt_cum_level_cum_wav_svar(cwsvar)
% modwt_cum_level_cum_wav_svar -- Calculate cumulative level of cumulative sample variance of MODWT wavelet coefficients.
%
% Usage:
%   [clcwsvar] = modwt_cum_level_cum_wav_svar(cwsvar)
%
% Inputs:
%   cwsvar       =  cumulative sample variance of MODWT wavelet coefficients.
%
% Outputs:
%   clcwsvar     =  cumulative level of cumulative sample variance of 
%                   MODWT wavelet coefficients.
%
% SideEffects:
%
%
% Description:
%
%
% Examples:
%
%
% Notes:
%
%
% Algorithm:
%
%   clcwsvar(j,t) = 1/J0 * sum(cwsvar(j,t))
%                    for j = 1,J0
%
% See Also:
%   modwt_cum_wav_svar
%
% References:
%

% $Id: modwt_cum_level_cum_wav_svar.m 612 2005-10-28 21:42:24Z ccornish $
%
% Author:
%   Charlie Cornish
%
% Date:
%   2003-06-03
%
% Credits:
%
%

  usage_str = ['Usage:  [clcwsvar] = ', mfilename, ...
               '(cwsvar)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:1], nargout, [0:1], 1, usage_str, 'struct'));


  [N, J] = size(cwsvar);
  
  clcwsvar = zeros(N, J);
  
  for (t = 1:N)
    clcwsvar(t,:) = cumsum(cwsvar(t,:)) / J;
  end
  
return

