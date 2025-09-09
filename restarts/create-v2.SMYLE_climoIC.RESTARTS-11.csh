#! /bin/csh -fxv 

setenv TOOLS_ROOT /pscratch/sd/n/nanr/CESM_tools/v21.LR.SMYLE/
set syr = 2005
set eyr = 2005

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

set case = v21.LR.SMYLE_climoIC.${year}-${mon}.01

set Picdir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/
set icdir  = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/${year}-${mon}-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif

set findir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/climoIC/

# atm initial conditions
set atmdir   = $findir
set atmfname = ${case}.eam.i.${year}-${mon}-01-00000.nc
set atmfout  = ${case}.eam.i.${year}-${mon}-01-00000.nc
cp $atmdir/${atmfname} $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout

# lnd initial conditions
## See setup script:  ./scripts/SMYLE_climoIC/run.v21.LR.BSMYLE_climoIC.sh

# ocn initial conditions -- change names (see underscore)
set ocnfname = v21.LR.SMYLE_climoIC.2005-11.01.mpaso.rst.2005-11-01-00000.nc
set icefname = v21.LR.SMYLE_climoIC.2005-11.01.mpassi.rst.2005-11-01-00000.nc

set ocnfout  = ${case}.mpaso.rst.2005-11-01_00000.nc
set icefout  = ${case}.mpassi.rst.2005-11-01_00000.nc

echo $icefname
echo $ocnfname

#cp $findir/${icefname}    $icdir/${icefout}
cp $findir/${ocnfname}   $icdir/${ocnfout}

#ncatted -a OriginalFile,global,a,c,$icefname   $icdir/$icefout
ncatted -a OriginalFile,global,a,c,$ocnfname   $icdir/$ocnfout

# create rpointer files
echo "$case.eam.r.$year-${mon}-01-00000.nc"    > ${icdir}/rpointer.atm
echo "$case.cpl.r.$year-${mon}-01-00000.nc"    > ${icdir}/rpointer.drv
echo "./$case.elm.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.lnd
echo "$case.mosart.r.$year-${mon}-01-00000.nc" > ${icdir}/rpointer.rof
echo "$year-${mon}-01_00:00:00"  > ${icdir}/rpointer.ice
echo "$year-${mon}-01_00:00:00"  > ${icdir}/rpointer.ocn

endif	# doThis2

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

endif	# doThis99

end
end

exit
 
 



