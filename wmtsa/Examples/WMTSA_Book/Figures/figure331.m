% figure331 - Display leakage of Haar wavelet variance
% compared to other estimators
% 
% Usage:
%   run figure331
%

% $Id: figure331.m 569 2005-09-12 19:37:21Z ccornish $


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

N = 4096;
k = [1:1:2048];
f = k / (N * delta_depth);
f = f(:);
% Normalized frequency
fn = f/(f(end)*2);

SDF_theor = zeros(length(f), 1);

indices = find(f <= 5/128);
SDF_theor(indices) = 32.768;

indices = find(f > 5/128 & f <= 5/8);
SDF_theor(indices) = 32.768 * abs( (128 * f(indices) / 5).^(-3.5));

indices = find(f > 5/8 &  f <= 5);
SDF_theor(indices) = abs( (8 * f(indices) / 5).^(-1.7)) / 500.;

% Subplot 1:  Theoretical SDF and Haar and D6 squared gain functions
haxes1 = subplot(2, 2, 1);

loglog(f, SDF_theor, 'k--');
hold on;

XLim = [10^-3, 10^1];
YLim = [10^-5, 10^3];
set(haxes1, 'XLim', XLim);
set(haxes1, 'YLim', YLim);
xlabel('\itf');

% Calculate squared gain functions for Haar and D6 filters for level 1
[Hst_haar] = modwt_wavelet_sgf(fn, 'haar', 1);
[Hst_d6] = modwt_wavelet_sgf(fn, 'd6', 1);

loglog(f, Hst_haar, 'r-');
loglog(f, Hst_d6, 'b-');

legend(haxes1, {'Theoretical SDF', 'Haar', 'D6'});

% Subplot 2:  1st Pass band of theoretical SDF, 
% and level 1 wavelet squared gain-SDF products for Haar and D6
haxes2 = subplot(2, 2, 2);

% Get pass band for [1/(2^2 * delta_depth), 1/(2 * delta_depth)] = [5/2, 5]
f_lower = 1 / (2^2 * delta_depth);
f_upper = 1 / (2 * delta_depth);
indices = find(f >= f_lower & f <= f_upper);
SDF_theor_pass = SDF_theor(indices);
loglog(f(indices), SDF_theor_pass, 'k--');
hold on;
patch([f(indices(1)) f(indices)' f(indices(end))], ...
      [YLim(1) SDF_theor_pass' YLim(1)], 'y');

XLim = [10^-3, 10^1];
YLim = [10^-5, 10^3];
set(haxes2, 'XLim', XLim);
set(haxes2, 'YLim', YLim);
xlabel('\itf');

% Calculate squared gain functions for Haar and D6 filters for level 1
[Hst_haar] = modwt_wavelet_sgf(fn, 'haar', 1);
[Hst_d6] = modwt_wavelet_sgf(fn, 'd6', 1);

loglog(f, Hst_haar.*SDF_theor, 'r-');
loglog(f, Hst_d6.*SDF_theor, 'b-');

legend(haxes2, {'Pass-band SDF', 'Haar', 'D6'});


% Subplot 3:  2nd Pass band of theoretical SDF, 
% and level 2 wavelet squared gain-SDF products for Haar and D6
haxes3 = subplot(2, 2, 3);

% Get pass band for [1/(2^3 * delta_depth), 1/(2^2 * delta_depth)]
f_lower = 1 / (2^3 * delta_depth);
f_upper = 1 / (2^2 * delta_depth);
indices = find(f >= f_lower & f <= f_upper);
SDF_theor_pass = SDF_theor(indices);
loglog(f(indices), SDF_theor_pass, 'k--');
hold on;
patch([f(indices(1)) f(indices)' f(indices(end))], ...
      [YLim(1) SDF_theor_pass' YLim(1)], 'y');

XLim = [10^-3, 10^1];
YLim = [10^-5, 10^3];
set(haxes3, 'XLim', XLim);
set(haxes3, 'YLim', YLim);
xlabel('\itf');

% Calculate squared gain functions for Haar and D6 filters for level 2
[Hst_haar] = modwt_wavelet_sgf(fn, 'haar', 2);
[Hst_d6] = modwt_wavelet_sgf(fn, 'd6', 2);

loglog(f, Hst_haar.*SDF_theor, 'r-');
loglog(f, Hst_d6.*SDF_theor, 'b-');

legend(haxes3, {'Pass-band SDF', 'Haar', 'D6'});

% Subplot 4:  Theoretical wavelet variances 
% for Haar and D6 filters.
haxes4 = subplot(2, 2, 4);

clear Hst_haar Hst_d6 f_band_avg;

for (j = 1:9)
  % Calculate squared gain functions for Haar and D6 filters for level j
  [Hst_haar] = modwt_wavelet_sgf(fn, 'haar', j);
  [Hst_d6] = modwt_wavelet_sgf(fn, 'd6', j);

  cumtrapz_haar = cumtrapz(f, (Hst_haar .* SDF_theor));
  cumtrapz_d6 = cumtrapz(f, (Hst_d6 .* SDF_theor));
  
  wvar_haar(j, 1)  = cumtrapz_haar(end);
  wvar_d6(j, 1)  = cumtrapz_d6(end);

  % Calculate frequency bands
  f_lower = 1 / (2^(j+1) * delta_depth);
  f_upper = 1 / (2^j * delta_depth);
  indices = find(f >= f_lower & f <= f_upper);
  f_band_avg(j) = mean(f(indices), 1);
end

Tau_j = 2.^([1:9]-1);
Tau_j = Tau_j(:);
depth_Tau_j = Tau_j * delta_depth;

loglog(depth_Tau_j, wvar_haar(1:9), 'rx');
hold on;
loglog(depth_Tau_j, wvar_d6(1:9), 'b+');

XLim = [10^-2, 10^2];
YLim = [10^-5, 10^3];
set(haxes4, 'XLim', XLim);
set(haxes4, 'YLim', YLim);
xlabel('\it{\tau_j}');

legend(haxes4, {'Haar', 'D6'});

% Add title and footer to figure
title_str = ...
    {['Figure 331.'], ...
     ['Leakage of Haar wavelet'], ...
     ['and comparison to theoretical SDF and D6 estimator']};

suptitle(title_str);

figure_datestamp(mfilename, gcf);

legend(haxes4, {'Haar', 'D6'});

