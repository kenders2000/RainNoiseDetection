function [varname_list] = load_table333
% load_table333 -- Load data from table333

% $Id: load_table333.m 612 2005-10-28 21:42:24Z ccornish $ 
  
  [wmtsa_data_path] = fileparts(which(['wmtsa/data/', mfilename]));
  
  % Check wvar
  data =  load([wmtsa_data_path, filesep, 'WVAR', filesep, ...
                'Table333.dat']);

  eta1 = data(:,2);
  eta2 = data(:,3);
  eta3 = data(:,4);
  MJ   = data(:,5);
  
  assignin('caller', 'eta1', eta1);
  assignin('caller', 'eta2', eta2);
  assignin('caller', 'eta3', eta3);
  assignin('caller', 'MJ', MJ);

  varname_list = {'eta1', 'eta2', 'eta3', 'MJ'};
  
return

