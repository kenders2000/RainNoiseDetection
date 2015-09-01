% figure190 - Calculate and plot rotated cumulative variance of subtidal sea level variations to replicate Figure 190 of WMTSA.
% 
% Usage:
%   figure190
%

% $Id: figure190.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('subtidal');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 7;
boundary = 'reflection';

[WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

WJt = WJt(1:length(X),:,:);
VJt = VJt(1:length(X),:,:);


% Compute the rotated cumulative wavelet coefficient sample variance
rcwsvar = modwt_rot_cum_wav_svar(WJt, wtfname);

% Setup x-axis for plotting.
delta_t = .5 / 365;  % sampling interval in years
time_offset = 1980;  % data series starts in 1980
xaxis = (1:length(X)) * delta_t + time_offset;
xlabel_str = 'years';

% Setup plotting parameters
title_str = {};
title_str(1) = {['\bfFigure 190.\rm Rotated cumulative variance ', ...
                 'for subtidal sea variations']};
title_str(2) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ...
                 ',  Boundary: ', boundary]};

CplotAxesProp.XLim       = [1980., 1992.];
CplotAxesProp.XTick      = [1980:1:1992];
CplotAxesProp.XTickLabel = [1980:1:1992];

XplotAxesProp.YLim       = [-40 80];
XplotAxesProp.YTick      = [-40:20:80];
XplotAxesProp.YTickLabel = [-40:20:80];

% Plot Rotated cumulative wavelet sample variance

level_range = [2, 7];

[hCplotAxes]  = plot_modwt_rcwsvar(rcwsvar, ...
                                   title_str, xaxis, xlabel_str, ...
                                   CplotAxesProp, level_range);

% Turn off yaxis tick mark labeling for C plot.
set(hCplotAxes, 'YTickLabel', {});


% Plot overlay of lines marking start of years 1981-1991
year_range = [1981:1:1991];
x1 = year_range;
x2 = year_range;

lineProp.Color = 'green';
lineProp.LineWidth = .35;
lineProp.LineStyle = '--';


% Plot overlay on C plot.
ylim = get(hCplotAxes, 'YLim');
y1 = ylim(1) * ones(length(x1),1);
y2 = ylim(2) * ones(length(x1),1);

set(get(hCplotAxes, 'Parent'), 'CurrentAxes', hCplotAxes);

linesegment_plot(x1, y1, x2, y2, lineProp);
linesegment_plot(x1, y1, x2, y2, lineProp);

figure_datestamp(mfilename, gcf);
