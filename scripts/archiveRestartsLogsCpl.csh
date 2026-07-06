#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-orbital/
setenv ARCHDIR1  /glade/derecho/scratch/$USER/archive/
setenv TSERIES  /glade/campaign/cgd/ccr/nanr/AMOC/LR/
setenv LOGSDIR  /glade/campaign/cgd/ccr/nanr/AMOC/LR/logs
setenv RESTDIR  /glade/campaign/cgd/ccr/nanr/AMOC/LR/restarts
setenv POPDDIR  /glade/campaign/cgd/ccr/nanr/AMOC/LR/pop.d_files

#foreach CASE ( b.e21.BHISTcmip6.f09_g17.obliq_24.5.001 b.e21.BHISTcmip6.f09_g17.obliq_22.5.001 )
foreach CASE ( b.e21.B1850cmip6.f09_g17.obliq_24.5.001 b.e21.B1850cmip6.f09_g17.obliq_22.5.001 )
#foreach CASE ( b.e21.BHISTcmip6.f09_g17.obliq_22.5.001 )

set USE_ARCHDIR = $ARCHDIR1

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
        cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/
else
   echo "cpl done"
endif
if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
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

end

exit

