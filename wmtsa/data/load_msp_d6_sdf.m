function [varname_list] = load_msp_d6_sdf
% load_msp_d6_sdf -- Load MODWT SDF (D6) for ocean shear (msp) times series.

% $Id: load_msp_d6_sdf.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  Y =  load([wmtsa_data_path, filesep, 'SDF', filesep, ...
             'SDF-D6-ocean-shear.dat']);

  % Expected results are in reverse order from psd results
  Y = flipud(Y);
  
  CJ = Y(:,1);
  f = Y(:,2);
  f_band = Y(:,3:4);

  assignin('caller', 'sdf_CJ', CJ);
  assignin('caller', 'sdf_f', f);
  assignin('caller', 'sdf_f_band', f_band);

  varname_list = {'sdf_CJ', 'sdf_f', 'sdf_f_band'};
  
return

