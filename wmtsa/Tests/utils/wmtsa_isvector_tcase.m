function tc = wmtsa_isvector_tcase
% modwt_case -- munit test case for wmtsa_isvector.
%
%****f* wmtsa.Tests.utils/wmtsa_isvector_tcase
%
% NAME
%   wmtsa_isvector_tcase -- munit test case for wmtsa_isvector.
%
% USAGE
%   run_tcase('wmtsa_isvector_tcase')
%
% INPUTS
%   (none)
%
% OUTPUTS
%   * tc          -- tcase case struct (tcase_s)
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-Apr-25
%
% COPYRIGHT
%   (c) Charles R. Cornish 2005
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: wmtsa_isvector_tcase.m 612 2005-10-28 21:42:24Z ccornish $

  
tc = MU_tcase_new(mfilename);
tc = MU_tcase_add_test(tc, @test_default_rowvector);
tc = MU_tcase_add_test(tc, @test_default_columnvector);
tc = MU_tcase_add_test(tc, @test_isnotavector_actval_2darray);
tc = MU_tcase_add_test(tc, @test_isnotavector_actval_3darray);
tc = MU_tcase_add_test(tc, @test_isapointvector_actval_point);
tc = MU_tcase_add_test(tc, @test_isarowvector_actval_rowvector);
tc = MU_tcase_add_test(tc, @test_isarowvector_actval_notarowvector);
tc = MU_tcase_add_test(tc, @test_isacolvector_actval_colvector);
tc = MU_tcase_add_test(tc, @test_isacolvector_actval_notacolvector);
tc = MU_tcase_add_test(tc, @test_isanonsingleton_vector);

return

function test_default_rowvector(varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, is row vector
  %    Expected Result: tf = 1
  expected_tf = 1;
  x = [1:10];
  [tf] = wmtsa_isvector(x);
  MU_assert_isequal(expected_tf, tf);
return
  
function test_default_columnvector(varargin)
  % Test Description:  
  %    Smoke test:  Normal execution, is column vector
  %    Expected Result: tf = 1
  expected_tf = 1;
  x = [1:10];
  x = x(:);
  [tf] = wmtsa_isvector(x);
  MU_assert_isequal(expected_tf, tf);
return

function test_isnotavector_actval_2darray(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = NaN
  x = ones(3, 3);
  expected_tf = 0;
  expected_nsdim = [];
  [tf, nsdim] = wmtsa_isvector(x);
  MU_assert_isempty(nsdim);
  MU_assert_isequal(expected_tf, tf);
return

function test_isnotavector_actval_3darray(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = NaN
  x = ones(3, 3, 3);
  expected_tf = 0;
  expected_nsdim = [];
  [tf, nsdim] = wmtsa_isvector(x);
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isempty(nsdim);
return

function test_isapointvector_actval_point(varargin)
  % Test Description:  
  %    Expected Result: tf = 1, nsdim = NaN
  x = 1;
  expected_tf = 1;
  expected_nsdim = [];
  [tf, nsdim] = wmtsa_isvector(x, 'point')
  nsdim
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isempty(nsdim);
return

function test_isapointvector_actval_notapoint(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = NaN
  x = [1:10];
  expected_tf = 0;
  expected_nsdim = 2;
  [tf, nsdim] = wmtsa_isvector(x, 'point');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

function test_isarowvector_actval_rowvector(varargin)
  % Test Description:  
  %    Expected Result: tf = 1, nsdim = 2
  x = [1:10];
  expected_tf = 1;
  expected_nsdim = 2;
  [tf, nsdim] = wmtsa_isvector(x, 'row');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

function test_isarowvector_actval_notarowvector(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = 1
  x = [1:10]';
  expected_tf = 0;
  expected_nsdim = 1;
  [tf, nsdim] = wmtsa_isvector(x, 'row');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

function test_isacolvector_actval_colvector(varargin)
  % Test Description:  
  %    Expected Result: tf = 1, nsdim = 2
  x = [1:10]';
  expected_tf = 1;
  expected_nsdim = 1;
  [tf, nsdim] = wmtsa_isvector(x, 'col');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

function test_isacolvector_actval_notacolvector(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = 1
  x = [1:10];
  expected_tf = 0;
  expected_nsdim = 2;
  [tf, nsdim] = wmtsa_isvector(x, 'col');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

function test_isanonsingleton_vector(varargin)
  % Test Description:  
  %    Expected Result: tf = 0, nsdim = 1
  x = [1];
  expected_tf = 0;
  expected_nsdim = [];
  [tf, nsdim] = wmtsa_isvector(x, 'nonsingleton');
  MU_assert_isequal(expected_tf, tf);
  MU_assert_isequal(expected_nsdim, nsdim);
return

