function [rcwsvar] = modwt_rot_cum_wav_svar(WJt, wtfname)
% modwt_rot_cum_wsvar -- Calculate the rotated wavelet sample variance from MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_rot_cum_wav_svar
%
% NAME
%   modwt_rot_cum_wsvar -- Calculate the rotated wavelet sample variance of
%         MODWT wavelet coefficients.
%
% SYNOPSIS
%   [rcwsvar] = modwt_rot_cum_wav_svar(WJ, wtfname)
%
% INPUTS
%   WJt          - NxJ array of MODWT wavelet coefficents
%                  where N = number of time intervals
%                        J = number of levels
%   wtfname      - string containing name of a WMTSA-supported MODWT 
%                  wavelet filter.
%
% OUTPUTS
%   rcwsvar      - NxJ containing rotated cumulative sample variance of
%                  the MODWT wavelet coefficients
%
% SIDE EFFECTS
%   1.  wtfname is a supported wavelet, otherwise error.
%
% DESCRIPTION
%
%
% EXAMPLE
%
%
% ALGORITHM
%
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   modwt_cum_wav_svar, modwt_cir_shift, modwt
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

% $Id: modwt_rot_cum_wav_svar.m 612 2005-10-28 21:42:24Z ccornish $

  usage_str = ['Usage:  [rcwsvar] =  ', mfilename, ...
               ' (WJ, wtfname)'];

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

  cwsvar = modwt_cum_wav_svar(WJt, wtfname);

  [N, J] = size(cwsvar);

  cwsvarN = cwsvar(N,:);

  t = 0:N-1;

  rcwsvar = [];
  
  for (j = 1:J)
    rcwsvar(:,j) = cwsvar(:,j) - t(:) * cwsvarN(1,j) / (N - 1);
  end

return


