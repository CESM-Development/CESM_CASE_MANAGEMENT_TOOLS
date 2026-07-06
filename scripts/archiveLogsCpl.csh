#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm13-SPNA-HR/scripts/
setenv TSERIES  /glade/campaign/cgd/ccr/yeager/WISHBONE/timeseries-5yrs
setenv LOGSDIR  /glade/campaign/cgd/ccr/yeager/WISHBONE/logs-5yrs
setenv RESTDIR  /glade/campaign/cgd/ccr/yeager/WISHBONE/restarts-5yrs
setenv POPDDIR  /glade/campaign/cgd/ccr/yeager/WISHBONE/popd-5yrs

set syr = 112
set eyr = 112

setenv ARCHNANR  /glade/derecho/scratch/nanr/archive/

set CASE = b.e13.SPNA-derecho.ne120_t12.SY-${syr}.001

set USE_ARCHDIR = $ARCHNANR

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
else
   cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/
   echo "cpl done"
endif
if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
else
   echo "logs done"
endif
# if (! -e $RESTDIR/$CASE.rest.tar) then
   # cd $USE_ARCHDIR
   # tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
# else
   # echo "rest done"
# endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif

exit

