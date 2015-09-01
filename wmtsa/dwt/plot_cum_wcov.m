function plot_cum_wcov(wcov, CI_wcov, ylabel_str, title_str)
% plot_cum_wcov -- Plot the cumlative wavelet covariance and (optionally) confidence intervals.
%
%****f* wmtsa.dwt/plot_cum_wcov
%
% NAME
%   plot_cum_wcov -- Plot the cumlative wavelet covariance and (optionally) confidence intervals.
%
% SYNOPSIS
%   plot_cum_wcov(wcov, [CI_wcov], [ylabel_str], [title_str])
%
% INPUTS
%   wcov         = vector containing wavelet covariance for J levels.
%   CI_wcov      = Jx2 array containing 95% confidence interval of wcov,
%                  lower bound (column 1) and upper bound (column 2)
%   ylabel_str   = string containing first line of ylabel for plot
%   title_str    = string containing title for the plot
%
% OUTPUTS
%
%
% SIDE EFFECTS
%
% DESCRIPTION
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
%   2003/05/16
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

% $Id: plot_cum_wcov.m 612 2005-10-28 21:42:24Z ccornish $

  usage_str = ['Usage:  ', mfilename, ...
               '(wcov, [CI_wcov], [ylabel_str], [title_str])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:4], nargout, '', 1, usage_str, 'struct'));

  plot_ci = 0;
  
  if (nargin > 1)
    if (CI_wcov)
      plot_ci = 1;
    end
  end
  
  nlevels = length(wcov);
  x_axis = (1:1:nlevels);
  
  cum_wcov = cumsum(wcov);
  cum_CI_wcov = cumsum(CI_wcov);
  
  plot(x_axis, cum_wcov, 'b')
  hold on;
  
  if (plot_ci)
    plot(x_axis, cum_CI_wcov(:,1), 'b--');
    plot(x_axis, cum_CI_wcov(:,2), 'b--');
  end
  
  
  xlabel('level');
  
  if exist('ylabel_str', 'var')
    ylabel(ylabel_str);
  end
  
  if exist('title_str', 'var')
    title(title_str);
  end
  
return








