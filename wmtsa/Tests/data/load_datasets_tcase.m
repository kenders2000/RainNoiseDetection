function tc = load_datasets_tcase
% load_datasets_tcase -- munit test case to test load_datasets.
%
%****f*  toolbox.subdirectory/load_datasets
%
% NAME
%   load_datasets_tcase -- munit test case to test load_datasets.
%
% USAGE
%   run_tcase('load_datasets_tcase')
%
% INPUTS
%
%
% OUTPUTS
%   tc            = tcase structure for load_datasets testcase.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
%
% SEE ALSO
%   
%
  
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-08-01
%
% COPYRIGHT
%   2005-01-26
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: load_datasets_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);

% Time Series

tc = MU_tcase_add_test(tc, @test_load_ecg);
tc = MU_tcase_add_test(tc, @test_load_msp);
tc = MU_tcase_add_test(tc, @test_load_nile);
tc = MU_tcase_add_test(tc, @test_load_subtidal);
tc = MU_tcase_add_test(tc, @test_load_solar_magnetic);
tc = MU_tcase_add_test(tc, @test_load_atomic_clock);
tc = MU_tcase_add_test(tc, @test_load_nmr);
tc = MU_tcase_add_test(tc, @test_load_16pta);

% MODWT Coefficients

tc = MU_tcase_add_test(tc, @test_load_ecg_la8_modwt);
tc = MU_tcase_add_test(tc, @test_load_nile_haar_modwt);
tc = MU_tcase_add_test(tc, @test_load_16pt_d4_modwt);

return

% Time Series

function test_load_ecg(mode)
  load_ecg;
return

function test_load_msp(mode)
  load_msp;
return

function test_load_nile(mode)
  load_nile;
return

function test_load_subtidal(mode)
  load_subtidal;
return

function test_load_solar_magnetic(mode)
  load_solar_magnetic;
return

function test_load_atomic_clock(mode)
  load_atomic_clock;
return

function test_load_nmr(mode)
  load_nmr;
return

function test_load_16pta(mode)
  load_16pta;
return

% MODWT Coefficients

function test_load_ecg_la8_modwt(mode)
  load_ecg_la8_modwt;
return

function test_load_nile_haar_modwt(mode)
  load_nile_haar_modwt;
return

function test_load_16pt_d4_modwt(mode)
  load_16pt_d4_modwt;
return
