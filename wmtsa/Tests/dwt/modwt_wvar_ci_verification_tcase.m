function tc = modwt_wvar_ci_verification_tcase
% modwt_wvar_ci_verification_tcase -- munit test case to test modwt_wvar_ci.
%
%****f*  wmtsa.Tests.dwt/modwt_wvar_ci_verification_tcase
%
% NAME
%   modwt_wvar_ci_verification_tcase -- munit test case to test modwt_wvar.
%
% USAGE
%   run_tcase('modwt_wvar_ci_verification_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_wvar_ci_verification testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_wvar_ci
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

%   $Id: modwt_wvar_ci_verification_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_edof_ocean_d6);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_nile_haar_622_715);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_nile_haar_716_1284);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_edof_ocean_d6_eta1);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_edof_ocean_d6_eta3);
tc = MU_tcase_add_test(tc, @test_verify_modwt_wvar_ci_16pt_haar_lv1);

return

function test_verify_modwt_wvar_ci_edof_ocean_d6(mode)
  % Test Description:  
  %    Verify edof and MJ results for presented in Table 333
  %    of ocean shear using d6 filter.

  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
  WJt = WJt(1:N,:);
  
  ci_method = 'chi2eta3';
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

  [CI_wvar_eta1, edof_eta1, Qeta_eta1] = ...
      modwt_wvar_ci(wvar, NJt, 'chi2eta1', WJt, lb, ub);
  
  [CI_wvar_eta3, edof_eta3, Qeta_eta3] = ...
      modwt_wvar_ci(wvar, NJt, 'chi2eta3', WJt, lb, ub);

  [exp_wvar] = wmtsa_data('msp_d6_wvar');
  
  fuzzy_tolerance = 1E-15;
%  fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, 'summary')
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal');

  % Check EDOFs of table 333.
  [exp_edof_eta1, exp_edof_eta2, exp_edof_eta3, exp_MJ] = ...
      wmtsa_data('table333');

  MU_assert_fuzzy_diff(exp_MJ, MJ, 0, ...
                       'MJs are not equal');


  MU_assert_fuzzy_diff(exp_edof_eta1, round(edof_eta1), 0, ...
                       'edof_eta1s are not equal');



  MU_assert_fuzzy_diff(exp_edof_eta3, round(edof_eta3), 0, ...
                       'edof_eta3s are not equal');

  
return

