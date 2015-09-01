% figur334 - Estimated LA(8) wavelet variances for levels j = (2...5)
% 
% Usage:
%   run figure334
%

% $Id: figure334.m 569 2005-09-12 19:37:21Z ccornish $

% Load the data
[X, x_att] = wmtsa_data('msp');

base_depth = 350.0;
delta_depth = 0.1;

depth = base_depth + delta_depth * ([0:1:length(X)-1]);
depth = depth(:);

J0 = 9;
wavelet = 'la8';
boundary = 'reflection';

% Calculate MODWT
[WJt, VJt, w_att] = modwt(X, wavelet, J0, boundary);

% Circularly advance MODWT to align with orignal time series
[TWJt, TVJt] = modwt_cir_shift(WJt, VJt, wtfname, J0);

% Compute wavelet variance over depth range 400 to 500 meters
% using N = 257 samples and stepping each time point
indices = find(depth >= 400 & depth <= 500);
depth_range = depth(indices);

Tau_j = 2.^([1:J0]-1);
Tau_j = Tau_j(:);
depth_Tau_j = Tau_j * delta_depth;

[rwvar, CI_rwvar] = modwt_running_wvar(TWJt, indices, 1, 257, ...
                                           'chi2eta3', 'biased', wtfname);


% Plot wavelet variances for levels j = 2...5.
iplot = 0;
for (j = 5:-1:2)
  iplot = iplot + 1;
  subplot(2, 2, iplot);
  
  semilogy(depth_range, rwvar(:, j), 'b-');
  hold on;
  semilogy(depth_range, CI_rwvar(:, j, 1), 'r--');
  hold on;
  semilogy(depth_range, CI_rwvar(:, j, 2), 'r--');

  XLim = [400, 500];
  YLim = [10^-4, 10^-1];
  set(gca, 'XLim', XLim);
  set(gca, 'YLim', YLim);
  
  XTick = [400, 450, 500];
  XTickLabel = XTick;
  set(gca, 'XTick', XTick);
  set(gca, 'XTickLabel', XTickLabel);

  YTick = [1E10-4, 1E10-3, 1E10-2, 1E10-1];
  YTickLabel = YTick;
  set(gca, 'YTick', YTick);
  set(gca, 'YTickLabel', YTickLabel);

  if (iplot >= 3)
    xlabel('depth (meters)');
  end
  
  title_str = [sprintf('%0.2f', depth_Tau_j(j)), ' m'];
  title(title_str);
  
end

title_str = ...
    {['Figure 334.'], ...
     ['Running wavelet variance with confidence intervals'], ...
     ['for running spans of 257 MODWT coefficients, levels = 2..5']};

suptitle(title_str);

figure_datestamp(mfilename, gcf);

