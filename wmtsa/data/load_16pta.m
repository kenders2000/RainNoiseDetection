function [varname_list] = load_16pta
% load_16pt -- Load 16pt series in left-hand plot of Figure 42.

% $Id: load_16pta.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_16pta'));
  
  sixteen_pta = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'ts16a.dat']);
  
  sixteen_pta_att.name = 'sixteen_pta';
  sixteen_pta_att.N = length(sixteen_pta);
  sixteen_pta_att.delta_t = 1;
  sixteen_pta_att.delta_t_units = '';
  sixteen_pta_att.start = '';
  sixteen_pta_att.end = '';
  sixteen_pta_att.units = '';
  sixteen_pta_att.description = '16pt (Figure 42) times series';
  sixteen_pta_att.source = 'WMTSA Book';
  
  assignin('caller', 'sixteen_pta', sixteen_pta);
  assignin('caller', 'sixteen_pta_att', sixteen_pta_att);

  varname_list = {'sixteen_pta', 'sixteen_pta_att'};
  
return

