function [varname_list] = load_msp
% load_msp -- Ocean shear series.

% $Id: load_msp.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_msp'));
  
  msp = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'msp-data.dat']);
  
  msp_att.name = 'msp';
  msp_att.N = length(msp);
  msp_att.delta_t = 0.1;
  msp_att.delta_t_units = 'm';
  msp_att.start = 350.0;
  msp_att.end = 1037.4;
  msp_att.units = 'sec^-1';

  assignin('caller', 'msp', msp);
  assignin('caller', 'msp_w_att', msp_w_att);

  varname_list = {'msp', 'msp_w_att'};
  
return

