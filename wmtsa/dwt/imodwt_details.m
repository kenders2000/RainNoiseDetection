function [DJt, att] = imodwt_details(WJt, wtfname)
% imodwt_details -- Calculate details via inverse maximal overlap discrete wavelet transform (IMODWT).
%
%****f* wmtsa.dwt/imodwt_details
%
% NAME
%   imodwt_details -- Calculate details via inverse maximal overlap discrete wavelet transform (IMODWT).
%
% SYNOPSIS
%   [DJt, att] = imodwt_details(WJt, wtfname)
%
% INPUTS
%   WJt          -  NxJ array of MODWT wavelet coefficents
%                   where N  = number of time points
%                         J = number of levels.
%   wtfname      -  (optional) string containing name of a WMTSA-supported 
%                   MODWT wavelet filter.
%                   Valid Values:  see modwt_filter
%
% OUTPUT
%   DJt          -  NxJ array of reconstituted details of data series for J0 scales.
%   att          -  structure containing IMODWT transform attributes.
%
% SIDE EFFECTS
%   1.  wavelet is a WMTSA-supported MODWT wavelet filter; otherwise error.
%
% DESCRIPTION
%   The output parameter att is a structure with the following fields:
%       name      - name of transform (= 'MODWT')
%       wtfname   - name of MODWT wavelet filter
%       npts      - number of observations (= length(X))
%       J0        - number of levels 
%       boundary  - boundary conditions
%
%
% EXAMPLE
%   [DJt, att] = imodwt_details(WJt, VJ0, 'la8');
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
%   imodwtj, imodwt, imodwt_smooth, modwt_filter, modwt
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

% $Id: imodwt_details.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  [DJt, att] = ', mfilename, ...
             '(WJt, wtfname)'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [2:2], nargout, [0:2], 1, usage_str, 'struct'));

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
gt = wtf_s.g;
ht = wtf_s.h;

[N, J] = size(WJt);
J0 = J;

zeroj =  zeros(N, 1);
DJt = zeros(N, J);

for j = J0:-1:1
  Vin = zeroj;
  Win = WJt(:,j);
  for jj = j:-1:1
    Vout = imodwtj(Win, Vin, ht, gt, jj);
    Win = zeroj;
    Vin = Vout;
  end;
  DJt(:,j) = Vout;
end
    
att.Transform = 'IMODWT';
att.WTF = wtfname;
att.N = N;
att.J0 = J0;

return

