function [haxes, hlines] = plot_filter_sgf(transform, wtfname, nlevels, f, figtitle_str, ...
                                           plotOpts)
% plot_filter_sgf -- Plot squared gain functions for specified transform, wavelet filter, levels and frequencies.
%
%****f* wmtsa.dwt/plot_filter_sgf
%
% NAME
%   plot_filter_sgf -- Plot squared gain functions for 
%           specified transform, wavelet filter, levels and frequencies.
%
% SYNOPSIS
%   [haxes, hlines] = plot_filter_sgf(transform, wtfname, nlevels, [f], [title_str]...
%                                     [plotOpts])
%
% INPUTS
%   transform    =  transform (DWT or MODWT) to plot
%   wtfname      =  character string or cell array of strings containing name(s)
%                   of a supported (MO)DWT scaling filter.
%   nlevels      =  maximum level of scale to plot.
%   f            =  (optional) array of sinsuoidal frequencies
%   figtitle_str = (optional) string contanining name of title of figure.
%   plotOpts     = (optional) structure containing plotting options.
%
% OUTPUTS
%   haxes        = vector of handles to axes drawn.
%   hlines       = vector of handles to lines drawn for equivalent filters.
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
% NOTES
%
%
% SEE ALSO
%
%


% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2003/11/02
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
  
