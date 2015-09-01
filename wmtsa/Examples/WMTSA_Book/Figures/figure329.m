% figure329 - Calculate and plot wavelet variances for vertical shear series
% using unbiased MODWT estimator for various wavelet filters.
% 
% Usage:
%   run figure329
%

% $Id: figure329.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('msp');

base_depth = 350.0;
delta_depth = 0.1;

depth = base_depth + delta_depth * ([0:1:length(X)-1]);
depth = depth(:);

% Extract meausurments between depths of 489.5 to 899.0 meters
indices = find(depth >= 489.5 & depth <= 899.0);
X = X(indices);
depth = depth(indices);


J0_haar = 12;
J0_d4 = 10;
J0_d6 = 9;
J0_la8 = 9;

Tau_j = 2.^([1:12]-1);
Tau_j = Tau_j(:);
depth_Tau_j = Tau_j * delta_depth;

boundary = 'periodic';

% Calculate MODWT using different filters
[WJt_haar, VJt_haar, w_att_haar] = modwt(X, 'haar', 12, boundary);
[WJt_d4, VJt_d4, w_att_d4] = modwt(X, 'd4', 10, boundary);
[WJt_d6, VJ0t_d6, w_att_d6] = modwt(X, 'd6', 9, boundary);
[WJt_la8, VJt_la8, w_att_la8] = modwt(X, 'la8', 9, boundary);

% Calculate wavelet variances
[wvar_haar, CI_wvar_haar] = modwt_wvar(WJt_haar, '', 'unbiased', 'haar');
[wvar_d4, CI_wvar_d4] = modwt_wvar(WJt_d4, '', 'unbiased', 'd4');
[wvar_d6, CI_wvar_d6] = modwt_wvar(WJt_d6, '', 'unbiased', 'd6');
[wvar_la8, CI_wvar_la8] = modwt_wvar(WJt_la8, '', 'unbiased', 'la8');


% Left hand plot
haxes1 = subplot(1, 2, 1);

loglog(depth_Tau_j(1:J0_haar), wvar_haar(1:J0_haar), 'rx');
hold on;
loglog(depth_Tau_j(1:J0_d6), wvar_d6(1:J0_d6), 'b+');


% Fit lines to two segments of Haar variances
seg1 = depth_Tau_j(1:7);
log_seg1 = log(seg1);
haar_seg1 = wvar_haar(1:7);
log_haar_seg1 = log(haar_seg1);
p = polyfit(log_seg1, log_haar_seg1, 1);
log_seg1_fit = polyval(p, log_seg1)';
seg1_fit = exp(log_seg1_fit);
loglog(seg1, seg1_fit, 'k-');
hold on;

seg2 = depth_Tau_j(8:12);
log_seg2 = log(seg2);
haar_seg2 = wvar_haar(8:12);
log_haar_seg2 = log(haar_seg2);
p = polyfit(log_seg2, log_haar_seg2, 1);
log_seg2_fit = polyval(p, log_seg2)';
seg2_fit = exp(log_seg2_fit);
loglog(seg2, seg2_fit, 'k-');

legend(haxes1, {'Haar', 'D6', 'Linear fit to Haar'}, 4);

XLim = [10^-2, 10^3];
YLim = [10^-5, 10^1];
set(haxes1, 'XLim', XLim);
set(haxes1, 'YLim', YLim);

% Right hand plot
haxes2 = subplot(1, 2, 2);

loglog(depth_Tau_j(1:J0_d4), wvar_d4(1:J0_d4), 'mo');
hold on;

loglog(depth_Tau_j(1:J0_d6), wvar_d6(1:J0_d6), 'b+');

loglog(depth_Tau_j(1:J0_la8), wvar_la8(1:J0_la8), 'gs');


set(haxes2, 'XLim', XLim);
set(haxes2, 'YLim', YLim);


% Add title and footer to figure
title_str = ...
    {['Figure 329.'], ...
     ['Wavelet variances estimated for vetical shear series'], ...
     ['using the unbiased MODWT estimator']};

suptitle(title_str);

figure_datestamp(mfilename, gcf);

legend(haxes2, {'D4', 'D6', 'LA8'}, 4);
