function make(target, opts)
% make.m -- Make-like utility for compiling wmtsa C functions.

%  $Id: make.m 612 2005-10-28 21:42:24Z ccornish $

  
% Find the Makefile in current directory
  
if (exist('Makefile.m', 'file'))
  run './Makefile';
elseif (exist('makefile.m', 'file'))
  run './makefile';
else  
  error('Makefile or makefile does not exist in current directory');
  return
end

cur_dir = pwd;
src_dir = pwd;

  
if (~exist('target', 'var') || isempty(target))
  target = 'all';
end

if (~exist('opts', 'var') || isempty(opts))
  opts = '';
end

switch target
 case 'clean'
  cd(src_dir);
  make_clean(TARGETS);
 case 'all'
  cd(src_dir);
  make_clean(TARGETS);
  make_exe(TARGETS, opts);
 case 'debug'
  debug_opts = '-g -DDEBUG';
  cd(src_dir);
  make_clean(TARGETS);
  make_exe(TARGETS, [debug_opts, ' ', opts]);
 otherwise
  cd(src_dir);
  if (~iscell(target))
    target_list = {target};
  else
    target_list = target;
  end
  make_clean(target_list);
  make_exe(target_list);
end

cd(cur_dir);
  
return


function make_clean(target_list)
  for (i = 1:length(target_list))
    target = target_list{i};
    mex_function = target;
    mex_function_exe = [mex_function '.' mexext];
    if (exist(mex_function_exe, 'file') == 1)
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
    
    if (exist([mex_function '.c'], 'file'))
      mex_function_src = [mex_function '.c'];
    elseif (exist([mex_function '.f'], 'file'))
      mex_function_src = [mex_function '.f'];
    else
      error(['Cannot find source file for target: ', target]);
    end
    
    mex_function_exe = [mex_function '.' mexext];
    if (exist(mex_function_exe, 'file') ~= 1)
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


