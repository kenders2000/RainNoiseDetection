% figure184 - Calculate and plot MODWT MRA of ECG time series to replicate Figure 184 of WMTSA.
% 
% Usage:
%   figure184
%

% $Id: figure184.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('ecg');

% Compute MODWT coefficients
wtfname = 'la8';
J0 = 6;
boundary = 'reflection';
[WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

% Compute inverse MODWT MRA reconstruction.
[DJt, SJt] = imodwt_mra(WJt, VJt, att);

% Setup x-axis for plotting.
delta_t = 1 / 180;   % sampling interval in seconds
time_offset = 0.31;  % seconds
xaxis = (1:length(X)) * delta_t + time_offset;
xlabel_str = 't (sec)';

% Setup plotting parameters
title_str = {};
title_str(1) = {'\bfFigure 184.\rm MODWT multiresolution analysis of ECG time series'};
title_str(2) = {['Wavelet: ' wtfname ',  NLevels: ', int2str(J0), ...
                 ',  Boundary: ', boundary]};

XplotAxesProp.XLim       = [0 12];
XplotAxesProp.XTick      = [0:1:12];
% XplotAxesProp.XTickLabel = [0:2:12];
% XplotAxesProp.XMinorTick = 'off';

XplotAxesProp.YLim       = [-1.5 1.5];
XplotAxesProp.YTick      = [-1.5 -.5 .5 1.5];
XplotAxesProp.YTickLabel = [-1.5 -.5 .5 1.5];

% Plot MRA coefficients

[hMRAplotAxes, hXplotAxes] = plot_imodwt_mra(DJt, SJt, X, att, ...
              title_str, xaxis, xlabel_str, ...
              [], XplotAxesProp);

figure_datestamp(mfilename, gcf);




