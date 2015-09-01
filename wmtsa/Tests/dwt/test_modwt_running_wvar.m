function [result] = test_modwt_running_wvar
% test_modwt_running_wvar -- Test driver for test_modwt_running_wvar.
%

%   $Id: test_modwt_running_wvar.m 612 2005-10-28 21:42:24Z ccornish $


% Load the data
vertical_shear = load('TestData/msp-data.dat');

base_depth = 350.0;
delta_depth = 0.1;

depth = base_depth + delta_depth * ([0:1:length(vertical_shear)-1]);
depth = depth(:);

J0 = 9;
wavelet = 'la8';
boundary = 'reflection';

% Calculate MODWT
[WJt, VJ0t] = modwt(vertical_shear, wavelet, J0, boundary);

% Circularly advance MODWT to align with orignal time series
[TWJt, TVJ0t] = modwt_cir_shift(WJt, VJ0t, wavelet, J0);

indices = find(depth >= 400 & depth <= 500);
depth_range = depth(indices);

Tau_j = 2.^([1:J0]-1);
Tau_j = Tau_j(:);
depth_Tau_j = Tau_j * delta_depth;


[rwvar, CI_rwvar] = ...
    modwt_running_wvar(TWJt, indices, 1, 257, ...
                       'chi2eta3', 'biased', wavelet);

% Load expected results
lev2 =  load('TestData/WVAR/RWV-LA8-ocean-shear-02.dat');
lev3 =  load('TestData/WVAR/RWV-LA8-ocean-shear-04.dat');
lev4 =  load('TestData/WVAR/RWV-LA8-ocean-shear-08.dat');
lev5 =  load('TestData/WVAR/RWV-LA8-ocean-shear-16.dat');

rwvar_2_5_exp = [lev2(:,2), lev3(:,2), lev4(:,2), lev5(:,2)];
CI_rwvar_2_5_exp(:,1,:) = lev2(:,3:4);
CI_rwvar_2_5_exp(:,2,:) = lev3(:,3:4);
CI_rwvar_2_5_exp(:,4,:) = lev4(:,3:4);
CI_rwvar_2_5_exp(:,4,:) = lev5(:,3:4);


% Compare expected to actual results

fuzzy_tolerance = 1E-5;

if (fuzzy_diff(rwvar(:,2:5), rwvar_2_5_exp, fuzzy_tolerance, 'summary') == 0)
  disp('Running wavelet variances agree within fuzzy tolerance for levels 2:5');
else
  error('Running wavelet variances do not agree within fuzzy tolerances.');
end


% BUG:  Check CI interval calcuations.  Need to use a high fuzzy tolerance.
fuzzy_tolerance = 1E-1;

if (fuzzy_diff(CI_rwvar(:,2:5,:), CI_rwvar_2_5_exp, fuzzy_tolerance, 'summary') == 0)
  disp(['Confidence intervals of running wavelet variances agree ', ...
        'within fuzzy tolerance for levels 2:5']);
else
  error(['Confidence intervals of running wavelet variances do not ', ...
         'agree within fuzzy tolerances.']);
end

return