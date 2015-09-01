function tc = argterr_tcase
% verify_data_tcase -- munit test case to test argterr.
%
%****f*  wmtsa.Tests.utils/argterr_tcase
%
% NAME
%   argterr_tcase -- munit test case to test argterr.
%
% USAGE
%   run_tcase(@argterr_tcase)
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for argterr testcase.
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

%   $Id: argterr_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_datatypes);
tc = MU_tcase_add_test(tc, @test_struct_opt);

return

function test_normal(varargin)
  % Test Description:  Normal execution.
  %
    
  a = 1;
  errmsg = argterr(mfilename, a, 'int');
  MU_assert_isempty(errmsg);   
  
return

function test_insufficient_num_arguments(varargin)
  % Test Description:  
  %    Expected error: Insufficient number of Arguments
  try
    err = argterr;
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
  errmsg = argterr(mfilename, a, 'int');
  MU_assert_isempty(errmsg);   

  a = 'abc';
  exp_errmsg = ['Expected ''', var_name, ''' to be an integer.'];
  errmsg = argterr(mfilename, a, 'int');
  MU_assert_isequal(exp_errmsg, errmsg);   

  %%% int0

  a = 1;
  errmsg = argterr(mfilename, a, 'int0');
  MU_assert_isempty(errmsg);   

  a = -1;
  exp_errmsg = ['Expected ''', var_name, ''' to be an integer with value(s) >= 0.'];
  errmsg = argterr(mfilename, a, 'int0');
  MU_assert_isequal(exp_errmsg, errmsg);   

return

function test_struct_opt(varargin)
  % Test Description:  Test struct option
  %    

  var_name = 'a';
  a = 'abc';
  exp_errmsg = ['Expected ''', var_name, ''' to be an integer.'];

  err = argterr(mfilename, a, 'int', [], 1, '' , 'struct');
  MU_assert_isequal('WMTSA:argterr:invalidArgumentDataType', err.identifier);
  MU_assert_isequal(exp_errmsg, err.message);

  
return
  
  
