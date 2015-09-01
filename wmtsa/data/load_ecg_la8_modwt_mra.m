function [varname_list] = load_ecg_la8_modwt_mra
% load_ecg_la8_modwt_mra -- Load MODWT MRA coefficients (LA8 filter) for ecg times series.

% $Id: load_ecg_la8_modwt_mra.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which('wmtsa/data/load_ecg_la8_modwt_mra'));
  
  MRA = load([wmtsa_data_path, filesep, 'MODWT', filesep, ...
              'ecg-LA8-MODWT-MRA.dat']);

  wtf = 'la8';
  J0 = 6;
  boundary = 'periodic';

  [N, J] = size(MRA);
  DJt = MRA(:,1:J0);
  SJt = MRA(:,J0+1);
  
  
  att.Transform = 'MODWT_MRA';
  att.WTF = wtf;
  att.N = N;
  att.NW = N;
  att.J0 = J0;
  att.NChan = 1;
  att.Boundary = boundary;
  att.Aligned = 0;
  att.RetainSJ = 0;
  
  assignin('caller', 'ecg_DJt', DJt);
  assignin('caller', 'ecg_SJt', SJt);
  assignin('caller', 'ecg_mra_att', att);

  varname_list = {'ecg_DJt', 'ecg_SJt', 'ecg_mra_att'};
  
return

