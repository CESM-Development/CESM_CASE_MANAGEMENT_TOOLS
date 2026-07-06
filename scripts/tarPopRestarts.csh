#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-bruteForce/
setenv ARCHDIR  /glade/scratch/nanr/archive/
#setenv CAMPDIR  /glade/campaign/cesm/collections/CESM2-SF/
#setenv LOGSDIR  $CAMPDIR/logs
#setenv POPDDIR  $CAMPDIR/pop.d_files
setenv RESTDIR  /glade/campaign/cgd/ccr/nanr/decadalPrediction/pop-restarts/

set smbr=1
set embr=1

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.B2000cmip6.f09_g17.ocnSpinup.00${mbr}
else
        set CASE = b.e21.B2000cmip6.f09_g17.ocnSpinup.0${mbr}
endif

#tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
#tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*

set doRestarts = 1
if ($doRestarts == 1) then
#set srest = 2018
#set erest = 2051
set srest = 197
set erest = 201
@ sr = $srest
@ er = $erest

while ($sr <= $er) 
  set mon = 1
  while ($mon <= 12) 
     if ($mon < 10) then
        tar -cvf $RESTDIR/$CASE.0${sr}-0$mon-01-00000.tar $ARCHDIR/$CASE/rest/0${sr}-0$mon-01-00000/*.pop.*
     else
        tar -cvf $RESTDIR/$CASE.0${sr}-$mon-01-00000.tar $ARCHDIR/$CASE/rest/0${sr}-$mon-01-00000/*.pop.*
     endif
     @ mon += 1
  end
@ sr += 1

endif

end             # member loop

exit

