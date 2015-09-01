function [haxes] = plot_wcov(wcov, CI_wcov, title_str, ylabel_str, LineSpec, ...
                             axesProp, level_range, plotOpts)
% plot_wcov -- Plot the wavelet covariance and confidence intervals.
%
%****f* wmtsa.dwt/plot_wcov
%
% NAME
%   plot_wcov -- Plot the wavelet covariance and confidence intervals.
%
% SYNOPSIS
%   [haxes] = plot_wvcov(wcov, [CI_wvar], [title_str], [ylabel_str], [LineSpec], ...
%                      [axesProp], [level_range], [plotOpts])
%
%
% INPUTS
%   wcov         = vector containing wavelet covariance for J levels.
%   CI_wcov      = (optional) Jx2 matrix containing confidence intervals of wcov,
%                  lower bound (column 1) and upper bound (column 2)
%   title_str    = (optional) character string containing title for the plot.
%   ylabel_str   = (optional) character string containing first line of ylabel for plot.
%   LineSpec     = (optional) character string containing LineSpec (see plot).
%   axesProp     = (optional) structure containing name-value pairs of axes
%                  properties to override (see axes).
%   level_range  = (optional) number or range of numbers indicating subset of
%                  levels (j's) to plot.
%   plotOpts     = (optional) structure containing plot options (unused at present).
%
% OUTPUTS
%   haxes        = handle to axes of wavelet covariance plot.
%
% SIDE EFFECTS
%   
%
% DESCRIPTION
%   plot_wcov plots the wavelet covariance and optionally confidence intervals
%   on a semilog y-axes as a function of level.  By default, the wavelet
%   variance is plotted for range of levels from 0 to max(level) rounded
%   up to next even number.  Use axesProp.XLim to change the limits
%   for range of levels to plot.
%
% EXAMPLE
%   [WJ0t_x, VJ0t_x] = modwt(X, 'la8', 6, 'reflection')
%   [WJ0t_y, VJ0t_y] = modwt(Y, 'la8', 6, 'reflection')
%   [wcov, CI_wcov] = modwt_wcov(WJt_x, WJt_y)
%   axesProp.XLim = [0, 10]
%   plot_wvar(wvar, CI_wvar, 'Wavelet Variance', 'w', '', axesProp)
%
% NOTES
%
%
% SEE ALSO
%   modwt_wcov
%
% TOOLBOX
%   wmtsa/plotutils
%
% CATEGORY
%   WMTSA Plotting: Wavelet Coariance
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/04/24
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

% $Id: plot_wcov.m 612 2005-10-28 21:42:24Z ccornish $

  usage_str = ['Usage:  [haxes] = ', mfilename, ...
               'plot_wvcov(wcov, [CI_wvar], [title_str], [ylabel_str], [LineSpec], ',  ...
               '[axesProp], [level_range], [plotOpts])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:8], nargout, [0:1], 1, usage_str, 'struct'));

  % Check arguments
  
  plot_ci = 0;
  if (nargin > 1)
    if (exist('CI_wcov', 'var') && ~isempty(CI_wcov))
      plot_ci = 1;
    end
  end
  
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = 'r';
    ci_LineSpec = 'k--';
  end
  
  J = length(wcov);
  if (exist('level_range', 'var') && ~isempty(level_range))
    nlevels = length(level_range);
    x_axis = level_range;
  else
    nlevels = J;
    x_axis = (1:1:nlevels);
    level_range = x_axis;
  end
  
  % Plot the wavelet covariance
  
  hline = plot(x_axis, wcov, LineSpec);
  
  % Plot the wavelet variance confidence intervals
  
  if (plot_ci)
    hold on;
    if (~exist('ci_LineSpec', 'var'))
      Color = get(hline, 'Color');
      LineStyle = '--';
      plot(x_axis(level_range), CI_wcov(level_range,1), ...
           'Color', Color, 'LineStyle', LineStyle);
      plot(x_axis(level_range), CI_wcov(level_range,2), ...
           'Color', Color, 'LineStyle', LineStyle);
    else
      plot(x_axis(level_range), CI_wcov(level_range,1), ci_LineSpec);
      plot(x_axis(level_range), CI_wcov(level_range,2), ci_LineSpec);
    end
  end
  
  ha = gca;
  
  xmin = 0;
  xmax = max(x_axis);
  if (mod(xmax,2) == 1)
    xmax = xmax + 1;
  end
    
  set(ha, 'XLim', [xmin, xmax]);
  
  xmin = 0;
  xmax = max(x_axis);
  if (mod(xmax,2) == 1)
    xmax = xmax + 1;
  end
    
  set(ha, 'XLim', [xmin, xmax]);
  htext_xlabel = xlabel('level');
  
  if (exist('axesProp', 'var') && ~isempty(axesProp))
    ha = set_axes_prop(ha, axesProp);
  end
  
  htext = xlabel('level');
  
  default_ylabel_str = 'wavelet covariance';
  if exist('ylabel_str', 'var')
    ylabel_str2 = ylabel_str;
  else
    ylabel_str2 = default_ylabel_str;
  end
  
  ylabel(ylabel_str2);
  
  if exist('title_str', 'var')
    title(title_str);
  end
  
  if (nargout > 0)
    haxes = ha;
  end
  
return
