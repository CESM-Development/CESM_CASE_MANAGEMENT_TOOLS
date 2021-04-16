#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv ARCHDIR  /glade/scratch/$USER/SMYLE/archive/
setenv TSERIES  /glade/campaign/cesm/development/espwg/SMYLE/archive
setenv LOGSDIR  /glade/campaign/cesm/development/espwg/SMYLE/logs
setenv RESTDIR  /glade/campaign/cesm/development/espwg/SMYLE/restarts

set syr = 1990
set eyr = 1999

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
#foreach mon ( 02 05 08 11 )
foreach mon ( 11 )


# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.00${mbr}
else
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.0${mbr}
endif

echo 'Year   = ' $year
echo 'Member = ' $mbr
echo 'Case   = ' $CASE

#cd $ARCHDIR/$CASE; tar -cvf $LOGSDIR/$CASE.logs.tar logs/
                   #tar -cvf $RESTDIR/$CASE.rest.tar rest/
tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs/
tar -cvf $RESTDIR/$CASE.rest.tar $ARCHDIR/$CASE/rest/

end             # member loop

exit

