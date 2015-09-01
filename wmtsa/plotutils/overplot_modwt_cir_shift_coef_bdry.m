function overplot_modwt_cir_shift_coef_bdry(hWplotAxes, WJt, VJ0t, att, ...
                                            xaxis, J0, level_range, lineProp)
% overplot_modwt_cir_shift_coef_bdry -- Plot an overlay of the boundaries of shifted MODWT coefficients influenced by circularity conditions.
%
%****f* wmtsa.plotutils/overplot_modwt_cir_shift_coef_bdry
%
% NAME
%   overplot_modwt_cir_shift_coef_bdry -- Plot an overlay of the boundaries
%   outside of which the shifted MODWT coefficients are influenced by circularity conditions.
%
% SYNOPSIS
%   overplot_modwt_cir_shift_coef_bdry(hWplotAxes, WJt, VJ0t, att, ...
%                                      [xaxis], [J0], [level_range], [lineProp])
%
% INPUTS
%   hWplotAxes   =  handle to axes for MODWT coefficients (W) subplot.
%   WJt          =  NxJ array of MODWT wavelet coefficents
%                   where N = number of time intervals,
%                         J = number of levels
%   VJ0t         =  Nx1 vector of MODWT scaling coefficients at level J0.
%   * att        -- MODWT transform attributes (struct).
%   xaxis        =  (optional) vector of values to use for plotting x-axis.
%   J0           =  (optional) override value of J0, if J ~= J0 or
%                     if max(level_range) ~= J0.
%   level_range  =  (optional) number or range of numbers indicating subset of
%                     levels (j's) to plot.
%   lineProp     =  (optional) structure containing line property values to
%                     override default line properties.
%
% OUTPUTS
%
% DESCRIPTION
%   overplot_modwt_cir_shift_coef_bdry plots an overlay of the boundaries of the 
%   circularly shifted MODWT coefficients influenced by the circularity
%   condtions.  The overlay is plotted on the subplot specified by the handle
%   to the hWplotAxes axes.
%
%   The default values of the line objects drawn are:
%      Color:      red
%      LineWidth:  1
%   The default values may be overridden via by specifying an attribute and value
%   in the lineProp parameter, e.g. lineProp.Color = 'green';
%
% EXAMPLE
%
%
% NOTES
%
%
% REFERENCES
%
%
% SEE ALSO
%   plot_modwt_coef, multi_yoffset_plot
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

% $Id: overplot_modwt_cir_shift_coef_bdry.m 612 2005-10-28 21:42:24Z ccornish $


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check Input Arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usage_str = ['Usage:  ', mfilename, ...
             ' (hAxes, WJt, VJ0t, att, [xaxis], ', ...
             ' [J0], [level_range], [lineProp])'];

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
plot_WJt = 0;
plot_VJ0t = 0;

if (exist('WJt', 'var') && ~isempty(WJt) )
  plot_WJt = 1;
end  

if (exist('VJ0t', 'var') && ~isempty(VJ0t) )
  plot_VJ0t = 1;
end

if (plot_WJt == 0 && plot_VJ0t == 0)
  error('Must specify either WJt or VJ0t, or both for plotting');
end


if (NW < NX)
  N = NW;
else
  N = NX;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Transform data for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(~exist('lineProp', 'var') || isempty(lineProp))
  lineProp.Color = 'red';
  lineProp.LineWidth = 1;
end

lower_bound = [];
upper_bound = [];
WJ_min = [];
WJ_max = [];
W_min = [];
W_max = [];

if (plot_WJt)

  if(~exist('level_range', 'var') || isempty(level_range))
    level_range = 1:J0;
  end

  % Align coefficients  
  TWJt = NaN(size(WJt));
  for (j = 1:J0)
    nuHj = advance_wavelet_filter(wtfname, j);
    TWJt(:,j) = circshift(WJt(:,j), nuHj);
  end

  TWJt = TWJt(1:N,:);
  
  WJ_min = min(TWJt);
  WJ_max = max(TWJt);
  W_min = WJ_min(level_range);
  W_max = WJ_max(level_range);
  
  [wavelet_lower_bound, wavelet_upper_bound] = modwt_cir_shift_wcoef_bdry(wtfname, N, J0);
  lower_bound = wavelet_lower_bound(level_range);
  upper_bound = wavelet_upper_bound(level_range);

end

if (plot_VJ0t)

  VJ0t_min = min(VJ0t);
  VJ0t_max = max(VJ0t);
  W_min = [W_min VJ0t_min];
  W_max = [W_max VJ0t_max];
  
  [scaling_lower_bound, scaling_upper_bound] = modwt_cir_shift_scoef_bdry(wtfname, N, J0);
  lower_bound = [lower_bound scaling_lower_bound];
  upper_bound = [upper_bound scaling_upper_bound];

end



set(get(hWplotAxes, 'Parent'), 'CurrentAxes', hWplotAxes);

JJ = length(W_min);
yoffset = -abs(W_min(1));


for (j = 1:JJ)

  yoffset = yoffset + abs(W_min(j));
  
  if(exist('xaxis', 'var') && ~isempty(xaxis))
    if (isnan(lower_bound(j)) || ...
        lower_bound(j) > length(xaxis) || ...
        lower_bound(j) < 1)
      x1(1) = NaN;
    else
      x1(1) = xaxis(lower_bound(j));
    end
    if (isnan(upper_bound(j))  || ...
        upper_bound(j) > length(xaxis) || ...
        upper_bound(j) < 1)
      x1(2) = NaN;
    else
      x1(2) = xaxis(upper_bound(j));
    end
  else
    x1(1) = lower_bound(j);
    x1(2) = upper_bound(j);
  end

  y1(1) = W_min(j) + yoffset;
  y2(1) = W_max(j) + yoffset;
  
  x2 = x1;
  y1(2) = y1(1);
  y2(2) = y2(1);
  
  hLineSegments = linesegment_plot(x1, y1, x2, y2, lineProp);
  
  yoffset = yoffset + abs(W_max(j));

end;

return;  
