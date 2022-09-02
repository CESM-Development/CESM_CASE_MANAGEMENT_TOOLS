#!/bin/csh -fx
### set env variables
module load ncl nco

setenv ARCHDIR  /glade/scratch/molina/archive/
setenv CAMPDIR  /glade/campaign/cgd/ccr/nanr/AMOC/LR/
setenv LOGSDIR  $CAMPDIR/logs
setenv RESTDIR  $CAMPDIR/restarts
setenv POPDDIR  $CAMPDIR/pop.d_files

set CASE = b.e21.B1850cmip6.f09_g17.1PCT-rampDown.001
set CASE = b.e21.B1850cmip6.f09_g17.AMOC-4xco2.001

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


exit

