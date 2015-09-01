function [haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W, NJ, LineSpec, title_str, axesProp, plotOpts)
% plot_dwt_vector -- Plot the vector W of DWT coefficients.
%
%****f* wmtsa.dwt/plot_dwt_vector
%
% NAME
%   plot_dwt_vector -- Plot the vector W of DWT coefficients.
%
% SYNOPSIS
%   [haxes] = plot_dwt_vector(W, NJ)
%
% INPUTS
%   W            =  vector of DWT coefficents.
%   NJ           =  (optional) vector of length J0+1 containing number of DWT 
%                   wavelet (W) and scaling (VJ0) coefficients for each level.
%   LineSpec     =  (optional) line specification for plotting.
%   title_str    =  (optional) character string or cell array of strings containing title of plot.
%   axesProp     =  (optional) structure containing name-value pairs of axes
%                   properties to override.
%   plotOpts     =  (optional) structure containing plotting options.
%
% OUTPUTS
%   haxes        =  handle to plot axes.
%   hlineDWT     =  vector containing handles to line objects plotting DWT
%                   (see stem function for details).
%   hlineBdry    =  handle to line object plotting boundaries between DWT levels.
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   
%   plotOpts contains the following fields for controlling plotting:
%     
%     labelSubvectors = a Boolean controlling whether DWT coefficient subvectors
%                       are labeled.
%                       Default value:  1 = label subvectors.
%     subvectorLabels = vector of numbers for labeling subectors.  
%                       If vector element has value equal 0, that subvector is
%                       is not labele.
%                       Default:  All Wj and VJ0 subvectors are labeled.
%
% EXAMPLE
%   [W, NJ] = = dwt(X, 'la8', 6, 'periodic');
%   N = length(W);
%   axesProp.XLim = [0, N];
%   [haxes, hlineDWT, hlineBdry] = plot_dwt_vector(W, NJ); 
%
% WARNINGS
%
%
% ERRORS
%
%
% BUGS
%  1. Only plots first channel.
%
% REFERENCES
%
%
% SEE ALSO
%   dwt, LineSpec, axes, line, stem
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2004-01-08
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

%   $Id: plot_dwt_vector.m 612 2005-10-28 21:42:24Z ccornish $
  

  usage_str = ['Usage:  [haxes, hlineDWT, hlineBdry] = ', mfilename, ...
               '(W, [NJ], [LineSpec], [title_str], [axesProp], [plotOpts)'];

  %%  Check input arguments and set defaults.
  error(nargerr(mfilename, nargin, [1:6], nargout, [0:3], 1, usage_str, 'struct'));

  if (~exist('plotOpts', 'var'))
    plotOpts = [];
  end
  
  if (~isfield(plotOpts, 'labelSubvectors'))
    plotOpts.labelSubvectors = 1;
  end
  
  W1 = W{1};
  
  
  if (exist('LineSpec', 'var') && ~isempty(LineSpec))
    hline_dwt = stem(W1, LineSpec);
    set(hline_dwt, 'Marker', 'none');
  else
    hline_dwt = stem(W1);
    set(hline_dwt, 'Marker', 'none');
  end
  
  ha = gca;
  
  if (exist('title_str', 'var') && ~isempty(title_str))
    title(title_str);
  end
  
  % Overide default values for plot axes.
  if (exist('axesProp', 'var') && ~isempty(axesProp))
    axesPropName = {};
    axesPropVal = {};
  
    axes_field_names = fieldnames(axesProp);
    nfields = length(axes_field_names);
    
    for (i = 1:nfields)
      fname = axes_field_names{i};
      axesPropName(i) = {fname};
      fval = axesProp.(fname);
      axesPropVal(i) = {fval};
    end
  
    set(ha, axesPropName, axesPropVal);
  
  end
  
  sz_NJ = size(NJ);
  
  % If NJ is provided, overlay boundaries between levels.
  if (exist('NJ', 'var') && ~isempty(NJ))
    YLim = get(gca, 'YLim');
    nlines = sz_NJ(1) - 1;
    xstart = zeros(nlines, 1);
    xstart = cumsum(NJ(1:nlines, 1));
    ystart = YLim(1) * ones(nlines, 1);
    xend = xstart;
    yend = YLim(2) * ones(nlines, 1);
  
    hold on;
    LineSpec = ':r';
    hline_bdry = linesegment(xstart, ystart, xend, yend, LineSpec);
  
    if (plotOpts.labelSubvectors )
      xpos = cumsum(NJ(:,1)) - NJ(:,1) + NJ(:,1)/2;
      YLim = get(gca, 'YLim');
      ypos = YLim(2) + (YLim(2) - YLim(1)) * .01;
      if (isfield(plotOpts, 'subvectorLabels'))
        subvectorLabels = plotOpts.subvectorLabels;
      else
        nlevels = length(NJ(:,1)) - 1;
        subvectorLabels = [1:nlevels, nlevels];
      end
      for (j = 1:length(NJ(:,1)))
        if (subvectorLabels(j))
          if (j < length(NJ(:,1)))
            label_str = ['\bfW\rm_', num2str(subvectorLabels(j))];
          else
            label_str = ['\bfV\rm_', num2str(subvectorLabels(j))];
          end
          text(xpos(j), ypos, label_str, ...
               'HorizontalAlignment', 'center', ... 
               'VerticalAlignment', 'bottom');
        end
      end
    end
  end
  
  if (nargout >= 1 )
    haxes = ha;
  end
  
  if (nargout >= 2)
    hlineDWT = hline_dwt;
  end
  
  if (nargout >= 3)
    hlineBdry = hline_bdry;
  end
  
return
