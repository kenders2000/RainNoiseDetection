function [errmsg] = wmtsa_encode_errmsg(err_id, varargin)
% wmtsa_encode_errmsg  -- Encode error message for given err_id.
%
%****f* wmtsa.dwt/wmtsa_encode_errmsg
%
% NAME
%   wmtsa_encode_errmsg  -- Encode error message for given err_id.
%
% SYNOPSIS
%   [errmsg] = wmtsa_encode_errmsg(err_id, [varargin])
%
% INPUTS
%   err_id        =  error id.
%   varagin       =  variable argument list.
%
% OUTPUTS
%   errmsg        =  error message.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   Function encodes an error message for a specified err_id using
%   the variable number of arguments passed on the funtion call.
%
% EXAMPLE
%
%
% WARNINGS
%
%
% ERRORS
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
%   2004-06-25
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

%   $Id: wmtsa_encode_errmsg.m 612 2005-10-28 21:42:24Z ccornish $

  


usage_str = ['Usage:  [errmsg] = ', mfilename, ...
             '(err_id, [varargin])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, '1:', nargout, [0:1], 1, usage_str, 'struct'));

switch err_id
  case 'WMTSA:ArgumentNotAVector'
   if (nargin > 1)
     arg1 = varargin{1};
   else
     arg1 = '';
   end
   errmsg = sprintf('Argument (%s) must be a vector.', arg1);
  case 'WMTSA:invalidArgumentDataType'
   if (nargin > 1)
     arg1 = varargin{1};
   else
     arg1 = '';
   end
   if (nargin > 2)
     arg2 = varargin{2};
   else
     arg2 = '';
   end
   errmsg = sprintf('Argument (%s) does not have expected datatype (%s).', ...
                    arg1, arg2);
  case 'WMTSA:missingRequiredArgument'
   if (nargin > 1)
     arg1 = varargin{1};
   else
     arg1 = '';
   end
   if (nargin > 2)
     arg2 = varargin{2};
   else
     arg2 = '.';
   end
   errmsg = sprintf('Must specify argument (%s)%s', ...
                    arg1, arg2);
 otherwise
  error('Unknown err_id (', err_id, ')');
end

return
