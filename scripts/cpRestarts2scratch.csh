#!/bin/csh -fx
### set env variables
setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-historicalPacemaker/

#set COMPSET = BSSP585cmip6
set COMPSET = BHISTcmip6
set MACHINE = derecho
set RESOLN = f09_g17
set STOP_OPTION=nyears

#setenv SCENARIO HIST-ATL_15d50m.derecho
setenv SCENARIO HIST-IND_15d50m.derecho
#setenv SCENARIO HIST-PAC_15d50m.derecho
setenv BASEROOT /glade/work/nanr/CESM2-PACEMAKER/
setenv RUNROOT  /glade/derecho/scratch/nanr/archive/

# case name counter
set bmbr =  1
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

# reference name counter

foreach mbr ( `seq $mb  $me` )

  set padded_mbr = `printf "%03d" $mbr`

  setenv CASENAME b.e21.${COMPSET}.${RESOLN}.${SCENARIO}.${padded_mbr}

  setenv CASEROOT  $BASEROOT$CASENAME
  setenv REFROOT  /glade/campaign/cgd/ccr/AMOC/cesm2/restarts/$CASENAME/

  mkdir -p $RUNROOT/$CASENAME/rest/
  cd $RUNROOT/$CASENAME/rest/
  cp $REFROOT/$CASENAME*2015-01*.tar .
  tar -xvf $CASENAME*2015-01*.tar
  rm *.tar

  #cd $CASEROOT

  #./xmlchange STOP_N=1
  #./xmlchange REST_N=1
  #./xmlchange RESUBMIT=0
  #
  #if (${mbr} == 1) then
	  #./xmlchange EXEROOT=/glade/derecho/scratch/nanr/$USEEXEROOT/bld/
	  ##./case.setup --reset
	  #qcmd -A P93300313 -- ./case.build
	  #else
	  ##./case.setup --reset
	  #./xmlchange EXEROOT=/glade/derecho/scratch/nanr/$USEEXEROOT/bld/
	  ##./xmlchange BUILD_COMPLETE=TRUE
	  #endif
	  #

	  #./case.submit

end             # member loop

exit

