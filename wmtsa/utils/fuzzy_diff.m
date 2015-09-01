function result = fuzzy_diff(a, b, fuzzy_tol, mode)
% fuzzy_diff --  Find differences in two arrays exceeding fuzzy_tolerance.
%
%****f* wmtsa.utils/fuzzy_diff
%
% NAME
% fuzzy_diff --  Find differences in two arrays exceeding fuzzy_tolerance.
%
% USAGE
%   result = fuzzy_diff(a, b, [fuzzy_tol], [mode])
%
% INPUTS
%   a                = first array or vector of values
%   b                = second array or vector of values
%   fuzzy_tol        = (optional) minimum tolerance or threshold
%                      Valid values:  >= 0
%                      Default: 0
%   mode             = (optional) format of returned result
%                      Valid Values:  'details', 'summary'
%                      Default:  'details'
%
% OUTPUT
%   result           = array or number containing the result of comparison.
%
% DESCRIPTION
%   fuzzy_diff compares two arrays and allows for approximate equality when strict
%   equality may not exist due to minor differences due to rounding errors.  
%   fuzzy_diff subtracts two arrays and identifies those elements whose 
%   differences exceed the fuzzy tolerance threshold.  
%
%   The function has 2 modes of operation:
%      details   = return an array of size(a) with elements 
%                   = 0,   for differences between a and b <  fuzzy_tolerance
%                   = a-b, for differences between a and b >= fuzzy_tolerance
%      summary   = return a number whose values 
%                   = 0, for no differences within fuzzy_tolerance
%                   > 0, number of elements >= fuzzy_tolerance
%
%   Note: fuzzy_diff compares to arrays on an absolute threshold (fuzzy_tol).
%         Use nsigdig_diff to compare arrays that differ by a significant number
%         of digits.

%
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-01   
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: fuzzy_diff.m 612 2005-10-28 21:42:24Z ccornish $
  

if nargerr(mfilename, nargin, [2:4], nargout, [0:1])
  error_str = ['Usage:  [result] = ', mfilename, ...
               ' (a, b, [fuzzy_tol], [mode])'];
  error(error_str);
end 

if (size(a) ~= size(b))
  error(['size(a) must be equal size(b)']);
end

default_fuzzy_tol = 0;
default_mode = 'details';

if (~exist('fuzzy_tol', 'var') || isempty(fuzzy_tol))
  fuzzy_tol = default_fuzzy_tol;
end

if (fuzzy_tol < 0)
    error(['fuzzy_tol = ', num2str(fuzzy_tol), ' must be >= 0.']);
end

if (~exist('mode', 'var') || isempty(mode))
  mode = default_mode;
end

result = [];

fuzzy_locations = find( abs( a - b ) <= fuzzy_tol);

switch mode
 case {'details', 'detailed'}
  abdiff = a - b;
  abdiff(fuzzy_locations) = 0;
  result = abdiff;
 case 'summary'
  abdiff = ones(size(a));
  abdiff(fuzzy_locations) = 0;
  diff_sum = sum(abdiff(:));
  result = diff_sum;
 otherwise
  error(['Unknown mode']);
end


return
