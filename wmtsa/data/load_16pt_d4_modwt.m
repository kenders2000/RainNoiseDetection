function [varname_list] = load_16pt_d4_modwt
% load_16pt_d4_modwt -- Load MODWT coefficients (D4 filter) for 16pt times series.

% $Id: load_16pt_d4_modwt.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_16pt_d4_modwt'));
  
  Wt = load([wmtsa_data_path, filesep, 'MODWT', filesep, '16pt-fig42-D4-MODWT.dat']);
  
  [N, J] = size(Wt);
  wtf = 'd4';
  J0 = 3;
  boundary = 'periodic';
  
  WJt = Wt(:,1:2:2*J0);
  VJ0t = Wt(:,2:2:2*J0);

  att.Transform = 'MODWT';
  att.WTF = wtf;
  att.N = N;
  att.NW = N;
  att.J0 = J0;
  att.NChan = 1;
  att.Boundary = boundary;
  att.Aligned = 0;
  att.RetainVJ = 1;
  
  assignin('caller', 'sixteen_pt_WJt', WJt);
  assignin('caller', 'sixteen_pt_VJ0t', VJ0t);
  assignin('caller', 'sixteen_pt_WJt_att', att);

  varname_list = {'sixteen_pt_WJt', 'sixteen_pt_VJ0t', 'sixteen_pt_WJt_att'};
  
return

