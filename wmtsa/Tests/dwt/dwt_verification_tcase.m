function tc = dwt_verification_tcase
% dwt_verification_tcase -- munit test case to verify results of dwt transform.
%
%****f* wmtsa.Tests.dwt/dwt_verification_tcase
%
% NAME
%   dwt_verification_tcase -- munit test case to verify results of dwt transform.
%
% USAGE
%   run_tcase('dwt_verification_tcase')
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
% SEE ALSO
%   dwt_wvar
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

%   $Id: dwt_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_dwt_ecg_haar);
tc = MU_tcase_add_test(tc, @test_verify_dwt_ecg_c6);
tc = MU_tcase_add_test(tc, @test_verify_dwt_ecg_d4);
tc = MU_tcase_add_test(tc, @test_verify_dwt_ecg_la8);

%%% tc = MU_tcase_add_test(tc, @test_verify_dwt_barrow_haar_cirshifted);

return

function test_verify_dwt_ecg_haar(mode, varargin)
% test_verify_dwt_ecg_haar -- Verify calculated dwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wavelet = 'haar';
  J0 = 6;
  boundary = 'periodic';

  [WJ, VJ, att] = dwt(X, wavelet, J0, boundary);
  W = dwt2vector(WJ, VJ, att);
  W_act = W{1}(:);
  
  
  [W_e, att_exp] = wmtsa_data('ecg_haar_dwt');
  W_exp = W_e{1}(:);
  
%% BUG:  Why is this tolerance so high
%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-6;

  MU_assert_fuzzy_diff(W_exp, W_act, fuzzy_tolerance, ...
                       'Ws are not equal', mode);
  
  tf = compare_struct_fieldnames(att_exp, att);
  MU_assert_istrue(tf, 'att''s do not have same field names.', mode);
  
  
return
  
   
function test_verify_dwt_ecg_c6(mode, varargin)
% test_verify_dwt_ecg_c6 -- Verify calculated dwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wavelet = 'c6';
  J0 = 6;
  boundary = 'periodic';

  [WJ, VJ, att] = dwt(X, wavelet, J0, boundary);
  W = dwt2vector(WJ, VJ, att);
  W_act = W{1}(:);
  
  
  [W_e, att_exp] = wmtsa_data('ecg_c6_dwt');
  W_exp = W_e{1}(:);
 
%% BUG:  Why is this tolerance so high
%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-5;

  MU_assert_fuzzy_diff(W_exp, W_act, fuzzy_tolerance, ...
                       'Ws are not equal', mode);
  
  tf = compare_struct_fieldnames(att_exp, att);
  MU_assert_istrue(tf, 'att''s do not have same field names.', mode);
  
  
return
  
function test_verify_dwt_ecg_d4(mode, varargin)
% test_verify_dwt_ecg_d4 -- Verify calculated dwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wavelet = 'd4';
  J0 = 6;
  boundary = 'periodic';

  [WJ, VJ, att] = dwt(X, wavelet, J0, boundary);
  W = dwt2vector(WJ, VJ, att);
  W_act = W{1}(:);
  
  
  [W_e, att_exp] = wmtsa_data('ecg_d4_dwt');
  W_exp = W_e{1}(:);
  
%% BUG:  Why is this tolerance so high
%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-5;

  MU_assert_fuzzy_diff(W_exp, W_act, fuzzy_tolerance, ...
                       'Ws are not equal', mode);
  
  tf = compare_struct_fieldnames(att_exp, att);
  MU_assert_istrue(tf, 'att''s do not have same field names.', mode);
  
  
return
  
function test_verify_dwt_ecg_la8(mode, varargin)
% test_verify_dwt_ecg_la8 -- Verify calculated dwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wavelet = 'la8';
  J0 = 6;
  boundary = 'periodic';

  [WJ, VJ, att] = dwt(X, wavelet, J0, boundary);
  W = dwt2vector(WJ, VJ, att);
  W_act = W{1}(:);
  
  
  [W_e, att_exp] = wmtsa_data('ecg_la8_dwt');
  W_exp = W_e{1}(:);
  
%% BUG:  Why is this tolerance so high
%  fuzzy_tolerance = 1E-15;
  fuzzy_tolerance = 1E-5;

  MU_assert_fuzzy_diff(W_exp, W_act, fuzzy_tolerance, ...
                       'Ws are not equal', mode);
  
  tf = compare_struct_fieldnames(att_exp, att);
  MU_assert_istrue(tf, 'att''s do not have same field names.', mode);
  
  
return
  
