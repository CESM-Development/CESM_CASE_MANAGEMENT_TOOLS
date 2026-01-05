#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLEsmbb_DP

# ...
set syr = 1994
set eyr = 1994

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
        cd $DOUT/$CASE/$CASEDIR
        cp /pscratch/sd/n/nanr/archive/v21.LR.BSMYLEsmbb.${syr}-11.001/archive.00${mbr}/rof/hist/v21.LR.BSMYLEsmbb.${syr}-11.00${mbr}.mosart.h1.${nextyr}-11-02-00000.nc ../run.00${mbr}
    ./case.submit
else
        set CASEDIR = case_scripts.0${mbr}
        cp /pscratch/sd/n/nanr/archive/v21.LR.BSMYLEsmbb.${syr}-11.001/archive.0${mbr}/rof/hist/v21.LR.BSMYLEsmbb.${syr}-11.0${mbr}.mosart.h1.${nextyr}-11-02-00000.nc ../run.0${mbr}
    ./case.submit
endif


echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

