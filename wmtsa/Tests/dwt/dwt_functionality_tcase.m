function tc = dwt_functionality_tcase
% dwt_functionality_tcase -- munit test case to test dwt functionality.
%
%****f* wmtsa.Tests.dwt/dwt_functionality_tcase
%
% NAME
%   dwt_functionality_tcase -- munit test case to test dwt functionality.
%
% USAGE
%   run_tcase('dwt_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for dwt testcase.
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

%   $Id: dwt_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_normal_wavelet);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_J0);
tc = MU_tcase_add_test(tc, @test_normal_nlevels_conservative);

tc = MU_tcase_add_test(tc, @test_normal_reflection);
tc = MU_tcase_add_test(tc, @test_normal_circular);

tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_negative_J0);
tc = MU_tcase_add_test(tc, @test_invalid_wavelet);
tc = MU_tcase_add_test(tc, @test_invalid_nlevels);
tc = MU_tcase_add_test(tc, @test_invalid_boundary);
tc = MU_tcase_add_test(tc, @test_opt_RetainVJ);
tc = MU_tcase_add_test(tc, @test_multivariate);

return

function test_normal_default(mode, varargin)
% test_normal_default -- Smoke test:  Normal execution, default parameters
  [X, att] = wmtsa_data('ecg');
  [WJ, VJ, w_att] = dwt(X);
return
  
function test_normal_wavelet(mode, varargin)
% test_normal_wavelet -- Normal execution, specify wavelet
  [X, att] = wmtsa_data('ecg');
  [WJ, VJ, w_att, NJ] = dwt(X, 'la8');
return

function test_normal_nlevels_J0(mode, varargin)
% test_normal_nlevels_J0 -- Normal execution, specify nlevels = J0 = 10.
  [X, att] = wmtsa_data('ecg');
  [WJ, VJ, w_att, NJ] = dwt(X, 'la8', 10);
return

function test_normal_nlevels_conservative(mode, varargin)
% test_normal_nlevels_conservative  -- Normal execution, specify nlevels = 'conservative'
  [X, att] = wmtsa_data('ecg');
  [WJ, VJ, w_att, NJ] = dwt(X, 'la8', 'conservative');
return


function test_normal_reflection(mode, varargin)
% test_normal_reflection -- Normal execution, specify boundary = 'reflection'
    
  [X, att] = wmtsa_data('ecg');
  J0 = 6;
  [WJ, VJ, w_att, NJ] = dwt(X, 'la8', J0, 'reflection');

  % Ascertain that NJ =  2*2^j
  N = length(X);
  NX = 2*N;

  MU_assert_isequal(J0, length(WJ), 'Length(WJ) not equal J0.', mode);
  MU_assert_isequal(J0, length(VJ), 'Length(VJ) not equal J0.', mode);

  for (j = 1:J0)
    NWJ = length(WJ{j,1});
    MU_assert_isequal(NWJ, NX/2^j, 'Number of wavelet coefficients not equal NX / 2^j', mode);
    MU_assert_isequal(NJ(j,1), NX/2^j, 'NJ(j,1) not equal NX / 2^j', mode);
    NVJ = length(VJ{j,1});
    if (j == J0)
      nvj = NX / 2^J0;
    else
      MU_assert_isempty(VJ{j,1}, 'VJ is not empty', mode);
      nvj = 0;
    end
    MU_assert_isequal(NJ(j,2), nvj, 'NJ(j,2) not equal nvj', mode);
  end
  
return

function test_normal_circular(mode, varargin)
% test_normal_periodic -- Normal execution, specify boundary = 'circular'
  [X, att] = wmtsa_data('ecg');
  J0 = 6;
  [WJ, VJ, w_att, NJ] = dwt(X, 'la8', J0, 'periodic');

  % Ascertain that NJ =  2*2^j
  N = length(X);

  MU_assert_isequal(J0, length(WJ), 'Length(WJ) not equal J0.', mode);
  MU_assert_isequal(J0, length(VJ), 'Length(VJ) not equal J0.', mode);

  for (j = 1:J0)
    NWJ = length(WJ{j,1});
    MU_assert_isequal(NWJ, N/2^j, 'Number of wavelet coefficients not equal N / 2^j', mode);
    MU_assert_isequal(NJ(j,1), N/2^j, 'NJ(j,1) not equal N / 2^j', mode);
    NVJ = length(VJ{j,1});
    if (j == J0)
      nvj = N / 2^J0;
    else
      MU_assert_isempty(VJ{j,1}, 'VJ is not empty', mode);
      nvj = 0;
    end
    MU_assert_isequal(NJ(j,2), nvj, 'NJ(j,2) not equal nvj', mode);
  end
