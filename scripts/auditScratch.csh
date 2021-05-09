#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv ARCHDIR  /glade/scratch/cesmsf/archive/

# ...
foreach exper ( EE EE-SSP370 GHG GHG-SSP370 AAER AAER-SSP370 BMB BMB-SSP370 )


# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-${exper}.00${mbr}
else
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-${exper}.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
if (-d $ARCHDIR/$CASE) then
    cd $ARCHDIR/$CASE
    set t2 = `ls -lR $ARCHDIR/$CASE | wc -l`
    set s2 = `du . -sh`
    echo  $CASE " ===    " $t2  $s2
else
    echo " missing   ===    " $CASE
endif

end             # member loop
end             # member loop

exit

