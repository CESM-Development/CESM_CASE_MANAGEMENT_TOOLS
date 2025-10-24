#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2_CANFIRE

# ...
set syr = 2023
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

# case name counter
set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE_v2_CANFIRE.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    #./xmlchange JOB_QUEUE=regular
    ./xmlchange JOB_WALLCLOCK_TIME=02:30:00
    cp /pscratch/sd/n/nanr/CESM_tools/v21.LR.SMYLE/scripts/CANFIRE_v2_TRENDY/user_nl_files/user_nl_eam-canfiresON ./user_nl_eam
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit

