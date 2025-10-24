#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /global/cfs/cdirs/mp9/archive/v21.LR.SMYLE
setenv DOUT  /pscratch/sd/n/nanr/v21.LR.SMYLE

# ...
set syr = 2013
set eyr = 2013

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    ./xmlchange STOP_N=14
    ./xmlchange REST_N=14

end             # member loop
end             # member loop
end             # member loop

exit

