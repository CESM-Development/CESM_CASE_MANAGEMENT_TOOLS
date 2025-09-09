#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2

# ...
set syr = 2013
set eyr = 2013

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )

# case name counter
set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE_v2.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    #cp /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/v21.LR.BSMYLE_v2.2011-02.001/case_scripts.002/env_mach_specific.xml .
    #./xmlchange STOP_N=14
    #./xmlchange REST_N=14
    #./xmlchange EXEROOT=/pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/exeroot/

    #diff user_nl_eam ../case_scripts.001/user_nl_eam
    #./preview_namelists
    #./xmlchange JOB_WALLCLOCK_TIME=16:00:00
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit

