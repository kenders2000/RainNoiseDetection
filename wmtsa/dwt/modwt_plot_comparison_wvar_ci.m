function  modwt_plot_comparison_wvar_ci(WJ, ylabel_str, title_str)
% modwt_plot_comparison_wvar_ci -- Plot wavelet variance and various confidence interval methods for MODWT wavelet coefficients.
%
% SYNPOPSIS
%   modwt_plot_comparison_wvar_ci(WJ, [ylabel_str], [title_str])
%
% Inputs:
%    W          = NxJ matrix containing MODWT-computed wavelet coefficients
%                 where N = number of time intervals,
%                       J = number of levels
%   ylabel_str  = string containing first line of ylabel for plot
%   title_str   = string containing title for the plot
%
% Outputs:
%
%
% SideEffects:
%
%
% Description:
%
%
% Examples:
%
%
% Notes:
%
%
% Algorithm:
%
%
% See Also:
%
%
% References
%

% $Id: modwt_plot_comparison_wvar_ci.m 612 2005-10-28 21:42:24Z ccornish $
%
% Author:
%   Charlie Cornish
%
% Date:
%   2003-04-25
%
% Credits:
%
%

  global VERBOSE;

  usage_str = ['Usage:  ', mfilename, ...
               '(WJ, [ylabel_str], [title_str])'];
               '[figtitle_str], [plotOpts])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:4], nargout, '', 1, usage_str, 'struct'));

  [wvar, CI_gaussian] = modwt_wvar(WJ, 'gaussian');
  
  [wvar, CI_chi2eta1] = modwt_wvar(WJ, 'chi2eta1');
  
  [wvar, CI_chi2eta3] = modwt_wvar(WJ, 'chi2eta3');
  
  nlevels = length(wvar);
  x_axis = (1:1:nlevels);
  
  semilogy(x_axis, wvar, 'k', ...
           x_axis, CI_gaussian(:,1), 'rx--', ...
           x_axis, CI_chi2eta1(:,1), 'g+-.', ...
           x_axis, CI_chi2eta3(:,1), 'b*:');
  hold on;
  legend('wvar', 'CI-gaussian', 'CI-chi2eta1', 'CI-chi2eta3', 2);
  
  semilogy(x_axis, CI_gaussian(:,2), 'rx--', ... 
  	 x_axis, CI_chi2eta1(:,2), 'g+-.', ...
           x_axis, CI_chi2eta3(:,2), 'b*:');
  
  xlabel('level');
  
  default_ylabel_str = 'wavelet variance';
  if exist('ylabel_str', 'var')
    ylabel_str2(1) = {ylabel_str};
    ylabel_str2(2) = {default_ylabel_str}; 
  else
    ylabel_str2 = default_ylabel_str;
  end
  
  ylabel(ylabel_str2);
  
  title_str2 = {['Comparison of Confidence Interval Methods']};
  
  if exist('title_str', 'var')
    title_str2 = [title_str2 title_str];
  end;
  
  title(title_str2);
  
return



