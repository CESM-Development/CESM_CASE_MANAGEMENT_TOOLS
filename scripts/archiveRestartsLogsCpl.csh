#!/bin/csh -fx
### set env variables
module load ncl nco

setenv TSERIES  /glade/campaign/cgd/ccr/AMOC/cesm2/timeseries
setenv LOGSDIR  /glade/campaign/cgd/ccr/AMOC/cesm2/logs
setenv RESTDIR  /glade/campaign/cgd/ccr/AMOC/cesm2/restarts
setenv POPDDIR  /glade/campaign/cgd/ccr/AMOC/cesm2/popd

setenv ARCHNANR  /glade/derecho/scratch/$USER/archive/
#setenv ARCHNANR  /glade/campaign/cgd/ccr/AMOC/cesm2/history-files/


# case name counter
set smbr =  10
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-PAC_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.00${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-ATL_15d50m.derecho.00${mbr}
	set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-PAC_15d50m.derecho.00${mbr}
else
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-PAC_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.0${mbr}
	#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-ATL_15d50m.derecho.0${mbr}
	set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-PAC_15d50m.derecho.0${mbr}
endif

set USE_ARCHDIR = $ARCHNANR

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
endif
#else
   cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/
   echo "cpl done"
#endif

set filename = $CASE.logs.tar
set empty_size = 10240  # Replace with your desired size in kilobytes

# Check if the file exists
if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
      echo "tar file doesn't exist"
else
   if (`stat -c %s $LOGSDIR/$filename` == $empty_size) then
      echo "$filename is smaller than $desired_size KB"
      echo "making new tarfile\n"
      cd $USE_ARCHDIR
      mv $LOGSDIR/$filename $LOGSDIR/$filename.empty
      tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
   else
      echo "logs done"
   endif
endif

set doRest = 1
if ($doRest == 1) then
## Archive restarts
set filename = $CASE.rest.tar
if (! -e $RESTDIR/$CASE.rest.tar) then
   cd $USE_ARCHDIR
   tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
else
   if (`stat -c %s $RESTDIR/$filename` == $empty_size) then
      echo "$filename is smaller than $desired_size KB"
      echo "making new tarfile\n"
      cd $USE_ARCHDIR
      mv $RESTDIR/$filename $RESTDIR/$filename.empty
      tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
   else
      echo "rest done"
   endif
endif

endif

## Archive popd files
set filename = $CASE.popd.tar
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   if (`stat -c %s $POPDDIR/$filename` == $empty_size) then
      echo "$filename is smaller than $desired_size KB"
      echo "making new tarfile\n"
      cd $USE_ARCHDIR
      mv $POPDDIR/$filename $POPDDIR/$filename.empty
      tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
   else
      echo "popd done"
   endif
endif

end             # member loop

exit

