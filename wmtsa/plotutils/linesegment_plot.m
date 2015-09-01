function [hline] = linesegment_plot(x1, y1, x2, y2, lineProp)
% linesegment_plot -- Plot a series of line segments on current plot axes.
%
%****f* wmtsa.plotutils/linesegment_plot
%
% NAME
%   linesegment_plot -- Plot a series of line segments on current plot axes.
%
% SYNOPSIS
%   [hline] = linesegment_plot(x1, y1, x2, y2, lineProp)
%
% INPUTS
%   x1           = vector of x-axis start points.
%   x1           = vector of y-axis start points.
%   x1           = vector of x-axis end points.
%   x1           = vector of y-axis start points.
%   lineProp     = (optional) struct containing line properties to override.
%
% OUTPUTS
%   hline = vector containing handles to Line (segment) objects drawn.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   linesegment_plot plots a series of line segments defined by (x1,x2)->(x2,y2).
%   (x1,y1) are start points; (x2,y2) are end points.
%   
% EXAMPLE
%
%
% NOTES
%
%
% REFERENCES
%
%
% SEE ALSO
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/05/24
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

% $Id: linesegment_plot.m 612 2005-10-28 21:42:24Z ccornish $

  
if nargerr(mfilename, nargin, [4:5], nargout, [0:1])
  error_str = (['Usage:  hline = ', mfilename, ...
               '(x1, y1, x2, y2, [lineProp])']);
  error(error_str);
end

Nx1 = length(x1);
Ny1 = length(y1);
Nx2 = length(x2);
Ny2 = length(y2);

if (any([Nx1-Ny1, Nx1-Nx2, Nx1-Ny2]))
  error('Vectors are of unequal length');
end

linePropName = {};
linePropVal = {};

if (exist('lineProp', 'var') && ~isempty(lineProp))

  % Populate cell arrays for line property names and values.
  axes_field_names = fieldnames(lineProp);
  nfields = length(axes_field_names);
  
  for (i = 1:nfields)
    fname = axes_field_names{i};
    linePropName(i) = {fname};
    fval = lineProp.(fname);
    linePropVal(i) = {fval};
  end
end

hline_segment_vec = [];
for (i = 1:length(x1))
  x = [x1(i), x2(i)];
  y = [y1(i), y2(i)];
  hline_segment = line(x, y);
  set(hline_segment, linePropName, linePropVal);

  hline_segment_vec = [hline_segment_vec, hline_segment];
end

if (nargout >= 1)
  hline = hline_segment_vec;
end

return



