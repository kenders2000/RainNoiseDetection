function [varname_list] = load_msp_4096
% load_msp_4096 -- Ocean shear series.

% $Id: load_msp_4096.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_msp_4096'));
  
  msp_4096 = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'msp-data-4096.dat']);
  
  msp_4096_att.name = 'msp-4096';
  msp_4096_att.N = length(msp_4096);
  msp_4096_att.delta_t = 0.1;
  msp_4096_att.delta_t_units = 'm';
  msp_4096_att.start = 350.0;
  msp_4096_att.end = 1037.4;
  msp_4096_att.units = 'sec^-1';

  assignin('caller', 'msp_4096', msp_4096);
  assignin('caller', 'msp_4096_att', msp_4096_att);

  varname_list = {'msp_4096', 'msp_4096_att'};
  
return

