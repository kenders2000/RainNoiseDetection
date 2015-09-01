function tc = nargerr_tcase
% nargerr_tcase -- munit test case to test nargerr.
%
%****f*  wmtsa.Tests.utils/nargerr_tcase
%
% NAME
%   nargerr_tcase -- munit test case to test nargerr.
%
% USAGE
%   run_tcase(@nargerr_tcase)
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for nargerr testcase.
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
%   2004-Apr-27
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

%   $Id: nargerr_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_normal);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_arg_range_using_string);
tc = MU_tcase_add_test(tc, @test_mode_arg);
tc = MU_tcase_add_test(tc, @test_msg_arg);
tc = MU_tcase_add_test(tc, @test_struct_opt);

return

function test_normal(varargin)
  % Test Description:  Normal execution.
  %
    
  errmsg = nargerr(mfilename, 1, [1:2], 1, [0:1]);
  MU_assert_isempty(errmsg);   
  
  errmsg = nargerr(mfilename, 1, [1:2], 1, [0:1], '', '', 'string');
  MU_assert_isempty(errmsg);   
  
  err = nargerr(mfilename, 1, [1:2], 1, [0:1], '', '', 'struct');
  MU_assert_isempty(err);   
return

function test_insufficient_num_arguments(varargin)
  % Test Description:  
  %    Expected error: Insufficient number of Arguments
  try
    err = nargerr;
  catch
    [errmsg, msg_id] = lasterr
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_arg_range_using_string(varargin)
  % Test Description:  
  %    
  expected_err = [];
  err = nargerr(mfilename, 1, '0:1', 1, [0:1]);
  MU_assert_isequal(expected_err, err);

  expected_err = [];
  err = nargerr(mfilename, 1, ':1', 1, [0:1]);
  MU_assert_isequal(expected_err, err);

  expected_err = [];
  err = nargerr(mfilename, 1, ':', 1, [0:1]);
  MU_assert_isequal(expected_err, err);

  expected_err = 'Too many input arguments.';
  err = nargerr(mfilename, 2, '0:1', 1, [0:1]);
  MU_assert_isequal(expected_err, err);

  expected_err = [];
  err = nargerr(mfilename, 1, '', 1, '0:1');
  MU_assert_isequal(expected_err, err);

  expected_err = [];
  err = nargerr(mfilename, 1, '', 1, ':1');
  MU_assert_isequal(expected_err, err);
  
  expected_err = 'Too many output arguments.';
  err = nargerr(mfilename, 1, '', 2, ':1');
  MU_assert_isequal(expected_err, err);

return

function test_mode_arg(varargin)
  % Test Description:  Test mode option.
  %    

  expected_err = [];
  err = nargerr(mfilename, 1, [1:2], 1, [0:1], 0);
  MU_assert_isequal(expected_err, err);
    
  expected_err = [];
  err = nargerr(mfilename, 1, [1:2], 1, [0:1], 1);
  MU_assert_isequal(expected_err, err);
return

function test_msg_arg(varargin)
  % Test Description:  Test msg option.
  %    
  msg = 'This is an optional message';
  
  nargerr(mfilename, 3, [1:2], 1, [0:1], 0, msg);
  
  nargerr(mfilename, 3, [1:2], 1, [0:1], 1, msg);

return

function test_struct_opt(varargin)
  % Test Description:  Test struct option
  %    
  
  err = nargerr(mfilename, 1, [2:2], 1, [1:1], 1, '', 'struct')
  MU_assert_isequal('MATLAB:nargchk:notEnoughInputs', err.identifier);

  err = nargerr(mfilename, 3, [2:2], 1, [1:1], 1, '', 'struct')
  MU_assert_isequal('MATLAB:nargchk:tooManyInputs', err.identifier);
  
  err = nargerr(mfilename, 2, [2:2], 0, [1:1], 1, '', 'struct')
  MU_assert_isequal('MATLAB:nargoutchk:notEnoughOutputs', err.identifier);

  err = nargerr(mfilename, 2, [2:2], 2, [1:1], 1, '', 'struct')
  MU_assert_isequal('MATLAB:nargoutchk:tooManyOutputs', err.identifier);

  try
    error(nargerr(mfilename, 1, [2:2], 1, [1:1], 1, '', 'struct'))
  catch
    [errmsg, err_id] = lasterr
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', err_id);
  end
  
return
  
  
