function tc = modwt_verification_tcase
% modwt_verification_tcase -- munit test case to verify results of modwt transform.
%
%****f* wmtsa.Tests.dwt/modwt_verification_tcase
%
% NAME
%   modwt_verification_tcase -- munit test case to verify results of modwt transform.
%
% USAGE
%   run_tcase('modwt_verification_tcase')
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
% SEE ALSO
%   modwt_wvar
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

%   $Id: modwt_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_modwt_ecg_la8);
tc = MU_tcase_add_test(tc, @test_verify_modwt_nile_haar);
tc = MU_tcase_add_test(tc, @test_verify_modwt_16pt_d4);

%%% tc = MU_tcase_add_test(tc, @test_verify_modwt_barrow_haar_cirshifted);

return

function test_verify_modwt_ecg_la8(mode, varargin)
% test_verify_modwt_ecg_la8 --  Verify calculated modwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  J0 = 6;
  boundary = 'periodic';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);

  [WJt_exp, VJt_exp, w_att_exp] = wmtsa_data('ecg_la8_modwt');
  
  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(WJt_exp, WJt, fuzzy_tolerance, ...
                       'WJts are not equal', mode);
  
  MU_assert_fuzzy_diff(VJt_exp, VJt, fuzzy_tolerance, 'VJts are not equal', mode);
  
  tf = compare_struct_fieldnames(w_att, w_att_exp);
  MU_assert_istrue(tf, 'att''s do not have same field names.', mode);
  
  tf = compare_struct_fieldvalues(w_att, w_att_exp);
  MU_assert_istrue(tf, 'att''s do not have same field values.', mode);
  
return
  
   
function test_verify_modwt_nile_haar(mode)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
  [X, x_att] = wmtsa_data('nile');

  wtfname = 'haar';
  J0 = 4;
  boundary = 'periodic';
  
  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);

  [WJt_exp, VJt_exp, w_att_exp] = wmtsa_data('nile_haar_modwt');

  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(WJt_exp, WJt, fuzzy_tolerance, ...
                       'WJts are not equal', mode);
  
  MU_assert_fuzzy_diff(VJt_exp, VJt, fuzzy_tolerance, 'VJts are not equal', mode);

return

function test_verify_modwt_16pt_d4(mode)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
    
  [X, x_att] = wmtsa_data('16pta');

  wtfname = 'd4';
  J0 = 3;
  boundary = 'periodic';
  opts.RetainVJ = 1;
  
  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary, opts);

  [WJt_exp, VJt_exp, w_att_exp] = wmtsa_data('16pt_d4_modwt');

  % Expect results from WMTSA are to 5 decimal place accuracy.
  fuzzy_tolerance = 1E-5;

  MU_assert_fuzzy_diff(WJt_exp, WJt, fuzzy_tolerance, ...
                       'WJts are not equal', mode);
  
  MU_assert_fuzzy_diff(VJt_exp, VJt, fuzzy_tolerance, 'VJts are not equal', mode);

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function test_verify_modwt_barrow_haar_cirshifted(mode, varargin)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
  X = load('TestData/barrow-spring.dat');
  wtfname = 'haar';
  J0 = 4;
  boundary = 'reflection';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
  [TWJt, TVJt] = modwt_cir_shift(WJt, VJt, wtfname, J0);

  TWt_exp = load('TestData/MODWT/barrow-spring-MODWT-haar-cirshifted.dat');
  TWJt_exp = TWt_exp(:,2:J0+1);
  TVJt_exp = TWt_exp(:,J0+2);

  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(TWJt_exp, TWJt, fuzzy_tolerance, ...
                       'WJts are not equal');
  
  MU_assert_fuzzy_diff(TVJt_exp, TVJt, fuzzy_tolerance, 'VJts are not equal');
return
