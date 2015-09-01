function [DJt, SJt, mra_att] = modwt_mra(X, wtf, nlevels, boundary)
% modwt_mra -- Calculate MODWT multi-resolution details and smooths of a time series (direct method).
%
%****f* wmtsa.dwt/modwt_mra.m
%
% NAME
%   modwt_mra -- Calculate MODWT multi-resolution details and smooths of a time
%                series (direct method).
%
% SYNOPSIS
%   [DJt, SJt, mra_att] = modwt(X, wtfname, nlevels, boundary)
%
% INPUTS
%   * X          -- set of observations 
%                   (vector of length N or matrix of size N x Nchan)
%   * wtf        -- (optional) wavelet transform filter name or struct 
%                   (string, case-insensitve or wtf struct).
%                   Default:  'la8'
%   * nlevels    -- (optional) maximum level J0 (integer) 
%                   or method of calculating J0 (string).
%                   Valid values: integer>0 or a valid method name
%                   Default:  'conservative'
%   * boundary   -- (optional) boundary conditions to use (string)
%                   Valid values: 'circular' or 'reflection'
%                   Default: 'reflection'
%   * opts       -- (optional) Additional function options.
%
% OUTPUT
%   * DJt        -- MODWT details coefficents (N x J x NChan array).
%   * SJt        -- MODWT smooth coefficients (N x {1,J} x NChan vector).
%   * mra_att    -- structure containing IMODWT MRA transform attributes
%
% SIDE EFFECTS
%   1.  wtfname is a WMTSA-supported MODWT wavelet filter; otherwise error.
%   2.  nlevels is an integer > 0, or is a string containing valid method for
%       choosing J0; otherwise error.
%
% DESCRIPTION
%   modwt_mra calculates the MODWT MRA detail and smooth coefficients
%   from a set of observations in a single function call.
%
%    The output parameter att is a structure with the following fields:
%       name      - name of transform (= 'MODWT')
%       wtfname   - name of MODWT wavelet filter
%       npts      - number of observations (= length(X))
%       J0        - number of levels 
%       boundary  - boundary conditions
%
% EXAMPLE
%
%
% NOTES
%
%
% ALGORITHM
%   See pages 177-179 of WMTSA for description of Pyramid Algorithm for
%   the inverse MODWT multi-resolution analysis.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%   Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   imodwt_mra, imodwt_details, imodwt_smooth, imodwtj, modwt, modwt_filter
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-04-29
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_mra.m 612 2005-10-28 21:42:24Z ccornish $


  defaults.wtfname = 'la8';
  defaults.boundary = 'reflection';
  defaults.nlevels  = 'conservative';

  usage_str = ['Usage:  [DJt, SJt, mra_att] = ', mfilename, ...
               '(X, wtfname, [nlevels], [boundary])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:4], nargout, [0:3], 1, usage_str, 'struct'));

  set_defaults(defaults);

  

  [WJt, VJt, w_att] = modwt(X, wtf, nlevels, boundary);
  [DJt, SJt, mra_att] = imodwt_mra(WJt, VJt, w_att);
  
  
  
return
  
