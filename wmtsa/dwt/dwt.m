function [WJ, VJ, att, NJ] = dwt(X, wtf, nlevels, boundary, varargin)
%   dwt -- Compute the (partial) discrete wavelet transform (DWT).
%
%****f* wmtsa.dwt/dwt
%
% NAME
%   dwt -- Compute the (partial) discrete wavelet transform (DWT).
%
% USAGE
%   [W, V, att, NJ] = dwt(X, [wtf], [nlevels], [boundary], [{opts}])
%
% INPUTS
%   * X          -- set of observations 
%                   (vector of length N or matrix of size N x Nchan)
%   * wtf        -- (optional) wavelet transform filter name or struct 
%                   (string, case-insensitve or wtf struct).
%                   Default:  'la8'
%   * nlevels    -- (optional) maximum level J0 (integer) 
%                   or method of calculating J0 (character string).
%                   Valid values: integer>0 or a valid method name
%                   Default:  'conservative'
%   * boundary   -- (optional) boundary conditions to use (character string)
%                   Valid values: 'circular' or 'reflection'
%                   Default: 'reflection'
%   * opts       -- (optional) Additional function options.
%
% OUTPUTS
%   * WJ         --  DWT wavelet coefficents 
%                    (cell array of length J0 of NJ(:,1) x NChan matrices).
%   * VJ         --  DWT scaling coefficents 
%                    (cell array of length J0 of NJ(:,2) x NChan matrices).
%   * att        --  structure containing DWT transform attributes.
%   * NJ         --  Jx2 matrix containing number of DWT wavelet (WJ)
%                    and scaling (VJ) coefficients at each level j.
%
% SIDE EFFECTS
%   1.  wavelet is a WMTSA-supported DWT wavelet filter; otherwise error.
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
%
%
% COPYRIGHT
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 630 $
%
%***

%   $Id: dwt.m 630 2006-05-02 20:47:17Z ccornish $

defaults.wtf = 'la8';
defaults.boundary = 'reflection';
defaults.nlevels  = 'conservative';
  
opts_defaults.RetainVJ = 0;

usage_str = ['Usage:  [WJ, VJ, att, NJ] = ', mfilename, ...
             '(X, [wtf], [nlevels], [boundary], [opts])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, '1:', nargout, [0:4], 1, usage_str, 'struct'));

set_defaults(defaults);



%% Parse and check the options.
opts = parse_opts(varargin{:});
error(validate_opts(opts, opts_defaults, 'struct'));
opts = set_opts_defaults(opts, opts_defaults);


%% Get a valid wavelet transform filter coefficients struct.
if (ischar(wtf))
  try
    [wtf_s] = dwt_filter(wtf);
  catch
    rethrow(lasterror);
  end
elseif (iswtf(wtf))
  wtf_s = wtf;
else
  error('WMTSA:invalidWaveletTransformFilter', ...
        encode_errmsg('WMTSA:invalidWaveletTransformFilter', wmtsa_err_table, 'wtf'));
end

wtfname = wtf_s.Name;
g = wtf_s.g;
h = wtf_s.h;

% If a vector, make X a column vector
if (wmtsa_isvector(X, 'nonsingleton'))
  X = X(:);
end

%%  N     = length of original series
%%  NChan = number of channels for multi-variant dataset.
[N, NChan] = size(X);

%%  If nlevels is an integer > 0, set J0 = nlevels.
%%  otherwise, select J0 based on choice method specified.
if (isa(nlevels, 'char'))
  if (strcmp(nlevels, 'conservative'))
    J0 = modwt_choose_nlevels(nlevels, wtfname, N);
  else
    error('WMTSA:invalidNLevelsValue', ...
          encode_errmsg('WMTSA:invalidNLevelsValue', wmtsa_err_table));
  end
elseif (isnumeric(nlevels))
  if (nlevels > 0)
    J0 = nlevels;
  else
    error('WMTSA:negativeJ0', ...
          ['nlevels must be an integer greater than 0.']);
  end
else
  error('WMTSA:invalidNLevelsValue', ...
         encode_errmsg('WMTSA:invalidNLevelsValue', wmtsa_err_table));
end

if (J0 < 0)
  error('WMTSA:negativeJ0', ...
        ['J0 must be greater than 0.']);
elseif (2.^J0 > N)
  error('WMTSA:DWT:TooLargeJ0', 'Level (J0) too large for sample size for DWT');
end

if (~opts.RetainVJ && ...
    (log2(N) ~= floor(log2(N))))
  error('WMTSA:DWT:nonPowerOfTwoSampleSize', ...
        ['Sample size is not a multiple of a power of 2; ', ...
         'Use RetainVJ option for odd length sample sizes']);
end

%% Initialize the scale (Vin) for first level by setting it equal to X
%% using specified  boundary conditions
switch boundary
  case 'reflection'
   Xin = cat(1, X, flipdim(X, 1));
  case {'circular', 'periodic'}
   Xin = X;
  otherwise
   error('WMTSA:invalidBoundary', ['Invalid boundary method.']);
end


%% NW = length of the extended series = number of coefficients
NW = size(Xin, 1);

NJ = zeros(J0, 2);;
NJ(:,1) = floor(NW ./ 2.^[1:J0]);
WJ = cell(J0,NChan);
VJ = cell(J0,NChan);


%% Do the DWT
for (i = 1:NChan)
  Vin = Xin(:,i);
  for (j = 1:J0)
    [W_j, Vout] = dwtj(Vin, h, g);
    WJ{j,i} = W_j;
    if (j == J0)
      VJ{J0,i} = Vout(:);
      NJ(j,2) = length(Vout);
    elseif (opts.RetainVJ)
        if (mod(length(Vout), 2))
          Vin = Vout(1:length(Vout)-1);
          VJ{j,i} = Vout(end);
          NJ(j,2) = 1;
        else
          Vin = Vout;
          NJ(j,2) = 0;
        end
    else
      Vin = Vout;
      NJ(j,2) = 0;
    end
  end
end


%% Update attributes
att.Transform = 'DWT';
if (isstruct(wtf))
  att.WTF = wtf;
else
  att.WTF = wtfname;
end
att.N = N;
att.NW = NW;
att.J0 = J0;
att.NChan = NChan;
att.Boundary = boundary;
att.Aligned = 0;
att.RetainVJ = opts.RetainVJ;

return

