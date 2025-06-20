#! /bin/csh -fxv 

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-SMYLE

if ($HOST != casper10) then
echo "ERROR:  Must be run on Casper"
#exit
endif


#foreach  ye9r ( 1954 1964 1974 1984 1994 2004 )
set syr = 1991
set eyr = 1991

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 08 )

set case = b.e30.SMYLE_IC.ne30pg3_t232_wg37.${year}-${mon}.01

set Picdir = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/inputdata/cesm3_init/{$case}/
set icdir  = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/inputdata/cesm3_init/{$case}/${year}-${mon}-01

if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif


set doThis99 = 1
if ($doThis99 == 1) then

# atm, lnd initial conditions
set atmcase =  ERA5_x_ne30np4_L58_rgC2_WO
set lndcase =  ctsm53041_54surfdata_ne30_102_HIST

# names
#set atmfname = ${atmcase}.cam2.i.${year}-${mon}-01-00000.nc
set atmfname = ${atmcase}.${year}-${mon}-01-00000.nc
set lndfname = ${lndcase}.clm2.r.${year}-${mon}-01-00000.nc
set roffname = ${lndcase}.mosart.r.${year}-${mon}-01-00000.nc

# directories
set atmdir = /glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/ne30np4_L58_gll/
set lnddir = /glade/derecho/scratch/wwieder/archive/ctsm53041_54surfdata_ne30_102_HIST/rest/${year}-${mon}-01-00000/

# rename atm, land IC files
set atmfout = ${case}.cam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

echo $atmfout
echo $atmdir/$atmfname
end

set doThis = 1

if ($doThis == 1) then
cp $atmdir/${atmfname} $icdir/$atmfout
cp $lnddir/${lndfname} $icdir/$lndfout
cp $lnddir/${roffname} $icdir/$roffout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
ncatted -a OriginalFile,global,a,c,$roffname $icdir/$roffout

endif

# ocn/ice
# years used for ICs:   0306 (1958) - 0366 (2018)
#set ocncase = g.e22.GOMIPECOIAF_JRA-1p4-2018.TL319_g17.SMYLE.005
set ocncase = g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081

#/glade/derecho/scratch/gmarques/archive/g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081/rest/0011-01-01-00000/:
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.cice.r.0011-01-01-00000.nc
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.cpl.r.0011-01-01-00000.nc
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.datm.r.0011-01-01-00000.nc
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.drof.r.0011-01-01-00000.nc
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.mom6.r.0011-01-01-00000.nc
#g.e30_b06.GJRAv4.TL319_t232_wgx3_hycom1_N75.2025.081.ww3.r.0011-01-01-00000

set first_rest_year = 1958
set ocean_base_year = 62

#  1958-01-01 = 0062-01-01


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

set doThis2 = 1
if ($doThis2 == 1) then

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

endif	# doThis2

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

endif	# doThis99

end
end

exit
 
 



