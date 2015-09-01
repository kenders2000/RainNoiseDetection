function ts = modwt_tsuite
% modwt_tsuite -- munit test suite to test modwt and inverse transforms.
%
%****f*  wmtsa.wmtsa.Test/modwt_tsuite.m
%
% NAME
%    modwt_tsuite -- munit test suite to test modwt and inverse transforms.
%
% USAGE
%    run_tsuite('modwt_tsuite')
%
% INPUTS
%
%
% OUTPUTS
%   ts            = tsuite structure for modwt transform testsuite.
%
% DESCRIPTION
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-04-30
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

%   $Id: modwt_tsuite.m 612 2005-10-28 21:42:24Z ccornish $

  
ts = MU_tsuite_new(mfilename);

tc = MU_tcase_create(@modwt_functionality_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@modwt_verification_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

% tc = MU_tcase_create(@imodwt_tcase);
% ts = MU_tsuite_add_tcase(ts, tc);

% tc = MU_tcase_create(@imodwt_mra_verification_tcase);
% ts = MU_tsuite_add_tcase(ts, tc);

% tc = MU_tcase_create(@modwt_mra_functionality_tcase);
% ts = MU_tsuite_add_tcase(ts, tc);

% tc = MU_tcase_create(@modwt_mra_verification_tcase);
% ts = MU_tsuite_add_tcase(ts, tc);

return

