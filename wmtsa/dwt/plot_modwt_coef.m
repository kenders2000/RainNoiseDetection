function [hWplotAxes, hXplotAxes] = plot_modwt_coef(WJt, VJ0t, X, w_att, ...
                                                  title_str, xaxis, xlabel_str, ...
                                                  WplotAxesProp, XplotAxesProp, ...
                                                  J0, level_range, plotOpts, ...
                                                  masterPlotFrame, xaxis_range, scale_str)
% plot_modwt_coef -- Plot the MODWT wavelet and scaling coefficients and the original time series.
%
%****f* wmtsa.dwt/plot_modwt_coef
%
% NAME
%   plot_modwt_coef -- Plot the MODWT wavelet and scaling coefficients and the
%      original time series.
%
% SYNOPSIS
%   [hWplotAxes, hXplotAxes] = plot_modwt_coef(WJt, VJ0t, [X], w_att, ... 
%                                   [title_str], [xaxis], [xlabel_str], ...
%                                   [WplotAxesProp], [XplotAxesProp], ...
%                                   [J0], [level_range], [plotOpts], ...
%                                   [masterPlotFrame], [xaxis_range], [scale_str])
%   [hWplotAxes, hXplotAxes] = plot_modwt_coef(WJt,   [], [X], w_att, ...
%                                   [title_str], [xaxis], [xlabel_str], ...
%                                   [WplotAxesProp], [XplotAxesProp], ...
%                                   [J0], [level_range], [plotOpts], ...
%                                   [masterPlotFrame], [xaxis_range], [scale_str])
%   [hWplotAxes, hXplotAxes] = plot_modwt_coef([],  VJ0t, [X], w_att, ...
%                                   [title_str], [xaxis], [xlabel_str], ...
%                                   [WplotAxesProp], [XplotAxesProp], ...
%                                   [J0], [level_range], [plotOpts], ...
%                                   [masterPlotFrame], [xaxis_range], [scale_str])
%
% INPUTS
%   WJt           =  NxJ array of MODWT wavelet coefficents
%                    where N = number of time intervals,
%                          J = number of levels
%   VJ0t          =  Nx1 vector of MODWT scaling coefficients at level J0.
%   X             =  (optional) vector of observations of size N.
%   * w_att        -- MODWT transform attributes (struct).
%   title_str     =  (optional) character string or cell array of strings containing title of plot.
%   xaxis         =  (optional) vector of values to use for plotting x-axis.
%   xlabel_str    =  (optional) character string or cell array of strings containing label x-axis.
%   WplotAxesProp =  (optional) structure containing axes property values to
%                    override for W subplot.
%   XplotAxesProp =  (optional) structure containing axes property values to
%                    override for X subplot.
%   J0            =  (optional) override value of J0, if J ~= J0 or
%                    if max(level_range) ~= J0.
%   level_range   =  (optional) number or range of numbers indicating subset of
%                    levels (j's) to plot.
%   plotOpts      =  (optional) structure containing plot options.
%   masterPlotFrame = (optional) structure containing coordinates to 
%                     place X and W plots.
%   xaxis_range   =  (optional) range of xaxis values to plot.
%   scale_str     =  (optional) character cell array of strings containing
%                    physcial scale values of levels to label left y-axis of W plot.
%
% OUTPUTS
%   hWplotAxes    =  (optional) handle to axes for MODWT coefficients (W) subplot.
%   hXplotAxes    =  (optional) handle to axes for original data series (X) subplot.
%
% SIDE EFFECTS
%   1. If plotting VJ0t, without WJt (i.e. WJt = []), must specify a value for
%      J0; otherwise error.
%   2. If a level_range is specified, must provide a value for J0; otherwise
%      error.
%   3. Either WJt or VJ0t,  or both WJt and VJ0t may be specified'; otherwise
%      error.
%
% DESCRIPTION
%   plot_modwt_coef plots the MODWT coefficients and optionally the original
%   data series.  Either or both the MODWT wavelet and scaling coefficients
%   may be plotted (aka Wplot).  The orignal time series is tagged the Xplot.
%   The MODWT coefficients are circularly shifted at each level so as to 
%   properly align the coefficients with the original data series.
%
%   By default, the wavelet coefficients (WJt) and scaling coefficient at
%   level J0 (VJ0t) are plotted.  A subrange of wavelet coefficient levels
%   may be specified by via the parameter, level_range = [lower:upper]
%
%   By default, the boundaries demarcing the circularly shifted MODWT
%   coefficients influenced by the circularity conditions are plot.  
%   Plotting of the boundaries may be toggled off.
%  
%   By default, the mean value of VJ0t is subtracted from VJ0t, so that
%   when plotting a data series with large mean offsets, the VJ0t level
%   does not dominate the Wplot.
%
%   Defaults for plotOpts:
%     plotOpts.PlotMODWTBoundary = 1;
%     plotOpts.PlotWJt = 1;
%     plotOpts.PlotVJ0t = 1;
%     plotOpts.PlotX = 1;
%     plotOpts.SubtractMeanVJ0t = 1;
%
% EXAMPLE
%    [WJt, VJ0t] = modwt(X, 'la8', 10, 'reflection');
%    plot_modwt_coef(WJt, VJ0t, X, 'la8');
%
% NOTES
%
%
% BUGS
%   1. MODWT Boundary lines do not draw across Y-axis range for values of VJ0t
%   with large offsets (means).
%
% REFERENCES
%    See figure 183 of WMTSA.
%
% SEE ALSO
%   modwt, modwt_filter, overplot_modwt_cir_shift_coef_bdry,
%   multi_yoffset_plot
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/01
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

% $Id: plot_modwt_coef.m 612 2005-10-28 21:42:24Z ccornish $

% Initialize constants and other parameters
ylabel_xoffset = .015;

% Master Plot Frame - contains all subplot
default_masterPlotFrame.left = .15;
default_masterPlotFrame.bottom = .11;
default_masterPlotFrame.width = .775;
default_masterPlotFrame.height = .805;
default_masterPlotFrame.subplot_yspacing = .010;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check Input Arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usage_str = ['Usage:  [hWplotAxes, hXplotAxes] = ', mfilename, ...
             '(WJt, VJ0t, [X], w_att' ...
             ', [title_str], [xaxis], [xaxis_label]', ...
             ', [WplotAxesProp], [XplotAxesProp]' ...
             ', [J0], [level_range], [plotOpts], ', ...
             ', [masterPlotFrame], [xaxis_range], [scale_str])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [1:15], nargout, [0:2], 1, usage_str, 'struct'));


if (~exist('w_att', 'var') || isempty(w_att) )
  error('Must specify the MODWT attribute structure.');
end  

wtfname = w_att.WTF;
NX  = w_att.NX;
N = NX;
NW = w_att.NW;
J0 = w_att.J0;
boundary = w_att.Boundary;

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



% Initialize and set the plot options

plot_WJt = 0;
plot_VJ0t = 0;
plot_X = 0;
plot_modwt_boundary = 1;
subtract_mean_VJ0t = 1;

if (exist('WJt', 'var') && ~isempty(WJt) )
  plot_WJt = 1;
end  

if (exist('VJ0t', 'var') && ~isempty(VJ0t) )
  plot_VJ0t = 1;
end

if (exist('X', 'var') && ~isempty(X) )
  plot_X = 1;
end

if (~exist('plotOpts', 'var'))
  plotOpts = [];
end

if (isfield(plotOpts, 'PlotWJt'))
  if (plotOpts.PlotWJt)
    plot_WJt = 1;
  else
    plot_WJt = 0;
  end
end

if (isfield(plotOpts, 'PlotVJ0t'))
  if (plotOpts.PlotVJ0t)
    plot_VJ0t = 1;
  else
    plot_VJ0t = 0;
  end
end

if (isfield(plotOpts, 'PlotX'))
  if (plotOpts.PlotX)
    plot_X = 1;
  else
    plot_X = 0;
  end
end

%%% if (plot_WJt == 0 && plot_VJ0t == 0)
%%%   error('Must specify either WJt or VJ0t, or both for plotting');
%%% end

if (isfield(plotOpts, 'PlotMODWTBoundary'))
  if (plotOpts.PlotMODWTBoundary)
    plot_modwt_boundary = 1;
  else
    plot_modwt_boundary = 0;
  end    
end

if (isfield(plotOpts, 'SubtractMeanVJ0t'))
  if (plotOpts.SubtractMeanVJ0t)
    subtract_mean_VJ0t = 1;
  else
    subtract_mean_VJ0t = 0;
  end    
end


if (~exist('level_range', 'var') || isempty(level_range))
  level_range = [];
else
  error(argterr(mfilename, level_range, 'posint', [], 1, '', 'struct'));
end


% Initialized and override masterPlotFrame

if (~exist('masterPlotFrame', 'var') || isempty(masterPlotFrame))
  masterPlotFrame = default_masterPlotFrame;
else
  if (~isfield(masterPlotFrame, 'left'))
    masterPlotFrame.left = default_masterPlotFrame.left;
  end
  if (~isfield(masterPlotFrame, 'bottom'))
    masterPlotFrame.bottom = default_masterPlotFrame.bottom;
  end
  if (~isfield(masterPlotFrame, 'width'))
    masterPlotFrame.width = default_masterPlotFrame.width;
  end
  if (~isfield(masterPlotFrame, 'height'))
    masterPlotFrame.height = default_masterPlotFrame.height;
  end
  if (~isfield(masterPlotFrame, 'wsubplot_yspacing'))
    masterPlotFrame.subplot_yspacing = default_masterPlotFrame.subplot_yspacing;
  end
end

if (~exist('scale_str', 'var') || isempty(scale_str))
  scale_str = [];
end


% Initial default values for the W (coefficients) plot frame.
WplotFrame.left = masterPlotFrame.left;
WplotFrame.bottom = masterPlotFrame.bottom;
WplotFrame.width = masterPlotFrame.width;
WplotFrame.height = masterPlotFrame.height;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Transform data for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


W = [];
Wlabels = {};

jj = 0;

if (plot_WJt)
  if(~exist('level_range', 'var') || isempty(level_range))
    level_range = 1:J0;
  end

  for (j = level_range)
    jj = jj + 1;
    nuHj = advance_wavelet_filter(wtfname, j);
    W(:,jj) = circshift(WJt(:,j), nuHj);
    Wlabels{jj} = ['T^{', int2str(nuHj), '}\bfW\rm_{', int2str(j), '}'];
  end
end

if (plot_VJ0t)
  jj = jj + 1;
  nuGj = advance_scaling_filter(wtfname, J0);
  if (subtract_mean_VJ0t)
    VJ0t = VJ0t - mean(VJ0t);
    label_str = ['T^{', int2str(nuGj), ...
                 '}\bfV\rm_{', int2str(J0), '}\prime'];
  else
    label_str = ['T^{', int2str(nuGj), '}\bfV\rm_{', int2str(J0), '}'];
  end
    
  W(:,jj) = circshift(VJ0t, nuGj);
  Wlabels{jj} = label_str;
end


%% Truncate for reflection BC's, where NW = 2 * N;
W = W(1:N,:,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Setup up x-axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If xaxis is not specified, use the sample points
if (~exist('xaxis', 'var') || isempty(xaxis))
  xaxis = (1:N);
end

if (exist('xaxis_range', 'var') && ~isempty(xaxis_range))
  indices = find(xaxis >= xaxis_range(1) & xaxis <= xaxis_range(end));
  xaxis = xaxis(indices);
  W = W(indices,:);
  if (plot_X)
    X = X(indices,1);
  end
else
  xaxis_range = [];
end

xaxis_xmin = min(xaxis);
xaxis_xmax = max(xaxis);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parse the Xplot options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (plot_X)

  % Check that length(X) == length(W)
  if (length(X) ~= length(W))
    error(['Length of X must be equal nrows of WJt and VJ0t']);
  end

  % Initialize default values
  Xmin = min(X);
  Xmax = max(X);

  XplotAxesPropName = {};
  XplotAxesPropVal = {};
  
  if (exist('XplotAxesProp', 'var') && ~isempty(XplotAxesProp))

    % Overide default values for Xmin, Xmin (= YLim min and max for Xplot)
    if (isfield(XplotAxesProp, 'YLim'))
      ylim = XplotAxesProp.YLim;
      Xmin = ylim(1);
      Xmax = ylim(2);
    end

    % Populate cell arrays for Xplot axes names and properties
    axes_field_names = fieldnames(XplotAxesProp);
    nfields = length(axes_field_names);
    
    for (i = 1:nfields)
      fname = axes_field_names{i};
      XplotAxesPropName(i) = {fname};
      fval = XplotAxesProp.(fname);
      XplotAxesPropVal(i) = {fval};
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Override x-axis min, max values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (exist('XplotAxesProp', 'var'))
  % Overide default values for xaxis_xmin, xaxis_xmax from XplotAxesProp
  if (isfield(XplotAxesProp, 'XLim'))
    xlim = XplotAxesProp.XLim;
    xaxis_xmin = xlim(1);
    xaxis_xmax = xlim(2);
  end
elseif (exist('WplotAxesProp', 'var'))
  % Overide default values for xaxis_xmin, xaxis_xmax from WplotAxesProp
  if (isfield(WplotAxesProp, 'XLim'))
    xlim = WplotAxesProp.XLim;
    xaxis_xmin = xlim(1);
    xaxis_xmax = xlim(2);
  end
else
  % Do nothing - no override
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Create Xplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (plot_X)

  % In creating the subplots for X and W, scale the subplots so that X and W 
  % are plotted on the same y scale.
  
  Wmax = max(W);
  Wmin = min(W);
  Wtotal_range = sum(abs(Wmax - Wmin));
  Xtotal_range = abs(Xmax - Xmin);
  Yaxis_total_range = Wtotal_range + Xtotal_range;
  Wplot_ypercent = Wtotal_range / Yaxis_total_range;
  Xplot_ypercent = Xtotal_range / Yaxis_total_range;

  XplotFrame.height = masterPlotFrame.height * Xplot_ypercent;
  WplotFrame.height = masterPlotFrame.height * Wplot_ypercent;

  XplotFrame.left = masterPlotFrame.left;
  XplotFrame.bottom = masterPlotFrame.bottom;
  XplotFrame.width = masterPlotFrame.width;
  
  XplotPosition = [XplotFrame.left, ...
              XplotFrame.bottom ...
              XplotFrame.width, ...
              XplotFrame.height];

  % Create a subplot for X
  hXplotAxes = axes('Tag', 'Xplot',  ...
       'Position', XplotPosition, ...
       'XAxisLocation', 'bottom', ...
       'YAxisLocation', 'left');


  line(xaxis, X);
  

  set(gca, XplotAxesPropName, XplotAxesPropVal);
  set(gca, 'XLim', [xaxis_xmin xaxis_xmax]);
  set(gca, 'YLim', [Xmin Xmax]);
  
  xscale = (xaxis_xmax - xaxis_xmin) / masterPlotFrame.width;
  ylabel_xpos = xaxis_xmax + (xscale * ylabel_xoffset);
  
  if ( min(X) < 0 && max(X) > 0)
    ylabel_ypos = 0;
  else
    ylabel_ypos = Xmin + (Xmax - Xmin) / 2;
  end
  
  text(ylabel_xpos, ylabel_ypos, '\bfX', ...
       'HorizontalAlignment', 'Left', ...
       'VerticalAlignment', 'Middle', ...
       'Tag', 'X');

  if (exist('xlabel_str', 'var') && ~isempty(xlabel_str))
    xlabel(xlabel_str)
  end

  WplotFrame.bottom = masterPlotFrame.bottom + XplotFrame.height + masterPlotFrame.subplot_yspacing;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Create Wplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WplotPosition = [WplotFrame.left, ...
                 WplotFrame.bottom ...
                 WplotFrame.width, ...
                 WplotFrame.height];

hWplotAxes = axes('Tag', 'Wplot',  ...
                  'Position', WplotPosition);


% Plot the MODWT coefficients

WplotAxesProp.XLim = [xaxis_xmin xaxis_xmax];
hWplotAxes = multi_yoffset_plot(xaxis, W, Wlabels, WplotAxesProp, scale_str);
% hWplotAxes = multi_yoffset_plot(xaxis, W, Wlabels, WplotAxesProp);

% Turn off tick mark labeling for Wplot.
set(hWplotAxes, 'YTickLabel', {});
set(hWplotAxes, 'XTickLabel', {});

if (~plot_X)
  % If no Xplot ...
  %   - add xaxis label if string value provided
  if (exist('xlabel_str', 'var') && ~isempty(xlabel_str))
    xlabel(xlabel_str)
  end
  %  - turn on tickmark lablels if overrided.
  if (isfield(WplotAxesProp, 'XTickLabel'))
    set(hWplotAxes, 'XTickLabel', WplotAxesProp.XTickLabel);
  end
  if (isfield(WplotAxesProp, 'YTickLabel'))
    set(hWplotAxes, 'YTickLabel', WplotAxesProp.YTickLabel);
  end
end


if (exist('title_str', 'var') && ~isempty(title_str))
  suptitle(title_str)
end


% TODO:  For now, don't plot circular shift boundaries if xaxis_range specified
%        Add at later date
if (plot_modwt_boundary && isempty(xaxis_range))
  overplot_modwt_cir_shift_coef_bdry(hWplotAxes, WJt, VJ0t, w_att, ...
                                     xaxis, J0, level_range);
end

return

