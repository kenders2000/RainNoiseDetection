function tc = modwt_wvar_ci_functionality_tcase
% modwt_wvar_ci_functionality_tcase -- munit test case to test modwt_wvar_ci.
%
%****f* wmtsa.Test.dwt/modwt_wvar_ci_functionality_tcase
%
% NAME
%   modwt_wvar_ci_functionality_tcase -- munit test case to test modwt_wvar_ci.
%
% USAGE
%   run_tcase('modwt_wvar_ci_functionality_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_wvar_ci_functionality testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-06-24
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

%   $Id: modwt_wvar_ci_functionality_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_invalid_ci_method);
tc = MU_tcase_add_test(tc, @test_modwt_wvar_ci_method_chi2eta1);
tc = MU_tcase_add_test(tc, @test_modwt_wvar_ci_method_chi2eta3);
tc = MU_tcase_add_test(tc, @test_modwt_wvar_ci_method_gaussian);

return

function test_normal_default(mode)
% test_normal_default  -- Smoke test:  Normal execution, default parameters
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'periodic';

  N = length(X);
  [WJt, VJ0t] = modwt(X, wtfname, J0, boundary);
  NJt = ones(J0,1) * N;

  % Compute wavelet variance - biased estimator
  wvar = (sum(WJt(:,1:J0).^2) / N)';
  whos wvar
  [CI_wvar, edof] = modwt_wvar_ci(wvar, NJt);
return

function test_insufficient_num_arguments(mode)
% test_insufficient_num_arguments -- Expected error: Insufficient number of Arguments

  try
     [CI_wvar, edof] = modwt_wvar_ci;
  catch
    [errmsg, msg_id] = lasterr;

    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id, '', mode);
  end
return

function test_invalid_ci_method(mode)
% test_invalid_ci_method -- WMTSA:WVAR:InvalidCIMethod
  [X, x_att] = wmtsa_data('ecg');

  wtfname = 'la8';
  J0 = 6;
  boundary = 'periodic';

  N = length(X);
  [WJt, VJt] = modwt(X, wtfname, J0);
  MJ = zeros(J0, 1);

  % Compute wavelet variance - biased estimator
  wvar = zeros(J0, 1) * NaN;
  for (j = 1:J0)
    wvar(j) = sum(WJt(:,j).^2);
    wvar(j) = wvar(j) / N;
    MJ(j) = N;
  end 
  try
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, 'not_a_ci_method');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:WVAR:InvalidCIMethod', msg_id);
  end
return


