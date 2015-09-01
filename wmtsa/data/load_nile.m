function [varname_list] = load_nile
% load_nile -- Load Nile River times series.

% $Id: load_nile.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_nile'));
  
  nile = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'Nile.dat']);
  
  nile_att.name = 'nile';
  nile_att.N = length(nile);
  nile_att.delta_t = 1;
  nile_att.delta_t_units = 'year';
  nile_att.start = 622;
  nile_att.end = 1284;
  nile_att.units = 'meters';
  nile_att.description = 'Nile River minima series';
  nile_att.source = 'Toussoun (1925)';
  
  assignin('caller', 'nile', nile);
  assignin('caller', 'nile_att', nile_att);

  varname_list = {'nile', 'nile_att'};
  
return

