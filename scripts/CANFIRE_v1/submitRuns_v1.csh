#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v1_CANFIRE

# ...
set syr = 2023
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

# case name counter
set smbr =  4
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE_v1_CANFIRE.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    ./xmlchange JOB_QUEUE=regular
    ./xmlchange JOB_WALLCLOCK_TIME=02:30:00
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit

