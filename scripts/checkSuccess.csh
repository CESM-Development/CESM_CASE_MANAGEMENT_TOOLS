#!/bin/csh 
### set env variables
### module load ncl nco

setenv TSERIES1  /pscratch/sd/n/nanr/v21.LR.SMYLE
setenv TSERIES2  /pscratch/sd/s/sglanvil/v21.LR.SMYLE/
setenv TSERIES3  /global/cfs/cdirs/mp9/archive/v21.LR.SMYLE

# ...
set syr = 1980
set eyr = 2014

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

#echo "==================================    " 
#echo $CASE 
if (-d $TSERIES1/$CASE) then
    cd $TSERIES1/$CASE
    set t2 = `ls -ld $TSERIES1/$CASE/archive.* | wc -l`
    echo " NSCR $CASE   ========= "  $t2
else
    if (-d $TSERIES2/$CASE) then
       cd $TSERIES2/$CASE
       set t2 = `ls -ld $TSERIES2/$CASE/archive.* | wc -l`
       echo " SSCR $CASE   ========= "  $t2
    else
       if (-d $TSERIES3/$CASE) then
          cd $TSERIES3/$CASE
          set t2 = `ls -ld $TSERIES3/$CASE/archive.* | wc -l`
          echo " mCFS $CASE   ========= "  $t2
       else
          echo " missing   ===    " $CASE/
       endif
    endif
endif

#end             # member loop
end             # member loop
end             # member loop

exit

