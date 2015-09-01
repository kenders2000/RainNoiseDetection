% get_att_from_properties -- Returns struct of attributes from object's properties.
function s = get_att_from_properties(obj)
  s.WTF        = obj.WTF;
  s.NX         = obj.NX;
  s.NW         = obj.NW;
  s.J0         = obj.J0;
  s.NChan      = obj.NChan;
  s.Boundary   = obj.Boundary;
  s.Aligned    = obj.Aligned;
  s.RetainedVJ = obj.RetainedVJ;
return
