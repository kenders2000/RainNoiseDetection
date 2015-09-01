function tc = wmtsa_ccvs_tcase
% wmtsa_ccvs_tcase -- munit test case to test wmtsa_ccvs.
%
%****f*  wmtsa.Tests.dwt./wmtsa_ccvs_tcase
%
% NAME
%   wmtsa_ccvs_tcase -- munit test case to test wmtsa_ccvs.
%
% USAGE
%   run_tcase('wmtsa_ccvs_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for wmtsa_ccvs testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   wmtsa_ccvs
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

%   $Id: wmtsa_ccvs_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_invalid_estimator);
tc = MU_tcase_add_test(tc, @test_X_Y_is_not_real);
tc = MU_tcase_add_test(tc, @test_X_Y_is_not_matrix);

tc = MU_tcase_add_test(tc, @test_verify_biased_estimator);
tc = MU_tcase_add_test(tc, @test_verify_unbiased_estimator);
tc = MU_tcase_add_test(tc, @test_verify_none_estimator);
tc = MU_tcase_add_test(tc, @test_verify_unbiased_estimator_subtract_mean);
tc = MU_tcase_add_test(tc, @test_verify_ccvs_16pt_haar_WJt_lv1);

return

function test_normal_default(mode)
% test_normal_default -- Smoke test:  Normal execution, default parameters
  X = randn(1000, 1);
  Y = randn(1000, 1);
  CCVS = wmtsa_ccvs(X, Y);
return

function test_insufficient_num_arguments(mode)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  try
     CCVS = wmtsa_ccvs;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_invalid_estimator(mode)
% test_invalid_estimator -- Expected error:  WMTSA:InvalidEstimator
  X = randn(1000, 1);
  Y = randn(1000, 1);
  try
      CCVS = wmtsa_ccvs(X, Y, 'not_an_estimator');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidArgumentValue', msg_id);
  end
return

function test_X_Y_is_not_real(mode)
% test_X_Y_is_not_real --  Expected error:  WMTSA:ArgumentNotAVector
  X = 1 + i;
  Y = randn(1000, 1);
  try
    CCVS = wmtsa_ccvs(X, Y);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
  X = randn(1000, 1);
  Y = 1 + i;
  try
    CCVS = wmtsa_ccvs(X, Y);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
return

function test_X_Y_is_not_matrix(mode)
% test_X_Y_is_not_matrix -- Expected error:  WMTSA:InvalidArgumentDataType
  X = ones(10, 5, 15);;
  Y = randn(1000, 1);
  try
    CCVS = wmtsa_ccvs(X, Y);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
  X = randn(1000, 1);
  Y = ones(10, 5, 15);;
  try
    CCVS = wmtsa_ccvs(X, Y);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:argterr:invalidArgumentDataType', msg_id);
  end
return

function test_verify_biased_estimator(mode)
%test_verify_biased_estimator(mode) --  Verify calculated CCVS, biaseed estimator
    
  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end

  estimator = 'biased';
  fuzzy_tolerance = 1E-15;
  
  X = rand(1000,1);
  Y = rand(1000,1);
