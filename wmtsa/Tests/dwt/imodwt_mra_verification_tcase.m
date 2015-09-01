function tc = imodwt_mra_verification_tcase
% imodwt_mra_verification_tcase -- munit test case to verify results of imodwt_mra transform.
%
%****f* wmtsa.Tests.dwt/imodwt_mra_verification_tcase
%
% NAME
%   imodwt_mra_verification_tcase -- munit test case to verify results of imodwt_mra transform.
%
% USAGE
%   run_tcase('imodwt_mra_verification_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for imodwt_mra testcase.
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

%   $Id: imodwt_mra_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_imodwt_mra_ecg_la8);


return

function test_verify_imodwt_mra_ecg_la8(varargin)
% test_verify_imodwt_mra_ecg_la8 -- Verify calculated modwt coefficients to expected values.
  [X, x_att] = wmtsa_data('ecg');
  wtfname = 'la8';
  N = length(X);
  J0 = 6;
  boundary = 'periodic';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
  [DJt, SJt, mra_att] = imodwt_mra(WJt, VJt, w_att);

  [DJt_exp, SJt_exp, mra_att_exp] = wmtsa_data('ecg_la8_modwt_mra');
  
  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(DJt_exp, DJt, fuzzy_tolerance, ...
                       'DJts are not equal');
  
  MU_assert_fuzzy_diff(SJt_exp, SJt, fuzzy_tolerance, ...
                       'SJ0ts are not equal');

return
  
