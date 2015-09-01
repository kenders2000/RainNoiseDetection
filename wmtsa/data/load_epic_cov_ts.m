function [varname_list] = load_epic_cov_ts
% load_epic_cov_ts -- Load EPIC covariance time series source data.

% $Id: load_epic_cov_ts.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_epic_cov_ts'));

  %% Leg 27 - w
  epic_rf03_27_w = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_27_w.dat']);
  
  epic_rf03_27_w_att.name = 'epic_rf03_27_w';
  epic_rf03_27_w_att.N = length(epic_rf03_27_w);
  epic_rf03_27_w_att.delta_t = .04;
  epic_rf03_27_w_att.delta_t_units = 'seconds';
  epic_rf03_27_w_att.start = 13546;
  epic_rf03_27_w_att.end = 14010.96;
  epic_rf03_27_w_att.units = 'm/s';
  epic_rf03_27_w_att.description = 'EPIC flight 3, (low) leg 27 vertical velocity (w)';
  epic_rf03_27_w_att.source = 'Cornish et al. (2005)';
  
  assignin('caller', 'epic_rf03_27_w', epic_rf03_27_w);
  assignin('caller', 'epic_rf03_27_w_att', epic_rf03_27_w_att);

  %% Leg 27 - theta_v
  epic_rf03_27_theta_v = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_27_theta_v.dat']);
  
  epic_rf03_27_theta_v_att.name = 'epic_rf03_27_theta_v';
  epic_rf03_27_theta_v_att.N = length(epic_rf03_27_theta_v);
  epic_rf03_27_theta_v_att.delta_t = .04;
  epic_rf03_27_theta_v_att.delta_t_units = 'seconds';
  epic_rf03_27_theta_v_att.start = 13546;
  epic_rf03_27_theta_v_att.end = 14010.96;
  epic_rf03_27_theta_v_att.units = 'degrees (K)';
  epic_rf03_27_theta_v_att.description = ...
      'EPIC flight 3, (low) leg 27 virtual potential  temperature (theta_v)';
  epic_rf03_27_theta_v_att.source = 'Cornish et al. (2005)';
  
  assignin('caller', 'epic_rf03_27_theta_v', epic_rf03_27_theta_v);
  assignin('caller', 'epic_rf03_27_theta_v_att', epic_rf03_27_theta_v_att);

  %% Leg 32 - w
  epic_rf03_32_w = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_32_w.dat']);
  
  epic_rf03_32_w_att.name = 'epic_rf03_32_w';
  epic_rf03_32_w_att.N = length(epic_rf03_32_w);
  epic_rf03_32_w_att.delta_t = .04;
  epic_rf03_32_w_att.delta_t_units = 'seconds';
  epic_rf03_32_w_att.start = 15555;
  epic_rf03_32_w_att.end = 16057.96;
  epic_rf03_32_w_att.units = 'm/s';
  epic_rf03_32_w_att.description = 'EPIC flight 3, (low) leg 32 vertical velocity (w)';
  epic_rf03_32_w_att.source = 'Cornish et al. (2005)';
  
  assignin('caller', 'epic_rf03_32_w', epic_rf03_32_w);
  assignin('caller', 'epic_rf03_32_w_att', epic_rf03_32_w_att);

  %% Leg 32 - theta_v
  epic_rf03_32_theta_v = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_32_theta_v.dat']);
  
  epic_rf03_32_theta_v_att.name = 'epic_rf03_32_theta_v';
  epic_rf03_32_theta_v_att.N = length(epic_rf03_32_theta_v);
  epic_rf03_32_theta_v_att.delta_t = .04;
  epic_rf03_32_theta_v_att.delta_t_units = 'seconds';
  epic_rf03_32_theta_v_att.start = 15555;
  epic_rf03_32_theta_v_att.end = 16057.96;
  epic_rf03_32_theta_v_att.units = 'degrees (K)';
  epic_rf03_32_theta_v_att.description = ...
      'EPIC flight 3, (low) leg 32 virtual potential  temperature (theta_v)';
  epic_rf03_32_theta_v_att.source = 'Cornish et al. (2005)';

  assignin('caller', 'epic_rf03_32_theta_v', epic_rf03_32_theta_v);
  assignin('caller', 'epic_rf03_32_theta_v_att', epic_rf03_32_theta_v_att);
  
  %% Leg 37 - w
  epic_rf03_37_w = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_37_w.dat']);
  
  epic_rf03_37_w_att.name = 'epic_rf03_37_w';
  epic_rf03_37_w_att.N = length(epic_rf03_37_w);
  epic_rf03_37_w_att.delta_t = .04;
  epic_rf03_37_w_att.delta_t_units = 'seconds';
  epic_rf03_37_w_att.start = 17514;
  epic_rf03_37_w_att.end = 17918.96;
  epic_rf03_37_w_att.units = 'm/s';
  epic_rf03_37_w_att.description = 'EPIC flight 3, (low) leg 37 vertical velocity (w)';
  epic_rf03_37_w_att.source = 'Cornish et al. (2005)';
  
  assignin('caller', 'epic_rf03_37_w', epic_rf03_37_w);
  assignin('caller', 'epic_rf03_37_w_att', epic_rf03_37_w_att);

  %% Leg 37 - theta_v
  epic_rf03_37_theta_v = load([wmtsa_data_path, filesep, 'TimeSeries', filesep, 'epic_rf03_37_theta_v.dat']);
  
  epic_rf03_37_theta_v_att.name = 'epic_rf03_37_theta_v';
  epic_rf03_37_theta_v_att.N = length(epic_rf03_37_theta_v);
  epic_rf03_37_theta_v_att.delta_t = .04;
  epic_rf03_37_theta_v_att.delta_t_units = 'seconds';
  epic_rf03_37_theta_v_att.start = 17514;
  epic_rf03_37_theta_v_att.end = 17918.96;
  epic_rf03_37_theta_v_att.units = 'degrees (K)';
  epic_rf03_37_theta_v_att.description = ...
      'EPIC flight 3, (low) leg 37 virtual potential  temperature (theta_v)';
  epic_rf03_37_theta_v_att.source = 'Cornish et al. (2005)';

  assignin('caller', 'epic_rf03_37_theta_v', epic_rf03_37_theta_v);
  assignin('caller', 'epic_rf03_37_theta_v_att', epic_rf03_37_theta_v_att);

  varname_list = ...
       {'epic_rf03_27_w', 'epic_rf03_27_w_att', ...
        'epic_rf03_27_theta_v', 'epic_rf03_27_theta_v_att', ...
        'epic_rf03_32_w', 'epic_rf03_32_w_att', ...
        'epic_rf03_32_theta_v', 'epic_rf03_32_theta_v_att', ...
        'epic_rf03_37_w', 'epic_rf03_37_w_att', ...
        'epic_rf03_37_theta_v', 'epic_rf03_37_theta_v_att'};
  
return

