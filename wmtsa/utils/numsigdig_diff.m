function result = numsigdig_diff(x, y, numsigdig, mode)
% numsigdig_diff --  Find differences in two arrays exceedning number of significant digits.
%
%****f* wmtsa.utils/numsigdig_diff
%
% NAME
% numsigdig_diff --  Find differences in two arrays exceedning number of significant digits.
%
% USAGE
%   result = numsigdig_diff(a, b, [numsigdig], [mode])
%
% INPUTS
%   * x           -- array or vector of values
%   * y           -- second array or vector of values
%   * numsigdig   -- (optional) number of significant digits threshold
%                    Valid values:  >= 0
%                    Default: 0
%   * mode        -- (optional) format of returned result
%                    Valid Values:  'details', 'summary'
%                    Default:  'details'
%
% OUTPUT
%   * result      -- array or number containing the result of comparison.
%
% DESCRIPTION
%   numsigdig_diff compares two arrays and allows approximate equality when strict
%   equality may not exist due to minor differences due to rounding errors.  
%   numsigdig_diff subtracts two arrays and identifies those elements whose 
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

% $Id: numsigdig_diff.m 612 2005-10-28 21:42:24Z ccornish $
  
defaults.numsigdig = 15;
defaults.mode = 'details';
  
usage_str = ['Usage:  [result] = ', mfilename, ...
             ' (x, y, [numsigdig], [mode])'];

try
  nargerr(mfilename, nargin, [2:4], nargout, [0:1], 1, usage_str);
catch
  rethrow(lasterror);
end

if (size(x) ~= size(y))
  error(['size(x) must be equal size(y)']);
end


% Set defaults
try
  set_default('numsigdig', defaults);
  set_default('mode', defaults);
catch
  throw(lasterror);
end

if (numsigdig < 0)
    error(['numsigdig = ', num2str(numsigdig), ' must be >= 0.']);
end


result = [];

% Find array elements that are within numsigdig tolerance.
% numsigdig_locations = ...
%    find( round(log10(abs( (x - y) ./ x))) + numsigdig <= 0)

% Find array elements with differences less than numsigdig tolerance.
xx = x;
xx(find(xx == 0)) = 1;
% lt_numsigdig_diff_locations = ...
%    find( (log10(abs( (x - y) ./ abs(x)))) +  numsigdig <= 0)

lt_numsigdig_diff_locations = ...
    find( round(log10(abs( (xx - y) ./ xx))) + numsigdig <= 0)

% lt_numsigdig_diff_locations = ...
%     find( round(log10(abs( (x - y))) - log10(y)) + numsigdig <= 0)



switch mode
 case {'details', 'detailed'}
  xydiff = x - y;
  xydiff(lt_numsigdig_diff_locations) = 0;
  result = xydiff;
 case 'summary'
  xydiff = ones(size(x));
  xydiff(lt_numsigdig_diff_locations) = 0;
  diff_sum = sum(xydiff(:));
  result = diff_sum;
 otherwise
  error(['Unknown mode']);
end


return
