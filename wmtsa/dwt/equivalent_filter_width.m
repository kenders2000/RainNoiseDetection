function [Lj] = equivalent_filter_width(L, j)
% equivalent_filter_width -- Calculate width of the equivalent wavelet or scaling filter.
%
%****f* wmtsa.dwt/equivalent_filter_width
%
% NAME
%   equivalent_filter_width -- Calculate width of the equivalent wavelet or scaling filter.
%
% SYNOPSIS
%   [Lj] = equivalent_filter_width(L, j)
%
% INPUTS
%   * L          --  width of wavelet or scaling filter (unit scale).
%   * j          --  jth level (index) of scale or a range of j levels of scales. 
%                    (integer or vector of integers).
%
% OUTPUTS
%   * Lj         -- equivalent width of wavelet or scaling filter for specified
%                   levels (integer or Jx1 vector of integers).
%
% SIDEEFFECTS
%   1.  L > 0, otherwise error.
%   2.  j > 0, otherwise error.
%
% DESCRIPTION
%   Given the length of a wavelet or scaling filter, the function calculates the
%   width of the equivalent filter a level or range of levels j for the specified
%   base filter width L.
%
% ALGORITHM
%    Lj = (2^j - 1) * (L - 1) + 1  (equation 96a of WMTSA)
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003-05-24
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

%   $Id: equivalent_filter_width.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  [Lj] = ', mfilename, ...
             '(L, j)'];

  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, '1:', nargout, [0:3], 1, usage_str, 'struct'));

error(argterr(mfilename, L, 'posint', [], 1, '', 'struct'));
error(argterr(mfilename, j, 'posint', [], 1, '', 'struct'));

Lj = (2.^j - 1) * (L - 1) + 1;

% Return as column vector
Lj = Lj(:);

return

