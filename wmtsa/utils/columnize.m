function y = columnize(X)
% columnize -- Convert array in to a column vector.
%
%****f* wmtsa.utils/columnize
%
% NAME
%   columnize -- Convert array in to a column vector.
%
% SYNOPSIS
%   y = columnize(X)
%
% INPUTS
%   * X          -- an array.
%
% OUTPUTS
%   * y          -- column vector
%
% DESCRIPTION
%   columnize converts an array into a column vector.
%
% TOOLBOX
%   utils
%
% CATEGORY
%   
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-Sep-11
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
%   $Revision: 612 $
%
%***

%   $Id: columnize.m 612 2005-10-28 21:42:24Z ccornish $

%% Set Defaults
  
usage_str = ['[y] = ', mfilename, '(X)'];
  
%% Check arguments.
error(nargerr(mfilename, nargin, [1:1], nargout, [0:1], 1, usage_str, 'struct'));

y = X(:);

return
