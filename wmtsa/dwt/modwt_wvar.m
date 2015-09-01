function [wvar, CI_wvar, edof, MJ, wvar_att] = modwt_wvar(WJt, ci_method, estimator, ...
                                                      wtfname, p, w_att)
% modwt_wvar -- Calculate wavelet variance of MODWT wavelet coefficients.
%
%****f* wmtsa.dwt/modwt_wvar
%
% SYNOPSIS
%   modwt_wvar -- Calculate wavelet variance of MODWT wavelet coefficients.
%
% SYNOPSIS
%   [wvar, CI_wvar] = modwt_wvar(WJt, [ci_method], [estimator], [wavelet], [p], [w_att])
%
% INPUTS
%   WJt          = MODWT wavelet coefficients (NxJ array).
%                  where N = number of time intervals
%                        J = number of levels
%   ci_method    = (optional) method for calculating confidence interval
%                  valid values:  'gaussian', 'chi2eta1', 'chi2eta3'
%                  default: 'chi2eta3'
%   estimator    = (optional) type of estimator
%                  valid values:  'biased', 'unbiased', 'weaklybiased'
%                  default: 'biased'
%   wtfname      = (optional) name of wavelet filter (string, case-insensitive).
%                   required for 'biased' and 'weaklybiased' estimators.
%   p            = (optional) percentage point for chi2square distribution.
%                  default: 0.025 ==> 95% confidence interval
%   w_att
%
% OUTPUTS
%   wvar         = wavelet variance (Jx1 vector).
%   CI_wvar      = confidence interval of wavelet variance (Jx2 array).
%                  lower bound (column 1) and upper bound (column 2).
%   edof         = equivalent degrees of freedom (Jx1 vector).
%   MJ           = number of coefficients used calculate the wavelet variance at
%                  each level (integer).
%   wvar_att     = structure containing MODWT wavelet variance attributes
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
% ERRORS  
%   WMTSA:InvalidNumArguments
%   WMTSA:WVAR:InvalidCIMethod
%   WMTSA:WVAR:InvalidEstimator
%   WMTSA:WaveletArgumentRequired
%
% NOTES
%   MJ is vector containing the number of coefficients used to calculate the 
%   wavelet variance at each level. 
%   For the unbiased estimator, MJ = MJ for j=1:J0, where MJ is the number 
%   of nonboundary MODWT coefficients at each level.
%   For the biased estimator, MJ = N for all levels.
%   For the weaklybiased estimator, MJ = MJ(Haar), for j=1:J0, where MJ(Haar) 
%   is the number of nonboundary MODWT coefficients for Haar filter at each level.
%
% ALGORITHM
%   See section 8.3 of WMTSA on page 306.
%   For unbiased estimator of wavelet variance, see equation 306b. 
%   For biased estimator of wavelet variance, see equation 306c. 
%
%
% REFERENCES
%   Percival, D. B. and A. T. Walden (2000) Wavelet Methods for
%     Time Series Analysis. Cambridge: Cambridge University Press.
%   
% SEE ALSO
%   modwt_wvar_ci
%
% TOOLBOX
%   wmtsa/wmtsa
%
% CATEGORY
%   ANOVA:WVAR:MODWT
%

% AUTHOR
%   Charlie Cornish
%   Brandon Whitcher
%
% CREATION DATE
%   2003-04-23
%
% CREDITS
%   Based on original function wave_var.m by Brandon Whitcher.
%
% COPYRIGHT
%
%
% REVISION
%   $Revision: 612 $
%
%***

% $Id: modwt_wvar.m 612 2005-10-28 21:42:24Z ccornish $

valid_ci_methods = {'gaussian', 'chi2eta1', 'chi2eta3', 'none'};
valid_estimator_methods = ...
    {'unbiased', 'unbiased-f', 'unbiased-b', 'unbiased-fb', ...
     'biased', 'biased-f', 'biased-b', 'biased-fb', ...
     'weaklybiased', 'weaklybiased-f', 'weaklybiased-b', 'weaklybiased-fb', ...
     'weaklybiased-test', 'none'};

default_ci_method = 'chi2eta3';
default_estimator = 'biased';
default_p = 0.025;

usage_str = ['[wvar, CI_wvar, edof, MJ, wvar_att] = ', mfilename, ...
             '(WJt, [ci_method], [estimator], [wtfname], [p], [w_att])'];
  
