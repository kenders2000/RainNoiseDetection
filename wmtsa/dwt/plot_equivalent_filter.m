function [haxes, hlines_filter, hlines_acw, hlines_xaxis] = ...
    plot_equivalent_filter(transform, wavelet, J, ...
                           LineSpec, title_str, ...
                           axesProp, level_range, plotOpts)
% plot_equivalent_filter -- Plot equivalent wavelet filters for J levels.
%
%****f* wmtsa.dwt/plot_equivalent_filter
%
% NAME
%   plot_equivalent_filter -- Plot equivalent wavelet filters for J levels.
%
% SYNOPSIS
%   [haxes, hlines_filter, hlines_acw, hlines_xaxis] = ...
%     plot_equivalent_filter(transform, wavelet, J, ...
%                            [LineSpec], [title_str], ...
%                            [axesProp], [level_range], [plotOpts])
%
% INPUTS
%   transform    = name of wavelet transform (character string, case-insensitve)
%   wavelet      = name of wavelet filter (character string, case-insensitve)
%   J            = number of levels (integer > 0)
%   LineSpec     = (optional) line specification for plotting.
%   figtitle_str = (optional) title of figure (character string)
%   axesProp     = (optional) axes properties to override (struct)
%   level_range  = (optional) subset of levels (j's) to plot (numeric range)
%   plotOpts     = (optional) additional plotting options (struct)
%
% OUTPUTS
%   haxes        = handles of axes drawn (vector)
%   hlines_filter = handles of lines drawn for equivalent filters (vector)
%   hlines_xaxis = handles to lines drawn for xaxis (vector)
%   hlines_acw   = handles of lines drawn for autocorrelation widths (vector)
%
% SIDE EFFECTS
%   1. transform is a valid transform; otherwise error.
%   2. wavelet is a valid wavelet filter; otherwise error.
%   3. J > 0; otherwise error.
%
% DESCRIPTION
%   plot_equivalent_filter plots the equivalent wavelet and scaling filter
%   coefficients for the specified wavelet filter, number of levels and
%   wavelet transform.  The x-axis can be scaled to relative or absolute values
%   of width of equivalent filter ( L_j). and while the y-axis can be
%   scaled local or overall coefficent magnitudes using the the plotOpts argument.
%
%   axesProp argument applies all subplot axes and can be used to override
%   behaviour specified by the plotOpts argument.  Note: Each subplot is
%   has the 'Tag' property set to h or g + level number and can be identified
%   for call back to a particular subplot.
%   
%   Use level_range to display partial range of levels or reverse order of
%   levels, e.g., level_range = [10:-1:5];
%
%   Plotting options are controlled by setting fields in plotOpts structure 
%   argument as follows:
%      PlotgJ = plot scaling equivalent filter.  Default = 1 (yes).
%      PlothJ = plot wavelet equivalent filter.  Default = 1 (yes).
%      DrawXAxis = draw a line reprsenting x-axis at y = 0. Default = 1 (yes).
%      DrawYTick = draw and label Y-Axis tick marks. Default = 0 (no).
%      NormalizeXAxisToLj = set the limits of the X-Axis to relative scale of Lj
%         at jth leve.  Default = 1 (yes).  If = 0, X-axis limits for all scales
%         is set to the absolute scale of the equivalent width at Jth scale and 
%         equivalent filters at all scales are shifted to properly align.
%      NormalizeYAxisToAbs = set limits of Y-axis to absolute limits.
%         The default = 0 (no)) plots each equivalent filter normalized to
%         its min and max.  If set to 1 (yes), plot all equivalent filter to
%         the absolute min and max value of all equivalent filters.
%      PlotAutocorrelationWidth = plot the autocorrelation width of the 
%         equivalent filter.  Default = 0 (no)
%      EqualYAxisYLim = Plot Yaxis with equal - and + magnitued, ie.
%                     = Set abs(YMin) = abs(YMax) 
%                     = max(abs(YMin), abs(YMax)). Default = 1 (yes)
%      PadXAxis = Extend x-axis limits by PadXAxis %  on each end
%                 Default = 0 (no)
%      PadYAxis = Extend y-axis limits by PadYAxis % on each end
%                 Default = 0 (no)
%      Stairs   = Plot filter as starirs. Default = 0, (no).
%
% EXAMPLE
%   plot_equivalent_filter('modwt', 'la8', 6, '', 1:4);
%
% REFERENCES
%   See figures 98a and 98b of WMTSA.
%
% SEE ALSO
%   dwt_equivalent_filter, modwt_equivalent_filter, LineSpec
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-02-12
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

