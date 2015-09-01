% figure186 - Calculate and plot MODWT MRA for Crescent City subtidal variations to replicate Figure 186 of WMTSA.
% 
% Usage:
%   figure186
%

% $Id: figure186.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('subtidal');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 7;
boundary = 'reflection';

[WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

% Compute inverse MODWT MRA reconstruction.
[DJt, SJt] = imodwt_mra(WJt, VJt, att);

% Setup x-axis for plotting.
% Sample interval is 1/2 day -- Convert to years
delta_t = .5 / 365;
% Start time is 0800 PST 6 Jan 1980 = 1980 + 6.333333 days
time_offset = 1980 + 6.33333 / 365;
xaxis = (1:length(X)) * delta_t + time_offset;
xlabel_str = 'years';

% Setup plotting parameters
title_str = {};
title_str(1) = {['\bfFigure 186.\rm MODWT multiresolution analysis ', ...
                 'for CrescentCity subtidal variations']};
title_str(2) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ...
                 ',  Boundary: ', boundary]};

XplotAxesProp.XLim       = [1980, 1992];
XplotAxesProp.XTick      = [1980:1:1992];
XplotAxesProp.XTickLabel = [1980:1:1992];

XplotAxesProp.YLim       = [-40 80];
XplotAxesProp.YTick      = [-40:20:80];
XplotAxesProp.YTickLabel = [-40:20:80];

MRAplotAxesProp.XLim       = XplotAxesProp.XLim;
MRAplotAxesProp.XTick      = XplotAxesProp.XTick;
MRAplotAxesProp.XTickLabel = XplotAxesProp.XTickLabel;

% Plot MRA coefficients

[hMRAplotAxes, hXplotAxes] = plot_imodwt_mra(DJt, SJt, X, att, ...
              title_str, xaxis, xlabel_str, ...
              MRAplotAxesProp, XplotAxesProp);


% Plot overlay of lines marking start of years 1981-1991
year_range = [1981:1:1991];
x1 = year_range;
x2 = year_range;

lineProp.Color = 'green';
lineProp.LineWidth = .35;
lineProp.LineStyle = '--';


% Plot overlay on MRA plot.
ylim = get(hMRAplotAxes, 'YLim');
y1 = ylim(1) * ones(length(x1),1);
y2 = ylim(2) * ones(length(x1),1);

set(get(hMRAplotAxes, 'Parent'), 'CurrentAxes', hMRAplotAxes);

linesegment_plot(x1, y1, x2, y2, lineProp);
linesegment_plot(x1, y1, x2, y2, lineProp);

% Plot overlay on X plot.
ylim = get(hXplotAxes, 'YLim');
y1 = ylim(1) * ones(length(x1),1);
y2 = ylim(2) * ones(length(x1),1);

set(get(hXplotAxes, 'Parent'), 'CurrentAxes', hXplotAxes);

linesegment_plot(x1, y1, x2, y2, lineProp);
linesegment_plot(x1, y1, x2, y2, lineProp);

figure_datestamp(mfilename, gcf);
