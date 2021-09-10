#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv ARCHDIR   /glade/scratch/cesmsf/archive/
setenv RESTDIR   /glade/campaign/cesm/collections/CESM2-SF/restarts/

# ...
#foreach exper ( EE EE-SSP370 GHG GHG-SSP370 AAER AAER-SSP370 BMB BMB-SSP370 )
foreach exper ( BMB )

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
echo 'Member = ' $mbr
echo 'Case   = ' $CASE

if (-e $RESTDIR/$CASE/$CASE.rest.2015-01-01-00000.tar) then
   echo $RESTDIR/$CASE/$CASE.rest.2015-01-01-00000.tar
   #cd $ARCHDIR/$CASE/rest; 
   #mkdir toss
   #mv -rf 18* toss
   #mv -rf 19* toss
   echo "Restarts removed $CASE"
else
   echo $RESTDIR/$CASE/$CASE.rest.2015-01-01-00000.tar
   echo "Case restarts need to be archived $CASE"
endif

end             # member loop
end             # member loop

exit

