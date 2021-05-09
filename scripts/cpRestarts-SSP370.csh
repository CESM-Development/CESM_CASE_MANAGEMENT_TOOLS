#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv ARCHDIR   /glade/scratch/cesmsf/archive/
setenv CAMPDIR   /glade/campaign/cesm/collections/CESM2-SF-temp/
setenv LOGSDIR   $CAMPDIR/logs/
setenv RESTDIR   $CAMPDIR/restarts/
setenv POPDDIR   $CAMPDIR/pop.d_files/

# ...
#foreach exper ( EE EE-SSP370 GHG GHG-SSP370 AAER AAER-SSP370 BMB BMB-SSP370 )
foreach exper ( EE-SSP370)

# case name counter
set smbr =  1
set embr =  5

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

if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $ARCHDIR/$CASE; 
   tar -cvf $LOGSDIR/$CASE.logs.tar logs/
   cd $ARCHDIR/$CASE/ocn/hist/; 
   tar -cvf $POPDDIR/$CASE.pop.d.tar *pop.d*
endif
if (! -e $LOGSDIR/$CASE.rest.2018-01-01-00000.tar) then
   cd $ARCHDIR/$CASE/rest; 
   tar -cvf $RESTDIR/$CASE.rest.2018-01-01-00000.tar 2018-01-01-00000/
   tar -cvf $RESTDIR/$CASE.rest.2024-01-01-00000.tar 2024-01-01-00000/
   tar -cvf $RESTDIR/$CASE.rest.2036-01-01-00000.tar 2036-01-01-00000/
   tar -cvf $RESTDIR/$CASE.rest.2051-01-01-00000.tar 2051-01-01-00000/
endif

end             # member loop
end             # member loop

exit

