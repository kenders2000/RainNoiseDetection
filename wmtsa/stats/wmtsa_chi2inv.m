function X = wmtsa_chi2inv(p, nu)
% wmtsa_chi2inv -- Wrapper function for chi2inv.
%
%****f* wmtsa.stats/chi2inv
%
% NAME
%   wmtsa_chi2inv -- Wrapper function for chi2inv
%
% SYNOPSIS
%   X = wmtsa_chi2inv(p, nu)
%   
%   global WMTSA_USE_QCHISQ
%   WMTSA_USE_QCHISQ = 1
%   X = wmtsa_chi2inv(p, nu)
%
% INPUTS
%   * p    -- probability (lower tail) with range [0,1].
%   * nu   -- degrees of freedom
%
% OUTPUTS
%   * X    -- corresponding inverse of chi-square cdf.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   wmtsa_chi2inv is a wrapper function for toolbox chi2inv function.  If the 
%   MATLAB Statistics toolbox is installed and a license avaialble, the chi2inv
%   Statistic toolbox norminv funciton is called.  Otherwise, the WMTSA stats
%   toolbox QGauss function is called.
%
%   Setting the global variable WMTSA_USE_QCHISQ to 1 will cause the QChisq to
%   be used regardless if the MATLAB Statistics toolbox chi2inv is available.
%
%
% USAGE
%
%
% WARNINGS
%
%
% ERRORS
%
%
% EXAMPLE
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
% TOOLBOX
%
%
% CATEGORY
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
% MATLAB VERSION
%   7.0
%
% CREDITS
%
%
% REVISION
%   $Revision$
%
%***

%   $Id$

%% Set Defaults
  
usage_str = ['[X] = ', mfilename, '(p, nu])'];
  
%% Check arguments.
error(nargerr(mfilename, nargin, [2:2], nargout, [0:1], 1, usage_str, 'struct'));

  
  global WMTSA_USE_QCHISQ;
   
  if (WMTSA_USE_QCHISQ | ...
      ~(license('test', 'statistics_toolbox') | ...
        license('checkout', 'statistics_toolbox')))
    warning('Statistics Toolbox not available, using QChisq function.');
    % QChisq uses 1 - p value instead of p.
    p = 1 - p;
    X = QChisq(p, nu);
  else
    [X] = chi2inv(p, nu);
  end

  
return


