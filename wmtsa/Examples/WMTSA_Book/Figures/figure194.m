% figure194 - Calculate and plot MODWT MRA of ocean shear to replicate Figure 194 of WMTSA.
% 
% Usage:
%   figure194
%

% $Id: figure194.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('msp');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 7;
boundary = 'reflection';

[WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);

% Compute inverse MODWT MRA reconstruction.
[DJt, SJt, mra_att] = imodwt_mra(WJt, VJt, w_att);


% Setup time axis
delta_z = 0.1;        % vertical sampling in meters
depth_offset = 350.0; % uppermost depth of profile
xaxis = (1:length(X)) * delta_z + depth_offset;
xlabel_str = 'depth (meters)';

% Setup plotting parameters
title_str = {};
title_str(1) = {['\bfFigure 194.\rm MODWT multiresolution analysis of vertical ' ...
                 'shear measurements']};
title_str(2) = {['(in inverse seconds) versus depth (in meters).']};
title_str(3) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ',  Boundary: ' ...
                 boundary]};

clear XplotAxesProp;

XplotAxesProp.XLim      = [300 1050];
XplotAxesProp.XTick     = [300:50:1050];

MRAplotAxesProp.XLim       = XplotAxesProp.XLim;
MRAplotAxesProp.XTick      = XplotAxesProp.XTick;
% MRAplotAxesProp.XTickLabel = XplotAxesProp.XTickLabel;


XplotAxesProp.YLim       = [-6.4 6.4];
XplotAxesProp.YTick      = [-6.4 0 6.4];
XplotAxesProp.YTickLabel = [-6.4 0 6.4];

% Plot MRA coefficients

[hMRAplotAxes, hXplotAxes] = plot_imodwt_mra(DJt, SJt, X, mra_att, ...
              title_str, xaxis, xlabel_str, ...
              MRAplotAxesProp, XplotAxesProp);

% Plot overlay of lines marking depths at 489.5 and 899.0 meters

x_489 = 489.5;
x_899 = 899.0;

lineProp.Color = 'green';
lineProp.LineWidth = .35;

% Plot overlay on MRA plot.
ylim = get(hMRAplotAxes, 'YLim');
y1 = ylim(1);
y2 = ylim(2);
set(get(hMRAplotAxes, 'Parent'), 'CurrentAxes', hMRAplotAxes);

linesegment_plot(x_489, y1, x_489, y2, lineProp);
linesegment_plot(x_899, y1, x_899, y2, lineProp);

% Plot overlay on X plot.
ylim = get(hXplotAxes, 'YLim');
y1 = ylim(1);
y2 = ylim(2);
set(get(hXplotAxes, 'Parent'), 'CurrentAxes', hXplotAxes);

linesegment_plot(x_489, y1, x_489, y2, lineProp);
linesegment_plot(x_899, y1, x_899, y2, lineProp);

figure_datestamp(mfilename, gcf);
