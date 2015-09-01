function tc = list2struct_tcase
% list2struct_tcase -- munit test case to test list2struct.
%
%****f*  toolbox.subdirectory/list2struct
%
% NAME
%   list2struct_tcase -- munit test case to test list2struct.
%
% USAGE
%   run_tcase('list2struct_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for list2struct testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   list2struct
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

%   $Id: list2struct_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);
tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_YYY);

return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters

  list = {'Color', 'red', 'LineWidth', 0.5};
  s = list2struct(list);
  
return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
    list2struct;
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_YYY(mode)
  % Test Description:  
  %    
return

function test_YYY_assert_error(mode)
  % Test Description:  
  %    Expected error:  YYYY
  try
    % function to try
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error(Expected_msg_id, msg_id);
  end
return
