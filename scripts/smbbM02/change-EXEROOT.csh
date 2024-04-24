#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/v21.LR.SMYLEsmbb

# ...
set syr = 1980
set eyr = 1980

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )

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
    ./xmlchange EXEROOT=$SCRATCH/v21.LR.SMYLEsmbb/exeroot/build

    ./case.submit
    
end             # member loop
end             # member loop
end             # member loop

exit

