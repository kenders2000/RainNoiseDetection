function tc = modwt_wvar_functionality_tcase
% modwt_wvar_functionality_tcase -- munit test case to test modwt_wvar.
%
%****f*  Test:WVAR:MODWT/modwt_wvar_functionality_tcase
%
% NAME
%   modwt_wvar_functionality_tcase -- munit test case to test modwt_wvar.
%
% USAGE
%   run_tcase('modwt_wvar_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_wvar_functionality testcase.
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

%   $Id: modwt_wvar_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_invalid_ci_method);
tc = MU_tcase_add_test(tc, @test_invalid_estimator);
tc = MU_tcase_add_test(tc, @test_valid_estimator_but_no_required_wavelet);

return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  wavelet = 'la8';
  X = wmtsa_load_sample_time_series('heart');
  [WJt, VJ0t] = modwt(X, wavelet);
  [wvar] = modwt_wvar(WJt);
return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
    [wvar, CI_wvar, edof, NJt, att] = modwt_wvar;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:InvalidNumArguments', msg_id);
  end
return

function test_invalid_ci_method(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WVAR:InvalidCIMethod
  wavelet = 'la8';
  X = load('TestData/heart.dat');
  [WJt, VJ0t] = modwt(X, wavelet);
  try
    [wvar, CI_wvar] = modwt_wvar(WJt, 'not_a_ci_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:WVAR:InvalidCIMethod', msg_id);
  end
return

function test_invalid_estimator(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WVAR:InvalidEstimator
  wavelet = 'la8';
  X = wmtsa_load_sample_time_series('heart');
  [WJt, VJ0t] = modwt(X, wavelet);
  try
    [wvar, CI_wvar] = modwt_wvar(WJt, '', 'not_a_estimator');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:WVAR:InvalidEstimator', msg_id);
  end
return

function test_valid_estimator_but_no_required_wavelet(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WaveletArgumentRequired
  wavelet = 'la8';
  X = wmtsa_load_sample_time_series('heart');
  [WJt, VJ0t] = modwt(X, wavelet);
  try
    [wvar, CI_wvar] = modwt_wvar(WJt, '', 'unbiased');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:MissingRequiredArgument', msg_id);
  end
return

