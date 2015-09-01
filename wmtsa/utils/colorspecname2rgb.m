function [rgb] = colorspecname2rgb(colorspecname)
% colorspecname2rgb -- Look up RGB value by ColorSpec name.
%
%****f* wmtsa.utils/colorspecname2rgb
%
% NAME
%   colorspecname2rgb -- Look up RGB value by ColorSpec name.
%
% USAGE
%   [rgb] = colorspecname2rgb(colorspecname)
%
% INPUTS
%   colorspecname - name of ColorSpec in specified format, in short or long
%                   format.
% 
% OUTPUTS
%   rbg          - three-element row vector whose elements specify the 
%                  intensities of the red, green, and blue components of 
%                  the color; the intensities must be in the range [0 1]. 
%
% SIDE EFFECTS
%   rgb must be RGB value for one of eight primary colors; otherwise error.
%
% DESCRIPTION
%   Funciton converts a ColorSpec name, in either short (single character)
%   or long (single word) format into RGB 3-element vector to specifying
%   its RGB value.
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
%
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

%   $Id: colorspecname2rgb.m 612 2005-10-28 21:42:24Z ccornish $

if nargerr(mfilename, nargin, [1:2], nargout, [0:1])
  error_str = ['Usage:  [rgb] = ', mfilename, ...
               '(colorspecname])'];
  error(error_str);
end

switch (colorspecname)
 case {'y', 'yellow'}
  rgb = [1 1 0];
 case {'m', 'magenta'}
  rgb = [1 0 1];
 case {'c', 'cyan'}
  rgb = [0 1 1];
 case {'r', 'red'}
  rgb = [1 0 0];
 case {'g', 'green'}
  rgb = [0 1 0];
 case {'b', 'blue'}
  rgb = [0 0 1];
 case {'w', 'white'}
  rgb = [1 1 1];
 case {'k', 'black'}
  rgb = [0 0 0];
 otherwise
  error ('Unknown ColorSpec name')
end

return
