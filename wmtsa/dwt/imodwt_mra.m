function [DJt, SJt, mra_att] = imodwt_mra(WJt, VJt, w_att)
% imodwt_mra -- Calculate MODWT multi-resolution details and smooths from wavelet coefficients via IMODWT transform.

%****f* wmtsa.dwt/imodwt_mra
%
% NAME
% imodwt_mra -- Calculate MODWT multi-resolution details and smooths from wavelet coefficients via IMODWT transform.
%
% USAGE
%   [DJt, SJt]  = imodwt_smooth(WJt, VJt, wavelet)
%
% INPUTS
%   * WJt        -- MODWT wavelet coefficents (N x J x NChan array).
%   * VJt        -- MODWT scaling coefficients (N x {1,J} x NChan vector).
%   * w_att      -- MODWT transform attributes (struct).
%
% OUTPUT
%   * DJt        -- MODWT details coefficents (N x J x NChan array).
%   * SJt        -- MODWT smooth coefficients (N x {1,J} x NChan vector).
%   * mra_att    -- structure containing IMODWT MRA transform attributes
%
%
% DESCRIPTION
%   modwt_mra computes the multi-resolution detail and smooth coefficients
%   fomr the MODWT wavelet and scaling coefficients.
%
% EXAMPLE
%
%
% NOTES
%
%
% BUGS
%   
%
% TODO
%   1. Add support for retain DJt (RetainDJt)
%   2. Rewrite modwt_details.
%   3. Rewrite modwt_smooth.
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
%   imodwt_details, imodwt_smooth, imodwtj, modwt, modwt_filter
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
%   $Revision: 630 $
%
%***

% $Id: imodwt_mra.m 630 2006-05-02 20:47:17Z ccornish $

usage_str = ['Usage:  [DJt, SJt, mra_att] = ', mfilename, ...
             '(WJt, VJt, w_att)'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [3:3], nargout, [0:3], 1, usage_str, 'struct'));

%% Get the wt filter coefficients.
if (ischar(w_att.WTF))
  wftname = w_att.WTF;
  wtf_s = modwt_filter(w_att.WTF);
  ht = wtf_s.h;
  gt = wtf_s.g;
else
  error('w_att.WTF must be a wft name (string).');
end

wtfname       = w_att.WTF;
N             = w_att.NX;
NW            = w_att.NW;
J0            = w_att.J0;
NChan         = w_att.NChan;
boundary      = w_att.Boundary;

w_att

for (i = 1:NChan)
  WJ = WJt(:,:,i);

  if (w_att.RetainVJ)
    VJ0 = VJt(:,J0,i);
  else
    VJ0 = VJt(:,1,i);
  end
  
  [DJt, DJt_att] = imodwt_details(WJt, wtfname);

  [SJt, SJt_att] = imodwt_smooth(VJ0, wtfname, J0);
  
end


mra_att.Transform = 'IMODWT_MRA';
mra_att.WTF       = wtfname;
mra_att.NX        = N;
mra_att.NW        = NW;
mra_att.J0        = J0;
mra_att.NChan     = NChan;
mra_att.Boundary  = boundary;
mra_att.Aligned   = 0;
% mra_att.RetainDJ = ???


return

