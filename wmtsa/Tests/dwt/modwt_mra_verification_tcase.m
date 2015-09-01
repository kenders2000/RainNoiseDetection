function tc = modwt_mra_verification_tcase
% modwt_mra_verification_tcase -- munit test case to verify results of modwt_mra transform.
%
%****f* wmtsa/wmtas/Test/modwt_mra_verification_tcase.m
%
% NAME
%   modwt_mra_verification_tcase -- munit test case to verify results of modwt_mra transform.
%
% USAGE
%   run_tcase('modwt_mra_verification_tcase')
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

%   $Id: modwt_mra_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_modwt_mra_ecg_la8);

return

function test_verify_modwt_mra_ecg_la8(varargin)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
  X = load('TestData/heart.dat');
  wavelet = 'la8';
  J0 = 6;
  boundary = 'periodic';

  [DJt, SJ0t, att] = modwt_mra(X, wavelet, J0, boundary);

  Dt_exp = load('TestData/MODWT/ecg-LA8-MODWT-MRA.dat');
  DJt_exp = Dt_exp(:,1:J0);
  SJ0t_exp = Dt_exp(:,J0+1);

  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(DJt_exp, DJt, fuzzy_tolerance, ...
                       'DJts are not equal');
  
  MU_assert_fuzzy_diff(SJ0t_exp, SJ0t, fuzzy_tolerance, ...
                       'SJ0ts are not equal');

return
