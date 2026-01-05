#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLEsmbb_DP

# ...
set syr = 1991
set eyr = 1991

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
set OUTPATH = /pscratch/sd/n/nanr/xfr/

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        cd $DOUT/$CASE/archive.00${mbr}/atm/hist/
        ncrcat -v date,TREFHT,TS v21.LR.BSMYLEsmbb.1991-11.00${mbr}.eam.h0.*.nc ${OUTPATH}/v21.LR.BSMYLEsmbb.1991-11.00${mbr}.eam.h0.TREFHT_TS.00${mbr}.nc
        
else
        cd $DOUT/$CASE/archive.0${mbr}/atm/hist/
        ncrcat -v date,TREFHT,TS v21.LR.BSMYLEsmbb.1991-11.0${mbr}.eam.h0.*.nc ${OUTPATH}/v21.LR.BSMYLEsmbb.1991-11.0${mbr}.eam.h0.TREFHT_TS.0${mbr}.nc
endif


echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

