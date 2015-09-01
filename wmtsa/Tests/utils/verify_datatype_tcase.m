function tc = verify_datatype_tcase
% verify_data_tcase -- munit test case to test verify_datatype.
%
%****f*  wmtsa.Tests.utils/verify_datatype_tcase
%
% NAME
%   verify_datatype_tcase -- munit test case to test verify_datatype.
%
% USAGE
%   run_tcase(@verify_datatype_tcase)
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for verify_datatype testcase.
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
%   2005-07-18
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: verify_datatype_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_datatypes);


return

function test_normal(varargin)
  % Test Description:  Normal execution.
  %
    
  a = 1;
  [tf, errmsg] = verify_datatype(a, 'int');
  MU_assert_isequal(1, tf);   
  MU_assert_isempty(errmsg);   
  
return

function test_insufficient_num_arguments(varargin)
  % Test Description:  
  %    Expected error: Insufficient number of Arguments
  try
    verify_datatype;
  catch
    [errmsg, msg_id] = lasterr
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_datatypes(varargin)
  % Test Description:  
  %    Exercise the various datatypes.

  var_name = 'a';
  %%%
  %%% Integers
  %%%

  %%% int

  a = 1;
  [tf, errmsg] = verify_datatype(a, 'int');
  MU_assert_isequal(1, tf);   
  MU_assert_isempty(errmsg);   

  a = 'abc';
  exp_errmsg = ['Expected ''', var_name, ''' to be an integer.'];
  [tf, errmsg] = verify_datatype(a, 'int');
  MU_assert_isequal(0, tf);   
  MU_assert_isequal(exp_errmsg, errmsg);   

  %%% int0

  a = 1;
  [tf, errmsg] = verify_datatype(a, 'int0');
  MU_assert_isequal(1, tf);   
  MU_assert_isempty(errmsg);   

  a = -1;
  exp_errmsg = ['Expected ''', var_name, ''' to be an integer with value(s) >= 0.'];
  [tf, errmsg] = verify_datatype(a, 'int0');
  MU_assert_isequal(0, tf);   
  MU_assert_isequal(exp_errmsg, errmsg);   

return

  
  
