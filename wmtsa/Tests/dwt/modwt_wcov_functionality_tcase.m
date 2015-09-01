function tc = modwt_wcov_functionality_tcase
% modwt_wcov_functionality_tcase -- munit test case to test modwt_wcov.
%
%****f*  wmtsa.Tests.dwt/modwt_wcov_functionality_tcase
%
% NAME
%   modwt_wcov_functionality_tcase -- munit test case to test modwt_wcov.
%
% USAGE
%   run_tcase('modwt_wcov_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_wcov_functionality testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_wcov
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

%   $Id: modwt_wcov_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_invalid_ci_method);
tc = MU_tcase_add_test(tc, @test_invalid_estimator);
tc = MU_tcase_add_test(tc, @test_valid_estimator_but_no_required_wavelet);
tc = MU_tcase_add_test(tc, @test_biased_estimator);
tc = MU_tcase_add_test(tc, @test_unbiased_estimator);
tc = MU_tcase_add_test(tc, @test_weaklybiased_estimator);

return

function test_normal_default(mode, varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJtX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJtY] = modwt(X, wtfname, J0, boundary);
  [wcov] = modwt_wcov(WJtX, WJtY);
return

function test_insufficient_num_arguments(mode, varargin)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);

  try
    [wcov] = modwt_wcov;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end

  try
    [wcov] = modwt_wcov(WJtX);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end

return

function test_invalid_ci_method(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WCOV:InvalidCIMethod
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  try
    [wcov, CI_wcov] = modwt_wcov(WJtX, WJtY, 'not_a_ci_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:WCOV:InvalidCIMethod', msg_id);
  end
return

function test_invalid_estimator(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WCOV:InvalidEstimator
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  try
    [wcov, CI_wcov] = modwt_wcov(WJtX, WJtY, '', 'not_a_estimator');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:WCOV:InvalidEstimator', msg_id);
  end
return

function test_valid_estimator_but_no_required_wavelet(mode)
  % Test Description:  
  %    Expected error:  WMTSA:WaveletArgumentRequired
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  try
    [wcov, CI_wcov] = modwt_wcov(WJtY, WJtY, '', 'unbiased');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:missingRequiredArgument', msg_id);
  end
return

function test_biased_estimator(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  ci_method = 'gaussian';
  estimator = 'biased';
  [wcov, CI_wcov, VARgamma] = modwt_wcov(WJtX, WJtY, ci_method, estimator, wtfname);
return

function test_unbiased_estimator(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  ci_method = 'gaussian';
  estimator = 'unbiased';
  [wcov, CI_wcov, VARgamma] = modwt_wcov(WJtX, WJtY, ci_method, estimator, wtfname);
return

function test_weaklybiased_estimator(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJ0tX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJ0tY] = modwt(X, wtfname, J0, boundary);
  ci_method = 'gaussian';
  estimator = 'weaklybiased';
  [wcov, CI_wcov, VARgamma] = modwt_wcov(WJtX, WJtY, ci_method, estimator, wtfname);
return
