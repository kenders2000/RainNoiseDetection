function overplot_imodwt_cir_mra_bdry(hMRAplotAxes, DJt, SJ0t, att, ...
                                      xaxis, J0, level_range, lineProp)
% overplot_imodwt_cir_mra_bdry -- Plot an overlay of the boundaries of inverse MODWT MRA influenced by circularity conditions.
%
%****f* wmtsa.plotutils/overplot_imodwt_cir_mra_bdry
%
% NAME
%   overplot_imodwt_cir_mra_bdry -- Plot an overlay of the boundaries of 
%               inverse MODWT MRA influenced by circularity conditions.
%
% SYNOPSIS
%   overplot_imodwt_cir_mra_bdry(hMRAplotAxes, WJt, VJ0t, att, ...
%                                [xaxis], [J0], [level_range], [lineProp])
%
% INPUTS
%   hMRAplotAxes  =  handle to axes for inverse MODWT MRA subplot.
%   DJt           =  NxJ array of MODWT details
%                    where N = number of time intervals,
%                          J = number of levels
%   SJ0t          =  Nx1 vector of MODWT smooth at level J0.
%   * att        -- MODWT transform attributes (struct).
%   xaxis         =  (optional) vector of values to use for plotting x-axis.
%   J0            =  (optional) override value of J0, if J ~= J0 or
%                      if max(level_range) ~= J0.
%   level_range   =  (optional) number or range of numbers indicating subset of
%                      levels (j's) to plot.
%   lineProp      =  (optional) structure containing line property values to
%                      override default line properties.
%
% OUTPUTS
%
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%   The default values of the line objects drawn are:
%      Color:      red
%      LineWidth:  1
%   The default values may be overridden via by specifying an attribute and value
%   in the lineProp parameter, e.g. lineProp.Color = 'green';
%
% EXAMPLES
%
%
% NOTES
%
%
% BUGS
%
%
% ALGORITHM
%
%
% REFERENCES
%
%
% SEE ALSO
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/24
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

% $Id: overplot_imodwt_cir_mra_bdry.m 612 2005-10-28 21:42:24Z ccornish $


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check Input Arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


usage_str = ['Usage:  ', mfilename, ...
             ' (hAxes, WJt, VJ0t, att, [xaxis])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [4:8], nargout, [0:0], 1, usage_str, 'struct'));

if (~exist('att', 'var') || isempty(att) )
  error('Must specify the MODWT attribute structure.');
end  

wtfname = att.WTF;
NX  = att.NX;
NW = att.NW;
J0 = att.J0;
boundary = att.Boundary;

% Check for valid wavelet and get wavelet filter coefficients
try
  wtf_s = modwt_filter(wtfname);
catch
  rethrow(lasterror);
end
h = wtf_s.h;
g = wtf_s.g;
L = wtf_s.L;

% Initialize and set the plot flags
plot_DJt = 0;
plot_SJ0t = 0;

if (exist('DJt', 'var') && ~isempty(DJt) )
  plot_DJt = 1;
  ND = size(DJt,1);
end  

if (exist('SJ0t', 'var') && ~isempty(SJ0t) )
  plot_SJ0t = 1;
  ND = size(SJ0t,1);
end

if (plot_DJt == 0 && plot_SJ0t == 0)
  error('Must specify either DJt or SJ0t, or both for plotting');
end

if (ND < NX)
  N = ND;
else
  N = NX;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Transform data for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(~exist('lineProp', 'var') || isempty(lineProp))
  lineProp.Color = 'red';
  lineProp.LineWidth = 1;
end;

lower_bound = [];
upper_bound = [];
DJ_min = [];
DJ_max = [];
MRA_min = [];
MRA_max = [];

if (plot_DJt)

  if(~exist('level_range', 'var') || isempty(level_range))
    level_range = 1:J0;
  end

  DJ_min = min(DJt);
  DJ_max = max(DJt);
  MRA_min = DJ_min(level_range);
  MRA_max = DJ_max(level_range);
  
  [detail_lower_bound, detail_upper_bound] = modwt_cir_shift_mra_bdry(wtfname, N, J0);
  lower_bound = detail_lower_bound(level_range);
  upper_bound = detail_upper_bound(level_range);

end

if (plot_SJ0t)

  SJ0t_min = min(SJ0t);
  SJ0t_max = max(SJ0t);
  MRA_min = [MRA_min SJ0t_min];
  MRA_max = [MRA_max SJ0t_max];
  
  [smooth_lower_bound, smooth_upper_bound] = modwt_cir_shift_mra_bdry(wtfname, N, J0);
  lower_bound = [lower_bound smooth_lower_bound(J0)];
  upper_bound = [upper_bound smooth_upper_bound(J0)];
end

set(get(hMRAplotAxes, 'Parent'), 'CurrentAxes', hMRAplotAxes);

JJ = length(MRA_min);
yoffset = -abs(MRA_min(1));


for (j = 1:JJ)

  yoffset = yoffset + abs(MRA_min(j));
  
  if(exist('xaxis', 'var') && ~isempty(xaxis))
    x1(1) = xaxis(lower_bound(j));
    x1(2) = xaxis(upper_bound(j));
  else
    x1(1) = lower_bound(j);
    x1(2) = upper_bound(j);
  end

  y1(1) = MRA_min(j) + yoffset;
  y2(1) = MRA_max(j) + yoffset;
  
  x2 = x1;
  y1(2) = y1(1);
  y2(2) = y2(1);
  
  hLineSegments = linesegment_plot(x1, y1, x2, y2, lineProp);
  
  yoffset = yoffset + abs(MRA_max(j));

end;

return
