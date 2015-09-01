function [W] = dwt2vector(WJ, VJ, att)
% dwt2vector -- Convert DWT coefficient cell array to vector representation.
%
%****f* wmtsa.dwt.dwt/dwt2vector
%
% NAME
%   dwt2vector -- Convert DWT coefficient cell array to vector representation.
%
% SYNOPSIS
%   [W] = dwt2vector(WJ, VJ, att)
%
% INPUTS
%   * WJ         --  DWT wavelet coefficents 
%                    (cell array of length J0 of NJ(:,1) x NChan matrices).
%   * VJ         --  DWT scaling coefficents 
%                    (cell array of length J0 of NJ(:,2) x NChan matrices).
%   * att        --  structure containing DWT transform attributes.
%
% OUTPUTS
%   * W          -- vector of DWT coefficients.
%                   (vector or cell array of vectors).
% SIDE EFFECTS
%
%
% DESCRIPTION
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
%   $Revision: 612 $
%
%***

%   $Id: dwt2vector.m 612 2005-10-28 21:42:24Z ccornish $

%% Set Defaults
  
usage_str = ['[W] = ', mfilename, '(WJ, VJ, att)'];
  
%% Check arguments.
error(nargerr(mfilename, nargin, [3:3], nargout, [0:1], 1, usage_str, 'struct'));

W = {};

NChan    = att.NChan;
J0       = att.J0;
NX       = att.NX;
NW       = att.NW;
boundary = att.Boundary;

for (ic = 1:NChan)
  WC = [];
  for (j = 1:J0)
    WC = [WC; WJ{j,ic}];
  end
  WC = [WC; VJ{J0,ic}];
  W{ic} = WC;  
end
  
return