%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [1:6], nargout, [0:5], 1, usage_str, 'struct'));

if (~exist('ci_method', 'var') ||isempty(ci_method))
  if (nargout < 2)
    ci_method = 'none';
  else
    ci_method = default_ci_method;
  end
else
  if (isempty(strmatch( ci_method, valid_ci_methods, 'exact')))
    error('WMTSA:WVAR:InvalidCIMethod', ...
          [ci_method, ' is not a valid confidence interval method.']);
  end
end

if (~exist('wtfname', 'var') || isempty(wtfname))
  wtfname = '';
end

if (~exist('estimator', 'var') || isempty(estimator))
  estimator = default_estimator;
else
  if (isempty(strmatch(estimator, valid_estimator_methods, 'exact')))
    error('WMTSA:WVAR:InvalidEstimator', ...
          [estimator, ' is not a valid estimator.']);
  end
  
  if (strmatch(estimator, {'unbiased', 'weaklybiased'}, 'exact'))
    if (~exist('wtfname', 'var') || isempty(wtfname))
      error('WMTSA:MissingRequiredArgument', ...
            wmtsa_encode_errmsg('WMTSA:MissingRequiredArgument', ...
                        'wtfname', ...
                       [' when specifying estimator (', estimator,').']));
    end
  end
end

if (~exist('p', 'var') || ~isempty(p))
  p = default_p;
end


if (strcmp(ci_method, 'none'))
  calc_ci = 0;
else
  calc_ci = 1;
end

if (strcmp(estimator,'unbiased-fb') || ...
    strcmp(estimator,'unbiased-b') || ...
    strcmp(estimator,'biased-fb') || ...
    strcmp(estimator,'biased-b') || ...
    strcmp(estimator,'weaklybiased-fb') || ...
    strcmp(estimator,'weaklybiased-b'))
  if (~exist('w_att', 'var') || isempty(w_att))
    error(['w_att argument required for ', estimator, ' estimator']);
  elseif ~(strcmp(w_att.boundary, 'reflection'))
    error(['MODWT Must use reflection BCs for ', estimator, ' estimator']);
  end
end

sz = size(WJt);
if (exist('w_att', 'var') && ~isempty(w_att))
  wavelet = w_att.wavelet;
  NX = w_att.NX;
  NW = w_att.NW;
  J = w_att.J0;
  boundary = w_att.Boundary;
else
  N = sz(1);
  NX = N;
  J = sz(2);
  boundary = '';
end


if (ndims(WJt) > 2)
  nsets = sz(3);
else
  nsets = 1;
end

  
% Initialize output arguments

MJ = zeros(J,1) * NaN;
wvar = zeros(J,nsets) * NaN;
CI_wvar = [];
edof = [];

switch estimator
 case {'unbiased', 'unbiased-f'}
  % Unbiased estimator of wavelet variance (equation 306b)
  % Sum of squares of coefficients from L_j to N
  % For unbiased estimator, do not included wavelets coefficients affected by 
  % circularity assumption.

  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  LJ = equivalent_filter_width(L, 1:J);
  MJ = modwt_num_nonboundary_coef(wtfname, N, 1:J);
%  MJ = MJ(:);
  

  for (j = 1:J)
    wvar(j,:) = sum(WJt(LJ(j):N,j,:).^2, 1) / MJ(j);
  end
  

  if (calc_ci)
    lb = LJ;
    ub = ones(J,1) * N;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end

 case 'unbiased-b'
  % Backward unbiased estimator of wavelet variance (equation 306b)
  % Sum of squares of coefficients from L_j to N
  % For unbiased estimator, do not included wavelets coefficients affected by 
  % circularity assumption.
  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  LJ = equivalent_filter_width(L, 1:J);
  MJ = modwt_num_nonboundary_coef(wtfname, N, 1:J);
  MJ = MJ(:);

  for (j = 1:J)
    wvar(j,:) = ...
        (sum(WJt(N+LJ(j):NX,j,:).^2, 1)) /MJ(j);
  end
  

  if (calc_ci)
    error('CI method for unbiased-fb not yet implemented');
    lb = LJ;
    ub = ones(J,1) * N;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end


 case 'unbiased-fb'
  % Forward/Backward unbiased estimator of wavelet variance (equation 306b)
  % Sum of squares of coefficients from L_j to N
  % For unbiased estimator, do not included wavelets coefficients affected by 
  % circularity assumption.
  wtf_s = modwt_filter(wtfname);
  ht = wtf_s.h;
  gt = wtf_s.g;
  L = wtf_s.L;

  LJ = equivalent_filter_width(L, 1:J);
  MJ = modwt_num_nonboundary_coef(wtfname, N, 1:J);
  MJ = MJ(:);


  for (j = 1:J)
    wvar(j,:) = ...
        (sum(WJt(LJ(j):N,j,:).^2, 1) + sum(WJt(N+LJ(j):NX,j,:).^2, 1)) / (2 * MJ(j));
  end
  

  if (calc_ci)
    error('CI method for unbiased-fb not yet implemented');
    lb = LJ;
    ub = ones(J,1) * N;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end

  
 case {'biased', 'biased-f'}
  % Biased estimator of wavelet variance (equation 306c)
  % Use all coefficients.
  MJ = ones(J,1) * N;

  wvar = sum(WJt(1:N,:,:).^2,1) / N;
  wvar = reshape(wvar, [J nsets]);
