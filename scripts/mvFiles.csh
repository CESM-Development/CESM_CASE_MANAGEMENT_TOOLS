#!/bin/csh -fx
### set env variables
setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-historicalPacemaker/

set COMPSET = BSSP585cmip6
set RESOLN = f09_g17
set STOP_OPTION=nyears
set PROJECT=P93300313

#setenv SCENARIO HIST-ATL_15d50m.derecho
#setenv USEEXEROOT  ATL-EXEROOT-SSP
#setenv SCENARIO HIST-IND_15d50m.derecho
#setenv USEEXEROOT  IND-EXEROOT-SSP
setenv SCENARIO HIST-PAC_15d50m.derecho

# case name counter
set smbr =  1
set embr =  1

@ mb = $smbr
@ me = $embr

# reference name counter

foreach mbr ( `seq $mb  $me` )

  set padded_mbr = `printf "%03d" $mbr`

  setenv CASENAME b.e21.${COMPSET}.${RESOLN}.${SCENARIO}.${padded_mbr}
  setenv TSERIESROOT /glade/derecho/scratch/nanr/timeseries/$CASENAME/
  setenv ARCHIVEROOT /glade/campaign/cgd/ccr/AMOC/cesm2/timeseries/$CASENAME/
  foreach comp ( atm  ice  lnd  ocn rof )
  #foreach comp ( atm )
	  if ($comp == atm) then
		  foreach freq ( day_1  hour_3  hour_6  month_1 )
		  #foreach freq ( day_1 )
			#echo $TSERIESROOT/$comp/proc/tseries/$freq/ $ARCHIVEROOT/$freq/
			#ls -1 $TSERIESROOT/$comp/proc/tseries/$freq/ 
			#ls -1 $ARCHIVEROOT/$freq/
			mv $TSERIESROOT/$comp/proc/tseries/$freq/* $ARCHIVEROOT/$comp/proc/tseries/$freq/
		end
	  else
  		foreach freq ( day_1  month_1 )
			#ls -1 $TSERIESROOT/$comp/proc/tseries/$freq/ 
			#ls -1 $ARCHIVEROOT/$freq/
			mv $TSERIESROOT/$comp/proc/tseries/$freq/* $ARCHIVEROOT/$comp/proc/tseries/$freq/
		end
	endif
  end

end             # member loop

exit

