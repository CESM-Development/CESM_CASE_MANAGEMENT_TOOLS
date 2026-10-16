#!/bin/csh -fx
setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-nudged-ERA5/

setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.5/

set COMPSET = BHISTsmbb
set MACHINE = derecho
set RESOLN = f09_g17
set RESUBMIT = 14
set STOP_N=3
set REST_N=3
set STOP_OPTION=nyears

@ USE_REFDATE = 1979 
setenv CASENAME b.e21.${COMPSET}.${RESOLN}.nudgeUV_6h_ERA5.001

setenv CASEROOT /glade/campaign/cesm/development/espwg/CESM2_nudged/$CASENAME
setenv RUNROOT $SCRATCH/$CASENAME/run

echo $CASEROOT

# ===================================================================================
# ===================================================================================
#  NOTE:  First member of ensemble creates executable
# ===================================================================================
# ===================================================================================

  $CESMROOT/cime/scripts/create_newcase --case $CASEROOT --res $RESOLN  --mach $MACHINE --compset $COMPSET 
  cd $CASEROOT
  
  ./case.setup
  mv user_nl_ww   user_nl_ww.`date +%m%d-%H%M`
  mv user_nl_clm  user_nl_clm.`date +%m%d-%H%M`
  mv user_nl_cam  user_nl_cam.`date +%m%d-%H%M`
  mv user_nl_cpl  user_nl_cpl.`date +%m%d-%H%M`
  mv user_nl_cice user_nl_cice.`date +%m%d-%H%M`
  mv user_nl_mosart user_nl_mosart.`date +%m%d-%H%M`
  cp $CESM2_TOOLS_ROOT/user_nl_files/BHISTsmbb/mbrs11-50/user_nl*  $CASEROOT/
  cp $CESM2_TOOLS_ROOT/SourceMods/src.pop/BHISTsmbb/* $CASEROOT/SourceMods/src.pop/
  cp $CESM2_TOOLS_ROOT/SourceMods/src.cam/* $CASEROOT/SourceMods/src.cam/
  cp $CESM2_TOOLS_ROOT/SourceMods/src.clm/* $CASEROOT/SourceMods/src.clm/

cat <<EOF>> user_nl_cam

!! from: /glade/u/home/islas/scripts/MAPP2023/nudging_uv/setup_nudgerun.sh
  Nudge_Model            =.true.
  Nudge_Path             ='/glade/campaign/cgd/cas/islas/ERA5_nudging_input_6h/fv1x1/L32/'
  Nudge_File_Template    ='ERA5_x_fv1x1_L32_rgC2_WO.%y-%m-%d-%s.nc'
  Nudge_Force_Opt        = 1
  Nudge_Timescale_Opt    = 0
  Nudge_Times_Per_Day    = XNUDGETIMEPERDAYX
  Model_Times_Per_Day    = 48
  Nudge_Uprof  =1
  Nudge_Ucoef  =XCOEF
  Nudge_Vprof  =1
  Nudge_Vcoef  =XCOEF
  Nudge_Tprof  =0
  Nudge_Tcoef  =0
  Nudge_Qprof  =0
  Nudge_Qcoef  =0
  Nudge_PSprof =0
  Nudge_PScoef =0
  Nudge_Beg_Year =1979
  Nudge_Beg_Month=1
  Nudge_Beg_Day  =1
  Nudge_End_Year =2024
  Nudge_End_Month=12
  Nudge_End_Day  =31

EOF

set nudge_times_per_day = 4

# Nudging timescale
set tau = 6
set nudge_coef = `echo "24 / $nudge_times_per_day / $tau" | bc -l`
set nudge_coef = `printf "%.4f\n" $nudge_coef`
echo $nudge_coef

# 
 sed -i "s|XCOEF|$nudge_coef|g" user_nl_cam
 sed -i "s|XNUDGETIMEPERDAYX|$nudge_times_per_day|g" user_nl_cam
 
  ./xmlchange RUN_REFCASE=b.e21.IC_nudgeUV.f09_g17.1979-01.01
  ./xmlchange RUN_REFDATE=${USE_REFDATE}-01-01
  ./xmlchange RUN_STARTDATE=${USE_REFDATE}-01-01
  ./xmlchange DOUT_S_SAVE_INTERIM_RESTART_FILES=TRUE
  ./xmlchange STOP_N=$STOP_N
  ./xmlchange STOP_OPTION=$STOP_OPTION
# Steve: need monthly restarts
  ./xmlchange REST_N=1
  ./xmlchange REST_OPTION=nmonths
  ./xmlchange RESUBMIT=$RESUBMIT


  ./xmlchange RUN_REFDIR="/glade/work/nanr/CESM2-nudged-ERA5/inputdata/cesm2_init/b.e21.IC_nudgeUV.f09_g17.1979-01.01/1979-01-01/"
  ./xmlchange GET_REFCASE=TRUE

  qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

echo $CASEROOT


exit