%  for (j = 1:J)
%      wvar(j,i) = sum(WJt(:,j,i).^2) / N;
%  end 

  if (calc_ci)
    lb = ones(1, J);
    ub = ones(1, J) * N;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end

 case 'biased-b'
  % Backward Biased estimator of wavelet variance (equation 306c)
  % Use all coefficients.
  MJ = ones(J,1) * 2 * N;

  wvar = sum(WJt(N+1:2*N,:,:).^2,1) / N;
  wvar = reshape(wvar, [J nsets]);
%  for (j = 1:J)
%      wvar(j,i) = sum(WJt(:,j,i).^2) / N;
%  end 

  if (calc_ci)
    error('CI method for biased-fb not yet implemented');
    lb = ones(1, J);
    ub = ones(1, J) * NX;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end
  
 case 'biased-fb'
  % Forward/Backward Biased estimator of wavelet variance (equation 306c)
  % Use all coefficients.
  MJ = ones(J,1) * 2 * N;

  wvar = sum(WJt(:,:,:).^2,1) / (2 * N);
  wvar = reshape(wvar, [J nsets]);
%  for (j = 1:J)
%      wvar(j,i) = sum(WJt(:,j,i).^2) / N;
%  end 

  if (calc_ci)
%    error('CI method for biased-fb not yet implemented');
    lb = ones(1, J);
    ub = ones(1, J) * 2 * N;
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    WJt, lb, ub, p);
  end
 
 case {'weaklybiased', 'weaklybiased-f'}
  % Weakly Biased estimator
  % Use wavelet coefficients that are 1/2 the filter autocorrelation width
  % away from time series boundary.   Over half of signal contribution comes
  % from coefficients within autocorrelation width.
  % This is less retrictive than unbiased estimator but more so biased one.
  % This is equivalent to using circular shifting wavelet coefficients for
  % time alignment and then not including boundary coefficients for Haar
  % filter, since L_j = w_a_j for Haar.

  nuHJ = advance_wavelet_filter(wtfname, 1:J);
  acw = filter_autocorrelation_width(wtfname, 1:J);
  
  % For weaklybiased, MJ is same as modwt_num_nonboundary_coef('haar', N, 1:J);
  MJ = modwt_num_nonboundary_coef('haar', N, 1:J);
%  MJ = MJ(:);

  lb = acw / 2;
  ub = N - acw / 2;

  for (j = 1:J)
    shiftsize = [1, nuHJ(j), 1];
    TWJt(:,j,:) = circshift(WJt(:,j,:), shiftsize);
    if (MJ(j) > 0)
      wvar(j,:) = (sum(TWJt(lb(j):ub(j),j,:).^ 2, 1)) / MJ(j);
    else
      wvar(j,nsets) = NaN;
    end
  end
  
  if (calc_ci)
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    TWJt, lb, ub, p);
  end

 case 'weaklybiased-b'
  % Backward Weakly Biased estimator
  % Use wavelet coefficients that are 1/2 the filter autocorrelation width
  % away from time series boundary.   Over half of signal contribution comes
  % from coefficients within autocorrelation width.
  % This is less retrictive than unbiased estimator but more so biased one.
  % This is equivalent to using circular shifting wavelet coefficients for
  % time alignment and then not including boundary coefficients for Haar
  % filter, since L_j = w_a_j for Haar.

  nuHJ = advance_wavelet_filter(wtfname, 1:J);
  acw = filter_autocorrelation_width(wtfname, 1:J);
  
  % For weaklybiased, MJ is same as modwt_num_nonboundary_coef('haar', N, 1:J);
  MJ = modwt_num_nonboundary_coef('haar', N, 1:J);
