#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-NoPinatubo/
setenv TSERIES2  /glade/campaign/cgd/cesm/CESM2-LE/CESM2-SF/noKrakatoa/timeseries

# ...
set syr = 1301
set eyr = 1301


@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

# case name counter
set smbr =  11
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
       set CASE = b.e21.BHISTsmbb.f09_g17.LE2-${year}.0${mbr}-noKrakatoa.0${mbr}

#echo "==================================    " 
#echo $CASE 
if (-d $TSERIES2/$CASE) then
    cd $TSERIES2/$CASE
    #set t1 = `ls  $TSERIES2/$CASE/atm/proc/tseries/month_1/*ZM_CLUBB* | wc -l`
    set t2 = `ls -lR $TSERIES2/$CASE | wc -l`
    set s2 = `du . -sh`
    if ($t2 < 1655 ) then
       echo  $CASE " ==============    " $t2  $s2
    else
       echo  $CASE " ===    " $t2  $s2
    endif
else
    echo " missing   ===    " $CASE
endif

end             # member loop
end             # member loop

exit

