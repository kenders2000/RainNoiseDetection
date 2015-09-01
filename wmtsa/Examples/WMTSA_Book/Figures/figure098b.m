% figure098b - Calculate and plot equivalent LA(8) wavelet and scaling filters.
% 
% Usage:
%   figure098b
%

% $Id: figure098b.m 353 2004-06-14 20:53:21Z ccornish $

plotOpts.PlotAutoCorrelationWidth = 0;

plot_equivalent_filter('DWT', 'la8', 7, ...
                       '', '',  ...
                       '', '', plotOpts);

figure_datestamp(mfilename, gcf);