function test_verify_modwt_wvar_ci_nile_haar_622_715(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.

  [X, x_att] = wmtsa_data('nile');

  X = X(1:94);
  N = length(X);

  wtfname = 'haar';
  J0 = 4;
  boundary = 'periodic';

  [WJt, VJt, w_att] = modwt(X, wtfname, J0, boundary);
    
  ci_method = 'chi2eta3';
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

  clear tmp*;

  % Check wvar

  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta] = ...
      wmtsa_data('nile_wvar_622_715');

  % Check wvar
  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);

  fuzzy_tolerance = 0;
  MU_assert_fuzzy_diff(exp_edof, edof, fuzzy_tolerance, ...
                       'edofs are not equal', mode);

  format long
  if (strcmp(mode, 'details'))
    exp_CI_wvar
    CI_wvar
  end
  
  
  fuzzy_tolerance = 1E-3;
  MU_assert_fuzzy_diff(exp_CI_wvar, CI_wvar, fuzzy_tolerance, ...
                       'CI_wvars are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_Qeta
    Qeta
  end
  
  
  fuzzy_tolerance = 1E-6;
  MU_assert_fuzzy_diff(exp_Qeta, Qeta, fuzzy_tolerance, ...
                       'Qeta are not equal', mode);

return

function test_verify_modwt_wvar_ci_nile_haar_716_1284(mode)
  % Test Description:  
  %    Verify calculated modwt wvar to expected values.

  [X, x_att] = wmtsa_data('nile');

  X = X(95:end);
  N = length(X);

  wtfname = 'haar';
  J0 = 4;
  boundary = 'periodic';

  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);
    
  ci_method = 'chi2eta3';
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

  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta] = ...
      wmtsa_data('nile_wvar_716_1284');

  
  format long
  
  fuzzy_tolerance = 1E-15;

  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);

  % Check CIs, EDOFs, Qetas
  [CI_wvar, edof, Qeta] = ...
      modwt_wvar_ci(wvar, MJ, ci_method, estimator, wtfname, WJt);

  
  fuzzy_tolerance = 0;
  MU_assert_fuzzy_diff(exp_edof, edof, fuzzy_tolerance, ...
                       'edofs are not equal', mode);

  format long
  if (strcmp(mode, 'details'))
    exp_CI_wvar
    CI_wvar
  end
  
  fuzzy_tolerance = 1E-3;
  MU_assert_fuzzy_diff(exp_CI_wvar, CI_wvar, fuzzy_tolerance, ...
                       'CI_wvars are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_Qeta
    Qeta
  end

  fuzzy_tolerance = 1E-5;
  MU_assert_fuzzy_diff(exp_Qeta, Qeta, fuzzy_tolerance, ...
                       'Qeta are not equal', mode);

return

function test_verify_modwt_wvar_ci_edof_ocean_d6_eta1(mode)
  % Test Description:  
  %    Verify edof, CI_wvar, Qeta, AJ, MJ results for presented in Figure 333
  %    of ocean shear using d6 filter and chi-square eta1 method.

  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wtfname, J0, boundary);
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

  [exp_wvar, exp_CI_wvar, exp_edof, exp_Qeta, exp_MJ, exp_AJ] = ...
      wmtsa_data('msp_d6_wvar_edof1');


  fuzzy_tolerance = 1E-15;

  % Compare wvar's
  MU_assert_fuzzy_diff(exp_wvar, wvar, fuzzy_tolerance, ...
                       'wvars are not equal', mode);

  format long;

  if (strcmp(mode, 'details'))
    exp_MJ
    MJ
  end

  % Compare MJ's
  fuzzy_tolerance = 0;
  MU_assert_fuzzy_diff(exp_MJ, MJ, fuzzy_tolerance, ...
                       'MJs are not equal', mode);


  
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

  fuzzy_tolerance = 1E-10;
  MU_assert_fuzzy_diff(exp_AJ, AJ, fuzzy_tolerance, ...
                       'AJs are not equal', mode);
  nsdig_tolerance = 12;
  MU_assert_numsigdig_diff(exp_AJ, AJ, nsdig_tolerance, ...
                       'AJs are not equal', mode);
  
  % Compare edofs
  edof_calc_from_exp_AJ = (exp_MJ .* (exp_wvar .* exp_wvar)) ./ exp_AJ;
  format long
  if (strcmp(mode, 'details'))
    exp_edof
    edof
    edof_calc_from_exp_AJ
  end
  
  fuzzy_tolerance = 1E-9;
  MU_assert_fuzzy_diff(exp_edof, edof, fuzzy_tolerance, ...
                       'edofs are not equal', mode);

  nsdig_tolerance = 12;
  MU_assert_numsigdig_diff(exp_edof, edof, nsdig_tolerance, ...
                       'edofs are not equal', mode);

  
  if (strcmp(mode, 'details'))
    exp_Qeta
    Qeta
  end
  
  fuzzy_tolerance = 1E-1;
  MU_assert_fuzzy_diff(exp_Qeta, Qeta, fuzzy_tolerance, ...
                       'Qeta are not equal', mode);

  if (strcmp(mode, 'details'))
    exp_CI_wvar;
    CI_wvar;
  end

  fuzzy_tolerance = 1E-3;
  MU_assert_fuzzy_diff(exp_CI_wvar, CI_wvar, fuzzy_tolerance, ...
                       'CI_wvars are not equal', mode);


  
return


function test_verify_modwt_wvar_ci_edof_ocean_d6_eta3(mode)
  % Test Description:  
  %    Verify edof, CI_wvar, Qeta, AJ, MJ results for presented in Figure 333
  %    of ocean shear using d6 filter and chi-square eta3 method.

  [X, x_att] = wmtsa_data('msp_4096');

  N = length(X);
  wtfname = 'd6';
  J0 = 9;
  boundary = 'reflection';

  [WJt, VJ0t, att] = modwt(X, wtfname, J0, boundary);
  WJt = WJt(1:N,:);

  ci_method = 'chi2eta3';
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

