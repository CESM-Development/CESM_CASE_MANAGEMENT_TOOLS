import xarray as xr
import sys

####################
#case = "g.e21.GIAF.TL319_t13.5thCyc.ice.001"
#year = "0269"
case = sys.argv[1]
year = sys.argv[2]

#fin = "/glade/scratch/fredc/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".pop.r."+year+"-11-01-00000.nc"
#fout = "/glade/scratch/fredc/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".pop.r.tx01v2."+year+"-11-01-00000.nc"
fin  = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".pop.r."+year+"-11-01-00000.nc"
fout = "/glade/scratch/nanr/archive/"+case+"/rest/"+year+"-11-01-00000/"+case+".pop.r.tx01v2."+year+"-11-01-00000.nc"
####################

ds = xr.open_dataset(fin)

ftxv2 = "/glade/p/cesm/community/ASD-HIGH-RES-CESM1/hybrid_v5_rel04_BC5_ne120_t12_pop62/rest/0040-11-01-00000/hybrid_v5_rel04_BC5_ne120_t12_pop62.pop.r.0040-11-01-00000.nc"
ds2 = xr.open_dataset(ftxv2)



encoding={}

for var in ds.data_vars:
  print('working on {}...'.format(var))
  encoding[var] = {'_FillValue': None}
  if len(ds[var].dims) == 3:
    ds[var].data[:,1580:1820,1525:1680] = ds2[var].data[:,1580:1820,1525:1680]
  elif len(ds[var].dims) == 2:
    ds[var].data[1580:1820,1525:1680] = ds2[var].data[1580:1820,1525:1680]
  else:
    raise ValueError('')



print('writting restart file {}...'.format(fout))
ds.to_netcdf(fout, encoding=encoding)
print('Done')



