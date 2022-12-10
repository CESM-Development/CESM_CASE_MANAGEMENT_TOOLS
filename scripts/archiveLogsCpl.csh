#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-L83/
setenv USE_ARCHDIR  /glade/scratch/$USER/archive/
setenv CSDIR    /glade/campaign/cesm/development/cvcwg/cvwg/L83/
setenv TSERIES  $CSDIR/timeseries
setenv LOGSDIR  $CSDIR/logs
setenv RESTDIR  $CSDIR/restarts
setenv POPDDIR  $CSDIR/popd_files
setenv CASE     b.e21.BHISTcmip6.f09_g17.L83_cam6.001

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
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
# if (! -e $RESTDIR/$CASE.rest.tar) then
#    cd $USE_ARCHDIR
#    tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
# else
#    echo "rest done"
# endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif

exit

