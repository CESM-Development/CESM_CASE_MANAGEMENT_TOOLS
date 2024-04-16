#!/bin/csh 
### set env variables
### module load ncl nco

#setenv TSERIES2  /global/cfs/cdirs/mp9/archive/v21.LR.SMYLE
setenv TSERIES2  /pscratch/sd/n/nanr/v21.LR.SMYLE

# ...
set syr = 1970
set eyr = 2018

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
        set ARCHDIR = archive.00${mbr}
else
        set ARCHDIR = archive.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
if (-d $TSERIES2/$CASE) then
    cd $TSERIES2/$CASE
    set t2 = `ls -lR $TSERIES2/$CASE/$ARCHDIR | wc -l`
    set s2 = `du . -sh`
    if ($t2 < 588 ) then
       echo  $CASE/$ARCHDIR " ==============    " $t2  $s2
    else
       echo  $CASE/$ARCHDIR " ===    " $t2  $s2
    endif
else
    echo " missing   ===    " $CASE/$ARCHDIR
endif

end             # member loop
end             # member loop
end             # member loop

exit

