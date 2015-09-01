function make(target, opts)
% make.m -- Make-like utility for compiling wmtsa C functions.

%  $Id: make.m 612 2005-10-28 21:42:24Z ccornish $
  
% Get path to this make file
this_file = mfilename('fullpath');

[wmtsa_path, filename, ext, versn] = fileparts(this_file);
cur_dir = pwd;
src_dir = [wmtsa_path filesep 'wmtsa'];
mex_function_list = {'modwtj', 'imodwtj', 'dwtj'};

  
if (~exist('target', 'var') || isempty(target))
  target = 'all';
end

switch target
 case 'clean'
  target_list = mex_function_list;
  cd(src_dir);
  make_clean(target_list)
 case 'all'
  target_list = mex_function_list;
  cd(src_dir);
  make_exe(target_list);
 case 'debug'
  target_list = mex_function_list;
  make_opts = '-g -DDEBUG';
  cd(src_dir);
  make_clean(target_list);
  make_exe(target_list, make_opts);
 otherwise
  target_list = {target};
  cd(src_dir);
  make_exe(target_list);
end

cd(cur_dir);
  
return;


function make_clean(target_list)
  for (i = 1:length(target_list))
    target = target_list{i};
    mex_function = target;
    mex_function_exe = [mex_function '.' mexext];
    if (exist(mex_function_exe, 'file'))
      disp(['Deleting ', mex_function_exe, '...']);
      delete(mex_function_exe);
    end
  end
return

function make_exe(target_list, make_opts)
  if (~exist('make_opts', 'var'))
    make_opts = '';
  end
  
  for (i = 1:length(target_list))
    target = target_list{i};
    mex_function = target;
    mex_function_src = [mex_function '.c'];
    mex_function_exe = [mex_function '.' mexext];
    if (isempty(which(mex_function)) || ~exist(mex_function_exe, 'file'))
      if (~exist(mex_function_src, 'file'))
        disp(['Source file does not exist: ', mex_function_src]);
      else
        cmd_str = [make_opts, ' ', mex_function_src];
        disp(['Compiling:  mex ', cmd_str, '...']);
        eval(['mex ', cmd_str]);
      end
    end
  end
return


