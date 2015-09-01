class omodwt
% file:  @omodwt/omodwt.m
% Public Properties
  properties (SetAccess = 'private')
    X@double           = [];
    WJ@double          = [];
    VJ@double          = [];
                       
    WTF@char           = '';
    NX                 = 0;
    NW                 = 0;
    J0                 = 0;
    NChan              = 0;
    Boundary@char      = '';
    Aligned@logical    = false;
    RetainedVJ@logical = false;
    
 
% Class methods
  methods
  
  
    function obj = omodwt(X, wtfname, nlevels, boundary, varargin)
    % Constructor
      obj.X = X;
      defaults.wtfname  = 'la8';
      defaults.boundary = 'reflection';
      defaults.nlevels  = 'conservative';
      set_defaults(defaults);

      if (nargin > 4)
        [WJ, VJ, w_att] = modwt(X, wtfname, nlevels, boundary, varargin);
      else
        [WJ, VJ, w_att] = modwt(X, wtfname, nlevels, boundary);
      end
      obj.WJ = WJ;
      obj.VJ = VJ;

      obj = set_properties_from_att(obj, w_att);

    end % Constructor
        
    function plot(obj)
      w_att = att(obj);
      plot_modwt_coef(obj.WJ, obj.VJ, obj.X, w_att); 
    end % plot
        
    function att = att(obj)
      att = get_att_from_properties(obj);
    end % att
        
end % Class
        
        
