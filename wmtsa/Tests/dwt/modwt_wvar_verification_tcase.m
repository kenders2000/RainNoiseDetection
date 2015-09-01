function tc = modwt_wvar_verification_tcase
% modwt_wvar_verification_tcase -- munit test case to test modwt_wvar.
%
%****f*  Test:WVAR:MODWT/modwt_wvar_verification_tcase
%
% NAME
%   modwt_wvar_verification_tcase -- munit test case to test modwt_wvar.
%
% USAGE
%   run_tcase('modwt_wvar_verification_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_wvar_verification testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_wvar
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-06-24
%
% COPYRIGHT
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: modwt_wvar_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ocean_la8);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ocean_haar);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ocean_d4);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ocean_d6);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_nile_haar);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_16pt_haar_lv1);

return

function test_verify_modwt_wvar_ocean_la8(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.
  X = wmtsa_load_sample_time_series('msp-4096');
  N = length(X);
  wavelet = 'la8';
  J0 = 9;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt, ci_method, estimator, wavelet);

  
  EXP_WVAR = load('TestData/WVAR/WV-LA8-ocean-shear.dat');
  exp_wvar = EXP_WVAR(:,2);
  
  fuzzy_tolerance = 1E-11;
%  fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal');
  
return

function test_verify_modwt_wvar_ocean_haar(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.
  X = wmtsa_load_sample_time_series('msp-4096');
  N = length(X);
  wavelet = 'haar';
  J0 = 12;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt, ci_method, estimator, wavelet);

  
  EXP_WVAR = load('TestData/WVAR/WV-Haar-ocean-shear.dat');
  exp_wvar = EXP_WVAR(:,2);
  
  fuzzy_tolerance = 1E-14;
%  fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal');
  
return

function test_verify_modwt_wvar_ocean_d4(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.
  X = wmtsa_load_sample_time_series('msp-4096');
  N = length(X);
  wavelet = 'd4';
  J0 = 10;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt, ci_method, estimator, wavelet);

  EXP_WVAR = load('TestData/WVAR/WV-D4-ocean-shear.dat');
  exp_wvar = EXP_WVAR(:,2);
  
  fuzzy_tolerance = 1E-14;
%  fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal');
  
return


function test_verify_modwt_wvar_ocean_d6(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.
  X = wmtsa_load_sample_time_series('msp-4096');
  N = length(X);
  wavelet = 'd6';
  J0 = 9;
  boundary = 'reflection';

  opts.TruncateCoefs = 0;
  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary, opts);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt(1:N,:), ci_method, estimator, wavelet);

  
  EXP_WVAR = load('TestData/WVAR/WV-D6-ocean-shear.dat');
  exp_wvar = EXP_WVAR(:,2);
  
  fuzzy_tolerance = 1E-15;
%  fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal');
  
return

function test_verify_modwt_wvar_nile_haar(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.
  X = wmtsa_load_sample_time_series('nile');
  X_622_715 = X(1:94);
  X_716_1284 = X(95:end);
  
  wavelet = 'haar';
  J0 = 4;
  boundary = 'periodic';

  [WJt_622_715, VJ0t_622_715, att] = modwt(X_622_715, wavelet, J0, boundary);
  [WJt_716_1284, VJ0t_716_1284, att] = modwt(X_716_1284, wavelet, J0, boundary);
    
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar_622_715, CI_wvar_622_715, edof_622_715, MJ_622_715] = ...
      modwt_wvar(WJt_622_715, ci_method, estimator, wavelet);
  [wvar_716_1284, CI_wvar_716_1284, edof_716_1284, MJ_716_1284] = ...
      modwt_wvar(WJt_716_1284, ci_method, estimator, wavelet);
    
  EXP_WVAR_622_715 = load('TestData/WVAR/WV-Nile-622-715.dat');
  EXP_WVAR_716_1284 = load('TestData/WVAR/WV-Nile-716-1284.dat');

  exp_wvar_622_715 = EXP_WVAR_622_715(:,3);
  exp_CI_wvar_622_715 = EXP_WVAR_622_715(:,4:5);
  exp_wvar_716_1284 = EXP_WVAR_716_1284(:,3);
  exp_CI_wvar_716_1284 = EXP_WVAR_716_1284(:,4:5);
  
  fuzzy_tolerance = 1E-15;
  fuzzy_diff(exp_wvar_622_715, wvar_622_715, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar_622_715, wvar_622_715, fuzzy_tolerance, ...
                       'wvars are not equal');
  MU_assert_fuzzy_diff(exp_wvar_716_1284, wvar_716_1284, fuzzy_tolerance, ...
                       'wvars are not equal');
%   MU_assert_fuzzy_diff(exp_CI_wvar_622_715, CI_wvar_622_715, fuzzy_tolerance, ...
%                        'CI_wvars are not equal');
%   MU_assert_fuzzy_diff(exp_CI_wvar_716_1284, CI_wvar_716_1284, fuzzy_tolerance, ...
%                        'CI_wvars are not equal');
  
return


function test_verify_modwt_wvar_16pt_haar_lv1(mode)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
    
  X = wmtsa_load_sample_time_series('16pt');

  wavelet = 'd4';
  J0 = 3;
  boundary = 'periodic';
  
  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);

  % Expect results from WMTSA are to 6 decimal place accuracy.
  fuzzy_tolerance = 1E-6;

  [act_wvar] = modwt_wvar(WJt, '', 'unbiased', 'd4');
  
  exp_wvar = 0.041930;

  MU_assert_fuzzy_diff(exp_wvar, act_wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);
  
return
  
