#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb

# ...
set syr = 2023
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLEsmbb.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    #cp /pscratch/sd/n/nanr/v21.LR.SMYLEsmbb/v21.LR.BSMYLEsmbb.2014-${mon}.001/case_scripts.001/user_nl_eam .
    #./xmlchange STOP_N=14
    #./xmlchange REST_N=14

    #diff user_nl_eam ../case_scripts.001/user_nl_eam
    #./preview_namelists
    #./xmlchange EXEROOT=/pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/exerootmonday
    #./xmlchange BUILD_COMPLETE=TRUE
    ./case.submit


end             # member loop
end             # member loop
end             # member loop

exit

