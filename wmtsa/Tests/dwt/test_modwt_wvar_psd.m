function [result] = test_modwt_wvar_psd
% test_modwt_wvar_psd -- Test driver for modwt_wvar_psd
%

%   $Id: test_modwt_wvar_psd.m 612 2005-10-28 21:42:24Z ccornish $

X = load('TestData/msp-data-4096.dat');

boundary = 'periodic';

% Calculate MODWT using D(6) filter
[WJt_d6, d6_VJ0t] = modwt(X, 'd6', 9, boundary);

% Calculate wavelet variance
[wvar_d6, CI_wvar_d6] = modwt_wvar(WJt_d6, 'chi2eta3', 'unbiased', 'd6');

% Calculate PSD from wavelet variance
delta_t = 0.1;
[PSD_d6, f_d6, CI_PSD_d6, f_band_d6] = modwt_wvar_psd(wvar_d6, delta_t, CI_wvar_d6);

% Load expected results
Y = load('TestData/SDF/SDF-D6-ocean-shear.dat');

% Expected results are in reverse order from psd results
Y = flipud(Y);


PSD_d6_exp = Y(:,1);
f_d6_exp = Y(:,2);
f_band_d6_exp = Y(:,3:4);

fuzzy_tolerance = 1E-10;
if (fuzzy_diff(PSD_d6, PSD_d6_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variance PSD for D6 filter agree within fuzzy tolerance');
else
  PSD_d6
  PSD_d6_exp
  error('Wavelet variance PSD for D6 filter do not agree within fuzzy tolerance');
end


if (fuzzy_diff(f_d6, f_d6_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variance f for D6 filter agree within fuzzy tolerance');
else
  f_d6
  f_d6_exp
  error('Wavelet variance f for D6 filter do not agree within fuzzy tolerance');
end

if (fuzzy_diff(f_band_d6, f_band_d6_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Wavelet variance f_band for D6 filter agree within fuzzy tolerance');
else
  f_band_d6
  f_band_d6_exp
  error('Wavelet variance f_band for D6 filter do not agree within fuzzy tolerance');
end

return




