function [haxes] = set_axes_prop(haxes, axesProp)
% set_plot_prop  - Set properties of given axes.
%
%****f* wmtsa.plotutils/set_axes_prop
%
% NAME
%   set_plot_prop - Set properties of given axes.
%
% SYNOPSIS
%   [haxes] = set_axes_prop(haxes, axesProp)
%
% INPUTS
%   haxes        = handle of axes to set properties.
%   axesProp     = stucture containing name-value pairs of axes properties to set.
%
% OUTPUTS
%   haxes        = handle to axes of properties set.
%
% DESCRIPTION
%   set_axes_prop takes a structure containing a set of field name-value pairs
%   and sets property values of the named properties for the specified axes.
%   The X/Y/ZLabel property is treated specially, since this is a property of
%   the label (i.e. Text) object.
%
% EXAMPLE
%   axesProp.XLim = [0, 10];
%   axesProp.XTick = [0:5:10];
%   axesProp.XTickLabel = axesProp.XTick;
%   axesProp.XLabel = 'x axis';
%   ha = gca;
%   set_axes_prop(ha, axesProp);
%
% ERRORS
%   If field name is not a valid axes property name, error occurs.
%
% SEE ALSO
%   axes, Axes Properties
%
% TOOLBOX
%   wmtsa/plotutil
%
% CATEGORY
%   Plotting Utilties
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-02-03
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

%   $Id: set_axes_prop.m 612 2005-10-28 21:42:24Z ccornish $
  
  
if nargerr(mfilename, nargin, [2:2], nargout, [0:1])
  error_str = ['Usage:  [haxes] = ', mfilename, ...
               '(set_axes_prop(haxes, axesProp)'];
  error(error_str);
end

try
  ha = findobj(haxes, 'Type', 'axes');
catch
  error('haxes is not a vaild axis handle.');
end


axesPropName = {};
axesPropVal = {};

axes_field_names = fieldnames(axesProp);
nfields = length(axes_field_names);

for (i = 1:nfields)
  fname = axes_field_names{i};
  fval = axesProp.(fname);

  switch fname
   case 'XLabel'
    set(get(haxes,'XLabel'), 'String', fval);
   case 'YLabel'
    set(get(haxes,'YLabel'), 'String', fval);
   case 'ZLabel'
    set(get(haxes,'ZLabel'), 'String', fval);
   otherwise
    set(haxes, fname, fval);
  end
end

if (nargout > 0)
  haxes = ha;
else
  clear haxes;
end

return
