#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/archive
setenv TARGET  $SCRATCH/v21.LR.BSMYLEsmbb_DP

# ...
set syr = 2022
set eyr = 2023

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

set CASE = v21.LR.BSMYLEsmbb.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set ARCHDIR = archive.00${mbr}
        set RUNDIR = run.00${mbr}
else
        set ARCHDIR = archive.0${mbr}
        set RUNDIR = run.0${mbr}
endif

echo $DOUT/$CASE/$ARCHDIR/rest/${nextyr}-03-01-00000/rpointer*
echo $TARGET/$CASE/$RUNDIR/
cp $DOUT/$CASE/$ARCHDIR/rest/${nextyr}-03-01-00000/rpointer.* $TARGET/$CASE/$RUNDIR/


echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

