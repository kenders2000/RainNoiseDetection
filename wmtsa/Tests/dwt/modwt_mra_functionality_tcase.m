function tc = modwt_mra_functionality_tcase
% modwt_mra_functionality_tcase -- munit test case to test modwt_mra functionality.
%
%****f* wmtsa.Tests.dwt/modwt_mra_functionality_tcase
%
% NAME
%   modwt_mra_functionality_tcase -- munit test case to test modwt_mra functionality.
%
% USAGE
%   run_tcase('modwt_mra_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_mra testcase.
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

%   $Id: modwt_mra_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_normal_wavelet);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_J0);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_conservative);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_maximum);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_supermax);
tc = MU_tcase_add_test(tc, @test_normal_reflection);
tc = MU_tcase_add_test(tc, @test_normal_periodic);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_negative_J0);

tc = MU_tcase_add_test(tc, @test_invalid_wavelet);
tc = MU_tcase_add_test(tc, @test_invalid_nlevels);
tc = MU_tcase_add_test(tc, @test_invalid_boundary);


return

function test_normal_default(mode, varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJt, att] = modwt_mra(X, 'la8');
return
  
function test_normal_wavelet(mode, varargin)
% test_normal_wavelet --  Normal execution, specify wavelet
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJt, att] = modwt_mra(X, 'la8');
return

function test_normal_nlevels_J0(mode, varargin)
% test_normal_nlevels_J0 -- Normal execution, specify nlevels = J0 = 10.
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'la8', 10);
return

function test_normal_nlevels_conservative(mode, varargin)
% test_normal_nlevels_conservative --  Normal execution, specify nlevels = 'conservative'
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'la8', 'conservative');
return

function test_normal_nlevels_maximum(mode, varargin)
% test_normal_nlevels_maximum Normal execution, specify nlevels = 'maximum'
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'la8', 'maximum');
return

function test_normal_nlevels_supermax(mode, varargin)
% test_normal_nlevels_supermax  -- Normal execution, specify nlevels = 'supermax'
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'la8', 'supermax');
return

function test_normal_reflection(mode, varargin)
% test_normal_reflection --  Normal execution, specify boundary = 'reflection'
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'la8', '', 'reflection');
return

function test_normal_periodic(mode, varargin)
% test_normal_periodic -- Normal execution, specify boundary = 'periodic'
  [X, x_att] = wmtsa_data('ecg');
  [DJt, SJ0t, att] = modwt_mra(X, 'haar', '', 'periodic');
return

function test_insufficient_num_arguments(mode, varargin)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJ0t] = modwt;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_negative_J0(mode, varargin)
% test_negative_J0 -- Expected error:  J0 < 0
  [X, x_att] = wmtsa_data('ecg');
  try
    [DJt, SJ0t, att] = modwt_mra(X, 'la8', -1);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:negativeJ0', msg_id, '', mode);
  end
return

function test_invalid_wavelet(mode, varargin)
% test_invalid_wavelet --  Expected error:  Invalid wavelet
  [X, x_att] = wmtsa_data('ecg');
  try
    [DJt, SJ0t, att] = modwt_mra(X, 'not_a_wavelet');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id, '', mode);
  end
return

function test_invalid_nlevels(mode, varargin)
% test_invalid_nlevels -- Invalid nlevels
  [X, x_att] = wmtsa_data('ecg');
  try
    [DJt, SJ0t, att] = modwt_mra(X, 'la8', 'not_a_nlevel_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidNLevelsValue', msg_id, '', mode);
  end
return

function test_invalid_boundary(mode, varargin)
% test_invalid_boundary  -- Invalid boundary
  [X, x_att] = wmtsa_data('ecg');
  try
    [DJt, SJ0t, att] = modwt_mra(X, 'la8', '', 'not_a_boundary');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidBoundary', msg_id, '', mode);
  end
return
