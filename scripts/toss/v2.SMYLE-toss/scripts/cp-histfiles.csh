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
set smbr =  3
set embr =  19

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-11.001

foreach mbr ( `seq $mb $me` )

set mbr_padZeros = `printf %03d $mbr`
set ARCHDIR = archive.${mbr_padZeros}
set CASEDIR = case_scripts.${mbr_padZeros}
set RUNDIR  = run.${mbr_padZeros}
#if ($mbr < 10) then
        #set ARCHDIR = archive.00${mbr}
        #set CASEDIR = case_scripts.00${mbr}
        #set RUNDIR  = run.00${mbr}
#else
        #set ARCHDIR = archive.0${mbr}
        #set CASEDIR = case_scripts.0${mbr}
        #set RUNDIR  = run.0${mbr}
#endif


#echo "==================================    " 
#echo $CASE 
if (-d $DOUT_NEW/$CASE) then
    cd $DOUT_NEW/$CASE/$RUNDIR
    echo " copyin files   ===    " $DOUT_NEW/$CASE/$ARCHDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/lnd/hist/v21.LR.BSMYLEsmbb.2013-11.$mbr_padZeros.elm.h1.2014-11-01-00000.nc $DOUT_NEW/$CASE/$RUNDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/atm/hist/v21.LR.BSMYLEsmbb.2013-11.$mbr_padZeros.eam.h1.2014-11-01-00000.nc $DOUT_NEW/$CASE/$RUNDIR
    cp $DOUT_NEW/$CASE/$ARCHDIR/rof/hist/v21.LR.BSMYLEsmbb.2013-11.$mbr_padZeros.mosart.h1.2014-11-02-00000.nc $DOUT_NEW/$CASE/$RUNDIR

else
    echo " missing   ===    " $DOUT_NEW/$CASE/$ARCHDIR
endif

cd $DOUT_NEW/$CASE/$CASEDIR
./case.submit 

end             # member loop
end             # member loop
end             # member loop

exit

