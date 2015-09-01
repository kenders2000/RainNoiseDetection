function tc = yn_tcase
% modwt_case -- munit test case for yn.
%
%****f* wmtsa.Tests.utils/yn_tcase
%
% NAME
%   yn_case -- munit test case for yn.
%
% USAGE
%   run_tcase('yntor_tcase')
%
% INPUTS
%   (none)
%
% OUTPUTS
%   * tc          -- tcase case struct (tcase_s)
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-Feb-16
%
% COPYRIGHT
%   (c) Charles R. Cornish 2005
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: yn_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  tc = MU_tcase_new(mfilename);
  tc = MU_tcase_add_test(tc, @test_default);
  tc = MU_tcase_add_test(tc, @test_input_argument_x);
  tc = MU_tcase_add_test(tc, @test_output_argument_return_format);
  tc = MU_tcase_add_test(tc, @test_evaluate_expression);

return

function test_default(varargin)
  % Test Description:  
  %    Smoke test:  Default operation
  x = 1;
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);
  x = 0;
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);
return

function test_input_argument_x(varargin)
  % Test Description:  
  %    Excercise various data types for input arguvment x
  x = 1;
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);
  
  x = 't';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'T';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'f';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'F';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'true';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'TRUE';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'false';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'FALSE';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);
  
  x = 'y';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'Y';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'n';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'N';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'yes';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'YES';
  expected_val = 1;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'NO';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);

  x = 'NO';
  expected_val = 0;
  tf = yn(x);
  MU_assert_isequal(expected_val, tf);
  
return

function test_output_argument_return_format(varargin)
  % Test Description:  
  %    Excercise various return_formats
  x = 1;
  return_format = 'numeric';
  expected_val = 1;
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  return_format = 'numeric';
  expected_val = 0;
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 1;
  return_format = 'tf';
  expected_val = 'T';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  return_format = 'tf';
  expected_val = 'F';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 1;
  return_format = 'truefalse';
  expected_val = 'TRUE';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  return_format = 'truefalse';
  expected_val = 'FALSE';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);
  
  x = 1;
  return_format = 'yn';
  expected_val = 'Y';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  return_format = 'yn';
  expected_val = 'N';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 1;
  return_format = 'yesno';
  expected_val = 'YES';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

  x = 0;
  return_format = 'yesno';
  expected_val = 'NO';
  tf = yn(x, return_format);
  MU_assert_isequal(expected_val, tf);

return

function test_evaluate_expression(varargin)
  % Test Description:  
  %    evaluate an expression for logical value
  x = 1;
  y = 1;
  return_format = 'numeric';
  expected_val = 1;
  tf = yn('x == y', return_format);
  MU_assert_isequal(expected_val, tf);

  x = 1;
  y = 0;
  return_format = 'tf';
  expected_val = 'F';
  tf = yn('x == y', return_format);
  MU_assert_isequal(expected_val, tf);

return
