function [varname_list] = load_ecg
% load_ecg -- Load ecg times series.

% $Id: load_ecg.m 612 2005-10-28 21:42:24Z ccornish $ 

  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_ecg'));
  
  ecg = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'heart.dat']);
  
  ecg_att.name = 'ecg';
  ecg_att.N = length(ecg);
  ecg_att.delta_t = 1 / 180;
  ecg_att.delta_t_units = 'sec';
  ecg_att.start = 0.31;
  ecg_att.end = 11.6822;
  ecg_att.units = 'millivolts';
  ecg_att.description = 'Electro-Cardiogram (Heart) time series.';
  ecg_att.source = 'Gust Bardy and Per Reinhall, University of Washingon';
  
  assignin('caller', 'ecg', ecg);
  assignin('caller', 'ecg_att', ecg_att);

  varname_list = {'ecg', 'ecg_att'};
  
return

