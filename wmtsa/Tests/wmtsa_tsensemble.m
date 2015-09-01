function tse = wmtsa_tsensemble
  
tse = MU_tsensemble_new(mfilename);

tse1 = MU_tsensemble_create('dwt/dwt_toolbox_tsensemble');
tse = MU_tsensemble_add_tsensemble(tse, tse1);

return
