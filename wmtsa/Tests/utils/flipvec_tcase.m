function tc = flipvec_tcase
% modwt_case -- munit test case for flipvec.
%
%****f* wmtsa.Tests.utils/flipvec_tcase
%
% NAME
%   flipvec_case -- munit test case for flipvec.
%
% USAGE
%   run_tcase('flipvector_tcase')
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
%   (c) Charles R. Cornish 2004, 2005
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: flipvec_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  tc = MU_tcase_new(mfilename);
  tc = MU_tcase_add_test(tc, @test_flip_rowvector);
  tc = MU_tcase_add_test(tc, @test_flip_columnvector);
  tc = MU_tcase_add_test(tc, @test_xisnotvector_actval_3darray);
  tc = MU_tcase_add_test(tc, @test_xisnotvector_actval_2darray);
  tc = MU_tcase_add_test(tc, @test_noarguments);
  tc = MU_tcase_add_test(tc, @test_verify_flip_rowvector);
  tc = MU_tcase_add_test(tc, @test_verify_flip_columnvector);
  

return

function test_flip_rowvector(varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, flip rowvector
  x = [1:10];
  y = flipvec(x);
return
  
function test_flip_columnvector(varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, flip columnvector
  x = [1:10];
  x = x(:);
  y = flipvec(x);
return

function test_xisnotvector_actval_3darray(varargin)
  % Test Description:  
  %    Expected Error:  not a vector
  x = ones(3, 3, 3);
  expected_msg_id = 'WMTSA:notAVector';
  try
    y = flipvec(x);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error(expected_msg_id, msg_id);
  end
return

function test_xisnotvector_actval_2darray(varargin)
  % Test Description:  
  %    Expected Error:  not a vector
  x = ones(3, 3);
  expected_msg_id = 'WMTSA:notAVector';
  try
    y = flipvec(x);
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error(expected_msg_id, msg_id);
  end
return

function test_noarguments(varargin)
  % Test Description:  
  %    Expected Error:  not a vector
  expected_msg_id = 'MATLAB:nargchk:notEnoughInputs';
  try
    y = flipvec;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error(expected_msg_id, msg_id);
  end
return

function test_verify_flip_rowvector(varargin)
  % Test Description:  
  %    Verify that flip is correct.
  x = [1:10];
  y = flipvec(x);
  MU_assert_isequal(y, x(end:-1:1));
return

function test_verify_flip_columnvector(varargin)
  % Test Description:  
  %    Verify that flip is correct.
  x = [1:10]';
  y = flipvec(x);
  MU_assert_isequal(y, x(end:-1:1));
return
