% figure099 - Calculate and plot squared gain functiosn of DWT LA(8) filters.
% 
% Usage:
%   figure099
%

% $Id: figure099.m 353 2004-06-14 20:53:21Z ccornish $

plot_filter_sgf('DWT', 'la8', 4);

figure_datestamp(mfilename, gcf);
