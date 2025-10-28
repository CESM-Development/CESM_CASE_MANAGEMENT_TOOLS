#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT_OLD  /global/cfs/cdirs/mp9/archive/v21.LR.SMYLEsmbb
setenv DOUT_NEW  /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb

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

set CASE = v21.LR.BSMYLEsmbb.${year}-11.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set ARCHDIR = archive.00${mbr}
        set CASEDIR = case_scripts.00${mbr}
else
        set ARCHDIR = archive.0${mbr}
        set CASEDIR = case_scripts.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
if (-d $DOUT_NEW/$CASE) then
    cd $DOUT_NEW/$CASE/$CASEDIR
    echo " changing   ===    " $DOUT_NEW/$CASE/$ARCHDIR
    echo " changing   ===    " $DOUT_NEW/$CASE/$ARCHDIR
    ./xmlquery DOUT_S_ROOT
    ./xmlchange DOUT_S_ROOT=$DOUT_NEW/$CASE/$ARCHDIR
else
    echo " missing   ===    " $DOUT_NEW/$CASE/$ARCHDIR
endif

end             # member loop
end             # member loop
end             # member loop

exit

