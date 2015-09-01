function tc = modwt_cum_level_wvar_tcase
% modwt_cum_level_wvar_tcase -- munit test case to test modwt_cum_level_wvar.
%
%****f*  wmtsa.Tests.dwt/modwt_cum_level_wvar_tcase
%
% NAME
%   modwt_cum_level_wvar_tcase -- munit test case to test modwt_cum_level_wvar.
%
% USAGE
%   run_tcase('modwt_cum_level_wvar_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_cum_level_wvar testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_cum_level_wvar
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   
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

%   $Id: modwt_cum_level_wvar_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_missing_required_argument);
tc = MU_tcase_add_test(tc, @test_verify_cum_level_wvar_ocean_d6_eta3);

return

function test_normal_default(mode, varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wavelet = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJt, VJ0t] = modwt(X, wavelet, J0, boundary);
  
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  [wvar, CI_wvar, edof] = modwt_wvar(WJt, ci_method, estimator, wavelet);

  [clwvar, CI_clwvar] = modwt_cum_level_cum_wav_svar(wvar, edof);
    
return

function test_insufficient_num_arguments(mode, varargin)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');

  wavelet = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJt, VJ0t] = modwt(X, wavelet, J0, boundary);
  
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  [wvar, CI_wvar, edof] = modwt_wvar(WJt, ci_method, estimator, wavelet);
  
  try
    [clwvar, CI_clwvar] = modwt_cum_level_wvar;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_missing_required_argument(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  [X, x_att] = wmtsa_data('ecg');

  wavelet = 'la8';
  J0 = 6;
  boundary = 'reflection';

  [WJt, VJ0t] = modwt(X, wavelet, J0, boundary);
  
  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  
  [wvar, CI_wvar, edof] = modwt_wvar(WJt, ci_method, estimator, wavelet);
  
  try
    [clwvar, CI_clwvar] = modwt_cum_level_wvar(wvar);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:missingRequiredArgument', msg_id);
  end
return

function test_verify_cum_level_wvar_ocean_d6_eta3(mode)  
  % Test Description:  
  %    Verify (display to screen) cumulative level wvar for
  %    of ocean shear using d6 filter and chi-square eta3 method.

  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wavelet = 'd6';
  J0 = 9;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wavelet, J0, boundary);
  WJt = WJt(1:N,:);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';

  % Calculate wvar
  [wvar, CI_wvar, edof, NJt] = ...
      modwt_wvar(WJt, ci_method, estimator, wavelet);

  [clwvar, CI_clwvar, zeta] = modwt_cum_level_wvar(wvar, edof);

  if (strcmp(mode, 'details'))
    wvar
    clwvar
  end
  
  if (strcmp(mode, 'details'))
    CI_clwvar
    CI_wvar
  end

  if (strcmp(mode, 'details'))
    zeta
    edof
  end
  
return
