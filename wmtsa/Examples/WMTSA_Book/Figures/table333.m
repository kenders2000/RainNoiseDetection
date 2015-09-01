% table333 - Compute equivalent degrees of freedom and number of
% non-boundary coefficients for D(6) MODWT wavelet variance estimtates
% for vertical ocean shear measurements
% 
% Usage:
%   run table333
%

% $Id: table333.m 580 2005-09-13 05:50:42Z ccornish $

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

J0_d6 = 9;

% Calculate MODWT using different filters
[WJt_d6, d6_VJt, d6_w_att] = modwt(X, 'd6', 9, 'reflection');

estimator = 'unbiased';

% Calculate wavelet variances using various conficence interval methods
[wvar_gaussian, CI_wvar_gaussian, edof_gaussian, MJ] = modwt_wvar(WJt_d6, 'gaussian', estimator, 'd6');
[wvar_eta1, CI_wvar_eta1, edof_eta1, MJ] = modwt_wvar(WJt_d6, 'chi2eta1', estimator, 'd6');
[wvar_eta3, CI_wvar_eta3, edof_eta3, MJ] = modwt_wvar(WJt_d6, 'chi2eta3', estimator, 'd6');


% Display results

disp('j =');
disp([1:1:J0_d6]);


disp('edof_gaussian =');
disp(round(edof_gaussian)');

disp('edof_eta1 =');
disp(round(edof_eta1)');

disp('edof_eta3 =');
disp(round(edof_eta3)');

disp('Mj =');
disp(MJ');

