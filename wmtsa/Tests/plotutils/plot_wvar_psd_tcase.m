function tc = plot_wvar_psd_tcase
% plot_wvar_psd_tcase -- munit test case to test plot_wvar_psd.
%
%****f*  wmtsa.Tests.dwt/plot_wvar_psd
%
% NAME
%   plot_wvar_psd_tcase -- munit test case to test plot_wvar_psd.
%
% USAGE
%   run_tcase('plot_wvar_psd_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for plot_wvar_psd testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   plot_wvar_psd
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

%   $Id: plot_wvar_psd_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);

return

function test_normal_default(mode)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
    
  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wtfname = 'haar';
  J0 = 12;
  boundary = 'reflection';

  % Calculate MODWT
  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt, ci_method, estimator, wtfname);

  % Calculate PSD from wtfname variance
  delta_t = 0.1;
  [CJ, f, CI_CJ, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar);

  plot_wvar_psd(f, CJ, f_band, CI_CJ);

  if (strcmp(mode, 'details'))
    pause(5);
  end
  close;
  
return

function test_insufficient_num_arguments(mode)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments

  [X, x_att] = wmtsa_data('msp_4096');
 
  N = length(X);
  wtfname = 'haar';
  J0 = 12;
  boundary = 'reflection';

  % Calculate MODWT
  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, att] = ...
      modwt_wvar(WJt, ci_method, estimator, wtfname);

  % Calculate PSD from wavelet variance
  delta_t = 0.1;
  [CJ, f, CI_CJ, f_band] = modwt_wvar_psd(wvar, delta_t, CI_wvar);


  try
    plot_wvar_psd;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return
