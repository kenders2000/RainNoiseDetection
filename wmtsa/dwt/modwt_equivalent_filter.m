function [hJt, gJt, LJ] = modwt_equivalent_filter(wtfname, J)
% modwt_equivalent_filter -- Calculate MODWT equivalent filter for J levels.
%
%****f* wmtsa.dwt/modwt_equivalent_filter
%
% NAME
%   modwt_equivalent_filter -- Calculate MODWT equivalent filter for J levels.
%
% SYNOPSIS
%   [hJ, gJ, LJ, name] = modwt_equivalent_filter(wtfname, J)
%
% INPUTS
%   wtfname      = string containing name of a WMTSA-supported wavelet filter,
%                  case-insensitve.
%   J            = number of levels (integer > 0)
%
% OUTPUTS
%   hJ           = 1xJ numeric cell array of containing equivalent wavelet
%                  filter coefficients.
%   gJ           = 1xJ numeric cell array of containing equivalent scaling
%                  filter coefficients.
%   LJ           = 1xJ numeric cell array containing widths of the
%                  equivalent filters (L_j).
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

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-01-27
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

%   $Id: modwt_equivalent_filter.m 612 2005-10-28 21:42:24Z ccornish $

  
  usage_str = ['Usage:  [hJ, gJ, LJ] = ', mfilename, ...
               '(wtfname, J)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [2:2], nargout, [0:3], 1, usage_str, 'struct'));


  % Check for valid wavelet and get wavelet filter coefficients
  try
    wtf_s = modwt_filter(wtfname);
  catch
    rethrow(lasterror);
  end
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  error(argterr(mfilename, J, 'posint', [], 1, '', 'struct'));

  
  LJ = {};
  hJt = {};
  gJt = {};
  
  Lj = equivalent_filter_width(L, 1);
  LJ{1} = Lj;
  hJt{1} = ht;
  gJt{1} = gt;
  
  
  for (j = 2:J)
    Lj = equivalent_filter_width(L, j);
    LJ{j} = Lj;
    num_zeros = 2^(j-1) - 1;
    hjt = zeros(1, L+(L-1)*num_zeros);
    gjt = zeros(1, L+(L-1)*num_zeros);
    
    for (l = 1:L)
      ll = (l-1) * num_zeros + l;
      hjt(ll) = ht(l);
      gjt(ll) = gt(l);
    end
  
    hJt{j} = conv(gJt{j-1}, hjt);
    gJt{j} = conv(gJt{j-1}, gjt);
    
  end  
    
return
