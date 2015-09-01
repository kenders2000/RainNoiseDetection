function [tf, mismatches] = compare_struct_fieldnames(s1, s2, match)
% compare_struct_fieldnames -- Compare two structs for match of fieldnames.
%
%****f* wmtsa.utils/compare_struct_fieldnames
%
% NAME
%   compare_struct_fieldnames -- Compare two structs for match of fieldnames.
%
% SYNOPSIS
%   [tf, msg] = compare_struct_fieldnames(s1, s2)
%   [tf, msg] = compare_struct_fieldnames(s1, s2, 'exact')
%   [tf, msg] = compare_struct_fieldnames(s1, s2, 'sorted')
%
% INPUTS
%   * s1         -- first struct to compare.
%   * s2         -- second struct to compare.
%   * match      -- type of match.
%                   Possible values:  'exact', 'sorted'
%
% OUTPUTS
%   * tf         -- flag indicating whether structs' fieldnames match (Boolean).
%   * mismatches -- list of pairs of non-matching fieldnames (Nx2 cell array of strings).
%
% SIDE EFFECTS
%   Function call requires a minimum of 2 input arguments; otherwise error.
%
% DESCRIPTION
%   compare_struct_filenames compares the fieldnames in two structs.  
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

%   $Id: compare_struct_fieldnames.m 612 2005-10-28 21:42:24Z ccornish $

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


tf = 1;

s1_fieldnames = fieldnames(s1);
s2_fieldnames = fieldnames(s2);

if (strcmpi(match, 'sorted'))
  s1_fieldnames = sort(s1_fieldnames);
  s2_fieldnames = sort(s2_fieldnames);
end



if (length(s1_fieldnames) ~= length(s2_fieldnames))
  tf = 0;
  if (nargout > 1)
    s1_len = length(s1_fieldnames);
    s2_len = length(s2_fieldnames);
    if (s1_len > s2_len)
      s2_temp = cell(size(s1_fieldnames));
      s2_temp(1:s2_len) = s2_fieldnames;
      s2_fieldnames = s2_temp;
    else
      s1_temp = cell(size(s2_fieldnames));
      s1_temp(1:s1_len) = s1_fieldnames;
      s1_fieldnames = s1_temp;
    end
    matches = strcmp(s1_fieldnames, s2_fieldnames);
    mismatches{:,1} = s1_fieldnames(~matches);
    mismatches{:,2} = s2_fieldnames(~matches);
  end
    
else
  matches = strcmp(s1_fieldnames, s2_fieldnames);
  tf = fix( sum(matches) / length(matches) );
  
  if (nargout > 1)
    if (~tf)
      mismatches{:,1} = s1_fieldnames(~matches);
      mismatches{:,2} = s2_fieldnames(~matches);
    else
      mismatches = {};
    end
  end
end

return
