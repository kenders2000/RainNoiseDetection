function result = nsigdig_diff(a, b, nsdig, mode)
% nsigdig_diff --  Find differences in two arrays exceedning number of significant digits.
%
%****f* wmtsa.utils/nsigdig_diff
%
% NAME
% nsigdig_diff --  Find differences in two arrays exceedning number of significant digits.
%
% USAGE
%   result = nsigdig_diff(a, b, [nsdig], [mode])
%
% INPUTS
%   a                = first array or vector of values
%   b                = second array or vector of values
%   nsdig            = (optional) number of significant digits threshold
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
%   nsigdig_diff compares two arrays and allows approximate equality when strict
%   equality may not exist due to minor differences due to rounding errors.  
%   nsigdig_diff subtracts two arrays and identifies those elements whose 
%   differences exceed the given number of significant digits.
%
%   The function has 2 modes of operation:
%      details   = return an array of size(a) with elements 
%                   = 0,   for differences between a and b <  number of significant digits
%                   = a-b, for differences between a and b >= number of significant digits
%      summary   = return a number whose values 
%                   = 0, for no differences >  number of significant digits
%                   > 0, number of elements >= number of significant digits.
%

%
% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-07-13   
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: nsigdig_diff.m 612 2005-10-28 21:42:24Z ccornish $
  

if nargerr(mfilename, nargin, [2:4], nargout, [0:1])
  error_str = ['Usage:  [result] = ', mfilename, ...
               ' (a, b, [nsdig], [mode])'];
  error(error_str);
end 

if (size(a) ~= size(b))
  error(['size(a) must be equal size(b)']);
end

default_nsdig = 15;
default_mode = 'details';

if (~exist('nsdig', 'var') || isempty(nsdig))
  nsdig = default_nsdig;
end

if (nsdig < 0)
    error(['nsdig = ', num2str(nsdig), ' must be >= 0.']);
end

if (~exist('mode', 'var') || isempty(mode))
  mode = default_mode;
end

result = [];

% Find array elements that are within nsdig tolerance.
nsdig_locations = ...
    find( round(log10(abs( (a-b) ./ a))) + nsdig <= 0);


switch mode
 case {'details', 'detailed'}
  abdiff = a - b;
  abdiff(nsdig_locations) = 0;
  result = abdiff;
 case 'summary'
  abdiff = ones(size(a));
  abdiff(nsdig_locations) = 0;
  diff_sum = sum(abdiff(:));
  result = diff_sum;
 otherwise
  error(['Unknown mode']);
end


return
