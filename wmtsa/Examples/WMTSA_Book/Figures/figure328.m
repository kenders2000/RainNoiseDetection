% figure328 - Display selected portion of vertical shear measurements and
% associated backward differences.
% 
% Usage:
%   figure328
%

% $Id: figure328.m 569 2005-09-12 19:37:21Z ccornish $

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


% Plot extracted time series
haxes1 = subplot(2, 1, 1);

plot(depth, X);

XLim = [450 900];
YLim1 = [-6, 6];
set(haxes1, 'XLim', XLim);
set(haxes1, 'YLim', YLim1);

title('X_t');


% Calculate and plot backward differences

backward_diff = diff(X);

haxes2 = subplot(2, 1, 2);

plot(depth(2:end), backward_diff);

YLim2 = [-0.25, .25];
YTickInc2 = [.25];
set(haxes2, 'XLim', XLim);
set(haxes2, 'YLim', YLim2);
set(haxes2, 'YTick', [YLim2(1):YTickInc2:YLim2(2)]);
set(haxes2, 'YTickLabel', [YLim2(1):YTickInc2:YLim2(2)]);

title('X_t^{(1)}');

title_str = ...
    {['Figure 328.'], ...
     ['Selected portion of vertical shear measurements (top)'], ...
     ['and associated backward differencies (bottom']};



suptitle(title_str);

figure_datestamp(mfilename, gcf);

