function [varname_list] = load_nile_haar_modwt
% load_nile_haar_modwt -- Load MODWT coefficients (Haar filter) for Nile River times series.

% $Id: load_nile_haar_modwt.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_nile_haar_modwt'));
  
  Wt = load([wmtsa_data_path, filesep, 'MODWT', filesep, 'Nile-Haar-MODWT.dat']);
  
  [N, J] = size(Wt);
  wtf = 'Haar';
  J0 = 4;
  boundary = 'periodic';
  
  WJt = Wt(:,1:J0);
  VJ0t = Wt(:,J0+1);

  att.Transform = 'MODWT';
  att.WTF = wtf;
  att.N = N;
  att.NW = N;
  att.J0 = J0;
  att.NChan = 1;
  att.Boundary = boundary;
  att.Aligned = 0;
  att.RetainVJ = 0;
  
  assignin('caller', 'nile_WJt', WJt);
  assignin('caller', 'nile_VJ0t', VJ0t);
  assignin('caller', 'nile_WJt_att', att);

  varname_list = {'nile_WJt', 'nile_VJ0t', 'nile_WJt_att'};
  
return

