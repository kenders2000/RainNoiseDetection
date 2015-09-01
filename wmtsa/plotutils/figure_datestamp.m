function [htext] = figure_datestamp(filename, hfigure)
% figure_datestamp -- Print a datestamp in footer area of a figure.
%
%****f* wmtsa.plotutils/figure_datestamp
%
% NAME
%   figure_datestamp -- Print a datestamp in footer area of a figure.
%
% SYNOPSIS
%   [htext] = figure_datestamp(filename, hfigure)
%
% INPUTS
%   filename     = (optional) string containing filename.
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

% $Id: figure_datestamp.m 612 2005-10-28 21:42:24Z ccornish $

if nargerr(mfilename, nargin, [0:2], nargout, [0:1])
  error_str = ['Usage:   = ', mfilename, ...
               '([filename], [hfigure])'];
  error(error_str);
end

str = datestr(now, 0);

if (exist('filename', 'var') && ~isempty(filename))
  str = [filename '  ' str];
end

if (exist('hfigure', 'var') && ~isempty(hfigure))
  htext_footer = figure_footer(str, hfigure);
else
  htext_footer = figure_footer(str);
end

% Turn off Tex interpreter
set(htext_footer, 'Interpreter', 'none');

if (nargout >= 1)
  htext = htext_footer;
end

return