function test_modwt_wvar_ci_method_chi2eta1(mode)
  % Test Description:  
  %    Verify chi2eta1 estimator method
    
  [X, x_att] = wmtsa_data('msp_4096');
  N = length(X);

  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';


  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);
  WJt = WJt(1:N,:);
  
  ci_method = 'chi2eta1';
  estimator = 'unbiased';
  
  % Calculate wvar
  [wvar, tmpCI_wvar, tmpedof, MJ] = ...
      modwt_wvar(WJt, 'none', estimator, wtfname);

  clear tmp*;

  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  LJ = equivalent_filter_width(L, 1:J0);
  NJt = modwt_num_nonboundary_coef(wtfname, N, 1:J0);
  lb = LJ;
  ub = ones(1, J0) * N;
  
  % Compute ci, eodf, Qeta, AJ
  [CI_wvar, edof, Qeta, AJ] = ...
      modwt_wvar_ci(wvar, NJt, ci_method, WJt, lb, ub);
  
  % Check wvar

  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta, exp_MJ, exp_AJ] = ...
      wmtsa_data('msp_d6_wvar_edof1');

  
  fuzzy_tolerance = 1E-15;

  % Compare wvar's
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);

  format long;
  % Compare MJ's
  MU_assert_fuzzy_diff(exp_MJ, MJ, 0, ...
                       'MJs are not equal', mode);
  if (strcmp(mode, 'details'))
    exp_MJ
    MJ
  end

  format long e;
  wvar4 = wvar .* wvar;
  exp_AJ_calc_from_exp_edof = (exp_MJ .* (exp_wvar .* exp_wvar)) ./ exp_edof;
  % Compare AJs
  if (strcmp(mode, 'details'))
    exp_AJ
    AJ
    exp_AJ_calc_from_exp_edof
    wvar4
  end
  
  fuzzy_tolerance = 1E+3;
  MU_assert_fuzzy_diff(exp_AJ, AJ, fuzzy_tolerance, ...
                       'AJs are not equal', mode);
  
  
  % Compare edofs
  edof_calc_from_exp_AJ = (exp_MJ .* (exp_wvar .* exp_wvar)) ./ exp_AJ;
  format long
  if (strcmp(mode, 'details'))
    exp_edof
    edof
    edof_calc_from_exp_AJ
  end
  
  fuzzy_tolerance = 0.05;
  MU_assert_fuzzy_diff(exp_edof, edof, fuzzy_tolerance, ...
                       'edofs are not equal', mode);

  
  fuzzy_tolerance = 1E-2;
  MU_assert_fuzzy_diff(exp_CI_wvar, CI_wvar, fuzzy_tolerance, ...
                       'CI_wvars are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_Qeta
    Qeta
  end
  
  fuzzy_tolerance = 1E-1;
  MU_assert_fuzzy_diff(exp_Qeta, Qeta, fuzzy_tolerance, ...
                       'Qeta are not equal', mode);

return

  

function test_modwt_wvar_ci_method_chi2eta3(mode)
  % Test Description:  
  %    Verify edof, CI_wvar, Qeta, AJ, MJ results for presented in Figure 333
  %    of ocean shear using d6 filter and chi-square eta3 method.

  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);

  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';


  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);
  WJt = WJt(1:N,:);

  ci_method = 'chi2eta3';
  estimator = 'unbiased';

  % Calculate wvar
  [wvar, tmpCI_wvar, tmpedof, MJ] = ...
      modwt_wvar(WJt, 'none', estimator, wtfname);

  clear tmp*;

  [wtf_s] = modwt_filter(wtfname);
  L = wtf_s.L;
  
  LJ = equivalent_filter_width(L, 1:J0);
  NJt = modwt_num_nonboundary_coef(wtfname, N, 1:J0);
  lb = LJ;
  ub = ones(1, J0) * N;
  
  % Compute ci, eodf, Qeta, AJ
  [CI_wvar, edof, Qeta, AJ] = ...
      modwt_wvar_ci(wvar, NJt, ci_method, WJt, lb, ub);

  % Check wvar
  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta, exp_MJ] = ...
      wmtsa_data('msp_d6_wvar_edof3');

  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);


  MU_assert_fuzzy_diff(exp_MJ, MJ, 0, ...
                       'MJs are not equal', mode);

  % Compare edofs
  fuzzy_tolerance = 0;

  format long
  if (strcmp(mode, 'details'))
    exp_edof
    edof
  end
  
  MU_assert_fuzzy_diff(exp_edof, edof, fuzzy_tolerance, ...
                       'edofs are not equal', mode);


  if (strcmp(mode, 'details'))
    exp_CI_wvar
    CI_wvar
  end
  
  fuzzy_tolerance = 1E-4;
  MU_assert_fuzzy_diff(exp_CI_wvar, CI_wvar, fuzzy_tolerance, ...
                       'CI_wvars are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_Qeta
    Qeta
  end
  
  fuzzy_tolerance = 1E-1;
  MU_assert_fuzzy_diff(exp_Qeta, Qeta, fuzzy_tolerance, ...
                       'Qeta are not equal', mode);


  
return


function test_modwt_wvar_ci_method_gaussian(mode)
  % Test Description:  
  %    Verify gaussian estimator method
    
  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);

  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';


  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);
  WJt = WJt(1:N,:);

  ci_method = 'gaussian';
  estimator = 'unbiased';
  
  % Calculate wvar
  [wvar, tmpCI_wvar, tmpedof, MJ] = ...
      modwt_wvar(WJt, 'none', estimator, wtfname);

  clear tmp*;

  [wtf_s] = modwt_filter(wtfname);
  L = wtf_s.L;

  LJ = equivalent_filter_width(L, 1:J0);
  NJt = modwt_num_nonboundary_coef(wtfname, N, 1:J0);
  lb = LJ;
  ub = ones(1, J0) * N;
  
  % Compute ci, eodf, Qeta, AJ
  [CI_wvar, edof, Qeta, AJ] = ...
      modwt_wvar_ci(wvar, NJt, ci_method, WJt, lb, ub);

  % Compare to chi2eta1 method results for comparison
  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta, exp_MJ, exp_AJ] = ...
      wmtsa_data('msp_d6_wvar_edof1');
  
  fuzzy_tolerance = 1E-15;

  % Compare wvar's
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);

  format long;


  wvar4 = wvar .* wvar;

  % Compare AJs
  if (strcmp(mode, 'details'))
    exp_AJ
    AJ
    wvar4
  end
  
  fuzzy_tolerance = 1E+3;
  MU_assert_fuzzy_diff(exp_AJ, AJ, fuzzy_tolerance, ...
                       'AJs are not equal', mode);
  
  if (strcmp(mode, 'details'))
    exp_CI_wvar
    CI_wvar
  end
  

return
