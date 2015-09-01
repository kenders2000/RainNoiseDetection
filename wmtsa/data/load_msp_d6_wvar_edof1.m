function [varname_list] = load_msp_d6_wvar_edof1
% load_msp_d6_wvar_edof1 -- Load MODWT WVAR EDOF (LA8 filter) for ocean shear (msp) times series.

% $Id: load_msp_d6_wvar_edof1.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  WVAR =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'WV-D6-ocean-shear-edof1.dat']);

  msp_wvar1 = WVAR(:,3);
  msp_CI_wvar1 = WVAR(:,4:5);
  msp_edof1 = WVAR(:,6);
  msp_Qeta1 = WVAR(:,7:8);
  msp_MJ1 = WVAR(:,9);
  msp_AJ1 = WVAR(:,10);

  
  assignin('caller', 'msp_wvar1', msp_wvar1);
  assignin('caller', 'msp_CI_wvar1', msp_CI_wvar1);
  assignin('caller', 'msp_edof1', msp_edof1);
  assignin('caller', 'msp_Qeta1', msp_Qeta1);
  assignin('caller', 'msp_MJ1', msp_MJ1);
  assignin('caller', 'msp_AJ1', msp_AJ1);


  varname_list = {'msp_wvar1', 'msp_CI_wvar1', 'msp_edof1', 'msp_Qeta1', 'msp_MJ1', 'msp_AJ1'};
  
return

