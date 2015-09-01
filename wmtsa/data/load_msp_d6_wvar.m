function [varname_list] = load_msp_d6_wvar
% load_msp_d6_wvar -- Load MODWT WVAR (D6) for ocean shear (msp) times series.

% $Id: load_msp_d6_wvar.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  WVAR =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'WV-D6-ocean-shear.dat']);

  msp_wvar_d6 = WVAR(:,2);
  
  assignin('caller', 'msp_wvar_d6', msp_wvar_d6);

  varname_list = {'msp_wvar_d6'};
  
return

