function plot_wcor(wcor, CI, ylabel_str, title_str)
% plot_wcor -- Plot the wavelet correlation and (optionally) confidence intervals.
%
%****f* wmtsa.dwt/plot_wcor
%
% NAME
%   plot_wcor -- Plot the wavelet correlation and (optionally) confidence intervals.
%
% SYNOPSIS
%   plot_wcor(wcor, [CI], [ylabel_str], [title_str])
%
% INPUTS
%   wcor          = vector containing wavelet corrrelation for J levels.
%   CI            = Jx2 matrix containing 95% confidence intervals,
%                   lower bound (column 1) and upper bound (column 2)
%   ylabel_str   = string containing first line of ylabel for plot
%   title_str    = string containing title for the plot
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
%   2003/04/24
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

% $Id: plot_wcor.m 612 2005-10-28 21:42:24Z ccornish $

  usage_str = ['Usage:  ', mfilename, ...
               '(wcor, [CI], [ylabel_str], [title_str])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:4], nargout, '', 1, usage_str, 'struct'));

  plot_ci = 0;
  
  if (nargin > 1)
    if ~isempty(CI)
      plot_ci = 1;
    end
  end
  
  nlevels = length(wcor);
  x_axis = (1:1:nlevels);
  
  plot(x_axis, wcor, 'r');
  hold on;
  
  if (plot_ci)
     plot(x_axis, CI(:,1), 'k--');
     plot(x_axis, CI(:,2), 'k--');
  end
  
  axis_values = axis;
  xmin = 0;
  xmax = max(x_axis);
  if (mod(xmax,2) == 1)
    xmax = xmax +1; 
  end
  
  ymin = -1.5;
  ymax =  1.5;
  
  axis_values(1) = xmin;
  axis_values(2) = xmax;
  axis_values(3) = ymin;
  axis_values(4) = ymax;
  
  axis(axis_values);
  
  default_ylabel_str = 'wavelet correlation';
  if exist('ylabel_str', 'var')
    ylabel_str2(1) = {ylabel_str};
    ylabel_str2(2) = {default_ylabel_str}; 
  else
    ylabel_str2 = default_ylabel_str;
  end
  
  ylabel(ylabel_str2);
  
  xlabel('level');
  
  if exist('title_str', 'var')
    title(title_str);
  end
  
return
