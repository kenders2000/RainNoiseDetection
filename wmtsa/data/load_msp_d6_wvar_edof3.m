function [varname_list] = load_msp_d6_wvar_edof3
% load_msp_d6_wvar_edof1 -- Load MODWT WVAR EDOF (LA8 filter) for ocean shear (msp) times series.

% $Id: load_msp_d6_wvar_edof3.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  WVAR =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'WV-D6-ocean-shear-edof3.dat']);

  msp_wvar3 = WVAR(:,3);
  msp_CI_wvar3 = WVAR(:,4:5);
  msp_edof3 = WVAR(:,6);
  msp_Qeta3 = WVAR(:,7:8);
  msp_MJ3 = WVAR(:,9);

  
  assignin('caller', 'msp_wvar3', msp_wvar3);
  assignin('caller', 'msp_CI_wvar3', msp_CI_wvar3);
  assignin('caller', 'msp_edof3', msp_edof3);
  assignin('caller', 'msp_Qeta3', msp_Qeta3);
  assignin('caller', 'msp_MJ3', msp_MJ3);

  varname_list = {'msp_wvar3', 'msp_CI_wvar3', 'msp_edof3', 'msp_Qeta3', 'msp_MJ3'};
  
return

