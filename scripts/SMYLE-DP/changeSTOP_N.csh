#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/v21.LR.BSMYLEsmbb_DP

# ...
set syr = 2016
set eyr = 2016

@ nextyr = $syr + 2
echo $nextyr


@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif

cd $DOUT/$CASE/$CASEDIR
./xmlchange STOP_N=48,REST_N=48,RESUBMIT=0
./xmlchange JOB_WALLCLOCK_TIME=24:00:00 --subgroup case.run
./case.submit



echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

