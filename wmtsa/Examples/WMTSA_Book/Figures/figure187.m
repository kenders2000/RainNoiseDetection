% figure187 - Calculate and plot expanded view of MODWT MRA for Crescent City subtidal variations to replicate Figure 187 of WMTSA.
% 
% Usage:
%   figure187
%

% $Id: figure187.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('subtidal');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 7;
boundary = 'reflection';

[WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

% Compute inverse MODWT MRA reconstruction.
[DJt, SJt] = imodwt_mra(WJt, VJt, att);

% Setup x-axis for plotting
% Sample interval is 1/2 day -- Convert to years
delta_t = .5 / 365;
% Start time is 0800 PST 6 Jan 1980 = 1980 + 6.333333 days
time_offset = 1980 + 6.33333 / 365;
xaxis = (1:length(X)) * delta_t + time_offset;
xlabel_str = 'years';


rec_1985 = (1985 - 1980) * 365 * 2;
rec_1987 = (1987 - 1980) * 365 * 2;


% Setup plotting parameters
title_str = {};
title_str(1) = {['\bfFigure 187.\rm Expanded view of MODWT multiresolution ' ...
                 'analysis for CrescentCity X variations']};
title_str(2) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ...
                 ',  Boundary: ', boundary]};

XplotAxesProp.XLim       = [1985, 1987];
XplotAxesProp.XTick      = [1985:1:1987];
XplotAxesProp.XTickLabel = [1985, 1986, 1987];

XplotAxesProp.YLim       = [-40 60];
XplotAxesProp.YTick      = [-40:20:60];
XplotAxesProp.YTickLabel = [-40:20:60];

MRAplotAxesProp.XLim       = XplotAxesProp.XLim;
MRAplotAxesProp.XTick      = XplotAxesProp.XTick;
MRAplotAxesProp.XTickLabel = XplotAxesProp.XTickLabel;

% Plot MRA coefficients

plot_boundaries = 0;

[hMRAplotAxes, hXplotAxes] = plot_imodwt_mra(DJt(rec_1985:rec_1987,:), ...
              SJt(rec_1985:rec_1987), X(rec_1985:rec_1987), att, ...
              title_str, xaxis(rec_1985:rec_1987), xlabel_str, ...
              MRAplotAxesProp, XplotAxesProp, ...
              [], [], plot_boundaries);


% Plot overlay of lines marking start of years 1981-1991
x1 = 1986;
x2 = 1986;

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



