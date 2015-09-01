function tc = modwt_functionality_tcase
% modwt_functionality_tcase -- munit test case to test modwt functionality.
%
%****f* wmtsa.Tests.dwt/modwt_functionality_tcase
%
% NAME
%   modwt_functionality_tcase -- munit test case to test modwt functionality.
%
% USAGE
%   run_tcase('modwt_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt testcase.
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
%   (c) 2004, 2005 Charles R. Cornish
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: modwt_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
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
tc = MU_tcase_add_test(tc, @test_opt_RetainVJ);
tc = MU_tcase_add_test(tc, @test_multivariate);

return

function test_normal_default(mode, varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X);
return
  
function test_normal_wavelet(mode, varargin)
% test_normal_wavelet --  Normal execution, specify wavelet
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8');
return

function test_normal_nlevels_J0(mode, varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, specify nlevels = J0 = 10.
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8', 10);
return

function test_normal_nlevels_conservative(mode, varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, specify nlevels = 'conservative'
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8', 'conservative');
return

function test_normal_nlevels_maximum(mode, varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, specify nlevels = 'maximum'
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8', 'maximum');
return

function test_normal_nlevels_supermax(mode, varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, specify nlevels = 'supermax'
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8', 'supermax');
return

function test_normal_reflection(mode, varargin)
% test_normal_reflection --  Normal execution, specify boundary = 'reflection'
    
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'la8', '', 'reflection');

  % Ascertain that NW =  2*N
  N = length(X);
  N2 = 2*N;
  [NW, J] = size(WJt);
  MU_assert_isequal(N2, NW, 'Number of wavelet coefficients not equal 2 * N', mode);
  [NV, JV] = size(WJt);
  MU_assert_isequal(N2, NV, 'Number of wavelet coefficients not equal 2 * N', mode);
return

function test_normal_periodic(mode, varargin)
% test_normal_periodic -- Normal execution, specify boundary = 'periodic'
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, att] = modwt(X, 'haar', '', 'periodic');

  % Ascertain that NW = N
  N = length(X);
  [NW, J] = size(WJt);
  MU_assert_isequal(N, NW, 'Number of wavelet coefficients not equal 2 * N', mode);
  [NV, JV] = size(WJt);
  MU_assert_isequal(N, NV, 'Number of wavelet coefficients not equal 2 * N', mode);
return

function test_insufficient_num_arguments(mode, varargin)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJt, att] = modwt;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_negative_J0(mode, varargin)
% test_negative_J0 -- Expected error:  J0 < 0
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJt, w_att] = modwt(X, 'la8', -1);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:negativeJ0', msg_id, '', mode);
  end
return

function test_invalid_wavelet(mode, varargin)
% test_invalid_wavelet --  Expected error:  Invalid wavelet
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJt, w_att] = modwt(X, 'not_a_wavelet');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id, '', mode);
  end
return

function test_invalid_nlevels(mode, varargin)
  % Test Description:  
  %    Expected error:  Invalid nlevels
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJt, w_att] = modwt(X, 'la8', 'not_a_nlevel_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidNLevelsValue', msg_id, '', mode);
  end
return

function test_invalid_boundary(mode, varargin)
  % Test Description:  
  %    Expected error:  Invalid boundary
  [X, x_att] = wmtsa_data('ecg');
  try
    [WJt, VJt, w_att] = modwt(X, 'la8', '', 'not_a_boundary');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidBoundary', msg_id, '', mode);
  end
return

function test_opt_RetainVJ(mode, varargin)
  % Test Description:  Test Retain VJ option
  opts.RetainVJ = 1;
  [X, x_att] = wmtsa_data('ecg');
  [WJt, VJt, w_att] = modwt(X, 'la8', '', 'reflection', opts);
  
  J0 = w_att.J0;
  
  N = length(X);
  N2 = 2*N;
  [NV, JV] = size(VJt);
  
  MU_assert_isequal(J0, JV, 'Number of levels of scaling coefficients not equal J', mode);

return

function test_multivariate(mode, varargin)
  % Test Description:  Test mulitvariate verions
  opts.RetainVJ = 1;
  [X, x_att] = wmtsa_data('ecg');
  Y = repmat(X, [1 5]);
  [WJt, VJt, w_att] = modwt(Y, 'la8', '', 'reflection');
  
  
  [NW J0 NChan] = size(WJt);
  
  MU_assert_isequal(NW, w_att.NW, 'Number of wavelet coefficients not equal to att.NW.', mode);
  MU_assert_isequal(J0, w_att.J0, 'Number of levels not equal to att.J0.', mode);
  MU_assert_isequal(NChan, w_att.NChan, 'Number of channels not equal to att.NChan.', ...
                    mode);
  
  for (i = 1:NChan)
    MU_assert_fuzzy_diff(WJt(:,:,1), WJt(:,:,i), 0, ...
                         ['Multi-variate wavelet coefficient channels are not equal']);
    MU_assert_fuzzy_diff(VJt(:,:,1), VJt(:,:,i), 0, ...
                         ['Multi-variate scaling coefficient channels are not equal']);
  end
  
    


return
