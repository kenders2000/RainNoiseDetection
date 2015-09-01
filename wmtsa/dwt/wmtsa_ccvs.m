function CCVS = wmtsa_ccvs(X, Y, estimator, subtract_mean, method, dim)
% wmtsa_ccvs -- Calculate the cross covariance sequence (CCVS) of a data series.
%
%****f* wmtsa.dwt/wmtsa_ccvs
%
% NAME
%   wmtsa_ccvs -- Calculate the cross covariance sequence (CCVS) of a data series.
%
% SYNOPSIS
%   CCVS = wmtsa_ccvs(X, [dim], [estimator], [subtract_mean], [method])
%
% INPUTS
%   * X           -- set of observations (matrix or vector).
%   * Y           -- set of observations (matrix or vector).
%   * dim         -- (optional) dimension to calculate CCVS over (integer).
%   * estimator   -- (optional) type of estimator
%                    Valid values:  'biased', 'unbiased', 'none'
%                    Default: 'biased'
%   * subtract_mean -- (optional) flag whether to subtract mean
%                    (numeric Boolean).
%                    Default: 1 = subtract mean
%   * method      -- method used to calculate CCVS (character string).
%
% OUTPUTS
%   * CCVS        -- crossvariance sequence (CCVS) (vector of length N).
%
% SIDE EFFECTS
%   X, Y are real; otherwise error.
%   X, Y are vectors or matrices; otherwise error.
%
% DESCRIPTION
%   wmtsa_ccvs calculates the crosscovariance sequence (CCVS) for a real valued
%   series.
% 
%   By default, the function calculates the CCVS over the first non-singleton
%   dimension.  For the current implementation X and Y must be a vectors or
%   matrices; higher order arrays not handled.  If X and Y are a vectors, CCVS is 
%   is returned with dimensions as X.  If X and Y are matrices, CCVS is 
%   calculated for the columns. If input argument 'dim' is supplied, 
%   the CCVS is calculated over that dim.
%   
%   The estimator option normalizes the CCVS estimate as follows:
%   * 'biased'   -- divide by N
%   * 'unbiased' -- divide by N - tau
%   * 'none'     -- unnormalized.
%
%   The 'subtract_mean' input argument specifies whether to subtract
%   the mean from the prior to calculating the CCVS. The default is 1 =
%   'subtract mean'.
%
%   The 'method' input argument specifies the method used to calculate
%   the CCVS:
%   * 'lag'     -- Calculate taking lag products.
%   * 'fft'     -- Calculate via FFT.
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
%   See page 266 of WMTSA for definition of CCVS.
%   See page 269 of WMTSA for definition of biased CCVS estimator.
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%
% SEE ALSO
%   wmtsa_acvs
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

% $Id: wmtsa_ccvs.m 612 2005-10-28 21:42:24Z ccornish $
  
valid_estimator_methods = {'biased', 'unbiased', 'none'};
defaults.estimator = 'biased';
defaults.subtract_mean = 1;
defaults.method = 'fft';

usage_str = ['Usage:  [CCVS] = ', mfilename, ...
             '(X, Y, [estimator], [subtract_mean], [method], [dim])'];

%%   Check Input Arguments
error(nargerr(mfilename, nargin, [1:6], nargout, [0:1], 1, usage_str, 'struct'));

error(argterr(mfilename, X, {'real', 'matrix'}, [], 1, '', 'struct'));
error(argterr(mfilename, Y, {'real', 'matrix'}, [], 1, '', 'struct'));

if (size(X) ~= size(Y))
  error('WMTSA:invalidArgumentDim', ...
        'X and Y must same dimensions');
end  

if (wmtsa_isscalar(X))
  % Trival case
  CCVS = 0;
  return
end

if (~exist('estimator', 'var') || isempty(estimator))
  estimator = defaults.estimator;
else
  if (isempty(strmatch(estimator, valid_estimator_methods, 'exact')))
    error('WMTSA:invalidArgumentValue', ...
          [estimator, ' is not a valid estimator.']);
  end
end

if (~exist('subtract_mean', 'var') || isempty(subtract_mean))
  subtract_mean = defaults.subtract_mean;
end

if (~exist('method', 'var') || isempty(method))
  method = defaults.method;
end

switch method
 case 'lag'
  fhCCVS = @ccvs_lag;
 case 'fft'
  fhCCVS = @ccvs_fft;
 case 'xcov'
  fhCCVS = @ccvs_xcov;
 otherwise
    error('WMTSA:invalidArgumentValue', ...
          ['Unknown method (', method, ') for calculating CCVS.']);
end

sz = size(X);
if ( wmtsa_isvector(X) || (~exist('dim', 'var') || isempty(dim)) )
  dim = min(find(sz ~= 1));
end

% dim is the dimension to calculate the CCVS along.
% odim is the other dimension.

odim = (dim == 1 ) + 1;

N = sz(dim);
new_sz = sz;
new_sz(dim) = 2 * N - 1;
CCVS = zeros(new_sz);

if (subtract_mean)
  sz_repmat = repmat(1, size(sz));
  sz_repmat(dim) = sz(dim);
  X = X - repmat(sum(X,dim)/sz(dim), sz_repmat);
  Y = Y - repmat(sum(Y,dim)/sz(dim), sz_repmat);
end


idx{dim} = ':';
for (i = 1:sz(odim))
  idx{odim} = i;
  CCVS(idx{:}) = feval(fhCCVS, X(idx{:}), Y(idx{:}));
end


switch lower(estimator)
 case 'biased'
  CCVS = CCVS / N;
 case 'unbiased'
  N = sz(dim);
  NLags = 2 * N - 1;
  sz_reshape = repmat(1, size(sz));
  sz_reshape(dim) = NLags;
  tau = reshape([-N+1:1:N-1], sz_reshape);
  tau = abs(tau);
  other_dim = mod(dim,2)+1;
  sz_repmat = repmat(1, size(sz));
  sz_repmat(other_dim) = sz(other_dim);
  tau = repmat(tau, sz_repmat);
  CCVS = CCVS ./ (N - tau);
 case 'none'
  % do nothing
 otherwise
  error('WMTSA:InvalidArgumentValue', ...
        [estimator, ' is not a valid estimator.']);
end

return

function CCVS = ccvs_lag(x, y)
  x = x(:);
  y = y(:);
  N = length(x);
  CCVS = zeros(2*N-1,1);
  for (itau = 0:N-1)
    CCVS(N-itau,1) =  sum(x(1:N-itau) .* y(1+itau:N));
    CCVS(itau+N,1) = sum(x(1+itau:N) .* y(1:N-itau));
  end  
return
  
function CCVS = ccvs_fft(x, y)
  x = x(:);
  y = y(:);
  N = length(x);
  X = fft(x, 2^nextpow2(2*N-1));
  Y = fft(y, 2^nextpow2(2*N-1));
  NN = 2^nextpow2(2*N-1);
  Nlags = 2 * N - 1;
  shft = floor((NN - Nlags)/2);
  CCVS = real(ifft(X .* conj(Y)));
  CCVS = ifftshift(CCVS);
  CCVS = circshift(CCVS, -shft);
  CCVS = CCVS(2:2*N);
return

function CCVS = ccvs_xcov(x, y)
  % Requires Signal Toolbox
  result = license('test', 'Signal_Toolbox');
  if (~result)
    error('No Signal Toolbox license available to run test');
  end

  x = x(:);
  y = y(:);
  N = length(x);
  CCVS = xcov(x, y);
return
