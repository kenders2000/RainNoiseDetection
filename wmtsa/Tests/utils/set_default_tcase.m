function tc = set_default_tcase
% set_default_tcase -- munit test case to test set_default.
%
%****f*  wmtsa.Tests.utils/set_default
%
% NAME
%   set_default_tcase -- munit test case to test set_default.
%
% USAGE
%   run_tcase('set_default_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for set_default testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   set_default
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

%   $Id: set_default_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);

return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
    
  
  set_default('a', 1);
  
  eval_str = ['exist(''a'', ''var'') & a == 1'];
  MU_assert_expression(eval_str);
  
return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
    % Insert function call - no arguments
    set_default;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

