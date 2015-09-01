function [tf, mismatches] = compare_struct_fieldvalues(s1, s2, match)
% compare_struct_fieldvalues -- Compare two structs for match of fieldvalues.
%
%****f* wmtsa.utils/compare_struct_fieldvalues
%
% NAME
%   compare_struct_fieldvalues -- Compare two structs for match of fieldvalues.
%
% SYNOPSIS
%   [tf, msg] = compare_struct_fieldvalues(s1, s2)
%   [tf, msg] = compare_struct_fieldvalues(s1, s2, 'exact')
%   [tf, msg] = compare_struct_fieldvalues(s1, s2, 'sorted')
%
% INPUTS
%   * s1         -- first struct to compare.
%   * s2         -- second struct to compare.
%   * match      -- type of match.
%                   Possible values:  'exact', 'sorted'
%
% OUTPUTS
%   * tf          -- flag indicating whether structs' fieldvalues match (Boolean).
%   * mismatches  -- list of fieldnames with mismatched values.
%
% SIDE EFFECTS
%   Function call requires a minimum of 2 input arguments; otherwise error.
%
% DESCRIPTION
%   compare_struct_filenames compares the fieldvalues in two structs.  
%
% USAGE
%
%
% WARNINGS
%
%
% ERRORS
%
%
% EXAMPLE
%
%
% NOTES
%
%
% BUGS
%
%
% TODO
%
%
% ALGORITHM
%
%
% REFERENCES
%
%
% SEE ALSO
%
%
% TOOLBOX
%
%
% CATEGORY
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
% MATLAB VERSION
%   7.0
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: compare_struct_fieldvalues.m 612 2005-10-28 21:42:24Z ccornish $

%% Set Defaults
  
usage_str = ['[tf, msg] = ', mfilename, '(s1, s2, [match])'];
  
%% Check arguments.
error(nargerr(mfilename, nargin, [2:3], nargout, [0:2], 1, usage_str, 'struct'));

error(argterr(mfilename, s1, 'struct'));
error(argterr(mfilename, s2, 'struct'));

%% Check for existance of variable; if not existant, create it with default value
if (~exist('match', 'var') || isempty(match))
  match = 'exact';
elseif (isempty(strmatch(match, {'exact', 'sorted'})))
  error('WMTSA:invalidArgumentValue', ...
        ['match argument value must be either ''exact'' or ''sorted''.']);
end

%% First check that fieldnames match
[tf, fieldmismatches] = compare_struct_fieldnames(s1, s2, match);

if (~tf)
  error('Structs have different fieldnames');
end

tf = 1;

s1_fieldnames = fieldnames(s1);
s2_fieldnames = fieldnames(s2);

if (strcmpi(match, 'sorted'))
  s1_fieldnames = sort(s1_fieldnames);
  s2_fieldnames = sort(s2_fieldnames);
end

mismatches = {};

tf = 1;

for (i = 1:length(s1_fieldnames))
  field = s1_fieldnames{i};
  
  if (s1.(field) ~= s2.(field))
    tf = 0;
    mismatches = [mismatches, {field}];
  end
  
end

return
