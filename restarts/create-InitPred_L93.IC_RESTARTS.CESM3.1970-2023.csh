#! /bin/csh -fxv 

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/

#foreach  ye9r ( 1954 1964 1974 1984 1994 2004 )
set syr = 1970
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

set aresoln = ne30np4_L93
set oresoln = t233_wgx3

set case = b.e30.SMYLE_IC.${aresoln}_${oresoln}.${year}-${mon}.01

set Picdir = /glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${case}/
set icdir  = /glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${case}/${year}-${mon}-01

if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif


# atm, lnd initial conditions
set atmcase =  ERA5_x_ne30np4_L93_rgC2_WO
set lndcase =  ctsm5.4.019_BGCcrop_ne30_144_HIST_restarts

# names
#set atmfname = ${atmcase}.cam2.i.${year}-${mon}-01-00000.nc
set atmfname = ${atmcase}.${year}-${mon}-01-00000.nc
set lndfname = ${lndcase}.clm2.r.${year}-${mon}-01-00000.nc
set roffname = ${lndcase}.mosart.r.${year}-${mon}-01-00000.nc

# directories
set atmdir = /glade/campaign/cesm/development/espwg/CESM3-SMYLE/ne30np4_L93/
set lnddir = /glade/campaign/cesm/development/espwg/CESM3-SMYLE/ctsm5.4.019_BGCcrop_ne30_144_HIST_restarts/rest/${year}-${mon}-01-00000/

# rename atm, land IC files
set atmfout = ${case}.cam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

echo $atmfout
echo $atmdir/$atmfname

cp $atmdir/${atmfname} $icdir/$atmfout
cp $lnddir/${lndfname} $icdir/$lndfout
cp $lnddir/${roffname} $icdir/$roffout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
#ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
ncatted -a OriginalFile,global,a,c,$roffname $icdir/$roffout


# ocn/ice
# years used for ICs:   0306 (1958) - 0366 (2018)
#set ocncase = g.e22.GOMIPECOIAF_JRA-1p4-2018.TL319_g17.SMYLE.005
set ocncase = g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018

#/glade/campaign/cesm/development/espwg/CESM3-SMYLE/g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018/rest/0011-01-01-00000/
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.cice.r.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.cpl.r.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.datm.r.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.drof.r.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.mom6.r.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.mom6.r_stoch.0011-01-01-00000.nc
#g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018.ww3.r.0011-01-01-00000

set first_rest_year = 1958
set ocean_base_year = 1

#  1958-01-01 = 0001-01-01


# Comment:  year translation:  if ($year == 1970 ) set ocnyr = 0013
# years used for ICs:   0001 (1958) - 0013 (1970)
# atmyr 1958 = ocnyr 0001
@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set pocnyr = `printf "%04d" $ocnyr`
#set ocndir = /glade/derecho/scratch/gmarques/archive/g.e30_a09a.GJRAv4.TL319_t233_wgx3_hycom1_N75.2026.018/rest/${pocnyr}-${mon}-01-00000/
set ocndir = /glade/campaign/cesm/development/espwg/CESM3-SMYLE/$ocncase/rest/${pocnyr}-${mon}-01-00000/

echo $ocndir

set icefout = ${case}.cice.r.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

set icefname   = ${ocncase}.cice.r.${pocnyr}-${mon}-01-00000.nc 
set poprfname  = ${ocncase}.mom6.r.${pocnyr}-${mon}-01-00000.nc  
set poprfname2  = ${ocncase}.mom6.r_stoch.${pocnyr}-${mon}-01-00000.nc  
set popwwfname = ${ocncase}.ww3.r.${pocnyr}-${mon}-01-00000    
set poprfout  = ${case}.mom6.r.${year}-${mon}-01-00000.nc
set poprfout2  = ${case}.mom6.r_stoch.${year}-${mon}-01-00000.nc
set popwwfout = ${case}.ww3.r.${year}-${mon}-01-00000
#set poprofout = ${case}.mom6.ro.${year}-${mon}-01-00000 
#set poprhfout = ${case}.mom6.rh.ecosys.nyear1.${year}-${mon}-01-00000.nc

echo $icefname
echo $poprfname

cp $ocndir/${icefname}    $icdir/${icefout}
cp $ocndir/${poprfname}   $icdir/${poprfout}
cp $ocndir/${poprfname2}   $icdir/${poprfout2}
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
echo "./$case.clm2.r.$year-${mon}-01-00000.nc"    > ${icdir}/rpointer.lnd.$year-${mon}-01-00000
echo "$case.mosart.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.rof.$year-${mon}-01-00000
echo "$case.mom6.r.$year-${mon}-01-00000.nc"   >> ${icdir}/rpointer.ocn.$year-${mon}-01-00000
echo "$case.dglc.r.$year-${mon}-01-00000.nc"   >> ${icdir}/rpointer.glc.$year-${mon}-01-00000
echo "$case.mom6.r_stoch.$year-${mon}-01-00000.nc"   >> ${icdir}/rpointer.ocn.$year-${mon}-01-00000
#echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.$year-${mon}-01-00000


end
end

exit
 
 



