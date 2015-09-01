function infomsg(msg_str, verbosity_level)
% infomsg  -- Display an informative message based on global VERBOSITY setting.
%
%****f* wmtsa.utils/infomsg.m
%
% NAME
% infomsg  -- Display an informative message based on global VERBOSITY setting.
%
% USAGE
%   infomsg(msg_str, [verbosity_level])
%
% INPUTS
%   msg_str         =  Informational message to be displayed.
%   verbosity_level =  (optional) verbosity level, integer or character value
%                      Valid Values:  an integer or character string with
%                      possible values:
%                                     0, operational
%                                     2, very, veryvebose
%                                     3, extremely, extremelyvebose
%                      Default:       1 = verbose
%
% OUTPUTS
%   none
%
% SIDE EFFECTS
%   1. Depending on setting of global variable VERBOSITY, msg_str is
%      displayed to the command window.
%   2. Error is raised if verbosity_level is an invalid value.
%
% DESCRIPTION
%   infomsg displays the informative message (msg_str) to the command
%   windwo based on the setting of the global variable VERBOSITY.
%
% NOTES
%   1. Global variable VERBOSITY must be declared and defined (set) to the
%      desired verbosity level.  Use set_infomsg_verbosity_level to set the
%      verbosity level.
%   2. Value of verbosity_level may be an integer or character.  The
%      function evaluates verbosity_level, determines the integer
%      value of verbosity_level.
%
% SEE ALSO
%   set_infomsg_verbosity_level
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-28
%
% COPYRIGHT
%
%
% CREDITS
%   argterr is a rewrite of errargt 
%   by M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi
%   which is part of the MATLAB wavelet toolkit.
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: infomsg.m 612 2005-10-28 21:42:24Z ccornish $


if nargerr(mfilename, nargin, [1:2], nargout, '')
  error_str = ['Usage:  ', mfilename, ...
               ' (msg_str, [verbosity_level])'];
  error(error_str);
end

global VERBOSITY;

% Constants
VERBOSITY_LEVEL_SILENT = -1;
VERBOSITY_LEVEL_OPERATIONAL = 0;
VERBOSITY_LEVEL_VERBOSE = 1;
VERBOSITY_LEVEL_VERY_VERBOSE = 2;
VERBOSITY_LEVEL_EXTREMELY_VERBOSE = 3;

if (isempty(VERBOSITY))
  current_verbosity = VERBOSITY_LEVEL_OPERATIONAL;
else
  current_verbosity = VERBOSITY;
end

default_verbosity_level = VERBOSITY_LEVEL_VERBOSE;
% default_verbosity_level = VERBOSITY_LEVEL_NONE;
if (~exist('verbosity_level', 'var') || isempty(verbosity_level))
  verbosity_level = default_verbosity_level;
end


if (ischar(verbosity_level))
  switch lower(verbosity_level)
    case {'silent'}
      vlevel = VERBOSITY_LEVEL_SILENT;
    case {'operational', 'none'}
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
end

% if ((vlevel > 0) && (VERBOSITY >= vlevel))
% if ((VERBOSITY >= vlevel))
if (vlevel > 0)
  if (current_verbosity >= vlevel)
    disp(msg_str);
  end
elseif (vlevel == 0)
  if( current_verbosity > VERBOSITY_LEVEL_SILENT)
    disp(msg_str);
  end
else
  % Display no messages vlevel < 0.
end

return



