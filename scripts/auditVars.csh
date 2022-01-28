#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/
setenv TSERIES  /glade/campaign/cesm/collections/CESM2-LE/archive/

foreach time_freq (hour_3)

cd $TSERIES
foreach i (`ls -1d b.e21.BHISTcmip6*`)
set ifiles = $i/atm/proc/tseries/$time_freq
if (-d $ifiles) then
set itrim=`echo $i | cut -d'/' -f 1`
echo $itrim
set nvars = `ls -1 $ifiles | cut -d"." -f9 | uniq | wc`
set lvars = `ls -1 $ifiles | cut -d"." -f9 | uniq`
foreach v ($lvars)
echo $itrim, $time_freq, $nvars[1], $v
end
endif
end

end

exit


@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.00${mbr}
else
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
if (-d $TSERIES2/$CASE) then
    cd $TSERIES2/$CASE
    #set t1 = `ls  $TSERIES2/$CASE/atm/proc/tseries/month_1/*ZM_CLUBB* | wc -l`
    set t2 = `ls -lR $TSERIES2/$CASE | wc -l`
    set s2 = `du . -sh`
    if ($t2 < 1814 ) then
       echo  $CASE " ==============    " $t2  $s2
    else
       echo  $CASE " ===    " $t2  $s2
    endif
else
    echo " missing   ===    " $CASE
endif

end             # member loop
end             # member loop
end             # member loop

exit