%   $Id: plot_equivalent_filter.m 612 2005-10-28 21:42:24Z ccornish $

  default_plotOpts.PlothJ = 1;
  default_plotOpts.PlotgJ = 1;
  default_plotOpts.DrawXAxis = 1;
  default_plotOpts.DrawYTick = 0;
  default_plotOpts.NormalizeXAxisToLj = 1;
  default_plotOpts.NormalizeYAxisToAbs = 0;
  default_plotOpts.PlotAutoCorrelationWidth = 1;
  default_plotOpts.EqualYAxisYLim = 1;
  default_plotOpts.PadXAxis = 0;
  default_plotOpts.PadYAxis = 0;
  default_plotOpts.Stairs = 0;
  %default_plotOpts.PadXAxis = .25;
  %default_plotOpts.PadYAxis = .25;
  %default_plotOpts.Stairs = 1;
    

  usage_str = ['Usage:  [haxes, hlines_filter, hlines_xaxis, hlines_acw] = ', ...
               mfilename, ...
               '(transform, wavelet, J, ', ...
               '[LineSpec], [figtitle_str], ', ...
               '[axesProp], [level_range], [plotOpts]])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [3:8], nargout, [0:4], 1, usage_str, 'struct'));
  
  
  switch upper(transform)
   case 'DWT'
    [hJ, gJ, LJ] = dwt_equivalent_filter(wavelet, J);
   case 'MODWT'
    [hJ, gJ, LJ] = modwt_equivalent_filter(wavelet, J);
   otherwise
    error(['Unknown transform specified (', transform, ')']);
  end
  
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = 'r-';
  else
    % Check type
    try
      argterr(mfilename, LineSpec, 'char');
    catch
      error('Invalid type for argument');
    end
  end
  
  if (~exist('level_range', 'var') || isempty(level_range))
    level_range = 1:J;
  end
  
  if (~exist('plotOpts', 'var') || isempty(plotOpts))
    plotOpts = default_plotOpts;
  else
    fields = fieldnames(default_plotOpts);
    for (i = 1:length(fields))
      field = fields{i};
      if (isfield(plotOpts, field))
        % Do nothing
      else
        plotOpts.(field) = default_plotOpts.(field);
      end
    end
  end
  
  
  ncol = 2;
  nrow = length(level_range);
  
  ha_list = [];
  hl_filter_list = [];
  hl_xaxis_list = [];
  hl_acw_list = [];
  
  
  if (~plotOpts.NormalizeXAxisToLj)
    J0 = max(level_range);
    LJ_max = LJ{J0};
  else
    LJ_max = 0;
  end
  
  if (plotOpts.NormalizeYAxisToAbs)
    gJ_max = max(gJ{1});
    gJ_min = min(gJ{1});
    hJ_max = max(hJ{1});
    hJ_min = min(hJ{1});
    for (j = 2:length(LJ))
      gJ_max = max(gJ_max, max(gJ{j}));
      gJ_min = min(gJ_min, min(gJ{j}));
      hJ_max = max(hJ_max, max(hJ{j}));
      hJ_min = min(hJ_min, min(hJ{j}));
    end
    J_max = max(gJ_max, hJ_max);
    J_min = min(gJ_min, hJ_min);
    J_min = J_min - 0.1 * abs(J_min);
    J_max = J_max + 0.1 * abs(J_max);
  end
  
  irow = 0;
  iplot = 0;
  
  for (j = level_range)
  
    irow = irow + 1;
    icol = 1;
    
    if (plotOpts.NormalizeXAxisToLj)
      XLim = [-1,LJ{j}+1];
      x = [1:1:LJ{j}];
      XLim = [0,LJ{j}-1];
      x = [0:1:LJ{j}-1];
    else
      XLim = [0, LJ_max];
  %    x = [1:1:LJ_max];
      x = [1:1:LJ{j}];
    end  
  
    if (plotOpts.PadXAxis)
      xlen = XLim(2) - XLim(1);
      XLim(1) = XLim(1) - xlen * plotOpts.PadXAxis;
      XLim(2) = XLim(2) + xlen * plotOpts.PadXAxis;
      if (XLim(1) < 0)
        XLim(1) = 0;
      end
    end
    
    g_j = gJ{j};
    h_j = hJ{j};
  
    
    if (plotOpts.NormalizeYAxisToAbs)
      YLim = [J_min, J_max];
    else
      ymin = min(min(g_j), min(h_j));
      ymax = max(max(g_j), max(h_j));
      YLim = [ymin - 0.1 * abs(ymin), ...
              ymax + 0.1 * abs(ymax)];
    end
    
    if (plotOpts.EqualYAxisYLim)
      ymax_abs = max(abs(YLim));
      YLim = [-ymax_abs, +ymax_abs];
    end
    
    if (plotOpts.PadYAxis)
      ylen = YLim(2) - YLim(1);
      YLim(1) = YLim(1) - ylen * plotOpts.PadYAxis;
      YLim(2) = YLim(2) + ylen * plotOpts.PadYAxis;
    end
  
    if (plotOpts.PlotgJ)
      iplot = iplot + 1;
      ha = subplot(nrow, ncol, iplot);
      set(ha, 'Tag', ['g', int2str(j)]);
      ha_list = [ha_list, gca];
  
      [hl_filter, hl_xaxis, hl_acw] = ...
          plot_equivalent_filter_j(x, g_j, wavelet, j, irow, nrow, ...
                                   XLim, YLim, LJ{j}, LJ_max, ...
                                   LineSpec, plotOpts);
      
      hl_filter_list = [hl_filter_list, hl_filter];
      hl_xaxis_list = [hl_xaxis_list, hl_xaxis];
      hl_acw_list = [hl_acw_list, hl_acw];
  
      ylabel(['\it{j} = ', num2str(j)], ...
             'Rotation', 0, ...
             'HorizontalAlignment', 'Right', ...
             'VerticalAlignment', 'Middle');
  
      if (irow == 1)
        title({'Scaling', '\it{g_{j,l}}'});
      end
      
      
    end
  
    if (plotOpts.PlothJ)
      iplot = iplot + 1;
      ha = subplot(nrow, ncol, iplot);
      set(ha, 'Tag', ['h', int2str(j)]);
      ha_list = [ha_list, gca];
      
      [hl_filter, hl_xaxis, hl_acw] = ...
          plot_equivalent_filter_j(x, h_j, wavelet, j, irow, nrow, ...
                                   XLim, YLim, LJ{j}, LJ_max, ...
                                   LineSpec, plotOpts);
      hl_filter_list = [hl_filter_list, hl_filter];
      hl_xaxis_list = [hl_xaxis_list, hl_xaxis];
      hl_acw_list = [hl_acw_list, hl_acw];
  
      set(gca, 'YAxisLocation', 'right');
      ylabel_str = {['L_j = ', num2str(LJ{j})]};
      if (plotOpts.PlotAutoCorrelationWidth)
         [width_a] = filter_autocorrelation_width(wavelet, j);
        ylabel_str = [ylabel_str, {['w_{a,j} = ', num2str(width_a)]}];
      end
      ylabel(ylabel_str, ...
             'Rotation', 0, ...
             'HorizontalAlignment', 'Left', ...
             'VerticalAlignment', 'Middle');
  
      if (irow == 1)
        title({'Wavelet', '\it{h_{j,l}}'});
      end
    
    end
  
  end
  
  if (~plotOpts.DrawYTick)
    set(ha_list, 'YTick', []);
    set(ha_list, 'YTickLabel', []);
  end
  
  if (exist('axesProp', 'var') && ~isempty(axesProp))
    set_axes_prop(ha_list, axesProp);
  end
  
  if (~exist('figtitle_str', 'var'))
    figtitle_str = {[upper(wavelet)], 'Equivalent Filters'};
  end
  
  if (~isempty(figtitle_str))
    suptitle(figtitle_str);
  end
  
  
  if (nargout > 0)
    haxes = ha_list;
  end
  
  if (nargout > 1)
    hlines_filter = hl_filter_list;
  end
  
  if (nargout > 2)
    hlines_acw = hl_acw_list;
  end
  
  if (nargout > 3)
    hlines_xaxis = hl_xaxis_list;
  end

return

function [hl_filter, hl_xaxis, hl_acw] = ...
      plot_equivalent_filter_j(x, g_j, wavelet, j, irow, nrow, ...
                               XLim, YLim, L_j, LJ_max, ...
                               LineSpec, plotOpts)
% Plot equivalent filter at jth level.

    if (plotOpts.NormalizeXAxisToLj)
      offset = -1;
      xx = x;
    else
      offset = (LJ_max - L_j) / 2;
      xx = x + offset;
    end

    hl_xaxis = [];
    if (plotOpts.DrawXAxis)
      hl_xaxis = plot([XLim(1), XLim(end)], [0,0], 'k');
      set(hl_xaxis, 'Tag', 'XAxis');
      hold on;
    end

    if (plotOpts.Stairs)
      xxx = [xx(1)-1, xx, xx(end)+1];
      gg_j = [0; g_j(:)];
      gg_j = [gg_j; 0];
      hl_filter = stairs(xxx, gg_j, LineSpec);
      hold on;
    else
      hl_filter = plot(xx, g_j, LineSpec);
      hold on;
    end

    set(hl_filter, 'Tag', 'Filter');

    set(gca, 'XLim', XLim);
    set(gca, 'YLim', YLim);
    
    hl_acw = [];
    if (plotOpts.PlotAutoCorrelationWidth)
      [width_a] = filter_autocorrelation_width(wavelet, j);
      
      if(strcmpi(wavelet, 'ccc'))
        x_acw = [x(1), x(end)+1] + offset;
      else
        coe = filter_center_of_energy(g_j);
%        filter_center = x(round(length(x)/2)) + 1;
%        x_acw = [filter_center - width_a / 2 , filter_center + width_a / 2] + ...
%                offset;
         x_acw = [coe - width_a / 2, coe + width_a / 2] + offset;
         x_acw = floor(x_acw + .5);
      end
      
      YLim = get(gca, 'YLim');
      g_j_min = min(g_j);

%      if (plotOpts.NormalizeYAxisToAbs)
        ymin = YLim(1) + 0.1 * (YLim(2) - YLim(1));
%      else
%        ymin = (YLim(1) - g_j_min) / 2;
%      end
      
      
      y_acw = [ymin, ymin];

      hl_acw = line(x_acw, y_acw);
      set(hl_acw, 'Tag', 'Width_a');
      set(hl_acw, 'Marker', 'x');
    end

    if (plotOpts.NormalizeXAxisToLj)
      if (irow == nrow)
        XTick = XLim;
        XTickLabel = {'0', 'Lj -1'};
        set(gca, 'XTick', XTick);
        set(gca, 'XTickLabel', XTickLabel);
      else
        set(gca, 'XTickLabel', []);
      end
    else
      if (irow == nrow)
        % do nothing
      else
        set(gca, 'XTickLabel', []);
      end
    end

    if (irow == nrow)
      xlabel('\itl');
    end

return

