function [varname_list] = load_subtidal
% load_subtidal -- Load subtidal sea level times series.

% $Id: load_subtidal.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_subtidal'));
  
  subtidal = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'percival-m_subtidal_sea_level.dat']);
  
  subtidal_att.name = 'subtidal';
  subtidal_att.N = length(subtidal);
  subtidal_att.delta_t = 1/2;
  subtidal_att.delta_t_units = 'day';
  subtidal_att.start = 6.333;
  subtidal_att.end = 4378.833;
  subtidal_att.units = 'centimeters';
  subtidal_att.description = 'Subtidal sea level time series';
  subtidal_att.source = ['National Ocean Service via Hal Mojeld, ', ...
                      'Pacific Marine Environmental Laboratory, ', ...
                      'National Oceanic & Atmospheric Administration'];
  subtidal_att.notes = ...
      [' starting time is 6.333... days, which corresponds to 0800 PST 6 January 1980; ' ...
       'ending time is 4378.833... days, which corresponds to 2000 PST 26 December.'];
  
  
  assignin('caller', 'subtidal', subtidal);
  assignin('caller', 'subtidal_att', subtidal_att);

  varname_list = {'subtidal', 'subtidal_att'};
  
return

