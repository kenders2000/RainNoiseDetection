% set_att_from_properties -- Set object's properties from att's name/value pairs.
function obj = set_properties_from_att(obj, s)
  obj.WTF        = s.WTF;
  obj.NX         = s.NX;
  obj.NW         = s.NW;
  obj.J0         = s.J0;
  obj.NChan      = s.NChan;
  obj.Boundary   = s.Boundary;
  obj.Aligned    = logical(s.Aligned);
  obj.RetainedVJ = logical(s.RetainedVJ);
return
