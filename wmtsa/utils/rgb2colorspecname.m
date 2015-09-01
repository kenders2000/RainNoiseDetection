function [colorspecname] = rgb2colorspecname(rgb, format)
% rgb2colorspecname -- Look up ColorSpec name by rgb value.
%
%****f* wmtsa.utils/rgb2colorspecname
%
% NAME
%   rgb2colorspecname -- Look up ColorSpec name by rgb value.
%
% USAGE
%   [colorspecname] = rgb2colorspecname(rgb, [format])
%
% INPUTS
%   rbg          - three-element row vector whose elements specify the 
%                  intensities of the red, green, and blue components of 
%                  the color; the intensities must be in the range [0 1]. 
%   format       - (optional) format for name, either 'short' or 'long'
%                  Default:  'short'
% 
% OUTPUTS
%   colorspecname - name of ColorSpec in specified format
%
% SIDE EFFECTS
%   rgb must be RGB value for one of eight primary colors; otherwise error.
%
% DESCRIPTION
%   Funciton converts a RGB 3-element vector to its equivalent name,
%   in either ColorSpec name in either short (default) format 
%   (single letter) or long format (complete name).
%
%   Possible ColorSpec names:
%     yellow
%     magenta 
%     cyan
%     red
%     green
%     blue
%     white
%     black
% SEE ALSO
%   ColorSpec
%
% TOOLBOX
%   wmtsa
%
% CATEGORY
%   utils
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-Apr-05
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

%   $Id: rgb2colorspecname.m 612 2005-10-28 21:42:24Z ccornish $

default_format = 'short';
  
if nargerr(mfilename, nargin, [1:2], nargout, [0:1])
  error_str = ['Usage:  [colorspecname] = ', mfilename, ...
               '(rgb, [format])'];
  error(error_str);
end

if (~exist('format', 'var') || isempty(format))
  format = default_format;
end

% Convert rgb to row vector
[m, n] = size(rgb);
if (n == 1)
  rgb = permute(rgb, [2, 1]);
end


if (rgb == [1 1 0])
  name = 'y';
elseif (rgb == [1 0 1])
  name = 'm'; 
elseif (rgb == [0 1 1])
  name = 'c';
elseif (rgb == [1 0 0])
  name = 'r';
elseif (rgb == [0 1 0])
  name = 'g';
elseif (rgb == [0 0 1])
  name = 'b';
elseif (rgb == [1 1 1])
  name = 'w';
elseif (rgb == [0 0 0])
  name = 'k';
else
  error ('Unknown RGB specification')
end

if (strcmpi(format, 'long'))
  switch name
   case 'y'
    colorspecname = 'yellow';
   case 'm'
    colorspecname = 'magenta';
   case 'c'
    colorspecname = 'cyan';
   case 'r'
    colorspecname = 'red';
   case 'g'
    colorspecname = 'green';
   case 'b'
    colorspecname = 'blue';
   case 'w'
    colorspecname = 'white';
   case 'k'
    colorspecname = 'black';
   otherwise
    error ('Unknown ColorSpec shortname')
  end
else    
  colorspecname = name;
end

return
