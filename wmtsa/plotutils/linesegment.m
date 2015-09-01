function [hline] = linesegment(xstart, ystart, xend, yend, LineSpec, lineProp)
% linesegment -- Plot a set of line segments as specified by their start and end points.
%
%****f* wmtsa.plotutils/linesegment
%
% NAME
%   linesegment -- Plot a set of line segments as specified by their start and end points.
%
% SYNOPSIS
%   [hline] = linesegment(xstart, ystart, xend, yend, [lineProp])
%
%
% INPUTS
%   xstart       = vector of x-coordinates for start of line segments.
%   ystart       = vector of y-coordinates for start of line segments.
%   xend         = vector of x-coordinates for end of line segments.
%   yend         = vector of y-coordinates for end of line segments.
%
% OUTPUTS
%
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
%   2004-01-09
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

%   $Id: linesegment.m 612 2005-10-28 21:42:24Z ccornish $

if nargerr(mfilename, nargin, [4:6], nargout, [0:1])
  error_str = ['Usage:  [hline] = ', mfilename, ...
               '(xstart, ystart, xend, yend, [lineProp]'];
  error(error_str);
end

default_linestyle = '-';
default_linecolor = '';

if (~exist('LineSpec', 'var') || isempty(LineSpec))
  LineSpec = [default_linestyle, default_linecolor];
end

[m, n] = size(xstart);

xx = zeros(3*m,n);
xx(1:3:3*m,:) = xstart;
xx(2:3:3*m,:) = xend;
xx(3:3:3*m,:) = NaN;

yy = zeros(3*m,n);
yy(1:3:3*m,:) = ystart;
yy(2:3:3*m,:) = yend;
yy(3:3:3*m,:) = NaN;

ha = newplot;
nextplot = lower(get(ha, 'NextPlot'));
hold_state = ishold;

hl = plot(xx, yy, LineSpec, 'parent', ha);

if (~hold_state)
  set(ha, 'NextPlot', next);
end


if (nargout > 0)
  hline = hl;
end


return
