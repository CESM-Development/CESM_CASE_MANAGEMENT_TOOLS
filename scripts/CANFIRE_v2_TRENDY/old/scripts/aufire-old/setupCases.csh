#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/

# ...
set syr = 1960
set eyr = 1960

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )

# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE_v2.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )

set padded_mbr = `printf "%03d" $mbr`
set CASEDIR = case_scripts.${padded_mbr}


echo "==================================    " 
#echo $CASE 
cd $DOUT/$CASE/$CASEDIR

./case.setup

end             # member loop
end             # member loop
end             # member loop

exit

