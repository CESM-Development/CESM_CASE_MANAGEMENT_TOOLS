#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLEsmbb_DP/
setenv TOOLSROOT  /pscratch/sd/n/nanr/CESM_tools/v21.LR.SMYLE/scripts/SMYLE-DP/

# ...
#set syr = 2010
#set eyr = 2010
#set NMON = 36
#set NRES = 1

#set syr = 2011
#set eyr = 2011
#set NMON = 42
#set NRES = 1

#set syr = 2009
#set eyr = 2009
#set NMON = 30
#set NRES = 1

#set syr = 2008
#set eyr = 2008
#set NMON = 48
#set NRES = 0

#set syr = 2007
#set eyr = 2007
#set NMON = 36
#set NRES = 0

set syr = 2006
set eyr = 2011
#set NMON = 24
#set NRES = 0


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
        set CASEDIR = case_scripts.00${mbr}
else
        set CASEDIR = case_scripts.0${mbr}
endif


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR
    #./xmlchange STOP_N=$NMON
    #./xmlchange REST_N=$NMON
    #./xmlchange RESUBMIT=$NRES
    #./xmlchange CONTINUE_RUN=TRUE
    #./xmlchange JOB_WALLCLOCK_TIME=24:00:00 --subgroup case.run
#
    #mv user_nl_eam user_nl_eam-historical
    #rm user_nl_eam 
    #cp $TOOLSROOT/user_nl_eam-SSP370-COMPSET ./user_nl_eam
    #./case.submit
    ./preview_namelists


end             # member loop
end             # member loop
end             # member loop

exit

