function tc = wmtsa_data_tcase
% wmtsa_data_tcase -- munit test case to test wmtsa_data.
%
%****f*  toolbox.subdirectory/wmtsa_data
%
% NAME
%   wmtsa_data_tcase -- munit test case to test wmtsa_data.
%
% USAGE
%   run_tcase('wmtsa_data_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for wmtsa_data testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   wmtsa_data
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   
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

%   $Id: wmtsa_data_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_insufficient_num_arguments);
tc = MU_tcase_add_test(tc, @test_available_datasets);

return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters
    
  % Insert default function call
return

function test_insufficient_num_arguments(mode)
  % Test Description:  
  %    Expected error: WMTSA:InvalidNumArguments
  try
    % Insert function call
  catch
    [errmsg, msg_id] = lasterr;
    MU_assert_error('MATLAB:nargchk:notEnoughInputs', msg_id);
  end
return

function test_available_datasets(mode)
  % Test Description:  
  wmtsa_data('datasets');
  
  dlist = wmtsa_data('datasets');
    
return

function test_ecg(mode)
  % Test Description:  
  wmtsa_data('ecg');
return
