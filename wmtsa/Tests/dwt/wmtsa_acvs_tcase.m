function tc = wmtsa_acvs_tcase
% wmtsa_acvs_tcase -- munit test case to test wmtsa_acvs.
%
%****f* wmtsa.Tests.dwt/wmtsa_acvs_tcase
%
% NAME
%   wmtsa_acvs_tcase -- munit test case to test wmtsa_acvs.
%
% USAGE
%   run_tcase('wmtsa_acvs_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for wmtsa_acvs testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   wmtsa_acvs
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-06-25
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

%   $Id: wmtsa_acvs_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_invalid_estimator);
tc = MU_tcase_add_test(tc, @test_X_is_not_real);
tc = MU_tcase_add_test(tc, @test_X_is_not_matrix);
tc = MU_tcase_add_test(tc, @test_verify_biased_estimator);
tc = MU_tcase_add_test(tc, @test_verify_unbiased_estimator);
tc = MU_tcase_add_test(tc, @test_verify_none_estimator);
tc = MU_tcase_add_test(tc, @test_verify_unbiased_estimator_subtract_mean);
tc = MU_tcase_add_test(tc, @test_verify_acvs_16pt_haar_WJt_lv1);

return

function test_normal_default(mode)
% test_normal_default -- Smoke test:  Normal execution, default parameters
  X = randn(1000, 1);
  ACVS = wmtsa_acvs(X);
return

function test_insufficient_num_arguments(mode)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  try
     ACVS = wmtsa_acvs;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_invalid_estimator(mode)
% test_invalid_estimator -- Expected error:  WMTSA:InvalidEstimator
  X = randn(1000, 1);
  try
      ACVS = wmtsa_acvs(X, 'not_an_estimator');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidArgumentValue', msg_id);
  end
return

function test_X_is_not_real(mode)
% test_X_is_not_real --  Expected error:  WMTSA:ArgumentNotAVector
  X = 1 + i;
  try
    ACVS = wmtsa_acvs(X);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
return

function test_X_is_not_matrix(mode)
% test_X_is_not_matrix -- Expected error:  WMTSA:InvalidArgumentDataType
  X = ones(10, 5, 15);;
  try
    ACVS = wmtsa_acvs(X);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
return

function test_verify_biased_estimator(mode)
% test_verify_biased_estimator -- Verify calculated ACVS
    
  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  N = length(X);
  estimator = 'biased';
  ACVS = wmtsa_acvs(X, estimator);
  XCOV = xcov(X, estimator);

  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(ACVS, XCOV, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');

  % dim = 1
  Y =[X(:), X(:)];
  ACVS_lag = wmtsa_acvs(X, estimator, '', 'lag', 1);
  ACVS_fft = wmtsa_acvs(X, estimator, '', 'fft', 1);
  ACVS_xcov = wmtsa_acvs(X, estimator, '', 'xcov', 1);

  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(ACVS_lag, ACVS_fft, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  MU_assert_fuzzy_diff(ACVS_lag, ACVS_xcov, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  
  % dim = 2
  Y =[X(:)'; X(:)'];
  ACVS_lag = wmtsa_acvs(X, estimator, '', 'lag', 2);
  ACVS_fft = wmtsa_acvs(X, estimator, '', 'fft', 2);
  ACVS_xcov = wmtsa_acvs(X, estimator, '', 'xcov', 2);

  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(ACVS_lag, ACVS_fft, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  MU_assert_fuzzy_diff(ACVS_lag, ACVS_xcov, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
return


function test_verify_unbiased_estimator(mode)
% test_verify_unbiased_estimator -- Verify calculated ACVS

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  N = length(X);
  estimator = 'unbiased';
  ACVS = wmtsa_acvs(X, estimator);
  XCOV = xcov(X, estimator);

  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(ACVS, XCOV, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  % dim = 1
  Y =[X(:), X(:)];
  ACVS_lag = wmtsa_acvs(X, estimator, '', 'lag', 1);
  ACVS_fft = wmtsa_acvs(X, estimator, '', 'fft', 1);
  ACVS_xcov = wmtsa_acvs(X, estimator, '', 'xcov', 1);

%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(ACVS_lag, ACVS_fft, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  MU_assert_fuzzy_diff(ACVS_lag, ACVS_xcov, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  
  % dim = 2
  Y =[X(:)'; X(:)'];
  ACVS_lag = wmtsa_acvs(X, estimator, '', 'lag', 2);
  ACVS_fft = wmtsa_acvs(X, estimator, '', 'fft', 2);
  ACVS_xcov = wmtsa_acvs(X, estimator, '', 'xcov', 2);

%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(ACVS_lag, ACVS_fft, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
  MU_assert_fuzzy_diff(ACVS_lag, ACVS_xcov, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');

return


function test_verify_none_estimator(mode)
% test_verify_none_estimator --  Verify calculated ACVS

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  N = length(X);
  estimator = 'none';
  ACVS = wmtsa_acvs(X, estimator);
  XCOV = xcov(X, estimator);
  

  fuzzy_tolerance = 1E-12;

  MU_assert_fuzzy_diff(ACVS, XCOV, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
return

function test_verify_unbiased_estimator_subtract_mean(mode)
% test_verify_unbiased_estimator_subtract_mean -- Verify calculated ACVS

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  N = length(X);
  estimator = 'unbiased';
  ACVS = wmtsa_acvs(X, estimator, 1);

  % subtract mean
  X = X - mean(X);
  XCOV = xcov(X, estimator);
  
  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(ACVS, XCOV, fuzzy_tolerance, ...
                       'ACVS does not agree with XCOV');
return

function test_verify_acvs_16pt_haar_WJt_lv1(mode)
% test_verify_acvs_16pt_haar_WJt_lv1  - Verify 16pt acvs.
%    Verify calculated acvs of modwt coefficients for level 1
%    to expected values from WMTSA.
    
  exp_acvs = ...
      [ 0.041930, -0.019245, 0.012438, -0.015160,  0.007801,  0.004758, -0.002215, ...
       -0.003311, -0.000568, 0.000812,  0.001544, -0.004341, -0.003355]';

  X = wmtsa_data('16pta');
  N = length(X);
  
  wavelet = 'd4';
  J0 = 3;
  boundary = 'periodic';
  
  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);

  LJ = equivalent_filter_width(4, 1:J0);
  MJ = modwt_num_nonboundary_coef('d4', N, 1:J0);
  NJt = MJ;
  WJt_unbiased_1 = WJt(LJ(1):N,1);
  act_acvs = wmtsa_acvs(WJt_unbiased_1, 'biased', 0);
  % Get the acvs for tau >= 0
  act_acvs = act_acvs(NJt(1):2*NJt(1)-1);
  
  % Expect results from WMTSA are to 6 decimal place accuracy.
  fuzzy_tolerance = 1E-6;

  if (strcmp(mode, 'details'))
    exp_acvs
    act_acvs
  end

  MU_assert_fuzzy_diff(exp_acvs, act_acvs, fuzzy_tolerance, ...
                       'acvs''s are not equal', mode);

  
return
    
