% figure126 - Calculate and plot partial DWT coefficients W of level J0 = 6 for
%             ECG time series using Harr, D(4), C(6) and LA(8) wavelets.
% 
% Usage:
%   figure126
%

% $Id: figure126.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('ecg');

% Calculate DWT coefficient vectors
J0 = 6;
boundary = 'periodic';
opts.RetainVJ = 0;

[WJ_haar, VJ_haar, att_haar, NJ_haar] = dwt(X, 'Haar', J0, 'periodic', opts);
[WJ_d4, VJ_d4, att_d4, NJ_d4] = dwt(X, 'd4', J0, 'periodic', opts);
[WJ_c6, VJ_c6, att_c6, NJ_c6] = dwt(X, 'c6', J0, 'periodic', opts);
[WJ_la8, VJ_la8, att_la8, NJ_la8] = dwt(X, 'la8', J0, 'periodic', opts);

[W_haar] = dwt2vector(WJ_haar, VJ_haar, att_haar);
[W_d4] = dwt2vector(WJ_d4, VJ_d4, att_d4);
[W_c6] = dwt2vector(WJ_c6, VJ_c6, att_c6);
[W_la8] = dwt2vector(WJ_la8, VJ_la8, att_la8);


% Plot the DWT coefficients vectors
nsubplots = 4;

XLim = [0, 2048];
XTick = [0, 512, 1024, 1536, 2048];
XTickLabel = XTick;

YLim = [-4, 4];
YTick = [-4, 0, 4];
YTickLabel = YTick;

axesProp.XLim = XLim;
axesProp.XTick = XTick;
axesProp.XTickLabel = XTickLabel;
axesProp.YLim = YLim;
axesProp.YTick = YTick;
axesProp.YTickLabel = YTickLabel;
axesProp.YMinorTick = 'off';


plotOpts.labelSubvectors = 1;
plotOpts.subvectorLabels = zeros(J0+1, 1);
plotOpts.subvectorLabels(1:4) = [1:4];
plotOpts.subvectorLabels(J0+1) = J0;

subplot(nsubplots, 1, 1);
[haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W_haar, NJ_haar, '', '', axesProp, ...
                                               plotOpts);
htext = ylabel('Haar');
set(htext, 'Rotation', 0, ...
           'HorizontalAlignment', 'right', ...
           'VerticalAlignment', 'middle');
hold on;

plotOpts.labelSubvectors = 0;

subplot(nsubplots, 1, 2);
[haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W_d4, NJ_d4, '', '', axesProp, ...
                                               plotOpts);
htext = ylabel('D(4)');
set(htext, 'Rotation', 0, ...
           'HorizontalAlignment', 'right', ...
           'VerticalAlignment', 'middle');
hold on;

subplot(nsubplots, 1, 3);
[haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W_c6, NJ_c6, '', '', axesProp, ...
                                               plotOpts);
htext = ylabel('C(6)');
set(htext, 'Rotation', 0, ...
           'HorizontalAlignment', 'right', ...
           'VerticalAlignment', 'middle');
hold on;

subplot(nsubplots, 1, 4);
[haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W_la8, NJ_la8, '', '', axesProp, ...
                                               plotOpts);
htext = ylabel('LA(8)');
set(htext, 'Rotation', 0, ...
           'HorizontalAlignment', 'right', ...
           'VerticalAlignment', 'middle');
hold on;

title_str = ...
    {['Figure 126.'], ...
     ['Partial DWT coefficients W for J0 = 6'], ...
     ['for ECG time series'], ...
     ['using Harr, D(4), C(6) and LA(8) wavelets.']};

suptitle(title_str);

figure_datestamp(mfilename, gcf);

