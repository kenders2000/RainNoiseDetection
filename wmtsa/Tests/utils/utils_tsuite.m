function ts = utils_tsuite
% utils_tsuite -- munit test suite to test utils.
%
%****f*  wmtsa.Tests.utils/utils_tsuite
%
% NAME
%   utils_tsuite -- munit test suite to test utils.
%
% USAGE
%
%
% INPUTS
%
%
% OUTPUTS
%   ts            = tsuite structure for utils testsuite.
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

%   $Id: utils_tsuite.m 612 2005-10-28 21:42:24Z ccornish $

  
ts = MU_tsuite_new(mfilename);

tc = MU_tcase_create(@verify_datatype_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@argterr_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@nargerr_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@yn_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@wmtsa_isvector_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@wmtsa_isscalar_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@wmtsa_ismatrix_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@flipvec_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@set_default_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@set_defaults_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@parse_opts_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

tc = MU_tcase_create(@list2struct_tcase);
ts = MU_tsuite_add_tcase(ts, tc);

return
