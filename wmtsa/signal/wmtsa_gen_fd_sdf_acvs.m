function s_X = wmtsa_gen_fd_sdf_acvs(N, delta, sigma_squared)
% wmtsa_gen_fd_sdf_acvs -- Generate the ACVS from the SDF of fractionally difference (FD) process.
%
%****f* wmtsa.signal/wmtsa_gen_fd_sdf_acvs
%
% NAME
%   wmtsa_gen_fd_sdf_acvs -- Generate the ACVS from the SDF of fractionally difference (FD) process.
%
% SYNOPSIS
%   s_X = wmtsa_gen_fd_sdf_acvs(N, delta, sigma_squared)
%
% INPUTS
%   * N           -- number of data points in series (integer).
%   * delta       -- long memory parameter for FD process (vector).
%   * sigma_squared -- (optional) process variance.
%                    Default:  1
%
% OUTPUTS
%   * s_X         -- ACVS of SDF of FD process (2*N+1 x length(delta) array).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   For given delta(s) and series length N, function calculates the 
%   autocovariance sequence (ACVS) of the spectral density function (SDF)
%   of a fractionally differenced (FD) process.
%
%   delta may be vector of values in the range -1 =< delta < 0.5.
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

%   $Id: wmtsa_gen_fd_sdf_acvs.m 612 2005-10-28 21:42:24Z ccornish $

defaults.sigma_squared = 1;
  
usage_str = ['Usage:  [s_X] = ', mfilename, ...
             '(N, delta, [sigma_squared])'];
  
[err_id, errmsg] =  nargerr(mfilename, nargin, [2:3], nargout, [0:1], 1, usage_str);
if (err_id)
  error('WMTSA:InvalidNumArguments', errmsg);
end


if (~exist('sigma_squared', 'var') || isempty(sigma_squared))
  sigma_squared = defaults.sigma_squared;
end

s_X = FD_sdf_acvs(N, delta, sigma_squared);


return

function s_X = FD_sdf_acvs(N, delta, sigma_squared)

  % Make delta into a row vector
  delta = reshape(delta, [1, length(delta)]);

  % Make s_X into a N x length(delta) matrix
  s_X = zeros(N, length(delta));
  
%  s_X(1,:) = sigma_squared * (gamma(1-2*delta) ./ gamma(1-delta).^2);
  s_X(1,:) = 1 * sigma_squared;
  
  % Equation 284d
  for (itau = 2:N)
    tau = itau - 1;
    s_X(itau,:) = s_X(itau-1,:) .* (tau + delta - 1) ./ (tau - delta);
  end
  
  % s_X is real-valued and symmeteric, i.e. s_X(-tau) = s_X(tau)
  dim = 1;
  s_X = cat(dim, flipdim(s_X(2:N,:),dim), s_X);
  
return
  
  