return

function test_insufficient_num_arguments(mode, varargin)
% otest_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, att] = wmtsa_data('ecg');
  try
    [WJt, VJ0t] = dwt;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_negative_J0(mode, varargin)
% test_negative_J0 --  Expected error:  J0 < 0
  [X, att] = wmtsa_data('ecg');
  try
    [WJ, VJ] = dwt(X, 'la8', -1);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:negativeJ0', msg_id, '', mode);
  end
return

function test_invalid_wavelet(mode, varargin)
% test_invalid_wavelet --  Expected error:  Invalid wavelet
  [X, att] = wmtsa_data('ecg');
  try
    [WJ, VJ] = dwt(X, 'not_a_wavelet');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id, '', mode);
  end
return

function test_invalid_nlevels(mode, varargin)
% test_invalid_nlevels -- Expected error:  Invalid nlevels
  [X, att] = wmtsa_data('ecg');
  try
    [WJ, VJ] = dwt(X, 'la8', 'not_a_nlevel_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidNLevelsValue', msg_id, '', mode);
  end
return

function test_invalid_boundary(mode, varargin)
% test_invalid_boundary -- Expected error:  Invalid boundary
  [X, att] = wmtsa_data('ecg');
  try
    [WJ, VJ] = dwt(X, 'la8', '', 'not_a_boundary');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidBoundary', msg_id, '', mode);
  end
return

function test_opt_RetainVJ(mode, varargin)
% test_opt_RetainVJ  --  Test Retain VJ option
  opts.RetainVJ = 1;
  [X, att] = wmtsa_data('ecg');
  Y = X(1:37);
  J0 = 3;
  [WJ, VJ, att, NJ] = dwt(Y, 'la8', J0, 'circular', opts);
  
  NJ_exp = [18 0; 9 1; 4 4];

  for (j = 1:J0)
    MU_assert_isequal(NJ_exp(j,1), NJ(j,1), 'NJ_exp not NJ', mode);
    MU_assert_isequal(NJ_exp(j,2), NJ(j,2), 'NJ_exp not NJ', mode);
    MU_assert_isequal(NJ_exp(j,1), length(WJ{j}), 'NJ_exp not length(WJ)', mode);
    MU_assert_isequal(NJ_exp(j,2), length(VJ{j}), 'NJ_exp not length(VJ)', mode);
  end
    

return

function test_multivariate(mode, varargin)
% test_multivariate -- Test mulitvariate verions
  opts.RetainVJ = 1;
  [X, att] = wmtsa_data('ecg');
  XX = [X; X(1)];
  Y = repmat(XX, [1 5]);
  J0 = 3;
  [WJ, VJ, att, NJ] = dwt(Y, 'la8', J0, 'circular', opts);
  
  
  [J0_act NChan] = size(WJ);
  
  MU_assert_isequal(J0, att.J0, 'Number of levels not equal to att.J0.', mode);
  MU_assert_isequal(NChan, att.NChan, 'Number of channels not equal to att.NChan.', ...
                    mode);
  
  for (i = 1:NChan)
    for (j = 1:J0)
      MU_assert_isequal(NJ(j,1), length(WJ{j,i}), 'Number of wavelet coefficients not equal to NJ.', mode);
      MU_assert_isequal(NJ(j,2), length(VJ{j,i}), 'Number of scaling coefficients not equal to NJ.', mode);
      MU_assert_fuzzy_diff(WJ{j,i}, WJ{j,1}, 0, ...
                           ['Multi-variate wavelet coefficient channels are not equal']);
      MU_assert_fuzzy_diff(VJ{j,i}, VJ{j,1}, 0, ...
                           ['Multi-variate scaling coefficient channels are not ' ...
                          'equal']);
    end
  end


return
