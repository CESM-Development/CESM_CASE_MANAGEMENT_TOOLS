#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-NoPinatubo/
setenv ARCHDIR1  /glade/scratch/$USER/archive/
setenv TSERIES  /glade/campaign/cgd/ccr/nanr/noPinatubo/timeseries
setenv RESTDIR  /glade/campaign/cgd/ccr/nanr/noPinatubo/restarts
setenv LOGSDIR  /glade/campaign/cgd/ccr/nanr/noPinatubo/logs
setenv POPDDIR  /glade/campaign/cgd/ccr/nanr/noPinatubo/restarts

set USE_ARCHDIR = $ARCHDIR1

set COMPSET=BHISTsmbb
set COMPSET=BHISTcmip6
set useyr = 1231
#set useyr = 1251


# case name counter
#set smbr =  11
#set embr =  20
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.${COMPSET}.f09_g17.LE2-${useyr}.00${mbr}-noPinatubo.001
else
        set CASE = b.e21.${COMPSET}.f09_g17.LE2-${useyr}.0${mbr}-noPinatubo.001
endif

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
else
        cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/
else
   echo "cpl done"
endif
if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/
else
   echo "logs done"
endif
if (! -e $RESTDIR/$CASE.rest.tar) then
   cd $USE_ARCHDIR
   tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
else
   echo "rest done"
endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif

end             # member loop

exit

