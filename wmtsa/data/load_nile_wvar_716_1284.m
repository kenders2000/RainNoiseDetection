function [varname_list] = load_nile_wvar_716_1284
% load_nile_wvar_716_1284 -- Load MODWT WVAR for Nile time series for period 716-1284.

% $Id: load_nile_wvar_716_1284.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  WVAR =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'WV-Nile-716-1284.dat']);

  nile_wvar_716_1284 = WVAR(:,3);
  nile_CI_wvar_716_1284 = WVAR(:,4:5);
  nile_edof_716_1284 = WVAR(:,6);
  nile_Qeta_716_1284 = WVAR(:,7:8);

  
  assignin('caller', 'nile_wvar_716_1284', nile_wvar_716_1284);
  assignin('caller', 'nile_CI_wvar_716_1284', nile_CI_wvar_716_1284);
  assignin('caller', 'nile_edof_716_1284', nile_edof_716_1284);
  assignin('caller', 'nile_Qeta_716_1284', nile_Qeta_716_1284);

  varname_list = {'nile_wvar_716_1284', 'nile_CI_wvar_716_1284', 'nile_edof_716_1284', 'nile_Qeta_716_1284'};
  
return