%  X = [1000:-1:1]/1000;  
%  Y = [1000:-1:1]/1000;  
%  X = [10:-1:1]/10;  
%  Y = [10:-1:1]/10;  
  % subtract mean
  X = X - mean(X);
  Y = Y - mean(Y);
  N = length(X);
  CCVS = wmtsa_ccvs(X, Y, estimator);
  XCOV = xcov(X, Y, estimator);


  MU_assert_fuzzy_diff(CCVS, XCOV, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV', mode);

  % dim = 1
  XX =[X(:), X(:)];
  YY =[Y(:), Y(:)];
  CCVS_lag = wmtsa_ccvs(X, Y, estimator, '', 'lag', 1);
  CCVS_fft = wmtsa_ccvs(X, Y, estimator, '', 'fft', 1);
  CCVS_xcov = wmtsa_ccvs(X, Y, estimator, '', 'xcov', 1);


  MU_assert_fuzzy_diff(CCVS_lag, CCVS_fft, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  MU_assert_fuzzy_diff(CCVS_lag, CCVS_xcov, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  
  % dim = 2
  XX =[X(:)'; X(:)'];
  YY =[Y(:)'; Y(:)'];
  CCVS_lag = wmtsa_ccvs(X, Y, estimator, '', 'lag', 2);
  CCVS_fft = wmtsa_ccvs(X, Y, estimator, '', 'fft', 2);
  CCVS_xcov = wmtsa_ccvs(X, Y, estimator, '', 'xcov', 2);


  MU_assert_fuzzy_diff(CCVS_lag, CCVS_fft, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  MU_assert_fuzzy_diff(CCVS_lag, CCVS_xcov, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  
return

function test_verify_unbiased_estimator(mode)
%test_verify_biased_estimator(mode) --  Verify calculated CCVS, uniased estimator

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end

  estimator = 'unbiased';
%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-14;
    
  X = rand(1000,1);
  Y = rand(1000,1);
%  X = [1000:-1:1]/1000;  
%  Y = [1000:-1:1]/1000;  
%  X = [10:-1:1]/10;  
%  Y = [10:-1:1]/10;  
  % subtract mean
  X = X - mean(X);
  Y = Y - mean(Y);
  N = length(X);
  CCVS = wmtsa_ccvs(X, Y, estimator);

  XCOV = xcov(X, Y, estimator);


  MU_assert_fuzzy_diff(CCVS, XCOV, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV', mode);
  

  % dim = 1
  XX =[X(:), X(:)];
  YY =[Y(:), Y(:)];
  CCVS_lag = wmtsa_ccvs(X, Y, estimator, '', 'lag', 1);
  CCVS_fft = wmtsa_ccvs(X, Y, estimator, '', 'fft', 1);
  CCVS_xcov = wmtsa_ccvs(X, Y, estimator, '', 'xcov', 1);


  MU_assert_fuzzy_diff(CCVS_lag, CCVS_fft, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  MU_assert_fuzzy_diff(CCVS_lag, CCVS_xcov, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  
  % dim = 2
  XX =[X(:)'; X(:)'];
  YY =[Y(:)'; Y(:)'];
  CCVS_lag = wmtsa_ccvs(X, Y, estimator, '', 'lag', 2);
  CCVS_fft = wmtsa_ccvs(X, Y, estimator, '', 'fft', 2);
  CCVS_xcov = wmtsa_ccvs(X, Y, estimator, '', 'xcov', 2);


  MU_assert_fuzzy_diff(CCVS_lag, CCVS_fft, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  MU_assert_fuzzy_diff(CCVS_lag, CCVS_xcov, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV');
  
return


function test_verify_none_estimator(mode)
  % Test Description:  
  %    Verify calculated CCVS

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  Y = [1000:-1:1]/1000;  
  % subtract mean
  X = X - mean(X);
  Y = Y - mean(Y);

  N = length(X);
  estimator = 'none';
  CCVS = wmtsa_ccvs(X, Y, estimator);
  XCOV = xcov(X, Y, estimator);

  fuzzy_tolerance = 1E-12;

  MU_assert_fuzzy_diff(CCVS, XCOV, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV', mode);
return

function test_verify_unbiased_estimator_subtract_mean(mode)
  % Test Description:  
  %    Verify calculated CCVS

  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end
    
  X = [1000:-1:1]/1000;  
  Y = [1000:-1:1]/1000;  
  N = length(X);
  estimator = 'unbiased';
  CCVS = wmtsa_ccvs(X, Y, estimator, 1);
  % subtract mean
  X = X - mean(X);
  Y = Y - mean(Y);
  XCOV = xcov(X, Y, estimator);
  
  fuzzy_tolerance = 1E-13;

  MU_assert_fuzzy_diff(CCVS, XCOV, fuzzy_tolerance, ...
                       'CCVS does not agree with XCOV', mode);
return

function test_verify_ccvs_16pt_haar_WJt_lv1(mode)
  % Test Description:  
  %    Verify calculated ccvs of modwt coefficients for level 1
  %    to expected values from WMTSA.
    
  exp_ccvs = ...
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
  act_ccvs = wmtsa_ccvs(WJt_unbiased_1, WJt_unbiased_1, 'biased', 0);
  % Get the acvs for tau >= 0
  act_ccvs = act_ccvs(NJt(1):2*NJt(1)-1);
  
  % Expect results from WMTSA are to 6 decimal place accuracy.
  fuzzy_tolerance = 1E-6;

  if (strcmp(mode, 'details'))
    exp_ccvs
    act_ccvs
  end
  
  % Expect results from WMTSA are to 6 decimal place accuracy.
  fuzzy_tolerance = 1E-6;
  MU_assert_fuzzy_diff(exp_ccvs, act_ccvs, fuzzy_tolerance, ...
                       'ccvs''s are not equal', mode);

  
return
    
