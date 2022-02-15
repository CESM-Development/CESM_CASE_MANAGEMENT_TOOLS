#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-sf/
setenv ARCHDIR  /glade/scratch/cesmsf/archive/
setenv CAMPDIR  /glade/campaign/cesm/collections/CESM2-SF/
setenv LOGSDIR  $CAMPDIR/logs
setenv RESTDIR  $CAMPDIR/restarts
setenv POPDDIR  $CAMPDIR/pop.d_files

set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.10${mbr}
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.10${mbr}
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.00${mbr}
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB-SSP370.00${mbr}
else
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.1${mbr}
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.1${mbr}
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.0${mbr}
        #set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB-SSP370.0${mbr}
endif

tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*

## use this script instead:
## ./garyRestarts.commandline.csh
## ./garyRestarts.commandline-ssp370.csh
set doRestarts = 0
if ($doRestarts == 1) then
#set srest = 2018
#set erest = 2051
set srest = 1853
set erest = 2015
@ sr = $srest
@ er = $erest

while ($sr <= $er) 
   tar -cvf $RESTDIR/$CASE.${sr}-01-01-00000.tar $ARCHDIR/$CASE/rest/${sr}-01-01-00000/
   @ sr += 3
end

endif

end             # member loop

exit

