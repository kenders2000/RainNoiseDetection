function [varname_list] = load_ecg_la8_modwt
% load_ecg_la8_modwt -- Load MODWT coefficients (LA8 filter) for ecg times series.

% $Id: load_ecg_la8_modwt.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_ecg_la8_modwt'));
  
  Wt = load([wmtsa_data_path, filesep, 'MODWT', filesep, 'ecg-LA8-MODWT.dat']);
  
  [N, J] = size(Wt);
  wtf = 'la8';
  J0 = 6;
  boundary = 'periodic';
  
  WJt = Wt(:,1:J0);
  VJt = Wt(:,J0+1);

  att.Transform = 'MODWT';
  att.WTF = wtf;
  att.N = N;
  att.NW = N;
  att.J0 = J0;
  att.NChan = 1;
  att.Boundary = boundary;
  att.Aligned = 0;
  att.RetainVJ = 0;
  
  assignin('caller', 'ecg_WJt', WJt);
  assignin('caller', 'ecg_VJt', VJt);
  assignin('caller', 'ecg_w_att', att);

  varname_list = {'ecg_WJt', 'ecg_VJt', 'ecg_w_att'};
  
return

