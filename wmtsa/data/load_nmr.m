function [varname_list] = load_nmr
% load_nmr -- Load atomic clock time differences times series.

% $Id: load_nmr.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_nmr'));
  
  nmr = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'nmr.dat']);
  
  nmr_att.name = 'nmr';
  nmr_att.N = length(nmr);
  nmr_att.delta_t = 1;
  nmr_att.delta_t_units = '';
  nmr_att.start = 0;
  nmr_att.end = 1024;
  nmr_att.units = '';
  nmr_att.description = 'nuclear magnetic resonance spectrum';
  nmr_att.source = ['Andrew Maudsley, Department of Radiology, ', ...
                    'University of California, San Francisco, ', ...
                    'via the public domain software package WaveLab'];
  
  
  assignin('caller', 'nmr', nmr);
  assignin('caller', 'nmr_att', nmr_att);

  varname_list = {'nmr', 'nmr_att'};
  
return

