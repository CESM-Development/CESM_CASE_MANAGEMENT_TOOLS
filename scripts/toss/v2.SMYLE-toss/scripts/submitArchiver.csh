#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb

# ...
set syr = 1989
set eyr = 1989

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# case name counter
set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    ./case.st_archive

end             # member loop
end             # member loop
end             # member loop

exit

