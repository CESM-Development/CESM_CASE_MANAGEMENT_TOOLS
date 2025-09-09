#! /bin/csh -fxv 

setenv TOOLS_ROOT /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/

set syr = 2023
set eyr = 2023
set cdate = c20250902
set cdate = c20240803


@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )
#foreach mon ( 08 ) 
#foreach mon ( 11 )

set case = v21.LR.SMYLE_IC.${year}-${mon}.01

set Picdir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/
set icdir  = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/${year}-${mon}-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif


set doThis99 = 1
if ($doThis99 == 1) then

# atm, lnd initial conditions
set atmcase = eami.HICCUP-ERA5-CATALYST
set lndcase = v21.LR.I20TRELM_CRUNCEP-daily

# names
set atmfname = ${atmcase}.${year}-${mon}-01.ne30np4.L72.${cdate}.nc

# directories
set atmdir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/initial_conditions/atm/M${mon}/

# rename atm, land IC files
set atmfout = ${case}.eam.i.${year}-${mon}-01-00000.nc

echo $atmfout

set doThis = 1

if ($doThis == 1) then
cp $atmdir/${atmfname} $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout

endif

end

exit
 
 



