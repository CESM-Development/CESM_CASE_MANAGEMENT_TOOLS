#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/v21.LR.BSMYLEsmbb_DP

# ...
set syr = 2001
set eyr = 2001

@ nextyr = $syr + 2
echo $nextyr


@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# case name counter
set smbr =  3
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
./xmlchange EXEROOT=/pscratch/sd/d/dsanders/v21.LR.BSMYLEsmbb_DP/v21.LR.BSMYLEsmbb.${year}-11.001/bld/
./case.submit



echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

