function [result] = test_imodwt_mra
% test_modwt -- Test driver for imodwt_mra
%

%   $Id: test_imodwt_mra.m 612 2005-10-28 21:42:24Z ccornish $

X = load('TestData/heart.dat');

wavelet = 'la8';
J0 = 6;
boundary = 'periodic';

% Compute the modwt
[WJt, VJ0t] = modwt(X, wavelet, J0, boundary);

% Function Tests

% Test Case 1: Normal execution, default parameters
disp('Test Case 1: Normal execution, default parameters');
[DJt, SJ0t, att] = imodwt_mra(WJt, VJ0t, wavelet);

% Test Case 2a: Error, insufficient arguments
disp('Test Case 2a: Error, insufficient arguments');
try
  [DJt, SJ0t, att] = imodwt_mra(WJt);
catch
  disp('Error caught');
end

% Test Case 2b: Error, insufficient arguments
disp('Test Case 2b: Error, insufficient arguments');
try
  [DJt, SJ0t, att] = imodwt_mra;
catch
  disp('Error caught');
end

% Test Case 3: Check output details and smooths  against expected results
disp('Test Case 3: Check output details and smooths against expected results');
[DJt, SJ0t, att] = imodwt_mra(WJt, VJ0t, wavelet);

Dt_expected = load('TestData/MODWT/ecg-LA8-MODWT-MRA.dat');
DJt_expected = Dt_expected(:,1:J0);
SJ0t_expected = Dt_expected(:,J0+1);

fuzzy_tolerance = 1E-10;
if (fuzzy_diff(DJt, DJt_expected, fuzzy_tolerance, 'summary') == 0)
  disp('DJt details agree within fuzzy tolerance');
else
  error('DJt details do not agree within fuzzy tolearance');
end


if (fuzzy_diff(SJ0t, SJ0t_expected, fuzzy_tolerance, 'summary') == 0)
  disp('SJ0t smooths agree within fuzzy tolerance');
else
  error('SJ0t smooths do not agree within fuzzy tolearance');
end


return