function [varname_list] = load_atomic_clock
% load_atomic_clock -- Load atomic clock time differences times series.

% $Id: load_atomic_clock.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_atomic_clock'));
  
  atomic_clock = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'clock-571.dat']);
  
  atomic_clock_att.name = 'atomic_clock';
  atomic_clock_att.N = length(atomic_clock);
  atomic_clock_att.delta_t = 1;
  atomic_clock_att.delta_t_units = 'day';
  atomic_clock_att.start = 0;
  atomic_clock_att.end = 1026;
  atomic_clock_att.units = '';
  atomic_clock_att.description = 'atomic clock time differences';
  atomic_clock_att.source = ['United States Naval Observatory'];
  
  
  assignin('caller', 'atomic_clock', atomic_clock);
  assignin('caller', 'atomic_clock_att', atomic_clock_att);

  varname_list = {'atomic_clock', 'atomic_clock_att'};
  
return

