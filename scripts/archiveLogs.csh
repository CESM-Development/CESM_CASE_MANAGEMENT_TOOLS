#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm13-ne120_g16/
setenv ARCHDIR1  /glade/derecho/scratch/$USER/archive/
setenv TSERIES  /glade/campaign/cesm/development/cvcwg/cvwg/HR-LR/timeseries
setenv LOGSDIR  /glade/campaign/cesm/development/cvcwg/cvwg/HR-LR/logs
setenv POPDDIR  /glade/campaign/cesm/development/cvcwg/cvwg/HR-LR/popd

set USE_ARCHDIR = $ARCHDIR1

set CASE = b.e13.BHISTC5.HR-LR-derecho-1920.ne120_g16.001

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
endif
cp $USE_ARCHDIR/$CASE/cpl/hist/*.gz $TSERIES/$CASE/cpl/hist/

if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
else
   echo "logs done"
endif
#if (! -e $RESTDIR/$CASE.rest.tar) then
   #cd $USE_ARCHDIR
   #tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
#else
   #echo "rest done"
#endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif


exit

