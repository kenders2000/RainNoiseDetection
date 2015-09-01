function [result] = test_dwt
% test_dwt -- Test driver for dwt.
%

%   $Id: test_dwt.m 612 2005-10-28 21:42:24Z ccornish $

X = load('TestData/heart.dat');

% Test Case 1: Normal execution, default parameters
disp('Test Case 1: Normal execution, default parameters');
[W, NJ, att] = dwt(X);

% Test Case 2: Normal execution, specify wavelet filter
disp('Test Case 2: Normal execution, specify wavelet filter');
[W, NJ, att] = dwt(X, 'la8');

% Test Case 3a: Normal execution, specify number of levels
disp('Test Case 3a: Normal execution, specify number of levels');
[W, NJ, att] = dwt(X, 'la8', 11);

% Test Case 3b: Normal execution, specify number of levels less than J0 max
disp('Test Case 3b: Normal execution, specify number of levels < J0 max');
[W, NJ, att] = dwt(X, 'la8', 10);

% Test Case 4a: Normal execution, specify number of boundary 'reflection'
disp('Test Case 4a: Normal execution, specify number of boundary ''reflection''');
[W, NJ, att] = dwt(X, 'la8', 11, 'reflection');

% Test Case 4b: Normal execution, specify number of boundary 'periodic'
disp('Test Case 4b: Normal execution, specify number of boundary ''periodic''');
[W, NJ, att] = dwt(X, 'la8', 11, 'periodic');

% Test Case 5: Error, insufficient arguments
disp('Test Case 5: Error, insufficient arguments');
try
  [W, NJ, att] = dwt;
catch
  disp('Error caught');
end

% Test Case 6: Error, invalid wavelet
disp('Test Case 6: Error, invalid wavelet');
try
  [W, NJ, att] = dwt(X, 'not_a_filter');
catch
  disp('Error caught');
end

% Test Case 7: Error, invalid num levels
disp('Test Case 7: Error, invalid num_levels');
try
  [W, NJ, att] = dwt(X, 'la8', 'not_a_num_levels');
catch
  disp('Error caught');
end

% Test Case 8: Error, invalid boundary conditions
disp('Test Case 8: Error, invalid boundary conditions');
try
  [W, NJ, att] = dwt(X, 'la8', '',  'no_a_boundary_conditions');
catch
  disp('Error caught');
end

% Test Case 9: Check output coefficients against expected results: Haar wavelet
disp('Test Case 9: Check output coefficients against expected results: Haar wavelet');
J0 = 6;
[W, NJ, att] = dwt(X, 'Haar', J0, 'periodic');

W_expected_Haar = load('TestData/DWT/ecg-Haar-DWT.dat');

fuzzy_tolerance = 1E-6;

if (fuzzy_diff(W, W_expected_Haar, fuzzy_tolerance, 'summary') == 0)
  disp('W (DWT coefficients) agree within fuzzy tolerance');
else
  error('W (DWT coefficients) outside range of expected values for fuzzy tolerance.');
end


% Test Case 10: Check output coefficients against expected results:  D(4) wavelet
disp('Test Case 10: Check output coefficients against expected results:  D(4) wavelet');
J0 = 6;
[W, NJ, att] = dwt(X, 'D4', J0, 'periodic');

W_expected_D4 = load('TestData/DWT/ecg-D4-DWT.dat');

fuzzy_tolerance = 1E-5;

if (fuzzy_diff(W, W_expected_D4, fuzzy_tolerance, 'summary') == 0)
  disp('W (DWT coefficients) agree within fuzzy tolerance');
else
  error('W (DWT coefficients) outside range of expected values for fuzzy tolerance.');
end

% Test Case 11: Check output coefficients against expected results:  C(6) wavelet
disp('Test Case 11: Check output coefficients against expected results:  C(6) wavelet');
J0 = 6;
[W, NJ, att] = dwt(X, 'C6', J0, 'periodic');

W_expected_C6 = load('TestData/DWT/ecg-C6-DWT.dat');

fuzzy_tolerance = 1E-5;

if (fuzzy_diff(W, W_expected_C6, fuzzy_tolerance, 'summary') == 0)
  disp('W (DWT coefficients) agree within fuzzy tolerance');
else
  error('W (DWT coefficients) outside range of expected values for fuzzy tolerance.');
end

% Test Case 12: Check output coefficients against expected results:   LA(8) wavelet
disp('Test Case 12: Check output coefficients against expected results:  LA(8) wavelet');
J0 = 6;
[W, NJ, att] = dwt(X, 'LA8', J0, 'periodic');

W_expected_LA8 = load('TestData/DWT/ecg-LA8-DWT.dat');

fuzzy_tolerance = 1E-5;

if (fuzzy_diff(W, W_expected_LA8, fuzzy_tolerance, 'summary') == 0)
  disp('W (DWT coefficients) agree within fuzzy tolerance');
else
  error('W (DWT coefficients) outside range of expected values for fuzzy tolerance.');
end

