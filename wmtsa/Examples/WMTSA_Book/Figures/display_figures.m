function display_figures(figure_list, output_mode, output_dir)
% display_figures -- Display figure scripts to screen or write to file
%

% $Id: display_figures.m 580 2005-09-13 05:50:42Z ccornish $
  
default_output_mode = 'screen';
default_output_dir = './images';

default_image_format_list = {'jpeg', 'epsc'};

[default_figure_list] = textread('figure_list', '%s');

if ( ~exist('figure_list', 'var') || isempty(figure_list))
  figure_list = default_figure_list;
end
 
if ( ~exist('output_mode', 'var') || ~isempty(output_mode))
  output_mode = default_output_mode;
end

if ( ~exist('output_dir', 'var') || ~isempty(output_dir))
  output_dir = default_output_dir;
end

image_format_list = default_image_format_list;

if (strcmp(output_mode, 'screen'))
  visible = 'on';
else
  visible = 'off';
end


for (ifig = 1:length(figure_list))
  fig_name = figure_list{ifig};
  disp(['Running ', fig_name, '...']);
  hfigure = figure('Name', fig_name, 'Visible', visible);

   eval(['run ', fig_name]);
  
  switch output_mode
   case 'screen'
    disp('Pausing ... Hit any key to continue.');
    pause;
   case 'file'
    for (ifor = 1:length(image_format_list))
      out_format = image_format_list{ifor};
      out_filename = [output_dir, filesp, fig, '.', out_format];
      try
        print(['-d', out_format], out_filename);
      catch
        disp(['Error encountered while printing format ', out_format]);
      end
    end
   otherwise
  end
  
  close(hfigure);  
end

