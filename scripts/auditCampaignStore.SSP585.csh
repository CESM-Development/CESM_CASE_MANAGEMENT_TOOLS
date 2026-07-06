#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-historicalPacemaker/
setenv TSERIES2  /glade/campaign/cgd/ccr/AMOC/cesm2/timeseries

# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-PAC_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-ATL_15d50m.derecho.00${mbr}
else
        set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-PAC_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-ATL_15d50m.derecho.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
if (-d $TSERIES2/$CASE) then
    cd $TSERIES2/$CASE
    #set t1 = `ls  $TSERIES2/$CASE/atm/proc/tseries/month_1/*ZM_CLUBB* | wc -l`
    set t2 = `ls -lR $TSERIES2/$CASE | wc -l`
    set s2 = `du . -sh`
    if ($t2 < 1756 ) then
       echo  $CASE " ==============    " $t2  $s2
    else
       echo  $CASE " ===    " $t2  $s2
    endif
else
    echo " missing   ===    " $CASE
endif

end             # member loop

exit

