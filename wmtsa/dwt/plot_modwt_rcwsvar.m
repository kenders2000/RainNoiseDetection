function [haxes]  = plot_modwt_rcwsvar(rcwsvar, title_str, xaxis, xlabel_str, ...
                                       axesProp, level_range)
% plot_modwt_rcwsvar -- Plot the rotated cumulative sample variance of the MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/plot_modwt_rcwsvar
%
% NAME
% plot_modwt_rcwsvar -- Plot the rotated cumulative sample variance of the MODWT wavelet coefficients.
%
% USAGE
%   [haxes]  = plot_modwt_rcwsvar(rcwsvar, [title_str], [xaxis], [xlabel_str], ...
%                                 [axesProp], [level_range])
%
% INPUTS
%   rcwsvar      = NxJ containing rotated cumulative sample variance of
%                    the MODWT wavelet coefficients
%   title_str    = (optional) character string or cell array of strings containing title of plot.
%   xaxis        = (optional) vector of values to use for plotting x-axis.
%   xlabel_str   = (optional) character string or cell array of strings containing label x-axis.
%   axesProp     = (optional) structure containing axes property values to
%                     override for C subplot.
%   level_range  = (optional) number or range of numbers indicating subset of
%                    levels (j's) to plot.  
%
% OUTPUTS
%   haxes   =  (optional) handle to axes for original data series (C) subplot.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
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
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/16
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


% $Id: plot_modwt_rcwsvar.m 612 2005-10-28 21:42:24Z ccornish $


% Initialize constants and other parameters
ylabel_xoffset = .015;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check Input Arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usage_str = ['Usage:  [haxes] = ', mfilename, ...
             'rcwsvar, [title_str], [xaxis], [xlabel_str], [axesProp], [level_range])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [1:8], nargout, [0:2], 1, usage_str, 'struct'));

[N, J] = size(rcwsvar);

if(~exist('level_range', 'var') || isempty(level_range))
  level_range = 1:J;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Transform data for plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

jj = 0;

for (j = level_range)
  jj = jj + 1;
  C(:,jj) = rcwsvar(:,j);
  Clabels{jj} = ['\itC''\rm_{', int2str(j), ',t}'];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Setup x-axis and subplot frames
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
%%  Override x-axis min, max values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (exist('axesProp', 'var'))
  % Overide default values for xaxis_xmin, xaxis_xmax from XplotAxesProp
  if (isfield(axesProp, 'XLim'))
    xlim = axesProp.XLim;
    xaxis_xmin = xlim(1);
    xaxis_xmax = xlim(2);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Plot data and label plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axesProp.XLim = [xaxis_xmin xaxis_xmax];

haxes = multi_yoffset_plot(xaxis, C, Clabels, axesProp);

if (exist('xlabel_str', 'var') && ~isempty(xlabel_str))
  xlabel(xlabel_str);
end

if (exist('title_str', 'var') && ~isempty(title_str))
  suptitle(title_str);
end

return
