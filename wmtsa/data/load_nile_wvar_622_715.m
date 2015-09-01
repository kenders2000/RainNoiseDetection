function [varname_list] = load_nile_wvar_622_715
% load_nile_wvar_622_715 -- Load MODWT WVAR for Nile time series for period 622-715.

% $Id: load_nile_wvar_622_715.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  WVAR =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'WV-Nile-622-715.dat']);

  nile_wvar_622_715 = WVAR(:,3);
  nile_CI_wvar_622_715 = WVAR(:,4:5);
  nile_edof_622_715 = WVAR(:,6);
  nile_Qeta_622_715 = WVAR(:,7:8);

  
  assignin('caller', 'nile_wvar_622_715', nile_wvar_622_715);
  assignin('caller', 'nile_CI_wvar_622_715', nile_CI_wvar_622_715);
  assignin('caller', 'nile_edof_622_715', nile_edof_622_715);
  assignin('caller', 'nile_Qeta_622_715', nile_Qeta_622_715);

  varname_list = {'nile_wvar_622_715', 'nile_CI_wvar_622_715', 'nile_edof_622_715', 'nile_Qeta_622_715'};
  
return

