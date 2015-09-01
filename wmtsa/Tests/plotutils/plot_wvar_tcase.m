function tc = plot_wvar_tcase
% plot_wvar_tcase -- munit test case to test plot_wvar.
%
%****f*  toolbox.subdirectory/plot_wvar
%
% NAME
%   plot_wvar_tcase -- munit test case to test plot_wvar.
%
% USAGE
%   run_tcase('plot_wvar_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for plot_wvar testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   plot_wvar
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

%   $Id: plot_wvar_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);

return

function test_normal_default(mode, varargin)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
    
  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wtfname = 'haar';
  J0 = 12;
  boundary = 'reflection';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, w_att] = ...
      modwt_wvar(WJt, ci_method, estimator, wtfname);

  plot_wvar(wvar, CI_wvar);

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

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';
  [wvar, CI_wvar, edof, MJ, w_att] = ...
      modwt_wvar(WJt, ci_method, estimator, wtfname);
    
  try
    plot_wvar;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return
