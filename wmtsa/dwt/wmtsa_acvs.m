function ACVS = wmtsa_acvs(X, estimator, subtract_mean, method, dim)
% wmtsa_acvs -- Calculate the autocovariance sequence (ACVS) of a data series.
%
%****f* wmtsa.dwt/wmtsa_acvs
%
% NAME
%   wmtsa_acvs -- Calculate the autocovariance sequence (ACVS) of a data series.
%
% SYNOPSIS
%   ACVS = wmtsa_acvs(X, [dim], [estimator], [subtract_mean], [method], [dim])
%
% INPUTS
%   * X           -- set of observations (array).
%   * estimator   -- (optional) type of estimator
%                    Valid values:  'biased', 'unbiased', 'none'
%                    Default: 'biased'
%   * subtract_mean -- (optional) flag whether to subtract mean
%                    (numeric Boolean).
%                    Default: 1 = subtract mean
%   * method      -- (optional) method used to calculate ACVS (character string).
%   * dim         -- (optional) dimension to compute ACVS along (integer).
%                    Default: 1 or first non-singular dimension.
%
% OUTPUTS
%   * ACVS        -- autocovariance sequence (ACVS) (vector or matrix).
%
% SIDE EFFECTS
%   X is a real; otherwise error.
%   X is a vector or matrix; otherwise error.
%
% DESCRIPTION
%   wmtsa_acvs calculates the autocovariance sequence (ACVS) for a real valued
%   series.
% 
%   By default, the function calculates the ACVS over the first non-singleton
%   dimension.  For the current implementation X must be a vector or matrix, 
%   higher order arrays not handled. If X is a vector, ACVS is returned with 
%   dimensions as X.  If X is a matrix, ACVS is calculated for the columns.
%   If input argument 'dim' is supplied, the ACVS is calculated over that dim.
%   
%   The estimator option normalizes the ACVS estimate as follows:
%   * 'biased'   -- divide by N
%   * 'unbiased' -- divide by N - tau
%   * 'none'     -- unnormalized.
%
%   The 'subtract_mean' input argument specifies whether to subtract
%   the mean from the prior to calculating the ACVS. The default is to
%   subtract them mean.
%
%   The 'method' input argument specifies the method used to calculate
%   the ACVS:
%   * 'lag'     -- Calculate taking lag products.
%   * 'fft'     -- Calculate via FFT.
%   * 'xcov'    -- Calculate via xcov function.
%   The default is 'fft'.
%
% ERRORS
%   WMTSA:InvalidNumArguments, WMTSA:InvalidArgumentDataType,
%   WMTSA:InvalidArgumentValue 
%
% EXAMPLE
%
%
% ALGORITHM
%   See page 266 of WMTSA for definition of ACVS.
%   See page 269 of WMTSA for definition of biased ACVS estimator.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%
%

% AUTHOR
%   Charlie Cornish
%   Brandon Whitcher
%
% CREATION DATE
%   2003-04-23
%
% CREDIT
%   Based on original function myACF.m by Brandon Whitcher.
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: wmtsa_acvs.m 612 2005-10-28 21:42:24Z ccornish $
  
valid_estimator_methods = {'biased', 'unbiased', 'none'};
defaults.estimator = 'biased';
defaults.subtract_mean = 1;
defaults.method = 'fft';

usage_str = ['Usage:  [ACVS] = ', mfilename, ...
             '(X, [estimator], [subtract_mean], [method], [dim])'];

%%   Check Input Arguments
error(nargerr(mfilename, nargin, [1:5], nargout, [0:1], 1, usage_str, 'struct'));

set_defaults(defaults);

error(argterr(mfilename, X, {'real', 'matrix'}, [], 1, '', 'struct'));

if (wmtsa_isscalar(X))
  % Trival case
  ACVS = 0;
  return
end

if (isempty(strmatch(estimator, valid_estimator_methods, 'exact')))
  error('WMTSA:invalidArgumentValue', ...
        ['Invalid value for estimator argument (, ', estimator, ')']);
end

switch method
 case 'lag'
  fhACVS = @acvs_lag;
 case 'fft'
  fhACVS = @acvs_fft;
 case 'xcov'
  fhACVS = @acvs_xcov;
 otherwise
    error('WMTSA:invalidArgumentValue', ...
          ['Unknown method (', method, ') for calculating ACVS.']);
end

sz = size(X);
if ( wmtsa_isvector(X) || (~exist('dim', 'var') || isempty(dim)) )
  dim = min(find(sz ~= 1));
end

N = sz(dim);
ACVS = zeros(size(X));

if (subtract_mean)
  sz_repmat = repmat(1, size(sz));
  sz_repmat(dim) = sz(dim);
  X = X - repmat(sum(X,dim)/sz(dim), sz_repmat);
end


% dim is the dimension to calculate the ACVS along.
% odim is the other dimension.

odim = (dim == 1 ) + 1;
idx{dim} = ':';
for (i = 1:sz(odim))
  idx{odim} = i;
  ACVS(idx{:}) = feval(fhACVS, X(idx{:}));
end
  
switch lower(estimator)
 case 'biased'
  ACVS = ACVS / N;
 case 'unbiased'
  sz_reshape = repmat(1, size(sz));
  sz_reshape(dim) = sz(dim);
  tau = reshape([0:sz(dim)-1], sz_reshape);
  other_dim = mod(dim,2)+1;
  sz_repmat = repmat(1, size(sz));
  sz_repmat(other_dim) = sz(other_dim);
  tau = repmat(tau, sz_repmat);

  ACVS = ACVS ./ (N - tau);
 case 'none'
  % do nothing
 otherwise
  error('WMTSA:invalidArgumentValue', ...
        [estimator, ' is not a valid estimator.']);
end

% Negative -tau values = +tau values
idx{dim} = [2:N];
idx{odim} = ':';
ACVS = cat(dim, flipdim(ACVS(idx{:}),dim), ACVS);

return

function ACVS = acvs_lag(x)
  x = x(:);
  N = length(x);
  for (itau = 0:N-1)
    ACVS(itau+1) = sum(x(1:N-itau) .* x(1+itau:N));
  end  
return
  
function ACVS = acvs_fft(x)
  x = x(:);
  N = length(x);
  X = fft(x, 2^nextpow2(2*N-1));
  ACVS = real(ifft(X .* conj(X)));
  ACVS = ACVS(1:N);
return

function ACVS = acvs_xcov(x)

% Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end

  x = x(:);
  N = length(x);
  ACVS = xcov(x);
  ACVS = ACVS(N:2*N-1);
return
