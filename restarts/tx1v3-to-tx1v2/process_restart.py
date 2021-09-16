import numpy as np
import subprocess


# /glade/campaign/cesm/development/omwg/projects/ihesp/g.e21.GIAF.TL319_t13.5thCyc.ice.001/rest/
case = "g.e21.GIAF.TL319_t13.5thCyc.ice.001"
#years = np.arange(269,295)
#years = np.arange(305,306)
years = np.arange(301,302)

for y in years:
  year = f'{y:04d}'
  print('Processing year {}...'.format(y))
  subprocess.call(['python', 'add_caspien_pop_rest.py', case, year])
  subprocess.call(['python', 'add_caspien_ice_rest.py', case, year])
  subprocess.call(['python', 'convert_cice5_to_cice4.py', case, year])
  # convert to 64-bit offset
  print('Converting POP restart file to 64-bit offset format...')
  pop_rfile = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".pop.r.tx01v2."+year+"-11-01-00000.nc"
  subprocess.call(['nccopy', '-6', pop_rfile, '/glade/scratch/nanr/archive/'+case+'/rest/'+year+'-11-01-00000/tmp.nc'])
  subprocess.call(['mv', '-f', '/glade/scratch/nanr/archive/'+case+'/rest/'+year+'-11-01-00000/tmp.nc', pop_rfile])
  print('Converting CICE restart file to 64-bit offset format...')
  cice_rfile = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".cice4.r.tx01v2."+year+"-11-01-00000.nc"
  subprocess.call(['nccopy', '-6', cice_rfile, '/glade/scratch/nanr/archive/'+case+'/rest/'+year+'-11-01-00000/tmp.nc'])
  subprocess.call(['mv', '-f', '/glade/scratch/nanr/archive/'+case+'/rest/'+year+'-11-01-00000/tmp.nc', cice_rfile])


