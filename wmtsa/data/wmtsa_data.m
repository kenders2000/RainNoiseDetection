function varargout = wmtsa_data(dataset)
% wmtsa_data -- Load a WMTSA dataset.
%
%****f* wmtsa.data/wmtsa_data
%
% NAME
%   wmtsa_data -- Load a WMTSA dataset.
%
% SYNOPSIS
%   wmtsa_data(dataset)
%   [X, att] = wmtsa_data(dataset)
%   [dataset_list] = wmtsa_data('datasets')
%
% INPUTS
%   * dataset    -- name of sample dataset (string).
%
% OUTPUTS
%   * out        -- listing of available datasets (cell array of strings).
%
% SIDE EFFECTS
%
%
% DESCRIPTION
%   wmtsa_data loads a dataset into the caller's workspace.  Two variables
%   are created in the caller's workspace:
%   * dataset     -- variable containing the data
%   * dataset_att -- attributes of dataset.
%
%   A function named 'load_<dataset>' exists for each dataset and contains the
%   instructions on how to load the dataset and create its attributes. The load
%   functions reside in the same directory (toolbox) as the wmtsa_data function.
%
%   Calling wmtsa_data('datasets') displays a list of available datasets and
%   returns a list to the output argument.
%
% USAGE
%   wmtsa_data('ecg')                % Creates ecg and ecg_att variables in workspace.
%   [X, att] = wmtsa_data('ecg')     % Creates X and att variables in workspace.
%
%   wmtsa_data('ecg_la8_modwt')      % Creates ecg MODWT coefficients
%                                    % (ecg_WJt, ecg_VJ0t, ecg_WJt_att)
%   [WJt, VJ0t, att] = wmtsa_data('ecg_la8_modwt')  
%                                    % Creates WJt, VJ0t and att variables in workspace.
%
% EXAMPLE
%   wmtsa_data('ecg');
%
% WARNINGS
%
%
% ERRORS
%
%
% NOTES
%
%
% BUGS
%
%
% TODO
%
%
% ALGORITHM
%
%
% REFERENCES
%
%
% SEE ALSO
%
%
% TOOLBOX
%
%
% CATEGORY
%
%

% AUTHOR
%   Charlie Cornish
%
% CREATION DATE
%   2005-01-26
%
% COPYRIGHT
%   (c) 2005 Charles R. Cornish
%
% CREDITS
%
%
% REVISION
%   $Revision: 612 $
%
%***

%   $Id: wmtsa_data.m 612 2005-10-28 21:42:24Z ccornish $

usage_str = ['Usage:  ', mfilename, '(dataset)'];
  
%%  Check input arguments and set defaults.

error(nargerr(mfilename, nargin, [1:1], nargout, '', 1, usage_str, 'struct'));

[wmtsa_data_path] = fileparts(which('wmtsa/data/wmtsa_data'));

if isempty(wmtsa_data_path)
  error('WMTSA:wmtsa_data:Unknown Path', ...
        ['Cannot find path to wmtsa/data toolbox']);
end

%% If requeted, provide list of datasets
if(strcmpi(dataset, 'datasets'))
  available_datasets = display_available_datasets;
  if (nargout > 0)
    varargout{1} = available_datasets;
  end
  return
end

%% Check for valid dataset
func_str = ['load_', dataset];

if isempty(which(['wmtsa/data/', func_str]));
  disp(['*** Error ***']);
  disp(['Cannot find dataset (', dataset, ')']);, ...
  disp(['Type: ', mfilename, ...
        '(''datasets'') for list of available datasets']);
  error('WMTSA:wmtsa_data:UnknownDataset', ...
        ['Unknown WMTSA dataset (', dataset, ')']);
end

fh = eval(['@', func_str]);

[varname_list] = feval(fh);

if (nargout > 0)
  for (i = 1:nargout)
    varargout{i} = eval(varname_list{i});
  end
else
  for (i = 1:length(varname_list))
    varname = varname_list{i};
    the_var = eval(varname);
    assignin('caller', varname, the_var);
  end
end


return

function available_datasets = display_available_datasets
% display_available_datasets -- Display to the available WMTSA datasets.

  s = what('wmtsa/data');
  mfile_list = s.m;
  load_file_list = mfile_list(strmatch('load_', mfile_list));
  load_func_list = strrep(load_file_list, '.m', '');
  available_datasets = strrep(load_func_list, {'load_'}, {''});

  disp(available_datasets);

return
  
