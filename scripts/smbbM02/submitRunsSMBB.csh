#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb
setenv TOOLSROOT  /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/

# ...
set syr = 2018
set eyr = 2018

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )

# case name counter
set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    #cp /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb/v21.LR.BSMYLEsmbb.2014-${mon}.001/case_scripts.001/user_nl_eam .
    #./xmlchange STOP_N=14
    #./xmlchange REST_N=14

    #diff user_nl_eam ../case_scripts.001/user_nl_eam
    #./preview_namelists
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit

