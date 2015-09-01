%  startup.m - Startup file for WMTSA package
%
%

% $Id: startup.m 629 2006-05-02 20:46:48Z ccornish $


% Get path to this startup file
this_file = [pwd '\startup.m']% mfilename('fullpath');

[wmtsa_path] = fileparts(this_file);

% Set paths

addpath([wmtsa_path filesep 'dwt']);         % 1-D DWT and core wavelet analysis functions
addpath([wmtsa_path filesep 'utils']);       % General utility functions
addpath([wmtsa_path filesep 'plotutils']);   % WMTSA plotting routines 
addpath([wmtsa_path filesep 'signal']);      % Signal processing functions
addpath([wmtsa_path filesep 'stats']);       % Statistic functions
addpath([wmtsa_path filesep 'data']);        % Sample data sets
addpath([wmtsa_path filesep 'third-party']); % Third-party routines required fo WMTSA

% Compile MEX files if necessary

cur_dir = pwd;
src_dir = [wmtsa_path filesep 'dwt'];

mex_function_list = {'modwtj', 'imodwtj', 'dwtj'};

cd(src_dir);

for (i = 1:length(mex_function_list))
  mex_function = mex_function_list{i};
  mex_function_exe_file = [mex_function '.' mexext];
  mex_function_src_file = [mex_function '.c'];

  if (isempty(which(mex_function)) || ~exist([src_dir filesep mex_function_exe_file], 'file'))
    disp(['Compiling '  mex_function_src_file '...']);
    mex(mex_function_src_file);
  end
  
end

cd(cur_dir);

% Cleanup

clear this_file;
clear wmtsa_path filename ext versn;
clear mex_function_list mex_function mex_function_exe_file mex_function_src_file;
clear src_dir cur_dir;







