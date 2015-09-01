function plot_modwt_clcwsvar(clcwsvar, title_str, xaxis, xlabel_str)
% plot_modwt_clcwsvar -- Plot the cumulative level of cumulative sample variance of MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/plot_modwt_clcwsvar
%
% NAME
%   plot_modwt_clcwsvar -- Plot the cumulative level of cumulative sample variance of MODWT wavelet coefficients.
%
% SYNOPSIS
%   plot_modwt_clcwsvar(clcwsvar, [title_str], [xaxis], [xlabel_str])
%
% INPUTS
%   clcwsvar     =  cumulative level cumulative sample wavlet variance.
%   title_str    =  (optional) character string containing title of plot.
%
% OUTPUTS
%
%
% SIDE EFFECTS
%
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
%   2003/06/03
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


% $Id: plot_modwt_clcwsvar.m 612 2005-10-28 21:42:24Z ccornish $


  usage_str = ['Usage:  ', mfilename, ...
               '(clcwsvar, [title_str], [xaxis], [xlabel_str])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:4], nargout, '', 1, usage_str, 'struct'));

  [N, J] = size(clcwsvar);
  
  legend_str = {};
  
  for (j = 1:J)
    legend_str{j} = ['\Sigma\SigmaW^2_{', int2str(j), '}'];
  end
  
  plot(clcwsvar);
  
  axis tight;
  
  if (exist('title_str', 'var') && ~isempty(title_str))
    suptitle(title_str)
  end
  
  legend(legend_str, 2);
  
return
  
  
  