%  MJ = MJ(:);

  lb = acw / 2;
  ub = N - acw / 2;

  for (j = 1:J)
    shiftsize = [1, nuHJ(j), 1];
    TWJt(:,j,:) = circshift(WJt(:,j,:), shiftsize);
    if (MJ(j) > 0)
      wvar(j,:) = ...
           sum(TWJt(lb(j)+N:ub(j)+N,j,:).^ 2, 1) / MJ(j);
    else
      wvar(j,nsets) = NaN;
    end
  end
  
  if (calc_ci)
    error('CI method for weaklybiased-fb not yet implemented');
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    TWJt, lb, ub, p);
  end
  
 case 'weaklybiased-fb'
  % Forward/Backward Weakly Biased estimator
  % Use wavelet coefficients that are 1/2 the filter autocorrelation width
  % away from time series boundary.   Over half of signal contribution comes
  % from coefficients within autocorrelation width.
  % This is less retrictive than unbiased estimator but more so biased one.
  % This is equivalent to using circular shifting wavelet coefficients for
  % time alignment and then not including boundary coefficients for Haar
  % filter, since L_j = w_a_j for Haar.

  nuHJ = advance_wavelet_filter(wtfname, 1:J);
  acw = filter_autocorrelation_width(wtfname, 1:J);
  
  % For weaklybiased, MJ is same as modwt_num_nonboundary_coef('haar', N, 1:J);
  MJ = modwt_num_nonboundary_coef('haar', N, 1:J);
%  MJ = MJ(:);

  lb = acw / 2;
  ub = N - acw / 2;

  for (j = 1:J)
    shiftsize = [1, nuHJ(j), 1];
    TWJt(:,j,:) = circshift(WJt(:,j,:), shiftsize);
    if (MJ(j) > 0)
      wvar(j,:) = ...
          (sum(TWJt(lb(j):ub(j),j,:).^ 2, 1) + ...
           sum(TWJt(lb(j)+N:ub(j)+N,j,:).^ 2, 1)) / (2 * MJ(j));
    else
      wvar(j,nsets) = NaN;
    end
  end
  
  if (calc_ci)
    error('CI method for weaklybiased-fb not yet implemented');
    [CI_wvar, edof] = modwt_wvar_ci(wvar, MJ, ci_method, ...
                                    TWJt, lb, ub, p);
  end
 
 case 'weaklybiased-test'
  % Weakly Biased estimator
  % Use wavelet coefficients that are 1/2 the filter autocorrelation width
  % away from time series boundary.   Over half of signal contribution comes
  % from coefficients within autocorrelation width.
  % This is less retrictive than unbiased estimator but more so biased one.
  % This is equivalent to using circular shifting wavelet coefficients for
  % time alignment and then not including boundary coefficients for Haar
  % filter, since L_j = w_a_j for Haar.
  [TWJt] = modwt_cir_shift(WJt, [], wtfname);
  for (j = 1:J)
    [lbi, ubi] = modwt_cir_shift_wcoef_bdry_indices('Haar', N, j);

    lbi = lbi(find(lbi>0));
    ubi = ubi(find(ubi>0));

    TWJt(lbi, j) = NaN;
    TWJt(ubi, j) = NaN;
    wvar(j) = sum(TWJt(~isnan(TWJt(:,j)),j).^2);
%    WJt(:,j) = TWJt(:,j);
    Nt_j = sum(~isnan(TWJt(:,j)));
    if (M_j > 0)
      wvar(j) = wvar(j) / Nt_j;
    else
      wvar(j) = NaN;
    end
    MJ(1, j) = Nt_j;
  end
  WJt = TWJt;
 otherwise
  error(['Unsupported estimator (', estimator, ')']);
end


if (nargout >= 5)
  wvar_att.name = 'MODWT WVAR';
  wvar_att.ci_method = ci_method;
  wvar_att.estimator = estimator;
  wvar_att.p = p;
end

return

