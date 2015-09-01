function [wvar_var] = wvar_var_fd_sdf_acvs(method, wtfname, N, delta, sigma_squared, ...
                                           cov_method)
% wvar_var_fd_sdf_acvs  -- Calculate variance of wavelet variance for a FD  process for given wavelet transform filter.
%
%****f* wmtsa.signal/wvar_var_fd_sdf_acvs
%
% NAME
%   wvar_var_fd_sdf_acvs  -- Calculate variance of wavelet variance for a FD  process for given wavelet transform filter.
%
% SYNOPSIS
%
%
% INPUTS
%
%
% OUTPUTS
%
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

%   $Id: wvar_var_fd_sdf_acvs.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  [ACVS] = ', mfilename, ...
               '(method, wtfname, N, delta, [sigma_squared])'];

% Check Arguments
[err, errmsg] =  nargerr(mfilename, nargin, [4:6], nargout, [0:1], 1, usage_str);
if (err)
  error('WMTSA:InvalidNumArguments', errmsg);
end

if (~exist('sigma_squared', 'var') || isempty(sigma_squared))
  sigma_squared = 1;
end

if (~exist('cov_method', 'var') || isempty(cov_method))
  cov_method = 'fft';
end

switch method
 case 'forward'
  wvar_var = forward_wvar_var(wtfname, N, delta, sigma_squared, cov_method);
 case {'bd', 'bidirectional'}
  wvar_var = bidirectional_wvar_var(wtfname, N, delta, sigma_squared, cov_method);
 otherwise
  error(['Unknown method: ', method]);
end

  
return

function wvar_var = forward_wvar_var(wtfname, N, delta, sigma_squared, cov_method)
  [ht, gt, L, name] = dwt_filter(wtfname);
  ht = ht(:);
  
  M = N - L + 1;

  s_acvs = wmtsa_gen_fd_sdf_acvs(N, delta, sigma_squared);
  ht_acvs = wmtsa_acvs(ht, 'none', 0);
  
  if (wmtsa_ismatrix(s_acvs))
    sz = size(s_acvs);
    ht_acvs = repmat(ht_acvs, [1 sz(2)]);
  end
  
  wvar_var = zeros(1, sz(2));

  v_range = [-(L-1):(L-1)];
  u_offset_range = v_range + L;
  for tp = L-1:N-1
    for t = L-1:N-1
    
      v_offset_range = v_range + t - tp + N;

      wvar_var = wvar_var + sum((s_acvs(v_offset_range,:) .* ...
                                 ht_acvs(u_offset_range,:)), 1).^2;

    end
  end

  wvar_var = wvar_var * 2 / M^2;
  
return

function wvar_var = bidirectional_wvar_var(wtfname, N, delta, sigma_squared, cov_method)
  
  [ht, gt, L, name] = dwt_filter(wtfname);
  ht = ht(:);
  
  M = N - L + 1;

  s_acvs = wmtsa_gen_fd_sdf_acvs(N, delta, sigma_squared);

  ht_b = flipvec(ht);
  ht_acvs_ff = wmtsa_acvs(ht, 'none', 0, cov_method);
  ht_acvs_bb = wmtsa_acvs(ht_b, 'none', 0, cov_method);
  ht_acvs_fb = wmtsa_ccvs(ht, ht_b, 'none', 0, cov_method);

  if (wmtsa_ismatrix(s_acvs))
    sz = size(s_acvs);
    ht_acvs_ff = repmat(ht_acvs_ff, [1 sz(2)]);
    ht_acvs_bb = repmat(ht_acvs_bb, [1 sz(2)]);
    ht_acvs_fb = repmat(ht_acvs_fb, [1 sz(2)]);
  end

  wvar_var_ff = zeros(1, sz(2));
  wvar_var_bb = zeros(1, sz(2));
  wvar_var_fb = zeros(1, sz(2));

  v_range = [-(L-1):(L-1)];
  u_offset_range = v_range + L;
  for (tp = L-1:N-1)
    for (t = L-1:N-1)
    
      v_offset_range = v_range + t - tp + N;

      wvar_var_ff = wvar_var_ff + sum((s_acvs(v_offset_range,:) .* ...
                                       ht_acvs_ff(u_offset_range,:)), 1).^2;
      wvar_var_bb = wvar_var_bb + sum((s_acvs(v_offset_range,:) .* ...
                                       ht_acvs_bb(u_offset_range,:)), 1).^2;
      wvar_var_fb = wvar_var_fb + sum((s_acvs(v_offset_range,:) .* ...
                                       ht_acvs_fb(u_offset_range,:)), 1).^2;

    end
  end


  wvar_var = wvar_var_ff + wvar_var_bb + 2 * wvar_var_fb;
  wvar_var = wvar_var / (2 * M^2);

return
