function ts = wtfilter_tsuite
% wtfilter_tsuite -- munit test suite to test wtfilter and inverse transforms.
%
%****f*  Tests.dwt/wtfilter_tsuite
%
% NAME
%    wtfilter_tsuite -- munit test suite to test wtfilter and associated functions.
%
% USAGE
%    run_tsuite('wtfilter_tsuite')
%
% INPUTS
%
%
% OUTPUTS
%   ts            = tsuite structure for wtfilter transform testsuite.
%
% DESCRIPTION
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-03-02
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

%   $Id: wtfilter_tsuite.m 612 2005-10-28 21:42:24Z ccornish $

  
ts = MU_tsuite_new(mfilename);

tc = MU_tcase_create(@wtfilter_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@modwt_filter_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@dwt_filter_tcase);
ts = MU_tsuite_add_tcase(ts, tc);


return