function test_verify_modwt_wvar_ci_16pt_haar_lv1(mode)
  % Test Description:  
  %    Verify calculated modwt coefficients to expected values.
    
  [X, x_att] = wmtsa_data('16pta');

  N = length(X);

  wtfname = 'd4';
  J0 = 3;
  boundary = 'periodic';
  
  [WJt, VJt, att] = modwt(X, wtfname, J0, boundary);

  ci_method = 'chi2eta1';
  estimator = 'unbiased';
  
  % Test eta1 method
  if (strcmp(mode, 'details'))
    disp('Testing eta1 method');
  end
  
  
  % Calculate wvar
  [wvar, tmpCI_wvar, tmpedof, MJ] = ...
      modwt_wvar(WJt, 'none', estimator, wtfname);

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
  
  exp_wvar = 0.041930;
  exp_edof_lv1 = 12.9365;
  edof_lv1 = edof(1);
  
  % Expect results from WMTSA are to 4 decimal place accuracy.
  fuzzy_tolerance = 1E-4;
  format long;

  if (strcmp(mode, 'details'))
    exp_wvar
    wvar
  end
  
  % Compare wvar's
  MU_assert_fuzzy_diff(exp_wvar, wvar(1), fuzzy_tolerance, ...
                       'wvar for level 1 are not equal', mode);
  
  % Compare ACVS at level 1
  exp_acvs_lv1 = ...
      [ 0.041930, -0.019245, 0.012438, -0.015160,  0.007801,  0.004758, -0.002215, ...
       -0.003311, -0.000568, 0.000812,  0.001544, -0.004341, -0.003355]';

  LJ = equivalent_filter_width(4, 1:J0);
  MJ = modwt_num_nonboundary_coef('d4', N, 1:J0);
  NJt = MJ;

  WJt_unbiased_1 = WJt(LJ(1):N,1);
  acvs = wmtsa_acvs(WJt_unbiased_1, 'biased', 0);
  % Get the acvs for tau >= 0
  acvs_lv1 = acvs(NJt(1):2*NJt(1)-1);
  
  if (strcmp(mode, 'details'))
    exp_acvs_lv1
    acvs_lv1
  end

  fuzzy_tolerance = 1E-6;

  MU_assert_fuzzy_diff(exp_acvs_lv1, acvs_lv1, fuzzy_tolerance, ...
                       'ACVS for level 1 are not equal', mode);
  
  % Compare AJ's
  AJ_lv1 = AJ(1);
  exp_AJ_lv1 = exp_acvs_lv1(1).^2 / 2 + sum(exp_acvs_lv1(2:end).^2);

  % Expect results from WMTSA are to 7 decimal place accuracy.
  if (strcmp(mode, 'details'))
    exp_AJ_lv1
    AJ_lv1
  end
  
  fuzzy_tolerance = 1E-7;
  MU_assert_fuzzy_diff(exp_AJ_lv1, AJ_lv1, fuzzy_tolerance, ...
                       'AJ for level 1 are not equal', mode);

  % Compare edof's
  if (strcmp(mode, 'details'))
    exp_edof_lv1
    edof_lv1
  end
  nsdig_tolerance = 6;
  
  MU_assert_numsigdig_diff(exp_edof_lv1, edof_lv1, nsdig_tolerance, ...
                       'edof for level 1 are not equal', mode);

  % Compare Qetas
  exp_Qeta_lv1 = [24.6512, 4.9477];
  exp_Qeta_lv1_more_acc =   [24.6473, 4.9699];
  Qeta_lv1 = Qeta(1,:);
  
  % Expect results from WMTSA are to 5 decimal place accuracy.
  nsdig_tolerance = 6;

  if (strcmp(mode, 'details'))
    exp_Qeta_lv1_more_acc
    Qeta_lv1
  end
  
  MU_assert_numsigdig_diff(exp_Qeta_lv1_more_acc, Qeta_lv1, nsdig_tolerance, ...
                         'Qeta for level 1 are not equal', mode);


  CI_wvar_lv1 = CI_wvar(1,:);
  exp_CI_wvar_lv1 =  [0.022004, 0.109632];

  % Expect results from are within 3 decimal place accuracy.
  fuzzy_tolerance = 1E-3;

  if (strcmp(mode, 'details'))
    exp_CI_wvar_lv1
    CI_wvar_lv1
  end
  
  MU_assert_fuzzy_diff(exp_CI_wvar_lv1, CI_wvar_lv1, fuzzy_tolerance, ...
                       'CI_wvar for level 1 are not equal', mode);

  % Test eta3 method  
  if (strcmp(mode, 'details'))
    disp('Testing eta3 method');
  end

  ci_method = 'chi2eta3';

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


  exp_wvar = 0.041930;
  exp_edof_lv1 = 6.5;
  edof_lv1 = edof(1);

  % Compare edof's
  if (strcmp(mode, 'details'))
    exp_edof_lv1
    edof_lv1
  end

  % Expect results from WMTSA are to 6 decimal place accuracy.

  MU_assert_fuzzy_diff(exp_edof_lv1, edof_lv1, fuzzy_tolerance, ...
                       'edof for level 1 are not equal', mode);

  % Compare Qeta's
  exp_Qeta_lv1 = [15.2369, 1.4584];
  Qeta_lv1 = Qeta(1,:);
  
  if (strcmp(mode, 'details'))
    exp_Qeta_lv1
    Qeta_lv1
  end
  
  nsdig_tolerance = 5;
  MU_assert_numsigdig_diff(exp_Qeta_lv1, Qeta_lv1, nsdig_tolerance, ...
                         'Qeta for level 1 are not equal', mode);

  CI_wvar_lv1 = CI_wvar(1,:);
  exp_CI_wvar_lv1 =  [0.017887, 0.186880];


  % Expect results from are within 4 decimal place accuracy.
  fuzzy_tolerance = 1E-5;

  if (strcmp(mode, 'details'))
    exp_CI_wvar_lv1
    CI_wvar_lv1
  end
  MU_assert_fuzzy_diff(exp_CI_wvar_lv1, CI_wvar_lv1, fuzzy_tolerance, ...
                       'CI_wvar for level 1 are not equal', mode);

  
return
  
