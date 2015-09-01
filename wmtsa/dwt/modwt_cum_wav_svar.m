function [cwsvar] = modwt_cum_wav_svar(WJt, wtfname)
% modwt_cum_wav_svar -- Calculate cumulative sample variance of MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_cum_wav_svar
%
% NAME
%   modwt_cum_wav_svar -- Calculate cumulative sample variance of 
%         MODWT wavelet coefficients.
%
% SYNOPSIS
%   [cwsvar] = modwt_cum_wav_svar(WJt, wtfname)
%
% INPUTS
%   WJt          -  NxJ array of MODWT wavelet coefficents
%                   where N = number of time intervals
%                         J = number of levels
%   wtfname      -  string containing name of a WMTSA-supported MODWT 
%                   wavelet filter.
%
% OUTPUTS
%   cwsvar       -  cumulative wavelet sample variance.
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
% ALGORITHM
%
%   cwsvar(j,t) = 1/N * sum( WJt^2 subscript(j,u+nuH_j mod N)) 
%                    for t = 0,N-1 at jth level
%
%   For details, see page 189 of WMTSA.   
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_cir_shift, modwt
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-16
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_cum_wav_svar.m 612 2005-10-28 21:42:24Z ccornish $
  
  usage_str = ['Usage:  [cwsvar] = ', mfilename, ...
               '(WJt, wavelet)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:2], nargout, [0:1], 1, usage_str, 'struct'));


  % Check for valid wavelet and get wavelet filter coefficients
  try
    wtf_s = modwt_filter(wtfname);
  catch
    rethrow(lasterror);
  end
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;


  [N, J] = size(WJt);
  cwsvar = zeros(N, J);
  TWJt = modwt_cir_shift(WJt, [], wtfname);

  for (j = 1:J)
    cwsvar(:,j) = cumsum(TWJt(:,j).^2) / N;
  end

return

