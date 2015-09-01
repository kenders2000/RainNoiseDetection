function tc = imodwt_tcase
% imodwt_tcase -- munit test case to test imodwt function.
%
%****f* wmtsa.Tests.dwt/imodwt_tcase.m
%
% NAME
%   imodwt_tcase -- munit test case to test imodwt function.
%
% USAGE
%   run_tcase('imodwt_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for imodwt testcase.
%
% DESCRIPTION
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-Apr-25
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

%   $Id: imodwt_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_normal_wavelet);
tc = MU_tcase_add_test(tc, @test_invalid_wavelet);
tc = MU_tcase_add_test(tc, @test_verify_imodwt_ecg_la8_periodic_bc);
tc = MU_tcase_add_test(tc, @test_verify_imodwt_ecg_la8_reflection_bc_nontrunc);



return

function test_normal_default(varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, w_att] = modwt(X, 'la8', 6, 'periodic');
  Xinv = imodwt(WJt, VJt, w_att);
return

function test_insufficient_num_arguments(mode, varargin)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, w_att] = modwt(X);
  
  % No arguments
  try
    Xinv = imodwt;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
  
  % One argument
  try
    Xinv = imodwt(WJt);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end

  % Two arguments
  try
    Xinv = imodwt(WJt, VJt);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end

return

function test_normal_wavelet(varargin)
% test_normal_wavelet --  Normal execution, specify wavelet
  [X, x_att] = wmtsa_data('ecg');

  [WJt, VJt, w_att] = modwt(X, 'haar', 6, 'periodic');
  Xinv = imodwt(WJt, VJt, w_att);

  [WJt, VJt, w_att] = modwt(X, 'la8', 6, 'periodic');
  Xinv = imodwt(WJt, VJt, w_att);
return

function test_invalid_wavelet(mode, varargin)
% test_invalid_wavelet --  Expected error:  Invalid wavelet
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, w_att] = modwt(X, 'haar', 6, 'periodic');

  att.WTF = 'not_a_wavelet';
  try
    Xinv  = imodwt(WJt, VJt, w_att);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id, '', mode);
  end
return


function test_verify_imodwt_ecg_la8_periodic_bc(varargin)
% test_verify_imodwt_ecg_la8_periodic_bc -- Verify calculated modwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  J0 = 6;
  boundary = 'periodic';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
  Xinv = imodwt(WJt, VJt, w_att);
  
  fuzzy_tolerance = 1E-11;

  MU_assert_fuzzy_diff(X, Xinv, fuzzy_tolerance, ...
                       'Xs are not equal');
  
return

function test_verify_imodwt_ecg_la8_reflection_bc_nontrunc(varargin)
% test_verify_imodwt_ecg_la8_reflection_bc_nontrunc -- Verify calculated modwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  N = length(X);
  J0 = 6;
  boundary = 'reflection';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
  Xinv = imodwt(WJt, VJt, w_att);

  fuzzy_tolerance = 1E-11;

  MU_assert_fuzzy_diff(X, Xinv, fuzzy_tolerance, ...
                       'Xs are not equal');
  
return


