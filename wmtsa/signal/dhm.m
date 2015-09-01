function Y_t = dhm(s_X, Z)
% dhm -- Generate simulation of stationary process using Davies-Harte method.
%
%****f* wmtsa.signal/dhm
%
% NAME
%   dhm -- Generate simulation of stationary process using Davies-Harte method.
%
% SYNOPSIS
%   Y_t = wmtsa_gen_stationary_process(s_X, Z)
%
% INPUTS
%   * s_X         -- ACVS of SDF of process (M lags, D deltas).
%   * Z           -- N sets M IID Gaussian RVs.
%
% OUTPUTS
%   * Y_t         -- simulated time series.
%
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
%
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: dhm.m 612 2005-10-28 21:42:24Z ccornish $

  
usage_str = ['Usage:  [Y_t] = ', mfilename, ...
             '(s_X, Z)'];
  
[err_id, errmsg] =  nargerr(mfilename, nargin, [2:2], nargout, [0:1], 1, usage_str);
if (err_id)
  error('WMTSA:InvalidNumArguments', errmsg);
end


if (wmtsa_isvector(Z))
  Z = Z(:);
end

if (wmtsa_isvector(s_X))
  s_X = s_X(:);
end

if (length(s_X) ~= length(Z))
  error('s_X and Z must have same number of rows');
end


% Davies-Harte method (DHM)

[M, ndelta] = size(s_X);
[M2, nsets] = size(Z);

Y_k = repmat(NaN, size(s_X));

dim = 1;

% Step 1:  Compute SDF of half of sdf sereis
s = cat(dim, s_X(1:M/2+1,:), flipdim(s_X(2:M/2,:), dim));


S_k = fft(s, [], dim);
ZZ = repmat(Z, [1, ndelta]);

% Step 2:  Check that S_k > 0
if (~isempty(find(S_k < 0)))
  error('Davies-Harte method:  S_k must be >= 0 for all k');
end

% Step 3:  Compute complex-valued sequence Y_k


% k = 0 
Y_k(1,:) = ZZ(1,:) .* sqrt(M * S_k(1,:));

% 1 =< k < M/2
k = [1:(M/2)-1];
kk = k + 1;
Y_k(kk,:) = (ZZ(2*k,:) .* (i * ZZ(2*k+1,:))) .* sqrt( (M/2) * S_k(kk,:));

% k = M/2
kk = (M/2) + 1;
Y_k(kk,:) = ZZ(M,:) .* sqrt(M * S_k(kk,:));

% M/2 < k <= M-1
k = [(M/2)+1:M-1];
kk = k + 1;
kkk = M - k + 1;
Y_k(kk,:) = conj(Y_k(kkk,:));

% Step 4:  Do inverst FFT
Y_t = real(ifft(Y_k, '', 1));
  
return

