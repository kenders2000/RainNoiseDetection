% figure183 - Calculate and plot MODWT coefficients of ECG time series to replicate Figure 183 of WMTSA.
% 
% Usage:
%   figure183
%

% $Id: figure183.m 599 2005-10-04 22:46:44Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('ecg');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 6;
% boundary = 'reflection';
boundary = 'periodic';

[WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

% Setup time axis
delta_t = 1 / 180;   % sampling interval in seconds
time_offset = 0.31;  % seconds
xaxis = (1:length(X)) * delta_t + time_offset;
xlabel_str = 't (seconds)';

% Setup plotting parameters
title_str = {};
title_str(1) = {'\bfFigure 183.\rm MODWT wavelet analysis of ECG time series'};
title_str(2) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ...
                 ',  Boundary: ', boundary]};

XplotAxesProp.XLim       = [0 12];
XplotAxesProp.XTick      = [0:1:12];
XplotAxesProp.XTickLabel = [0:1:12];

MRAplotAxesProp.XLim       = XplotAxesProp.XLim;
MRAplotAxesProp.XTick      = XplotAxesProp.XTick;
MRAplotAxesProp.XTickLabel = XplotAxesProp.XTickLabel;

XplotAxesProp.YLim       = [-1.5 1.5];
XplotAxesProp.YTick      = [-1.5 -.5 .5 1.5];
XplotAxesProp.YTickLabel = [-1.5 -.5 .5 1.5];

% Plot MODWT coefficients

[hWplotAxes, hXplotAxes] = plot_modwt_coef(WJt, VJt, X, att, ...
             title_str, xaxis, xlabel_str, ...
             MRAplotAxesProp, XplotAxesProp);

figure_datestamp(mfilename, gcf);
