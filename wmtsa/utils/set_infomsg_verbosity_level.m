function VERBOSITY = set_infomsg_verbosity_level(verbosity_level)
% set_infomsg_verbosity_level -- Set and return numeric value of VERBOSE to the verbose level for informational messages.
%
%****f* wmtsa.utils/set_infomsg_verbosity_level.m
%
% NAME
%   set_infomsg_verbosity_level -- Set and return numeric value of VERBOSE to the verbose level for informational messages.
%
% USAGE
%   VERBOSITY = set_infomsg_verbosity_level(verbosity_level)
%
% INPUTS
%   
%
% OUTPUTS
%   verbosity_level =  verbosity level, integer or character value
%                      Valid Values: an integer or character string with 
%                      possible values: 
%                                    -1, silent
%                                     0, operational, none
%                                     1, verbose
%                                     2, very, veryvebose
%                                     3, extremely, extremelyvebose
%                      Default:       0 = operational
%
%
% SIDE EFFECTS
%   Error is raised if verbosity_level is an invalid value.
%
% DESCRIPTION
%   Function sets the value of the global variable VERBOSITY to
%   following values:
%      1  for verbose messaging
%      2  for very verbose messaging
%      3  for extremely verbose messaging.
%
%   When infomsg is called with a verbosity_level, the message is
%   displayed based on the value of the global variable VERBOSITY
%   set via set_infomsg_verbosity_level or manually.
%
% NOTES
%   1.  Global variable VERBOSITY must be declared in the calling base or
%       caller workspace prior to executing set_infomsg_verbosity.
%   2.  Value of verbosity_level may be an integer or character.  The
%       function evaluates verbosity_level, determineds the integer
%       value of verbosity_level and sets VERBOSITY.
%
%
% SEE ALSO
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/08
%
% COPYRIGHT
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: set_infomsg_verbosity_level.m 612 2005-10-28 21:42:24Z ccornish $


if nargerr(mfilename, nargin, [1:1], nargout, [0:1])
  error_str = ['Usage:  [VERBOSITY] = ', mfilename, ...
               ' (verbosity_level)'];
  error(error_str);
end

global VERBOSITY;

% Constants
VERBOSITY_LEVEL_SILENT = -1;
VERBOSITY_LEVEL_OPERATIONAL = 0;
VERBOSITY_LEVEL_VERBOSE = 1;
VERBOSITY_LEVEL_VERY_VERBOSE = 2;
VERBOSITY_LEVEL_EXTREMELY_VERBOSE = 3;

default_verbosity_level = VERBOSITY_LEVEL_VERBOSE;

if (~exist('verbosity_level', 'var'))
  verbosity_level = default_verbosity_level;
end

if (ischar(verbosity_level))
  switch lower(verbosity_level)
    case {'silent'}
      vlevel = VERBOSITY_LEVEL_SILENT;
    case {'operational', 'none', 'default'}
      vlevel = VERBOSITY_LEVEL_OPERATIONAL;
    case {'verbose'}
      vlevel = VERBOSITY_LEVEL_VERBOSE;
    case {'very', 'veryverbose'}
      vlevel = VERBOSITY_LEVEL_VERY_VERBOSE;
    case {'extremely', 'extremelyverbose'}
      vlevel = VERBOSITY_LEVEL_EXTREMELY_VERBOSE;
    otherwise
      error(['Unrecognized verbose level (', verbosity_level, ').']);
  end
else
  vlevel = verbosity_level;
end;
   
VERBOSITY = vlevel;

assignin('base', 'VERBOSITY', VERBOSITY);


return;