% $Id: plot_filter_sgf.m 612 2005-10-28 21:42:24Z ccornish $

  LineSpecList = {'r:', 'g-', 'b--'};
  
  default_plotOpts.PlotLegend = 1;
  default_plotOpts.PlotFband = 1;
  default_plotOpts.LabelYAxis = 1;
  
  usage_str = ['Usage:  [haxes, hlines] = ', mfilename, ...
               '(transform, wtfname, nlevels, [f], ', ...
               '[figtitle_str], [plotOpts])'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [3:7], nargout, [0:2], 1, usage_str, 'struct'));

  if (iscell(wtfname))
    wtfname_list = wtfname;
  else
    wtfname_list = {wtfname};
  end
  
  num_wtfnames = length(wtfname_list);
  
  error(argterr(mfilename, nlevels, 'posint', [], 1, '', 'struct'));
  
  J0 = nlevels;
  
  if (~exist('f', 'var') || isempty(f))
    f = [0:.001:.5];
  end
  
  if (~exist('plotOpts', 'var') || isempty(plotOpts))
    plotOpts = default_plotOpts;
  else
    fields = fieldnames(default_plotOpts);
    for (i = 1:length(fields))
      field = fields{i};
      if (isfield(plotOpts, field))
        % Do nothing
      else
        plotOpts.(field) = default_plotOpts.(field);
      end
    end
  end
  
  if (isfield(plotOpts, 'LineSpecList'))
    if (length(plotOpts.LineSpecList) ~= length(wtfname_list))
      error('Length of plotOpts.LineSpecList must equal length wtfname list');
    end
    use_LineSpec = 1;
  else
    use_LineSpec = 0;
  end
  
  
  switch lower(transform)
   case {'wdwt', 'dwt'}
    hWaveletFunc = @dwt_wavelet_sgf;
    hScalingFunc = @dwt_scaling_sgf;
    wavelet_sgf_symbol = 'H';
    scaling_sgf_symbol = 'G';
    scale_factor = 1;
   case 'modwt'
    hWaveletFunc = @modwt_wavelet_sgf;
    hScalingFunc = @modwt_scaling_sgf;
    wavelet_sgf_symbol = 'Ht';
    scaling_sgf_symbol = 'Gt';
    scale_factor = 1/2;
   otherwise
    error(['Unknown transform (', transform, ')']);
  end
  
  nfreq = length(f);
  J0 = nlevels(end);
  
  HsJ_list = {};
  GsJ0_list = {};
  
  for (i = 1:length(wtfname_list))
  
    HsJ  = zeros(nfreq, J0);
    GsJ0 = zeros(nfreq, 1);
  
    for (j = 1:J0)
      Hsj = feval(hWaveletFunc, f, wtfname_list{i}, j);
      HsJ(:,j) = Hsj(:);
      fband(1,j) = 1 / 2^(j+1);
      fband(2,j) = 1 / 2^(j);
    end
  
    GsJ0 = feval(hScalingFunc, f, wtfname_list{i}, J0);
    
    HsJ_list{i} = HsJ;
    GsJ0_list{i} = GsJ0;
  end
  
  nsubplots = J0 + 1;
  
  ha_list = [];
  hl_list = [];
  
  iplot = 1;
  ha = subplot(nsubplots, 1, 1);
  ha_list = [ha_list, ha];
  set(ha, 'Tag', 'GsJ0');
  
  arg_str = '';
  for (i = 1:length(wtfname_list))
    if (i == 1)
      conj = '';
    else
      conj = ', ';
    end
    GsJ0_str = ['GsJ0_list{', int2str(i), '}'];
    arg_str = [arg_str, conj, 'f, ', GsJ0_str];
  
    if use_LineSpec
      arg_str = [arg_str, ', ', 'plotOpts.LineSpecList{', int2str(i), '}'];
    end
  end
  
  eval_str = ['hl = plot( ', arg_str, ');'];
  eval(eval_str);
  hl_list = [hl_list; hl];
  
  hold on;
  
  if (plotOpts.PlotLegend)
    legend(wtfname_list, 0);
  end
  
  ymax = 2^J0 * scale_factor^J0;
  set(gca, 'YLim', [0,ymax]);
  set(gca, 'YTick', [0,ymax]);
  set(gca, 'YTickLabel', [0,ymax]);
  
  if (plotOpts.PlotFband)
    YLim = get(gca,'YLim');
    ymax = YLim(2);
    fscaling = 1 / 2^(J0+1);
    hl = stem([fscaling], [ymax], 'r-');
    set(hl(1), 'Visible', 'off');
    hl_list = [hl_list; hl];
  end
  
  
  XLim = get(ha, 'XLim');
  set(gca, 'XTickLabel', []);
  
  if (plotOpts.LabelYAxis)
    ylabel_str = ['\sl', scaling_sgf_symbol, '\rm_{', num2str(J0), '}(\bullet)'];
    hText(iplot) = ylabel(ylabel_str, ...
                          'Rotation', 0, ...
                          'VerticalAlignment', 'middle', ...
                          'HorizontalAlignment', 'left');
  end
  
  title_str = ['Level ', num2str(J0), ' Scaling'];
  title(title_str);
  
  
  for (j = J0:-1:1)
    iplot = iplot + 1;
    ha = subplot(nsubplots, 1, iplot);
    ha_list = [ha_list, ha];
    set(ha, 'Tag', ['HsJ', '_', int2str(j)]);
  
    arg_str = '';
    for (i = 1:length(wtfname_list))
      if (i == 1)
        conj = '';
      else
        conj = ', ';
      end
  
      HsJ_str = ['HsJ_list{', num2str(i), '}(:,', int2str(j), ')'];
      arg_str = [arg_str, conj, 'f, ', HsJ_str];
  
      if use_LineSpec
        arg_str = [arg_str, ', ', 'plotOpts.LineSpecList{', int2str(i), '}'];
      end
    end
    
    eval_str = ['hl = plot( ', arg_str, ');'];
    eval(eval_str);
    hl_list = [hl_list; hl];
    
    hold on;
    ymax = 2^j * scale_factor^j;
    set(gca, 'YLim', [0,ymax]);
    set(gca, 'YTick', [0,ymax]);
    set(gca, 'YTickLabel', [0,ymax]);
  
    if (plotOpts.PlotFband)
      if (j == 1)
        hl = stem([fband(1,j)], [ymax], 'r-');
      else
        hl = stem([fband(1,j), fband(2,j)], [ymax, ymax], 'r-');
      end
      set(hl(1), 'Visible', 'off');
      hl_list = [hl_list; hl];
    end
  
    if (plotOpts.LabelYAxis)
      ylabel_str = ['\sl', wavelet_sgf_symbol, '\rm_{', num2str(j), '}(\bullet)'];
      hText(iplot) = ylabel(ylabel_str, ...
                            'Rotation', 0, ...
                            'VerticalAlignment', 'middle', ...
                            'HorizontalAlignment', 'left');
    end
    
    if (iplot == nsubplots)
      xlabel('\it{f}');
    else
      set(gca, 'XTickLabel', []);
    end
  
    title_str = ['Level ', num2str(j), ' Wavelet'];
    title(title_str);
    
  end
  
  if (plotOpts.LabelYAxis)
    Position_Text = get(hText(nsubplots), 'Position');
    ylabel_str_offset = abs(Position_Text(1)) / 2;
  
    for (i = 1:length(hText));
      Position = get(hText(i), 'Position');
      Position(1) =  XLim(2) + ylabel_str_offset;
      set(hText(i), 'Position', Position);
    end
  end
  
  
  % suptitle(title_str);
  
  if (~exist('title_str', 'var'))
    wtfname_str = wtfname_list{1};
    for (i = 2:length(wtfname_list))
      wtfname_str = [wtfname_str, ',  ', wtfname_list{i}];
    end
    wtfname_str = [wtfname_str, ' Filters'];
    title_str = { ...
        ['Squared Gain Function'], ...
        [upper(transform)], ...
        [upper(wtfname_str)], ...
      };
  end
  
  if (exist('figuretitle_str', 'var') && ~isempty(figtitle_str))
    suptitle(figtitle_str);
  end
  
  
  if (nargout > 0)
    haxes = ha_list;
  end
  
  if (nargout > 1)
    hlines = hl_list;
  end
  
return
