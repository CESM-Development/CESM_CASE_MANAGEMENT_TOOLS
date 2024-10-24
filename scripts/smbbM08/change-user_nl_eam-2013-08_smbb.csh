#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb
setenv TOOLSROOT  /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/

# ...
set syr = 2013
set eyr = 2013

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 08 )

# case name counter
set smbr =  1
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
    ./xmlchange STOP_N=11
    ./xmlchange REST_N=11

    mv user_nl_eam user_nl_eam-historical
    cp $TOOLSROOT/user_nl_files/smbb/user_nl_eam-SSP370smbb ./user_nl_eam
    #cp $TOOLSROOT/env_mach/env_mach_specific.xml .
    ./xmlchange PROJECT=mp9
    ./xmlchange CONTINUE_RUN=TRUE
    ./xmlchange DOUT_S=TRUE
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit
