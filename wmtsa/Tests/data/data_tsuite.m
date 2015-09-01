function ts = data_tsuite
% data_tsuite -- munit test suite to test data.
%
%****f*  wmtsa.Tests.data/data_tsuite
%
% NAME
%   data_tsuite -- munit test suite to test data.
%
% USAGE
%
%
% INPUTS
%
%
% OUTPUTS
%   ts            = tsuite structure for data testsuite.
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
%   2005-08-01
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

%   $Id: data_tsuite.m 612 2005-10-28 21:42:24Z ccornish $

  
ts = MU_tsuite_new(mfilename);
  
tc = MU_tcase_create(@load_datasets_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@wmtsa_data_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

return

