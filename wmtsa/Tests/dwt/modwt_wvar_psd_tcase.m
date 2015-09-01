function tc = modwt_wvar_psd_tcase
% modwt_wvar_psd_tcase -- munit test case to test modwt_wvar_psd.
%
%****f*  wmsta.Tests.dwt/modwt_wvar_psd_tcase
%
% NAME
%   modwt_wvar_psd_tcase -- munit test case to test modwt_wvar_psd.
%
% USAGE
%   run_tcase('modwt_wvar_psd_tcase')
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
%   modwt_psd
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-07-25
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

%   $Id: modwt_wvar_psd_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_verify_ocean_shear_d6);
% tc = MU_tcase_add_test(tc, @test_invalid_estimator);
% tc = MU_tcase_add_test(tc, @test_valid_estimator_but_no_required_wavelet);

return

function test_normal_default(mode, varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters

  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
  wtfname = 'd6';
  J0 = 9;
  boundary = 'periodic';
  
  [X, x_att] = wmtsa_data('msp_4096');

  % Calculate MODWT
  [WJt, VJ0t] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  % Calculate wtfname variance
  [wvar, CI_wvar] = modwt_wvar(WJt, 'chi2eta3', 'unbiased', 'd6');
  
  % Calculate PSD from wtfname variance
  delta_t = 0.1;
  [PSD, f, CI_PSD, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar);

return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  wtfname = 'd6';
  J0 = 9;
  boundary = 'periodic';
  
  [X, x_att] = wmtsa_data('msp_4096');

  % Calculate MODWT
  [WJt, VJt] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  % Calculate wavelet variance
  [wvar, CI_wvar] = modwt_wvar(WJt, 'chi2eta3', 'unbiased', 'd6');
  
  % Calculate PSD from wavelet variance
  delta_t = 0.1;
  try
    [PSD, f, CI_PSD, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_verify_ocean_shear_d6(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  wtfname = 'd6';
  J0 = 9;
  boundary = 'periodic';
  
  [X, x_att] = wmtsa_data('msp_4096');

  % Calculate MODWT
  [WJt, VJt] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  % Calculate wavelet variance
  [wvar, CI_wvar] = modwt_wvar(WJt, 'chi2eta3', 'unbiased', 'd6');
  
  % Calculate PSD from wavelet variance
  delta_t = 0.1;
  [CJ, f, CI_CJ, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar);

  % Load expected results

  [exp_CJ, exp_f, exp_f_band] = wmtsa_data('msp_d6_sdf');
  
  if (strcmp(mode, 'details'))
    exp_CJ
    CI_CJ
  end

  fuzzy_tolerance = 1E-13;

  MU_assert_fuzzy_diff(exp_CJ, CJ, fuzzy_tolerance, ...
                       'CJ''s (PSD''s) are not equal', mode);

  if (strcmp(mode, 'details'))
%    exp_CI_CJ
    CI_CJ
  end

  fuzzy_tolerance = 1E-14;

%  MU_assert_fuzzy_diff(exp_CJ, CJ, fuzzy_tolerance, ...
%                       'CI_CJ''s are not equal', mode);
  
  if (strcmp(mode, 'details'))
    exp_f
    f
  end

  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(exp_f, f, fuzzy_tolerance, ...
                       'f''s are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_f_band
    f_band
  end

  fuzzy_tolerance = 1E-14;

  MU_assert_fuzzy_diff(exp_f_band, f_band, fuzzy_tolerance, ...
                       'f''s are not equal', mode);


return
    
