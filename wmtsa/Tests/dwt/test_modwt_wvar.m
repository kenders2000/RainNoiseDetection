function [result] = test_modwt_wvar
% test_modwt -- Test driver for imodwt_wvar
%

%   $Id: test_modwt_wvar.m 612 2005-10-28 21:42:24Z ccornish $

X = load('TestData/msp-data-4096.dat');

boundary = 'periodic';

% Calculate MODWT using different filters
[WJt_haar, haar_VJ0t] = ...
    modwt(X, 'haar', 12, boundary);
[WJt_d4, d4_VJ0t] = ...
    modwt(X, 'd4', 10, boundary);
[WJt_d6, d6_VJ0t] = ...
    modwt(X, 'd6', 9, boundary);
[WJt_la8, la8_VJ0t] = ...
    modwt(X, 'la8', 9, boundary);

% Calculate wavelet variances
[wvar_haar, CI_wvar_haar, edof_haar, MJ_haar, att_harr] = ...
    modwt_wvar(WJt_haar, '', 'unbiased', 'haar');
[wvar_d4, CI_wvar_d4, edof_d4, MJ_d4, att_d4] = ...
    modwt_wvar(WJt_d4, '', 'unbiased', 'd4');
[wvar_d6, CI_wvar_d6, edof_d6, MJ_d6, att_d6] = ...
    modwt_wvar(WJt_d6, '', 'unbiased', 'd6');
[wvar_la8, CI_wvar_la8, edof_la8, MJ_la8, att_la8] = ...
    modwt_wvar(WJt_la8, '', 'unbiased', 'la8');

% Load expected wavelet variances
WV_Haar = load('TestData/WVAR/WV-Haar-ocean-shear.dat');
WV_D4 = load('TestData/WVAR/WV-D4-ocean-shear.dat');
WV_D6 = load('TestData/WVAR/WV-D6-ocean-shear.dat');
WV_LA8 = load('TestData/WVAR/WV-LA8-ocean-shear.dat');

wvar_haar_exp = WV_Haar(:,2);
wvar_d4_exp = WV_D4(:,2);
wvar_d6_exp = WV_D6(:,2);
wvar_la8_exp = WV_LA8(:,2);

% Compare expected to actual results

fuzzy_tolerance = 1E-10;
if (fuzzy_diff(wvar_haar, wvar_haar_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variances for Haar filter agree within fuzzy tolerance');
else
  error('Wavelet variances for Haar filter do not agree within fuzzy tolerance');
end

if (fuzzy_diff(wvar_d4, wvar_d4_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variances for D4 filter agree within fuzzy tolerance');
else
  error('Wavelet variances for D4 filter do not agree within fuzzy tolerance');
end

if (fuzzy_diff(wvar_d6, wvar_d6_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variances for D6 filter agree within fuzzy tolerance');
else
  error('Wavelet variances for D6 filter do not agree within fuzzy tolerance');
end

if (fuzzy_diff(wvar_la8, wvar_la8_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variances for LA8 filter agree within fuzzy tolerance');
else
  error('Wavelet variances for LA8 filter do not agree within fuzzy tolerance');
end

return