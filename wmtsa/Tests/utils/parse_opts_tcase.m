function tc = parse_opts_tcase
% parse_opts_tcase -- munit test case to test parse_opts.
%
%****f*  toolbox.subdirectory/parse_opts
%
% NAME
%   parse_opts_tcase -- munit test case to test parse_opts.
%
% USAGE
%   run_tcase('parse_opts_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for parse_opts testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   parse_opts
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-07-20
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

%   $Id: parse_opts_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

tc = MU_tcase_add_test(tc, @test_normal_default);


return

function test_normal_default(mode)
  % Test Description:  
  %    Smoke test:  Normal execution, default parameters

  opts = parse_opts('a', 1, 'b', 'xyz', 'c', {'abc', 'def', 'jkl'});

  opts_list = {'a', 1, 'b', 'xyz', 'c', {'abc', 'def', 'jkl'}};
  opts2 = parse_opts(opts_list);
  
  opt3 = parse_opts(opts);
  
return


