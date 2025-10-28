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
foreach mon ( 05 )

# case name counter
set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )

set mbr_padZeros = `printf %03d $mbr`
set ARCHDIR = archive.${mbr_padZeros}
set CASEDIR = case_scripts.${mbr_padZeros}
set RUNDIR  = run.${mbr_padZeros}

#echo "==================================    " 
#echo $CASE 
if (-d $DOUT_NEW/$CASE) then
    cd $DOUT_NEW/$CASE/$RUNDIR
    echo " copyin files   ===    " $DOUT_NEW/$CASE/$ARCHDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/lnd/hist/v21.LR.BSMYLEsmbb.2013-${mon}.$mbr_padZeros.elm.h1.2014-${mon}-01-00000.nc $DOUT_NEW/$CASE/$RUNDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/atm/hist/v21.LR.BSMYLEsmbb.2013-${mon}.$mbr_padZeros.eam.h1.2014-${mon}-01-00000.nc $DOUT_NEW/$CASE/$RUNDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/rof/hist/v21.LR.BSMYLEsmbb.2013-${mon}.$mbr_padZeros.mosart.h1.2014-${mon}-02-00000.nc $DOUT_NEW/$CASE/$RUNDIR

else
    echo " missing   ===    " $DOUT_NEW/$CASE/$ARCHDIR
endif

cd $DOUT_NEW/$CASE/$CASEDIR
./case.submit 

end             # member loop
end             # member loop
end             # member loop

exit

