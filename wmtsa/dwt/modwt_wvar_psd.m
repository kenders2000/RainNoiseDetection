function [CJ, f, CI_CJ, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar)
% modwt_wvar_psd -- Calculate estimate of band-averaged power spectral density from MODWT wavelet variance.
%
%****f* wmtsa.dwt/modwt_wvar_psd
%
% NAME
%   modwt_wvar_psd -- Calculate estimate of band-averaged power spectral density
%                     from MODWT wavelet variance.
%
% SYNOPSIS
%   [CJ, f, CI_CJ, f_band] = modwt_wvar_psd(wvar, delta_t, [CI_wav])
%
% INPUTS
%   wvar         = wavelet variance (Jx1 vector).
%   delta_t      = sampling interval of original time series.
%   CI_wvar      = confidence interval of wavelet variance (Jx2 array).
%                  lower bound (column 1) and upper bound (column 2).
%
% OUTPUTS
%   CJ           = estimate of average of power spectral density per octave band.
%                  (Jx1 vector)
%   f            = center frequency (geometric mean) of octave band.
%                  (Jx1 vector)
%   CI_CJ        = confidence interval of power spectral density estimate (Jx2 array)
%                  lower bound (column 1) and upper bound (column 2).
%   f_band       = lower and upper bounds of frequency octave band.
%                  (Jx2 vector)
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   modwt_wvar_psd calculates an estimate of the average spectral density
%   function from the MODWT wavelet variance.  
%
%   CJ, f, CI_CJ, and f_band are ordered by increasing level j and scale tau,
%   and hence decreasing frequency f.  This is in the typical order of PSD
%   estimates by increasing frequency f.  The reverse order of CJ by increasing
%   level j allows the ready comparision of CJ decomposed to different partial
%   levels J0.
% 
% EXAMPLE
%
%
% WARNINGS
%
%
% ERRORS
%
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
%   C_j = 2^j * wvar(j) * delta_t, for j = 1:J0
%  
%   See page 316 of WMTSA for further details.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%   Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   loglog_modwt_psd, modwt_wvar, modwt
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-11-09
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

%   $Id: modwt_wvar_psd.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  [CJ, f, CI_CJ, f_band] = ', mfilename, ...
             '(wvar, delta_t, [CI_wvar])'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [2:3], nargout, [0:4], 1, usage_str, 'struct'));


if (exist('CI_wvar', 'var') && ~isempty(CI_wvar))
  calc_ci = 1;
else
  calc_ci = 0;
end

J = length(wvar);
wvar = wvar(:);
j_range = [1:J]';

% Calculate estimates of average PSD per octave band from wavelet varaiance.
CJ = zeros(J,1) * NaN;

CJ = wvar .* 2.^j_range * delta_t;

if (calc_ci)
  CI_CJ = zeros(J,2) * NaN;
  CI_CJ(:,1) = CI_wvar(:,1) .* 2.^j_range * delta_t;
  CI_CJ(:,2) = CI_wvar(:,2) .* 2.^j_range * delta_t;
else
  CI_CJ = [];
end


% Calculate frequency band and center frequency for each PSD interval

f_band(:,1) = 1 ./ (2.^(j_range+1) * delta_t);
f_band(:,2) = 1 ./ (2.^(j_range) * delta_t);
f = sqrt(f_band(:,1) .* f_band(:,2));

return


