function [SJt, att] = imodwt_smooth(VJt, wtfname, J0)
% imodwt_smooth -- Calculate smooths at J0 level via inverse maximal overlap discrete wavelet transform (IMODWT).
%
%****f* wmtsa.dwt/imodwt_smooth
%
% NAME
%   imodwt_smooth -- Calculate smooths at J0 level via inverse maximal overlap discrete wavelet transform (IMODWT).
%
% SYNOPSIS
%   [SJt, att] = imodwt_smooth(VJt, wtfname, J0)
%
% INPUTS
%   VJt         =  Nx1 vector of MODWT scaling coefficients at J0 level.
%   wtfname      =  string containing name of a WMTSA-supported MODWT wavelet 
%                   filter.
%
% OUTPUT
%   SJOt         =  vector of reconstituted smoothed data series.
%   att          =  structure containing IMODWT transform attributes
%   J0           =  number of levels of partial decomposition.
%
% SIDE EFFECTS
%   1.  wtfname is a WMTSA-supported MODWT wavelet filter; otherwise error.
%
% DESCRIPTION
%
%
% EXAMPLE
%   [SJt, att] = imodwt_smooth(VJt, 'la8');
%
%
% NOTES
%
%
% ALGORITHM
%   See pages 177-179 of WMTSA for description of Pyramid Algorithm for
%   the inverse MODWT multi-resolution analysis.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%   Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   imodwtj, imodwt, imodwt_details, modwt_filter, modwt
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-01
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: imodwt_smooth.m 612 2005-10-28 21:42:24Z ccornish $
  
usage_str = ['Usage:  [SJt, att] = ', mfilename, ...
             '(VJt, wtfname, J0)'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [3:3], nargout, [0:2], 1, usage_str, 'struct'));

%% Get a valid wavelet transform filter coefficients struct.
if (ischar(wtfname))
  try
    [wtf_s] = modwt_filter(wtfname);
  catch
    rethrow(lasterror);
  end
else
  error('WMTSA:invalidWaveletTransformFilter', ...
        encode_errmsg('WMTSA:invalidWaveletTransformFilter', wmtsa_err_table, 'wtf'));
end

wtfname = wtf_s.Name;
L = wtf_s.L;
gt = wtf_s.g;
ht = wtf_s.h;

N = length(VJt);


zeroj =  zeros(N, 1);

SJt = zeros(N, 1);

Vin = VJt;

for (j = J0:-1:1)
  Vout = imodwtj(zeroj, Vin, ht, gt, j);
  Vin = Vout; 
end

SJt = Vout;
SJt = SJt(:);
    
att.Transform = 'IMODWT';
att.WTF = wtfname;
att.N = N;
att.J0 = J0;

return
