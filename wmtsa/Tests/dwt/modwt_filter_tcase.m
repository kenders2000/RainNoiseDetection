function tc = modwt_filter_tcase
% modwt_filter_tcase -- munit test case to test modwt_filter.
%
%****f*  Tests.dwt/modwt_filter_tcase
%
% NAME
%   modwt_filter_tcase -- munit test case to test modwt_filter.
%
% USAGE
%   run_tcase('modwt_filter_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for modwt_filter testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   modwt_filter
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-Apr-30
%
% COPYRIGHT
%   (c) 2004, 2005 Charles R. Cornish
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: modwt_filter_tcase.m 612 2005-10-28 21:42:24Z ccornish $


  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_smoke_test);
tc = MU_tcase_add_test(tc, @test_no_arg);
tc = MU_tcase_add_test(tc, @test_invalid_wavelet);
tc = MU_tcase_add_test(tc, @test_arg_list);
tc = MU_tcase_add_test(tc, @test_invalid_wavelet_empty);
tc = MU_tcase_add_test(tc, @test_verify_haar_filter);
tc = MU_tcase_add_test(tc, @test_verify_d4_filter);
tc = MU_tcase_add_test(tc, @test_verify_la8_filter);


return

function test_smoke_test(mode)
  % Test Description:  
  %    Expected result: successful executiong
  [wtf] = modwt_filter('la8');
return

function test_no_arg(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
     modwt_filter;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_invalid_wavelet(mode)
  % Test Description:  
  %    Expected error:  Invalid wavelet
  try
    [wtf] = modwt_filter('not_a_wavelet');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id);
  end
return

function test_arg_list(mode)
  % Test Description:  
  %    Expected result:  filter list
  modwt_filter('list');
return


function test_arg_verify_filter(mode)
  % Test Description:  
  %    Expected result: 
  exp_wtf.h = [0.5000   -0.5000];
  exp_wtf.g = [0.5000    0.5000];
  exp_wtf.L  = 2;
  exp_wtf.Name = 'Haar';
    
  [wtf] = modwt_filter('haar');
  
  MU_assert_isequal(exp_wtf.h, wtf.h);
  MU_assert_isequal(exp_wtf.g, wtf.g);
  MU_assert_isequal(exp_wtf.L, wtf.L);
  MU_assert_isequal(exp_wtf.Name, wtf.Name);
  
return

function test_invalid_wavelet_empty(mode)
  % Test Description:  
  %    Expected error:  Invalid wavelet (empty string)
  try
    [wtf] = modwt_filter('');
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:invalidWaveletTransformFilter', msg_id);
  end
return


function test_verify_haar_filter(mode)
  % Test Description:  
  %    Verify the results for the Haar filter.
  g_dwt = [0.7071067811865475 0.7071067811865475];
  exp_wtf.g = g_dwt ./ sqrt(2);
  exp_wtf.h = flipdim(exp_wtf.g, 2) .* (-1).^([1:length(exp_wtf.g)]-1);
  exp_wtf.L = 2;
  exp_wtf.Name = 'Haar';
  [wtf] = modwt_filter('haar');
  MU_assert_isequal(exp_wtf.h, wtf.h);
  MU_assert_isequal(exp_wtf.g, wtf.g);
  MU_assert_isequal(exp_wtf.L, wtf.L);
  MU_assert_isequal(exp_wtf.Name, wtf.Name);
return

function test_verify_d4_filter(mode)
  % Test Description:  
  %    Verify the results for the D4 filter.
  g_dwt = [0.4829629131445341  0.8365163037378077 ...
           0.2241438680420134 -0.1294095225512603];
  exp_wtf.g = g_dwt ./ sqrt(2);
  exp_wtf.h = flipdim(exp_wtf.g, 2) .* (-1).^([1:length(exp_wtf.g)]-1);
  exp_wtf.L = 4;
  exp_wtf.Name = 'D4';
  [wtf] = modwt_filter('d4');
  MU_assert_isequal(exp_wtf.h, wtf.h);
  MU_assert_isequal(exp_wtf.g, wtf.g);
  MU_assert_isequal(exp_wtf.L, wtf.L);
  MU_assert_isequal(exp_wtf.Name, wtf.Name);
return

function test_verify_la8_filter(mode)
  % Test Description:  
  %    Verify the results for the LA8 filter.
  g_dwt = [-0.0757657147893407 -0.0296355276459541, ...
           0.4976186676324578  0.8037387518052163, ...
           0.2978577956055422 -0.0992195435769354, ...
           -0.0126039672622612  0.0322231006040713];
  exp_wtf.g = g_dwt ./ sqrt(2);
  exp_wtf.h = flipdim(exp_wtf.g, 2) .* (-1).^([1:length(exp_wtf.g)]-1);
  exp_wtf.L = 8;
  exp_wtf.Name = 'LA8';
  [wtf] = modwt_filter('la8');
  MU_assert_isequal(exp_wtf.h, wtf.h);
  MU_assert_isequal(exp_wtf.g, wtf.g);
  MU_assert_isequal(exp_wtf.L, wtf.L);
  MU_assert_isequal(exp_wtf.Name, wtf.Name);
return
  
