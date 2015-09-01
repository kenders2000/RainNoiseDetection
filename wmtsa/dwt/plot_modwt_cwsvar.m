function [hCplotAxes] = plot_modwt_cwsvar(cwsvar, title_str, xaxis, xlabel_str, ...
                                            CplotAxesProp, level_range)
% function_name -- Plot the cumulative sample variance of the MODWT wavelet coefficients.
%
% Usage:
%
%
% Inputs:
%   cwsvar       =  NxJ containing cumulative sample variance of
%                     the MODWT wavelet coefficients
%   title_str    =  (optional) character string or cell array of strings containing title of plot.
%   xaxis        =  (optional) vector of values to use for plotting x-axis.
%   xlabel_str   =  (optional) character string or cell array of strings containing label x-axis.
%   CplotAxesProp = (optional) structure containing axes property values to
%                     override for C subplot.
%   level_range  =  (optional) number or range of numbers indicating subset of
%                     levels (j's) to plot.  
%
% Outputs:
%   hCplotAxes   =  (optional) handle to axes for original data series (C) subplot.
%
%
% Outputs:
%
%
% SideEffects:
%
%
% Description:
%
%
% Examples:
%
%
% Notes:
%
%
% Algorithm:
%
%
% See Also:
%
%
% References:
%

% $Id: plot_modwt_cwsvar.m 612 2005-10-28 21:42:24Z ccornish $
%
% Author:
%   Charlie Cornish
%
% Date:
%   2003/05/16
%
% Credits:
%
%

% Initialize constants and other parameters
ylabel_xoffset = .015;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check Input Arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usage_str = ['Usage:  [hCplotAxes] = ', mfilename, ...
             '(cwsvar, [title_str], [xaxis], [xlabel_str] ', ...
             '[CplotAxesProp], [level_range])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [1:6], nargout, [0:1], 1, usage_str, 'struct'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Setup data parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[N, J] = size(cwsvar);

if(~exist('level_range', 'var') || isempty(level_range))
  level_range = 1:J;
end

jj = 0;
legend_str = {};

for (j = level_range)
  jj = jj + 1;

  C(:,jj) = cwsvar(:,j);
  legend_str{jj} = ['C_{', int2str(j), ',t}'];

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Setup up x-axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If xaxis is not specified, use the sample points
if (~exist('xaxis', 'var') || isempty(xaxis))
  xaxis = (1:N);
  xaxis_xmin = 0;
  xaxis_xmax = xaxis(end);
else
  xaxis_xmin = min(xaxis);
  xaxis_xmax = max(xaxis);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Parse the Cplot options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialize default values
Cmin = min(min(cwsvar));
Cmax = max(max(cwsvar));

CplotAxesPropName = {};
CplotAxesPropVal = {};

if (exist('CplotAxesProp', 'var') && ~isempty(CplotAxesProp))

  % Overide default values for Cmin, Cmin (= YLim min and max for Cplot)
  if (isfield(CplotAxesProp, 'YLim'))
    ylim = CplotAxesProp.YLim;
    Cmin = ylim(1);
    Cmax = ylim(2);
  end

  % Populate cell arrays for Xplot axes names and properties
  axes_field_names = fieldnames(CplotAxesProp);
  nfields = length(axes_field_names);
  
  for (i = 1:nfields)
    fname = axes_field_names{i};
    CplotAxesPropName(i) = {fname};
    fval = CplotAxesProp.(fname);
    CplotAxesPropVal(i) = {fval};
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Override x-axis min, max values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (exist('CplotAxesProp', 'var'))
  % Overide default values for xaxis_xmin, xaxis_xmax from XplotAxesProp
  if (isfield(CplotAxesProp, 'XLim'))
    xlim = CplotAxesProp.XLim;
    xaxis_xmin = xlim(1);
    xaxis_xmax = xlim(2);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Plot data and label figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a Cplot axes
hCplotAxes = axes('Tag', 'Cplot',  ...
       CplotAxesPropName, CplotAxesPropVal);

% axis([xaxis_xmin xaxis_xmax Cmin Cmax]);

set(hCplotAxes, 'XLim', [xaxis_xmin xaxis_xmax]);
set(hCplotAxes, 'YLim', [Cmin Cmax]);

% plot(xaxis, cwsvar);
line(xaxis, C);

if (exist('xlabel_str', 'var') && ~isempty(xlabel_str))
  xlabel(xlabel_str)
end;

if (exist('title_str', 'var'))
  if (~isempty(title_str))
  suptitle(title_str)
  end;
else
  suptitle('Cumulative Wavelet Sample Variance');
end

% BUG:  legend does not display, gets overwritten by label lines.

% Add legend
legend(legend_str, 2);



% Label lines

Position = get(hCplotAxes, 'Position');
xaxis_width = Position(3);

xscale = (xaxis_xmax - xaxis_xmin) / xaxis_width;
ylabel_xpos = xaxis_xmax + (xscale * ylabel_xoffset);

[nrow, ncol] = size(C);

for (jj = 1:ncol)

  ylabel_ypos = C(end, jj);
  
  text(ylabel_xpos, ylabel_ypos, legend_str(jj), ...
       'HorizontalAlignment', 'Left', ...
       'VerticalAlignment', 'Middle');
end


return;
