function haxes = multi_yoffset_plot(x, y, ylabel_str, axesProp, left_ylabel_str)
% multi_yoffset_plot -- Plot series of stacked plots of multiple data series.
%
%****f* wmtsa.plotutils/multi_yoffset_plot
%
% NAME
%   multi_yoffset_plot -- Plot series of stacked plots of multiple data series.
%
% SYNOPSIS
%   [haxis] = multi_yoffset_plot(x, y, [ylabel_str], [axesProp], [left_ylabel_str])
%
% INPUTS
%   x            = vector of length nrow containing values to plot in x-dimension.
%   y            = nrow x ncol matrix of ncol sets of y-values to offset plot
%   ylabel_str   = (optional) cell array of length nrow containing character 
%                  strings for labeling y values.
%   axesProp     = structure containing property values for customizing plot axes.
%
% OUTPUTS
%   haxes        = handle to the plot axes.
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
%
%
% REFERENCES
%
%
% SEE ALSO
%   plot_modwt_coef
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/08
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

% $Id: multi_yoffset_plot.m 612 2005-10-28 21:42:24Z ccornish $


if nargerr(mfilename, nargin, [2:5], nargout, [0:2])
  error_str = ['Usage: [haxes] = ', mfilename, ...
               ' x y [ylabel_str] [axesProp], [left_label_str]'];
  error(error_str);
end

% Initialize constants and other parameters
ylabel_xoffset = .005;


cax = newplot;

[nrow, ncol] = size(y);

axesPropName = {};
axesPropVal = {};

xmin = 0;
xmax = x(end);

% Overide default values for plot axes.
if (exist('axesProp', 'var') && ~isempty(axesProp))
%%%   if (isfield(XplotAxesProp, 'YLim'))
%%%     ylimits = XplotAxesProp.YLim;
%%%     Xmin = ylimits(1);
%%%     Xmax = ylimits(2);
%%%   end

  if (isfield(axesProp, 'XLim'))
    xlim = axesProp.XLim;
    xmin = xlim(1);
    xmax = xlim(2);
  end

  axes_field_names = fieldnames(axesProp);
  nfields = length(axes_field_names);
  
  for (i = 1:nfields)
    fname = axes_field_names{i};
    axesPropName(i) = {fname};
    fval = axesProp.(fname);
    axesPropVal(i) = {fval};
  end
end


position = get(gca, 'Position');
xpos = position(1);
ypos = position(2);
xlen = position(3);
ylen = position(4);

% TODO:  Implement a la plot_modwt_coef
set(gca, axesPropName, axesPropVal);
set(gca, 'XLim', [xmin xmax]);

ymin1  = (min(y(:,1)));
yoffset = -abs(ymin1);

for (j = 1:ncol)

  yoffset = yoffset + abs(min(y(:,j)));
  
  line(x, (y(:,j) + yoffset) );

  if (j == 1), hold on; end
  
  yminj = min(y(:,j));
  ymaxj = max(y(:,j));

  ymax = max(y(:,j)) + yoffset;
  
  axis([xmin xmax ymin1 ymax]);
  
  if (exist('ylabel_str', 'var') && ~isempty(ylabel_str))

    xlimits = get(gca, 'XLim');
    xlim_min = xlimits(1);
    xlim_max = xlimits(2);
    xscale = (xlim_max - xlim_min) / xlen;
    ylabel_xpos = xlim_max + (xscale * ylabel_xoffset);
    
    ylabel_ypos = ymax - (ymaxj - yminj) / 2;

    text(ylabel_xpos, ylabel_ypos, ylabel_str(j), ...
         'HorizontalAlignment', 'Left', ...
         'VerticalAlignment', 'Top');
  end

  
  if (exist('left_ylabel_str', 'var') && ~isempty(left_ylabel_str))

    xlimits = get(gca, 'XLim');
    xlim_min = xlimits(1);
    xlim_max = xlimits(2);
    xscale = (xlim_max - xlim_min) / xlen;
    ylabel_xpos = xlim_min - (xscale * ylabel_xoffset);
    
    ylabel_ypos = ymax - (ymaxj - yminj) / 2;

    text(ylabel_xpos, ylabel_ypos, left_ylabel_str(j), ...
         'HorizontalAlignment', 'Right', ...
         'VerticalAlignment', 'Top');
  end

  yoffset = yoffset + abs(max(y(:,j)));
  
  if (j < ncol)
    xdivider = get(gca, 'XLim');
    ydivider = (yoffset * ones(length(xdivider),1));
    line(xdivider, ydivider);
  end;

end

haxes = gca;

return



