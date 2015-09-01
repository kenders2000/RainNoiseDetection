function tse = dwt_toolbox_tsensemble
  
tse = MU_tsensemble_new(mfilename);

ts = MU_tsuite_create(@wtfilter_tsuite);
tse = MU_tsensemble_add_tsuite(tse, ts);

ts = MU_tsuite_create(@modwt_tsuite);
tse = MU_tsensemble_add_tsuite(tse, ts);

return
