function haxes = plot_wvar_psd(f, CJ, f_band, CI_CJ, mode, LineSpec, axes_scale, axesProp)
% plot_wvar_psd -- Plot power spectral density (PSD) estimated from wavelet variance.
%
%****f* wmtsa.dwt/plot_wvar_psd
%
% NAME
%   plot_wvar_psd -- Plot band-averaged power spectral density (PSD) 
%     estimated from wavelet variance.
%
% SYNOPSIS
%   haxes = plot_wvar_psd(f, CJ, f_band, CI_CJ, mode, LineSpec)
%
% INPUTS
%   f            = center frequency (geometric mean) of octave band.
%                  (Jx1 vector)
%   CJ           = estimate of average of power spectral density per octave band.
%                  (Jx1 vector)
%   f_band       = (optional) lower and upper bounds of frequency octave band,
%                  (Jx2 vector)
%   CI_CJ        = (optional) confidence interval of power spectral density estimate,
%                  (Jx2 array), lower bound (row 1) and upper bound (row 2).
%   mode         = (optional) type of plot
%                  Valid values:  'point', 'staircase', 'box'
%                  Default value: 'point'
%   LineSpec     = (optional) LineSpec string
%   axes_scale   = (optional) Type of axes scale to use
%                  Valid values:  'linear', 'loglog', 'semilogx', 'semilogy'
%                  Default value: 'loglog'
%   axesProp     = (optional) structure containing name-value pairs of axes
%                  properties to override (see axes).
%
% OUTPUTS
%  haxes         = handle to plot axes
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   plot_wvar_psd plots the MODWT estimate (CJ) of the spectral density
%   function (SDF) average on a log-log axes.  The function plots the SDF 
%   for the follwing  modes:
%     - 'point'     = plots as points the average value of the SDF at the
%                     geometric mean of the octave frequency band.
%     - 'line'      = plots as a line the average value of the SDF at the 
%                     geometric mean of the octave frequency band.
%     - 'staircase' = plots the average value of SDF as a series of staircase
%                     with step width equal to width of the octave frequency
%                     band.
%     - 'box'       = plots an uncertainity box whose dimensions are the 
%                     octave frequency band (width) and confidence interval
%                     of CJ.
%
% EXAMPLE
%   [WJt, VJ0t] = modwt(X, 'la8', 10, 'reflection');
%   [wvar, CI_wvar] = modwt_wvar(WJt);
%   [f, CJ, f_band, CI_CJ] = modwt_wvar_sdf(wvar, delta_t, CI_wvar);
%   plot_wvar_psd(f, CJ, '', '', 'point');
%   hold on;
%   plot_wvar_psd(f, CJ, f_band, '', 'staircase');
%   hold on;
%   plot_wvar_psd(f, CJ, f_band, CI_CJ, 'box');
%
% WARNINGS
%
%
% ERRORS
%
%
% NOTES
%   1. For 'staircase' mode, f_band is a required input argument.
%   2. For 'box' mode, f_band and CI_CJ are required input arguments.
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
%   2003-11-12
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

%   $Id: plot_wvar_psd.m 612 2005-10-28 21:42:24Z ccornish $

valid_modes = {'point', 'line', 'staircase', 'box'};
valid_axes_scales = {'linear', 'semilogx', 'semilogy', 'loglog'};

default_mode = 'point';
default_axes_scale = 'loglog';
  
usage_str = ['Usage:  [haxes] = ', mfilename, ...
             '(f, CJ, [f_band], [CI_CJ], [mode], [LineSpec], [axes_scale], ' ...
             '[axesProp])'];

%%  Check input arguments and set defaults.
error(nargerr(mfilename, nargin, [2:8], nargout, [0:1], 1, usage_str, 'struct'));


if (~exist('mode', 'var') || isempty(mode))
  mode = default_mode;
end

if (~exist('axes_scale', 'var') || isempty(axes_scale))
  axes_scale = default_axes_scale;
end

switch mode
 case 'point'
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = '*';
  end
 case 'line'
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = '-';
  end
 case 'staircase'
  if (~exist('f_band', 'var') || isempty(f_band))
    error(['Must supply f_band input argument for staircase mode']);
  end
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = '-';
  end
 case 'box'
  if (~exist('f_band', 'var') || isempty(f_band))
    error(['Must supply f_band input argument for box mode']);
  end
  if (~exist('CI_CJ', 'var') || isempty(CI_CJ))
    error(['Must supply CI_CJ input argument for box mode']);
  end
  if (~exist('LineSpec', 'var') || isempty(LineSpec))
    LineSpec = 'k-';
  end
 otherwise
  error(['Unknown mode']);
end

switch lower(axes_scale)
 case 'linear'
  fname = 'plot';
 case {'loglog', 'semilogx', 'semilogy'}
  fname = axes_scale;
 otherwise
  error(['Unknown axes scaled']);
end

fhandle = str2func(fname);

J = length(CJ);

% Note:  wvar_psd is order by j-level (decreasing f).
% Sort and order by increasing frequency
[f_asc, asc_indx] = sort(f);
CJ_asc = CJ(asc_indx);

if (exist('f_band', 'var') && ~isempty(f_band))
  f_band_asc = f_band(asc_indx,:);
end

if (exist('CI_CJ', 'var') && ~isempty(CI_CJ))
  CI_CJ_asc = CI_CJ(asc_indx,:);
end

switch mode
 case 'point'
  feval(fhandle, f_asc, CJ_asc, LineSpec);
 case 'line'
  feval(fhandle, f_asc, CJ_asc, LineSpec);
 case 'staircase'
  f_sc = [];
  CJ_sc = [];
  for (j = 1:J)
    jj = 2*(j-1) + 1;
    f_sc(jj) = f_band_asc(j,1);
    f_sc(jj+1) = f_band_asc(j,2);
    CJ_sc(jj) = CJ_asc(j);
    CJ_sc(jj+1) = CJ_asc(j);
  end
  feval(fhandle, f_sc, CJ_sc, LineSpec);
 case 'box'
  for (j = 1:J)
    box_line{j} = [f_band_asc(j,1), CI_CJ_asc(j,1); ...
                   f_band_asc(j,2), CI_CJ_asc(j,1); ...
                   f_band_asc(j,2), CI_CJ_asc(j,2); ...
                   f_band_asc(j,1), CI_CJ_asc(j,2); ...
                   f_band_asc(j,1), CI_CJ_asc(j,1); ];
  end

  arg_str = '';
  comma = '';
  for (j = 1:J)
    arg_str = [arg_str, comma, ...
               ['box_line{', num2str(j), '}(:,1), '], ...
               ['box_line{', num2str(j), '}(:,2), '], ...
               'LineSpec'];
    comma = ', ';
  end
  arg_str = [fname, '( ', arg_str, ');'];
  eval(arg_str);

end

ha = gca;

if (exist('axesProp', 'var') && ~isempty(axesProp))
  ha = set_axes_prop(ha, axesProp);
end

if (nargout > 0)
  haxes = ha;
end

return
