function [X] = wmtsa_norminv(p)
% wmtsa_norminv -- Wrapper function for norm2inv.
%
%****f* wmtsa.stats/norminv
%
% NAME
%   wmtsa_norminv -- Wrapper function for norm2inv.
%
% SYNOPSIS
%   X = wmtsa_chi2inv(p)
%   
%   global WMTSA_USE_QGAUSS
%   WMTSA_USE_QGAUSS = 1
%   X = wmtsa_norminv(p, nu)
%
% INPUTS
%   * p    -- probability (lower tail) with range [0,1].
%
% OUTPUTS
%   * X    -- corresponding inverse normal culmulative distribution function (cdf).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   wmtsa_norminv is a wrapper function for toolbox norminv function.  If the 
%   MATLAB Statistics toolbox is installed and a license avaialble, the norminv
%   Statistic toolbox norminv funciton is called.  Otherwise, the WMTSA stats
%   toolbox QGauss function is called.
%
%   Setting the global variable WMTSA_USE_QGAUSS to 1 will cause the QGauss to
%   be used regardless if the MATLAB Statistics toolbox norminv is available.
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

  
  global WMTSA_USE_QGAUSS;
   
  if (WMTSA_USE_QGAUSS | ...
      ~(license('test', 'statistics_toolbox') | ...
        license('checkout', 'statistics_toolbox')))
    warning('Statistics Toolbox not available, using QGauss function.');
    % QGauss uses 1 - p value instead of p.
    p = 1 - p;
    X = QGauss(p);
  else
      [X] = norminv(p);
  end
  
return


function X = my_norminv(p, varargin)
  
  if (nargin > 1)
    nu = varargin{1};
  else
    nu = 2;
  end

  X = QChisq(p, nu);
    
return
