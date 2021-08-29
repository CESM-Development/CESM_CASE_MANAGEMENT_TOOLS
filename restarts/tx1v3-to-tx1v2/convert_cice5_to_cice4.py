import xarray as xr
import numpy as np
import sys

####################
#case = "g.e21.GIAF.TL319_t13.5thCyc.ice.001"
#year = "0269"
case = sys.argv[1]
year = sys.argv[2]

fin = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".cice.r.tx01v2."+year+"-11-01-00000.nc"
fout = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".cice4.r.tx01v2."+year+"-11-01-00000.nc"
####################


ds = xr.open_dataset(fin)


# Rename Tracers
ds = ds.rename_vars({'aerosnossl001':'aerosnossl1'})
ds = ds.rename_vars({'aerosnoint001':'aerosnoint1'})
ds = ds.rename_vars({'aeroicessl001':'aeroicessl1'})
ds = ds.rename_vars({'aeroiceint001':'aeroiceint1'})
ds = ds.rename_vars({'aerosnossl002':'aerosnossl2'})
ds = ds.rename_vars({'aerosnoint002':'aerosnoint2'})
ds = ds.rename_vars({'aeroicessl002':'aeroicessl2'})
ds = ds.rename_vars({'aeroiceint002':'aeroiceint2'})
ds = ds.rename_vars({'aerosnossl003':'aerosnossl3'})
ds = ds.rename_vars({'aerosnoint003':'aerosnoint3'})
ds = ds.rename_vars({'aeroicessl003':'aeroicessl3'})
ds = ds.rename_vars({'aeroiceint003':'aeroiceint3'})

# Drop the salinities
print('drop salinities...')
ds = ds.drop_vars('sice001')
ds = ds.drop_vars('sice002')
ds = ds.drop_vars('sice003')
ds = ds.drop_vars('sice004')

# Add traces is needed
if 'iage' not in ds.data_vars:
  print('add iage...')
  iage = 0. * ds.aicen.rename('iage')
  ds = xr.merge([ds, iage.to_dataset(name='iage')], combine_attrs='override')

if 'apnd' not in ds.data_vars:
  print('add apondn...')
  apondn = 0. * ds.aicen.rename('apondn')
  ds = xr.merge([ds, apondn.to_dataset(name='apondn')], combine_attrs='override')  
else:
  ds = ds.rename_vars({'apnd':'apondn'})

if 'hpnd' not in ds.data_vars:
  print('add hpondn...')
  hpondn = 0. * ds.aicen.rename('hpondn')
  ds = xr.merge([ds, hpondn.to_dataset(name='hpondn')], combine_attrs='override')  
else:
  ds = ds.rename_vars({'hpnd':'hpondn'})

if 'volpn' not in ds.data_vars:
  print('add volpn...')
  volpn = (ds.apondn * ds.hpondn).rename('volpn')
  ds = xr.merge([ds, volpn.to_dataset(name='volpn')], combine_attrs='override')  


# These need to be converted
print('convert qice001...')
qice001 = ds.qice001
ds = ds.drop_vars('qice001')
print('convert qice002...')
qice002 = ds.qice002
ds = ds.drop_vars('qice002')
print('convert qice003...')
qice003 = ds.qice003
ds = ds.drop_vars('qice003')
print('convert qice004...')
qice004 = ds.qice004
ds = ds.drop_vars('qice004')
print('convert qsno001...')
qsno001 = ds.qsno001
ds = ds.drop_vars('qsno001')

ncat = ds.dims['ncat']
nilyr = 4
nslyr = 1
nj = ds.dims['nj']
ni = ds.dims['ni']

eicen = xr.DataArray(np.zeros((nilyr*ncat,nj,ni)), dims=['ntilyr','nj','ni'])
esnon = xr.DataArray(np.zeros((nslyr*ncat,nj,ni)), dims=['nslyr','nj','ni'])

# Convert energy to enthalpy
for n in range(ncat):
   nt = n*nilyr
   eicen.data[n*nilyr,:,:] = qice001.data[n,:,:] * ds.vicen.data[n,:,:] / nilyr
   eicen.data[n*nilyr+1,:,:] = qice002.data[n,:,:] * ds.vicen.data[n,:,:] / nilyr
   eicen.data[n*nilyr+2,:,:] = qice003.data[n,:,:] * ds.vicen.data[n,:,:] / nilyr
   eicen.data[n*nilyr+3,:,:] = qice004.data[n,:,:] * ds.vicen.data[n,:,:] / nilyr
   esnon.data[n*nslyr,:,:] = qsno001.data[n,:,:] * ds.vsnon.data[n,:,:] / nslyr

print('add eicen...')
ds = xr.merge([ds, eicen.to_dataset(name='eicen')], combine_attrs='override')
print('add esnon...')
ds = xr.merge([ds, esnon.to_dataset(name='esnon')], combine_attrs='override')


# Write to netdcf
encoding={}
for var in ds.data_vars:
  encoding[var] = {'_FillValue': None}
print('writting restart file {}...'.format(fout))
ds.to_netcdf(fout, encoding=encoding)
print('Done')

