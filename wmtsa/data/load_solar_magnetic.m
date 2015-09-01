function [varname_list] = load_solar_magnetic
% load_solar_magnetic -- Load solar magnetic field magnitude time series.

% $Id: load_solar_magnetic.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_solar_magnetic'));
  
  solar_magnetic = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'magS4096.dat']);
  
  solar_magnetic_att.name = 'solar_magnetic';
  solar_magnetic_att.N = length(solar_magnetic);
  solar_magnetic_att.delta_t = 1;
  solar_magnetic_att.delta_t_units = 'hour';
  solar_magnetic_att.start = '1993-12-04 21:00:00 UT';
  solar_magnetic_att.end = '1994-05-24 12:00:00 UT';
  solar_magnetic_att.units = 'nanoteslas';
  solar_magnetic_att.description = 'solar magnetic field magnitude data';
  solar_magnetic_att.source = ['National Aeronautics and Space Administration (Ulysses Project)'];
  
  
  assignin('caller', 'solar_magnetic', solar_magnetic);
  assignin('caller', 'solar_magnetic_att', solar_magnetic_att);

  varname_list = {'solar_magnetic', 'solar_magnetic_att'};
  
return

