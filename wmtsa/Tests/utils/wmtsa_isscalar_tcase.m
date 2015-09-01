function tc = wmtsa_isscalar_tcase
% modwt_case -- munit test case for wmtsa_isscalar.
%
%****f* wmtsa.Tests.utils/wmtsa_isscalar_tcase
%
% NAME
%   wmtsa_isscalar_tcase -- munit test case for wmtsa_isscalar.
%
% USAGE
%   run_tcase('wmtsa_isscalar_tcase')
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

%   $Id: wmtsa_isscalar_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_is_a_scalar);
tc = MU_tcase_add_test(tc, @test_is_a_not_scalar);
tc = MU_tcase_add_test(tc, @test_no_arg);

return

function test_is_a_scalar(varargin)
% test_is_a_scalar -- x is a scalar; result true
  expected_tf = 1;
  x = 1;
  [tf] = wmtsa_isscalar(x);
  MU_assert_isequal(expected_tf, tf);
return
  
function test_is_a_not_scalar(varargin)
% test_is_a_not_scalar -- x is a scalar; result false
  expected_tf = 0;
  x = [1 2];
  [tf] = wmtsa_isscalar(x);
  MU_assert_isequal(expected_tf, tf);
return

function test_no_arg(mode)
% test_no_arg -- Expected error: WMTSA:InvalidNumArguments
  try
    wmtsa_isscalar;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return
