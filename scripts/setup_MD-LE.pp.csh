#!/bin/csh -fx
### set env variables
setenv TOOLSROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-MD-LE/
#setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08
setenv CESMROOT /glade/work/kmcmonigal/cesm2.1.4-rc.08_decouple_ocn_B1850_f09_g17

#setenv POSTPROCESS_PATH /glade/u/home/mickelso/CESM_postprocessing_3/
setenv POSTPROCESS_PATH /glade/work/jedwards/sandboxes/CESM_postprocessing/

module load ncl nco
module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing


set COMPSET = BHISTsmbb
set COMPSET = BHIST
set SIMULAT = MD-LE-km
set MACHINE = cheyenne
set RESOLN = f09_g17
set RESUBMIT = 1
set STOP_N=3
set STOP_OPTION=nyears

setenv BASEROOT /glade/work/nanr/CESM2-MD-LE/
setenv BASENAME b.e21.${COMPSET}.${RESOLN}.${SIMULAT}

set doThis = 0
if ($doThis == 1) then
	cd ~nanr/CESM-WF/
	./create_cylc_ensemble-MD-LE --case $BASEROOT$BASENAME --res $RESOLN  --compset $COMPSET 
endif

# .001: 
#  RUN_REFDATE=

# now create cases
set  REFCASE = cesm2.1.4-rc.08_decouple_ocn_B1850_f09_g17

set smbr =  1
set embr =  3

#@ mb = $smbr
#@ me = $embr



set mbr = 1
foreach REFDATE (1318 1293 1295 1298 1304)
   echo $mbr
   echo $REFDATE

   if    ($mbr < 10) then
        setenv CASENAME b.e21.${COMPSET}.${RESOLN}.${SIMULAT}.00${mbr}
   else if ($mbr >= 10 && $mbr < 100) then
        setenv CASENAME b.e21.${COMPSET}.${RESOLN}.${SIMULAT}.0${mbr}
   endif
 
   setenv CASEROOT  $BASEROOT$CASENAME
   $CESMROOT/cime/scripts/create_newcase --case $CASEROOT --res $RESOLN  --compset $COMPSET
  
   if ($mbr == 1) then
    set masterroot = $CASENAME
   endif

   echo $CASENAME
   echo $REFDATE

   setenv REFROOT   /glade/scratch/kmcmonigal/archive/forNan/rest/$REFDATE-01-01-00000/
   setenv RUNROOT   /glade/scratch/nanr/$CASENAME/run/

   cd $CASEROOT

# 20 nodes
  ./xmlchange NTASKS_CPL=576
  ./xmlchange NTASKS_ATM=576
  ./xmlchange NTASKS_LND=504
  ./xmlchange NTASKS_ICE=36
  ./xmlchange NTASKS_OCN=144
  ./xmlchange NTASKS_ROF=468
  ./xmlchange NTASKS_GLC=576
  ./xmlchange NTASKS_WAV=36
  ./xmlchange ROOTPE_ICE=504
  ./xmlchange ROOTPE_OCN=576
  ./xmlchange ROOTPE_WAV=540

  mv user_nl_clm user_nl_clm.`date +%m%d-%H%M`
  cp $TOOLSROOT/user_nl_files/user_nl_cam $CASEROOT/
  cp $TOOLSROOT/user_nl_files/user_nl_clm $CASEROOT/
  cp $TOOLSROOT/SourceMods/src.pop/* $CASEROOT/SourceMods/src.pop/

  ./case.setup --reset

  ./xmlchange RUN_REFCASE=$REFCASE
  ./xmlchange GET_REFCASE=FALSE
  ./xmlchange RUN_REFDATE=$REFDATE-01-01
  ./xmlchange STOP_N=$STOP_N
  ./xmlchange STOP_OPTION=$STOP_OPTION
  ./xmlchange RESUBMIT=$RESUBMIT

  cp $REFROOT/rpoint*   $RUNROOT/
  ln -s $REFROOT/$REFCASE* $RUNROOT/
  ln -s /glade/scratch/kmcmonigal/archive/forNan/x2oavg_Foxx_taux_6hourly.nc $RUNROOT/
  ln -s /glade/scratch/kmcmonigal/archive/forNan/x2oavg_Foxx_tauy_6hourly.nc $RUNROOT/

  set doPP = 0
  if ($doPP == 1) then
  	if ( ! -d "postprocess" ) then
   		create_postprocess -caseroot=`pwd`
  	endif
  	cd postprocess
  	pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/nanr/timeseries/$CASE/
  	pp_config --set CASE=$CASE
  	pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
  	pp_config --set ATM_GRID=0.9x1.25
  	pp_config --set LND_GRID=0.9x1.25
  	pp_config --set ICE_GRID=gx1v7
  	pp_config --set OCN_GRID=gx1v7
  	pp_config --set ICE_NX=320
  	pp_config --set ICE_NY=384
  endif
  
  ./preview_namelists

  # using single executable
  if ($mbr == 1) then
     ./case.build >& bld.`date +%m%d-%H%M`
  else
     ./case.setup --reset
     ./xmlchange EXEROOT=/glade/scratch/$USER/$masterroot/bld/
     ./xmlchange BUILD_COMPLETE=TRUE
  endif

  @ mbr ++

end             # REFDATE loop

exit

