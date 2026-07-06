#!/bin/csh 
### set env variables
module load ncl nco

# ...


foreach syr ( 1231 1251 1281 1301 )

# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
   if ($mbr <= 10) then 
      set rtype = cmip6
   else
      set rtype = smbb
   endif

if ($mbr < 10) then
        set case = b.e21.BHIST${rtype}.f09_g17.LE2-${syr}.00${mbr}
        set icdir = /glade/scratch/$USER/archive/$case/1880-01-01-00000/
else
        set case = b.e21.BHIST${rtype}.f09_g17.LE2-${syr}.0${mbr}
        set icdir = /glade/scratch/$USER/archive/$case/1880-01-01-00000/
endif

# create rpointer files

set year = 1880
set mon = 01

echo "$case.cice.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.ice
echo "./$case.pop.ro.$year-${mon}-01-00000"   > ${icdir}/rpointer.ocn.ovf
echo "$case.cam.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.drv
echo "$case.clm2.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.lnd
echo "$case.mosart.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.rof
echo "$case.pop.rh.ecosys.nyear1.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg.5
echo "$case.pop.rh.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg

echo "./$case.pop.r.$year-${mon}-01-00000.nc"    >> ${icdir}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.restart


end             # member loop
end             # member loop

exit

