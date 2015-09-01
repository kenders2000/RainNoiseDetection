function [htext] = figure_footer(str, hfigure)
% figure_footer -- Print the string in the footer text area of a figure.
%
%****f* wmtsa.plotutils/figure_footer
%
% NAME
%   figure_footer -- Print the string in the footer text area of a figure.
%
% SYNOPSIS
%   [htext] = figure_footer(str, hfigure)
%
% INPUTS
%   str          = string to print in footer.
%   hfigure      = (optional) handle to figure to print footer.
%                  Default:  current figure
%
% OUTPUTS
%   htext        = handle to text object of figure footer.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%
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

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/06/04
%
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

% $Id: figure_footer.m 612 2005-10-28 21:42:24Z ccornish $

if nargerr(mfilename, nargin, [0:2], nargout, [0:1])
  error_str = ['Usage:  [htext] = ', mfilename, ...
               '(str, [hfigure])'];
  error(error_str);
end

% If hfigure not specified, write footer on current figure
if (~exist('hfigure', 'var') || isempty(hfigure))
  hfigure = gcf;
end

% Amount of figure window devoted to subplots
plotregion = .88;

% position of footer in normalized coordinates
footer_xpos = .1;
footer_ypos = .015;

defaultFontSize = [8];
defaultFontName = 'Times';

% Save current axes
hCurAxes = gca;

haxes = axes('Tag', 'Footer', ...
             'Position', [0 0 1 1], ...
             'Visible', 'off', ...
             'Units', 'normalized');

htext_footer = text(footer_xpos, footer_ypos, str, ...
                    'Tag', 'FooterText', ...
                    'Parent', haxes, ...
                    'FontName', defaultFontName, ...
                    'FontSize', defaultFontSize, ...
                    'Units','normalized');

axes(hCurAxes);

if (nargout >= 1)
  htext = htext_footer;
end

return
