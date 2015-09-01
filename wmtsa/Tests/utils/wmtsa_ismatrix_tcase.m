function tc = wmtsa_ismatrix_tcase
% modwt_case -- munit test case for wmtsa_ismatrix.
%
%****f* wmtsa.Tests.utils/wmtsa_ismatrix_tcase
%
% NAME
%   wmtsa_ismatrix_tcase -- munit test case for wmtsa_ismatrix.
%
% USAGE
%   run_tcase('wmtsa_ismatrix_tcase')
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
%   2004-Apr-25
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

%   $Id: wmtsa_ismatrix_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal_type_not_specified);
tc = MU_tcase_add_test(tc, @test_type_option);
tc = MU_tcase_add_test(tc, @test_no_arg);

return

function test_normal_type_not_specified(varargin)
% test_normal_type_not_specified -- normal execution, type argument not specified.
  
  %% x is a scalar -- Result is true
  expected_tf = 1;
  x = 1;
  [tf] = wmtsa_ismatrix(x);
  MU_assert_isequal(expected_tf, tf);

  %% x is a vector -- Result is true
  expected_tf = 1;
  x = [1:10];
  [tf] = wmtsa_ismatrix(x);
  MU_assert_isequal(expected_tf, tf);

  %% x is a matrix -- Result is true
  expected_tf = 1;
  x = [1:10; 1:10];
  [tf] = wmtsa_ismatrix(x);
  MU_assert_isequal(expected_tf, tf);

  %% x is a array, dim > 2 -- Result is false
  expected_tf = 0;
  x = zeros([2 4 4]);
  [tf] = wmtsa_ismatrix(x);
  MU_assert_isequal(expected_tf, tf);
return
  
function test_type_option(varargin)
% test_type_option --  type argument specified.
  
  %% x is a scalar, type is point. --  Result is true
  expected_tf = 1;
  x = 1;
  [tf] = wmtsa_ismatrix(x, 'point');
  MU_assert_isequal(expected_tf, tf);

  %% x is a scalar, type is truevector. --  Result is false
  expected_tf = 0;
  x = 1;
  [tf] = wmtsa_ismatrix(x, 'truevector');
  MU_assert_isequal(expected_tf, tf);

  %% x is a scalar, type is truematrix. --  Result is false
  expected_tf = 0;
  x = 1;
  [tf] = wmtsa_ismatrix(x, 'truematrix');
  MU_assert_isequal(expected_tf, tf);

  %% x is a vector, type is point. --  Result is false
  expected_tf = 0;
  x = [1:10];
  [tf] = wmtsa_ismatrix(x, 'point');
  MU_assert_isequal(expected_tf, tf);

  %% x is a vector, type is truevector. --  Result is true
  expected_tf = 1;
  x = [1:10];
  [tf] = wmtsa_ismatrix(x, 'truevector');
  MU_assert_isequal(expected_tf, tf);

  %% x is a vector, type is truematrix. --  Result is false
  expected_tf = 0;
  x = [1:10];
  [tf] = wmtsa_ismatrix(x, 'truematrix');
  MU_assert_isequal(expected_tf, tf);

  %% x is a matrix, type is point. --  Result is false
  expected_tf = 0;
  x = [1:10; 1:10];
  [tf] = wmtsa_ismatrix(x, 'point');
  MU_assert_isequal(expected_tf, tf);

  %% x is a matrix, type is truevector. --  Result is false
  expected_tf = 0;
  x = [1:10; 1:10];
  [tf] = wmtsa_ismatrix(x, 'truevector');
  MU_assert_isequal(expected_tf, tf);

  %% x is a matrix, type is truematrix. --  Result is true
  expected_tf = 1;
  x = [1:10; 1:10];
  [tf] = wmtsa_ismatrix(x, 'truematrix');
  MU_assert_isequal(expected_tf, tf);

  %% x is a array, dim > 2, type is point -- Result is false
  expected_tf = 0;
  x = zeros([2 4 4]);
  [tf] = wmtsa_ismatrix(x, 'point');
  MU_assert_isequal(expected_tf, tf);

  %% x is a array, dim > 2, type is truevector -- Result is false
  expected_tf = 0;
  x = zeros([2 4 4]);
  [tf] = wmtsa_ismatrix(x, 'truevector');
  MU_assert_isequal(expected_tf, tf);

  %% x is a array, dim > 2, type is truematrix -- Result is false
  expected_tf = 0;
  x = zeros([2 4 4]);
  [tf] = wmtsa_ismatrix(x, 'truematrix');
  MU_assert_isequal(expected_tf, tf);
  
return

function test_no_arg(mode)
% test_no_arg -- Expected error: WMTSA:InvalidNumArguments
  try
    wmtsa_ismatrix;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return
