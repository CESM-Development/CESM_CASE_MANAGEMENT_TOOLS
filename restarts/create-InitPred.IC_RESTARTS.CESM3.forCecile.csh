#! /bin/csh -fxv 


set syr = 1991
set eyr = 1991

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 08 )

##  This will be the RUN_REFCASE  (all files will be renamed to this name):
set case = b.e30.SMYLE_IC.ne30pg3_t232_wg37.${year}-${mon}.01

##  The initial conditions will be stored here:
set Picdir = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/inputdata/cesm3_init/{$case}/
set icdir  = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/inputdata/cesm3_init/{$case}/${year}-${mon}-01

if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif

## Set casenames for land and atm ICs
## atm, lnd initial conditions
set atmcase =  ERA5_x_ne30np4_L58_rgC2_WO
set lndcase =  ctsm53041_54surfdata_ne30_102_HIST

## Casenames for original lnd, rof, and atm restarts
#set atmfname = ${atmcase}.cam2.i.${year}-${mon}-01-00000.nc
set atmfname = ${atmcase}.${year}-${mon}-01-00000.nc
set lndfname = ${lndcase}.clm2.r.${year}-${mon}-01-00000.nc
set roffname = ${lndcase}.mosart.r.${year}-${mon}-01-00000.nc

## Paths for original lnd, rof, and atm restarts
## directories
set atmdir = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/ne30np4_L58_gll/
set lnddir = /glade/derecho/scratch/wwieder/archive/ctsm53041_54surfdata_ne30_102_HIST/rest/${year}-${mon}-01-00000/

## Rename atm, rof and land files
set atmfout = ${case}.cam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

echo $atmfout
echo $atmdir/$atmfname

## Record provenance of orginal file in new netcdf file
cp $atmdir/${atmfname} $icdir/$atmfout
cp $lnddir/${lndfname} $icdir/$lndfout
cp $lnddir/${roffname} $icdir/$roffout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
ncatted -a OriginalFile,global,a,c,$roffname $icdir/$roffout

## CHECK the OCEAN OFFSET!!!!
## ocn/ice
set ocncase = g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081

## CHECK the OCEAN OFFSET!!!!
#  1958-01-01 = 0062-01-01
set first_rest_year = 1958
set ocean_base_year = 62

## CHECK the OCEAN OFFSET!!!!
# Comment:  year translation:  if ($year == 1997 ) set ocnyr = 0101
# years used for ICs:   0062 (1958) - 0101 (1997)
# atmyr 1958 = ocnyr 62
@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set pocnyr = `printf "%04d" $ocnyr`
set ocndir = /glade/derecho/scratch/gmarques/archive/g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081/rest/${pocnyr}-${mon}-01-00000/

echo $ocndir

set icefout = ${case}.cice.r.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

set icefname   = ${ocncase}.cice.r.${pocnyr}-${mon}-01-00000.nc 
set poprfname  = ${ocncase}.mom6.r.${pocnyr}-${mon}-01-00000.nc  
set popwwfname = ${ocncase}.ww3.r.${pocnyr}-${mon}-01-00000    
set poprfout  = ${case}.mom6.r.${year}-${mon}-01-00000.nc
set popwwfout = ${case}.ww3.r.${year}-${mon}-01-00000
#set poprofout = ${case}.mom6.ro.${year}-${mon}-01-00000 
#set poprhfout = ${case}.mom6.rh.ecosys.nyear1.${year}-${mon}-01-00000.nc

echo $icefname
echo $poprfname

cp $ocndir/${icefname}    $icdir/${icefout}
cp $ocndir/${poprfname}   $icdir/${poprfout}
#cp $ocndir/${poprofname}  $icdir/${poprofout}
#cp $ocndir/${poprhfname}  $icdir/${poprhfout}
cp $ocndir/${popwwfname}  $icdir/${popwwfout}

ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout
#ncatted -a OriginalFile,global,a,c,$poprofname  $icdir/$poprofout
#ncatted -a OriginalFile,global,a,c,$poprhfname  $icdir/$poprhfout

# create rpointer files

echo "$case.cice.r.$year-${mon}-01-00000.nc"    > ${icdir}/rpointer.ice.$year-${mon}-01-00000
echo "$case.cam.r.$year-${mon}-01-00000.nc"     > ${icdir}/rpointer.cam.$year-${mon}-01-00000
echo "$case.cpl.r.$year-${mon}-01-00000.nc"     > ${icdir}/rpointer.cpl.$year-${mon}-01-00000
echo "$case.clm2.r.$year-${mon}-01-00000.nc"    > ${icdir}/rpointer.lnd.$year-${mon}-01-00000
echo "$case.mosart.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.rof.$year-${mon}-01-00000
echo "$case.mom6.r.$year-${mon}-01-00000.nc"   >> ${icdir}/rpointer.ocn.$year-${mon}-01-00000
echo "$case.dglc.r.$year-${mon}-01-00000.nc"   >> ${icdir}/rpointer.glc.$year-${mon}-01-00000
echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.$year-${mon}-01-00000

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


end
end

exit
 
 



