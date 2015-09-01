function tc = modwt_cum_level_wcov_tcase
% modwt_cum_level_wcov_tcase -- munit test case to test modwt_cum_level_wcov.
%
%****f*  toolbox.subdirectory/modwt_cum_level_wcov_tcase
%
% NAME
%   modwt_cum_level_wcov_tcase -- munit test case to test modwt_cum_level_wcov.
%
% USAGE
%   run_tcase('modwt_cum_level_wcov_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_cum_level_wcov testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_cum_level_wcov
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

%   $Id: modwt_cum_level_wcov_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_missing_required_argument);

return

function test_normal_default(mode)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');
    
  wtfname = 'la8';
  J0 = 6;
  boundary = 'periodic';
  % boundary = 'reflection';

  Y = X;
  [WJtX, VJtX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJtY] = modwt(X, wtfname, J0, boundary);

  ci_method = 'gaussian';
  estimator = 'unbiased';
  
  [wcov, CI_wcov, VARwcov] = modwt_wcov(WJtX, WJtY, ci_method, estimator, ...
                                        wtfname);
  VARwcov

  [clwcov, CI_clwcov] = modwt_cum_level_wcov(wcov, VARwcov);
    
return

function test_insufficient_num_arguments(mode)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments
  [X, x_att] = wmtsa_data('ecg');
    

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJtX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJtY] = modwt(X, wtfname, J0, boundary);

  ci_method = 'gaussian';
  estimator = 'unbiased';
  
  [wcov, CI_wcov, VARwcov] = modwt_wcov(WJtX, WJtY, ci_method, estimator, wtfname);

  [clwcov, CI_clwcov] = modwt_cum_level_wcov(wcov, VARwcov);
  
  try
    [clwcov, CI_clwcov] = modwt_cum_level_wcov;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_missing_required_argument(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'reflection';

  Y = X;
  [WJtX, VJtX] = modwt(X, wtfname, J0, boundary);
  [WJtY, VJtY] = modwt(X, wtfname, J0, boundary);

  ci_method = 'gaussian';
  estimator = 'unbiased';
  
  [wcov, CI_wcov, VARwcov] = modwt_wcov(WJtX, WJtY, ci_method, estimator, wtfname);

  try
    [clwcov, CI_clwcov] = modwt_cum_level_wcov(wcov);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:missingRequiredArgument', msg_id);
  end
return

