function [coe] = filter_center_of_energy(a)
% filter_center_of_energy -- Calculate filter center of energy.
%
%****f* wmtsa.dwt/filter_center_of_energy
%
% NAME
%   filter_center_of_energy -- Calculate filter center of energy.
%
% SYNOPSIS
%   [coe] = filter_center_of_energy(a)
%
% INPUTS
%   a            = filter coefficients for filter a.
%
% OUTPUTS
%  coe           = center of energy for filter a.
%
% DESCRIPTION
%
%
% EXAMPLE
%
%
% WARNINGS
%
%
% ERRORS
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
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: filter_center_of_energy.m 612 2005-10-28 21:42:24Z ccornish $

  
  
  usage_str = ['Usage:  [coe] = ', mfilename, ...
               '(a)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:1], nargout, [0:1], 1, usage_str, 'struct'));

  % a = a(:);
  L = length(a);
  
  coe = sum([0:L-1] .* a.^2) / sum(a.^2);
  
return

