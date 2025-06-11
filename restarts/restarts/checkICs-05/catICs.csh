#! /bin/csh -fxv 

setenv TOOLS_ROOT /pscratch/sd/n/nanr/CESM_tools/v21.LR.SMYLE/
set syr = 1970
set eyr = 2019

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon  ( 05 )

    set mbr_padZeros = `printf %02d $mbr`
    set dirpath = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/
    echo "checking year $year-$mon-$mbr_padZeros" >> ICs-${mon}.totals
    set file = ${year}-${mon}.ics

    cat $file | grep ncdiff | wc >> ICs-${mon}.totals

end
end

exit
 
 



