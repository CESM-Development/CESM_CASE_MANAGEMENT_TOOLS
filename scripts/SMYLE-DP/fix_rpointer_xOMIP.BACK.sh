#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/archive

# ...
set syr = 2019
set eyr = 2020

@ nextyr = $syr + 3
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

set CASE = v21.LR.BSMYLE_xOMIP.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = archive.00${mbr}
        set RUNDIR  = run.00${mbr}
else
        set CASEDIR = archive.0${mbr}
        set RUNDIR  = run.0${mbr}
endif

cd $DOUT/$CASE/$CASEDIR/rest/${nextyr}-03-01-00000
sed -i '/^[[:space:]]*#/! s|smbb|_xOMIP|g' rpointer.atm rpointer.lnd rpointer.rof rpointer.drv


echo "==================================    " 
#echo $CASE 
cp rpointer.*  $SCRATCH/v21.LR.BSMYLEsmbb_DP/$CASE/$RUNDIR/

end             # member loop
end             # member loop
end             # member loop

exit

