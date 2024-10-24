#! /bin/csh -fxv 

setenv TOOLS_ROOT /pscratch/sd/n/nanr/CESM_tools/v21.LR.SMYLE/
set syr = 1958
set eyr = 2018

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon  ( 08 )
foreach mbr  ( `seq 2 20` )

    set mbr_padZeros = `printf %02d $mbr`
    set dirpath = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/
    set case = v21.LR.SMYLE_IC.${year}-${mon}.01
    set file = v21.LR.SMYLE_IC.pert.eam.i.${year}-${mon}-01-00000.nc

    echo "checking year $year-$mon-$mbr_padZeros" >> ${year}-${mon}.ics
    ncdump -h $dirpath/$case/pert.$mbr_padZeros/$file | grep ncdiff >> ${year}-${mon}.ics

end
end
end

exit
 
 



