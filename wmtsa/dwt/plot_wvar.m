function [haxes] = plot_wvar(wvar, CI_wvar, title_str, ylabel_str, LineSpec, ...
                             axesProp, level_range, plotOpts)
% plot_wvar      - Plot the wavelet variance and confidence intervals.
%
%****f* wmtsa.dwt/plot_wvar
%
% NAME
%   plot_wvar    - Plot the wavelet variance and confidence intervals.
%
% SYNOPSIS
%   [haxes] = plot_wvar(wvar, [CI_wvar], [title_str], [ylabel_str], [LineSpec], ...
%                      [axesProp], [level_range], [plotOpts])
%
% INPUTS
%   wvar         = wavelet variance(s) (Jx1 vector of cell array of vectors).
%   CI_wvar      = (optional) confidence interval of wavelet variance,
%                  (Jx2 array  or a cell array of Jx2 arrays)
%                  lower bound (column 1) and upper bound (column 2).
%   title_str    = (optional) character string containing title for the plot.
%   ylabel_str   = (optional) character string containing first line of ylabel for plot.
%   LineSpec     = (optional) character string containing LineSpec (see plot).
%   axesProp     = (optional) structure containing name-value pairs of axes
%                  properties to override (see axes).
%   level_range  = (optional) number or range of numbers indicating subset of
%                  levels (j's) to plot.
%   plotOpts     = (optional) structure containing plot options.
%
% OUTPUTS
%   haxes        = handle to axes of wavelet variance plot.
%
% SIDE EFFECTS
%   
%
% DESCRIPTION
%   plot_wvar plots the wavelet variance and optionally confidence intervals
%   on a semilog y-axes as a function of level.  By default, the wavelet
%   variance is plotted for range of levels from 0 to max(level) rounded
%   up to next even number.  Use axesProp.XLim to change the limits
%   for range of levels to plot.
%
%   The argument plotOpts is structure with fields controlling plotting
%   options as follows:
%
%     LabelScales = boolean flag indicating whether to add a second set of
%                   labels at min and max x-axis values with physical scale
%                   based on value of DeltaT.  A second x-axis label titled
%                   scale is added to the x-axis.
%     DeltaT      = sampling interval of time series in physical units.
%     DeltaTUnits = units of sample unit DeltaT.  If specified, units is
%                   is added to second x-axis label for the scale labels.
%     LegendList  = character cell array to add a legend to plot using 
%                   the values contained in the cell array.
%     LegendPos   = integer indicating where to place legend on plot.
%                   See legend for possible values and default.
%     LineSpecList = cell array of LineSpec values to use for plotting
%                   wvar and confidence intervals.
%     PlotErrorBar = boolean flag indicating to plot confidence intervals
%                   as error bars.
%
% EXAMPLES
%   [WJ0t, VJ0t] = modwt(X, 'la8', 6, 'reflection')
%   [wvar, CI_wvar] = modwt_wvar(WJt)
%   axesProp.XLim = [0, 10]
%   plotOpts.LabelScales = 1
%   plotOpts.DeltaT = (1 / 25) * 4  % Sample rate of 25 Hz times 4 m/s sensor
%                                   %  velocity
%   plotOpts.DeltaTUnits = 'm'
%   plot_wvar(wvar, CI_wvar, 'Wavelet Variance', 'w', '', axesProp, '', plotOpts)
%
% NOTES
%   The function expects that complete vectors of wavelet varianaces
%   and confidence levels are passed in as arguments.  To plot a subset
%   of points to plot, use the level_range argument.
%
% BUGS
%   When first used in a new figure window, an extra line of spacing occurs
%   between x-ticklabels and xlabel for primary and secondary x-axis labels.
%   Reissuing the command in the same figure window will create appropriate
%   line spacing.
%
% SEE ALSO
%   modwt_wvar, plot, LineSpec, axes
%
% TOOLBOX
%   wmtsa/plotutils
%
% CATEGORY
%   WMTSA Plotting: Wavelet Variance
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/04/23
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

% $Id: plot_wvar.m 612 2005-10-28 21:42:24Z ccornish $


  default_LineSpecList = {'b', 'k', 'r', 'g', 'c', 'm', 'y'};

  usage_str = ['Usage:  [haxes] = ', mfilename, ...
             '(wvar, [CI_wvar], [title_str], [ylabel_str], [LineSpec], ', ...
             '[axesProp], [level_range], [plotOpts])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:8], nargout, [0:1], 1, usage_str, 'struct'));


  % Validate arguments
  
  if (iscell(wvar))
    wvar_list = wvar;
  else
    wvar_list = {wvar};
  end
  
  plot_ci = 0;
  
  if (nargin > 1)
    if (exist('CI_wvar', 'var') && ~isempty(CI_wvar))
      plot_ci = 1;
      if (iscell(CI_wvar))
        CI_wvar_list = CI_wvar;
      else
        CI_wvar_list = {CI_wvar};
      end
    end
  end
  
  if (~exist('plotOpts', 'var'))
    plotOpts = [];
  end
  
  if (exist('LineSpec', 'var') & ~isempty(LineSpec))
    if (iscell(LineSpec))
      LineSpecList = LineSpec;
    elseif (ischar(LineSpec))
      LineSpecList = {LineSpec};
    else
      error([mfilename, ': LineSpec must be a char or cell array']);
    end
  else
    nlspec = length(default_LineSpecList);
    for (i = 1:length(wvar_list))
      ispec = mod(i, nlspec);
      LineSpecList{i} = default_LineSpecList{ispec};
    end
  end
  
  
  if (isfield(plotOpts, 'LineSpecList')  & ~isempty(plotOpts.LineSpecList))
    if (iscell(plotOpts.LineSpecList))
      LineSpecList = plotOpts.LineSpecList;
    elseif (ischar(plotOpts.LineSpecList))
      LineSpecList = {plotOpts.LineSpecList};
    else
      error([mfilename, ': plotOpts.LineSpecList must be a char or cell array']);
    end
  end
  
  if (isfield(plotOpts, 'CI_LineSpecList')  & ~isempty(plotOpts.CI_LineSpecList))
    if (iscell(plotOpts.CI_LineSpecList))
      CI_LineSpecList = plotOpts.CI_LineSpecList;
    elseif (ischar(plotOpts.CI_LineSpecList))
      CI_LineSpecList = {plotOpts.CI_LineSpecList};
    else
      error([mfilename, ': plotOpts.CI_LineSpecList must be a char or cell array']);
    end
  end
  
  
  if (length(LineSpecList) == 1)
    for (i = 2:length(wvar_list))
      LineSpecList{i} = LineSpecList{1};
    end
  end
  
  if (length(LineSpecList) < length(wvar_list))
    error('Length of LineSpecList must equal length wvar list');
  end
  
  % if (~exist('CI_LineSpecList', 'var'))
  %  CI_LineSpecList = LineSpecList;
  % end
  
  J_max = 0;
  for (i = 1:length(wvar_list))
    J_max = max(J_max, length(wvar_list{i}));
  end
  
  
  hl_list_wvar = [];
  hl_list_CI_wvar = [];
  for (i = 1:length(wvar_list))
  
    wvar = wvar_list{i};
    CI_wvar = CI_wvar_list{i};
    
    if (exist('level_range', 'var') && ~isempty(level_range))
      nlevels = length(level_range);
      x_axis = level_range;
      wvar = wvar(level_range);
      CI_wvar = CI_wvar(level_range,:);
    else
      J = length(wvar_list{i});
      x_axis = (1:1:J);
    end
  
    if (isfield(plotOpts, 'PlotErrorBar') && plotOpts.PlotErrorBar)
      if (~exist('CI_wvar_list', 'var') || isempty(CI_wvar_list{i}))
        error('Must specify CI_wvar if using PlotErrorBar plot option.')
      end
      L = wvar - CI_wvar(:,1);
      U = CI_wvar(:,2) - wvar;
      hl = errorbar(x_axis, ...
                    wvar, ...
                    L, U, LineSpecList{i});
      hold on;
      set(gca, 'YScale', 'log');
      hl_list_wvar = [hl_list_wvar, hl];
      
    else
    
      % Plot wavelet variance
      hl = semilogy(x_axis, wvar, ...
                       LineSpecList{i});
      hold on;
    
      hl_list_wvar = [hl_list_wvar, hl];
      
      % Plot the wavelet variance confidence intervals
  
      
      if (plot_ci)
        hold on;
        if (~exist('CI_LineSpecList', 'var'))
          Color = get(hl, 'Color');
          LineStyle = ':';
          semilogy(x_axis, CI_wvar(:,1), 'Color', Color, 'LineStyle', LineStyle);
          semilogy(x_axis, CI_wvar(:,2), 'Color', Color, 'LineStyle', LineStyle);
        else
          CI_LineSpecList{i}
          hl = semilogy(x_axis, CI_wvar(:,1), CI_LineSpecList{i});
          hl = semilogy(x_axis, CI_wvar(:,2), CI_LineSpecList{i});
          hl_list_CI_wvar = [hl_list_CI_wvar, hl];
        end
      end
    end
  
  end
  
  ha = gca;
  
  xmin = 0;
  xmax = max(x_axis);
  if (mod(xmax,2) == 1)
    xmax = xmax + 1;
  end
    
  set(ha, 'XLim', [xmin, xmax]);
  htext_xlabel = xlabel('Level');
  
  if (exist('axesProp', 'var') && ~isempty(axesProp))
    ha = set_axes_prop(ha, axesProp);
  end
  
  
  
  % Add optional second axis tick labels and labels for scales.
  if (isfield(plotOpts, 'LabelScales') && plotOpts.LabelScales)
    
    if (isfield(plotOpts, 'DeltaT'))
      delta_t = plotOpts.DeltaT;
  
  %    XLim = get(ha, 'XLim');
  %    max_level = XLim(2);
      
      XTick = get(ha, 'XTick');
      scale_tick = 2.^(XTick-1) * delta_t;
    
  %    scale_label_str{1} = num2str(scale_tick(1));
  %    scale_label_str{2} = num2str(scale_tick(end));
  
      scale_tick_label_list = {};
      for (i = 1:length(scale_tick))
        scale_tick_label_list{i} = num2str(scale_tick(i));
      end
  
  
  %    set(htext_xlabel, 'Units', 'normalized');
  %    Extent_xlabel = get(htext_xlabel, 'Extent');
  %    Position_xlabel = get(htext_xlabel, 'Position');
  
      set(htext_xlabel, 'Units', 'data');
      Extent_xlabel_data = get(htext_xlabel, 'Extent');
      Position_xlabel_data = get(htext_xlabel, 'Position');
      set(htext_xlabel, 'Units', 'normalized');
      Extent_xlabel_norm = get(htext_xlabel, 'Extent');
      Position_xlabel_norm = get(htext_xlabel, 'Position');
  
      
      
      for (i = 1:length(scale_tick_label_list))
  
        htext1 = text(XTick(i), ...
                      Position_xlabel_data(2), ...
                      scale_tick_label_list{i}, ...
                      'HorizontalAlignment', 'Center', ...
                      'VerticalAlignment', 'Top');
        set(htext1, 'Units', 'normalized');
        Extent_slabel_norm = get(htext1, 'Extent');
        Position_slabel_norm = get(htext1, 'Position');
        Position_slabel_norm(2) = Position_xlabel_norm(2) - Extent_xlabel_norm(4);
        set(htext1, 'Position',  Position_slabel_norm)
        set(htext1, 'Units', 'data');
        set(htext1, 'FontSize', get(get(ha, 'XLabel'), 'FontSize'));
      end
      
  %%%     htext1 = text(0, ...
  %%%                   Extent_xlabel(2), ...
  %%%                   scale_label_str{1}, ...
  %%%                   'Units', 'normalized', ...
  %%%                   'HorizontalAlignment', 'Center', ...
  %%%                   'VerticalAlignment', 'Top');
  %%%     
  %%%     htext2 = text(1, ...
  %%%                   Extent_xlabel(2), ...
  %%%                   scale_label_str(2), ...
  %%%                   'Units', 'normalized', ...
  %%%                   'HorizontalAlignment', 'Center', ...
  %%%                   'VerticalAlignment', 'Top');
    
  %    set(htext2, 'Units', 'normalized');
  %    Extent_htext2 = get(htext2, 'Extent');
    
      scale_label_str = 'Scale';
      
      if (isfield(plotOpts, 'DeltaTUnits'))
        scale_label_str = [scale_label_str, '  (', plotOpts.DeltaTUnits, ')'];
      end
      
  %%%    htext_slabel = text(Position_xlabel(1), ...
  %%%                        Extent_htext2(2), ...
  %%%                        scale_label_str, ...
  %%%                        'Units', 'normalized', ...
  %%%                        'HorizontalAlignment', 'Center', ...
  %%%                        'VerticalAlignment', 'Top');
  %%%    
  
      set(htext1, 'Units', 'normalized');
      Extent_slabel_norm = get(htext1, 'Extent');
      Position_slabel_norm = get(htext1, 'Position');
      set(htext1, 'Units', 'data');
      
      htext_slabel = text(Position_xlabel_norm(1), ...
                          Position_slabel_norm(2) - Extent_slabel_norm(4), ...
                          scale_label_str, ...
                          'Units', 'normalized', ...
                          'HorizontalAlignment', 'Center', ...
                          'VerticalAlignment', 'Top');
      set(htext_slabel, 'Units', 'data');
      
    end
  end
  
  % Add ylabel and title to plot.
  
  default_ylabel_str = 'Wavelet Variance';
  if exist('ylabel_str', 'var')
    ylabel_str2 = ylabel_str; 
  else
    ylabel_str2 = default_ylabel_str;
  end
  
  ylabel(ylabel_str2);
  
  if (exist('title_str', 'var')  && ~isempty(title_str))
    title(title_str);
  end
  
  
  if (isfield(plotOpts, 'LegendList') && ~isempty(plotOpts.LegendList))
    if (isfield(plotOpts, 'LegendPos') && ~isempty(plotOpts.LegendPos))
      pos = plotOpts.LegendPos;
    else
      pos = 1;
    end
  
    hl_list = hl_list_wvar;
    legend_list = plotOpts.LegendList;
    if (exist('hl_list_CI_wvar', 'var') && ~isempty(hl_list_CI_wvar))
      hl_list = [hl_list, hl_list_CI_wvar];
      legend_list = [legend_list, plotOpts.LegendList];
    end
    legend(hl_list, legend_list, pos);
  end
  
  if (nargout > 0)
    haxes = gca;
  end
  
return


