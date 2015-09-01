function tc = set_defaults_tcase
% set_defaults_tcase -- munit test case to test set_defaults.
%
%****f*  wmtsa.Tests.utils/set_defaults
%
% NAME
%   set_defaults_tcase -- munit test case to test set_defaults.
%
% USAGE
%   run_tcase('set_defaults_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for set_defaults testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   set_defaults
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-07-19
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: set_defaults_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_set_defaults_opts);
tc = MU_tcase_add_test(tc, @test_set_defaults_assert_error);

return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
    
  % Insert default function call
  defaults.a = 1;
  defaults.b = 'abc';
  defaults.c = {'x', 'y', 'z'};
  
  set_defaults(defaults);
  
  eval_str = ['exist(''a'', ''var'') & a == 1'];
  MU_assert_expression(eval_str);
  eval_str = ['exist(''b'', ''var'') & b == ''abc'''];
  MU_assert_expression(eval_str);
  
return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
    % Insert function call - no arguments
    set_defaults;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_set_defaults_opts(mode)
  % Test Description:  
  %    
  defaults.a = 1;
  defaults.b = 'abc';
  defaults.c = {'x', 'y', 'z'};

  clear a b  c;
  set_defaults(defaults, 'a');
  eval_str = ['exist(''a'', ''var'') & a == 1'];
  MU_assert_expression(eval_str);
  eval_str = ['~exist(''b'', ''var'')'];
  MU_assert_expression(eval_str);

  clear a b  c;
  set_defaults(defaults, {'a', 'b'});
  eval_str = ['exist(''a'', ''var'') & a == 1'];
  MU_assert_expression(eval_str);
  eval_str = ['exist(''b'', ''var'') & b == ''abc'''];
  MU_assert_expression(eval_str);

return

function test_set_defaults_assert_error(mode)
  % Test Description:  
  %    Expected error:  YYYY
  defaults.a = 1;
  defaults.b = 'abc';
  defaults.c = {'x', 'y', 'z'};
  try
    set_defaults(defaults, 'd');
    % function to try
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('WMTSA:set_defaults:noDefaultValue', msg_id);
  end

return
