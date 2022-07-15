import xarray as xr
import numpy as np
import cftime
from datetime import datetime
from netCDF4 import default_fillvals
from glob import glob
import os
import netCDF4


indir = '/glade/scratch/nanr/SST-highres/future/withleapYears/'
infiles = 'sst_input4MIPs_HighResMIP_MOHC-highresSST-future.????????-????????.nc'

outdir = '/glade/scratch/nanr/SST-highres/future/noLeapYear/'



files = np.sort(glob(indir+infiles))
print(files)

for f in files:

  ds = xr.open_dataset(f, use_cftime=True)

  dso = ds.sel(time=~((ds.time.dt.month == 2) & (ds.time.dt.day == 29)))

  time = cftime.date2num(dso.time, units='days since 1850-01-01-0000', calendar='365_day')

  #dso.time_bnds[31+28-1,1] = dso.time_bnds[31+28,0]
  #time_bnds = cftime.date2num(dso.time_bnds, units='days since 1850-01-01-0000', calendar='365_day')

  dso.time.data = time
  dso.time.attrs['units'] = "days since 1850-1-1 0:0:0"
  dso.time.attrs['calendar'] = "noleap"

  #dso.time_bnds.data = time_bnds

  dso.attrs['date_modified'] = datetime.now().isoformat()
  dso.attrs['modified_by'] = "Nan Rosenbloom (nanr@ucar.edu), NCAR/CGD"
  dso.attrs['modification'] = "removed leap day"

  spval = netCDF4.default_fillvals['f4']
 
  encoding = {'time': {'_FillValue': None, 'dtype': 'float32'}, \
              'lat': {'_FillValue': None}, \
              'lon': {'_FillValue': None},\
              'SST_cpl': {'_FillValue': spval, 'dtype': 'float32'}, \
              'ice_cov': {'_FillValue': spval, 'dtype': 'float32'}, \
             }
  outfile = outdir + os.path.basename(f).replace('.nc','.noleap.nc')
  dso.to_netcdf(outfile, encoding=encoding)
