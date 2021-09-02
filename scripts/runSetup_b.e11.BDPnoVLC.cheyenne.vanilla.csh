#!/bin/csh -f
#module load subversion

#setenv HOMEDIR `pwd`
#/global/u2/n/nanr/ccp/decadalPrediction-No_Volc/setup
setenv HOMEDIR /glade/work/nanr/cesm_tags/CASE_tools/cesm1-DP/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm1_1_2_LENS_n21/
#setenv CESMROOT /project/projectdirs/ccsm1/collections/cesm1_1_2_LENS/
setenv MACH cheyenne
setenv COMPSET B20TRLENSNOVOLC
setenv RESLN f09_g16
setenv DPINPUT /glade/scratch/nanr/DP/inputdata/DP
setenv CESMINPUT /glade/p/cesm/cseg/inputdata


#foreach  year ( 1954 1964 1974 1984 1994 2004 )
# syr = novYr+1
# 1955 Nov-initlalized: ensemble member 4, 5
set syr = 1999
set eyr = 1999

set smbr = 1
set embr = 1

@ ib = $syr
@ ie = $eyr

@ mb = $smbr
@ me = $embr

foreach year ( `seq $ib $ie` )

foreach mbr ( `seq $mb $me` )

@ yearm1 = $year - 1
# Use restarts created from case 001 for all ensemble members;  pertlim will differentiate runs.

#set REFCASE    = b.e11.BDP_IC.NorthAtlantic.f09_g16.1998-11.01
set REFCASE    = b.e11.BDP_IC.f09_g16.1998-11.01
if ($mbr < 10) then
	set CASE = b.e11.BDPNoVLC.f09_g16.vanilla.${yearm1}-11.00${mbr}
else
	set CASE = b.e11.BDPNoVLC.f09_g16.vanilla.${yearm1}-11.00${mbr}
endif
echo 'Year = ' $year
echo 'Member = ' $mbr
echo 'Case = ' $CASE

setenv CASEROOT /glade/scratch/$USER/$CASE
setenv WKDIR    /glade/scratch/$USER/
setenv RESTDIR  /glade/scratch/xianwu/restarts/b.e11.BDP_IC.NorthAtlantic.f09_g16.1998-11.01/1998-11-01/
setenv RESTDIR  /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.1998-11.01/1998-11-01/
setenv RUNDIR   /$WKDIR/$CASE/run


echo "setting up case = " $CASE

#cd /global/project/projectdirs/ccsm1/collections/cesm1_0_6/scripts 
 if (! -d $CASEROOT) then
 	cd $CESMROOT/scripts
 	./create_newcase -case $CASEROOT -mach $MACH -compset $COMPSET -res $RESLN -compset_file $CESMROOT/scripts/ccsm_utils/Case.template/config_compsets.DPnoVolc.xml
 endif
 cd $CASEROOT

# cp ~/NoVolc/env_mach_pes.xml-cesm2 $CASEROOT/env_mach_pes.xml

./xmlchange -file env_run.xml -id RUN_TYPE -val 'hybrid'
./xmlchange -file env_run.xml -id RUN_STARTDATE -val $yearm1'-11-01'
./xmlchange -file env_run.xml -id RUN_REFCASE   -val $REFCASE 
./xmlchange -file env_run.xml -id RUN_REFDATE   -val $yearm1'-11-01'
./xmlchange -file env_run.xml -id BRNCH_RETAIN_CASENAME -val 'TRUE'
./xmlchange -file env_run.xml -id GET_REFCASE -val 'FALSE'
./xmlchange -file env_run.xml -id STOP_OPTION -val 'nmonths'
./xmlchange -file env_run.xml -id STOP_N -val '14'
#./xmlchange -file env_run.xml -id STOP_N -val '122'
./xmlchange -file env_run.xml -id REST_N -val \$STOP_N

./xmlchange NTASKS_ATM=720
./xmlchange NTHRDS_ATM=2
./xmlchange NTASKS_CPL=720
./xmlchange NTHRDS_CPL=2

./xmlchange NTASKS_LND=144
./xmlchange NTHRDS_LND=2
./xmlchange NTASKS_ROF=144
./xmlchange NTHRDS_ROF=2

./xmlchange NTASKS_ICE=576
./xmlchange NTHRDS_ICE=1
./xmlchange ROOTPE_ICE=144

./xmlchange NTASKS_ICE=144
./xmlchange NTHRDS_ICE=2
./xmlchange ROOTPE_ICE=720


# set this to avoid attribute write errors that result in mismatch (jim edwards)
./xmlchange -file env_run.xml -id ICE_PIO_TYPENAME  -val 'netcdf'

# Turn on long-term archive, but modify l_archive script (below) to concatenate ice fields.
./xmlchange -file env_run.xml -id DOUT_L_MS -val 'TRUE'

#./xmlchange -file env_run.xml -id DOUT_L_MSROOT -val '/home/c/ccsm/csm/$CASE'
./xmlchange -file env_run.xml -id DOUT_S_SAVE_INT_REST_FILES -val TRUE

./cesm_setup
 # Steve SourceMods
 cp $HOMEDIR/SourceMods/src.pop2/* $CASEROOT/SourceMods/src.pop2/
 #cp $CASE.l_archive $CASE.l_archive.`date +%m%d-%H%M`
 #cp $CASE.run $CASE.run.`date +%m%d-%H%M`
 #cp ~/NoVolc/1955.run.template ./$CASE.run
 #cp $HOMEDIR/NoVolc/l_archive.template ./$CASE.l_archive

# ========================
# # POP2 forcing
# # ========================
mv user_nl_pop2 user_nl_pop2.`date +%m%d-%H%M`
cat >> user_nl_pop2 << EOF
pcfc_file = '$CESMINPUT/ocn/pop/res_indpt/forcing/pcfc1112_1931-2100_atm_sio1993_c150717.nc'
ndep_data_type = 'shr_stream'
ndep_shr_stream_file = '/$CESMINPUT/ocn/pop/gx1v6/forcing/ndep_ocn_1850-2100_rcp85_gx1v6_c150818.nc'
ndep_shr_stream_scale_factor = 7.1429e+06
ndep_shr_stream_year_align = 1849
ndep_shr_stream_year_first = 1849
ndep_shr_stream_year_last = 2101
EOF


# ========================
# rtm 
# ========================
mv user_nl_rtm user_nl_rtm.`date +%m%d-%H%M`
cat >> user_nl_rtm << EOF
!----------------------------------------------------------------------------------
! Users should add all user specific namelist changes below in the form of
! namelist_var = new_namelist_value
! NOTE: namelist variable rtm_tstep CAN ONLY be changed by modifying the value
!       of the xml variable ROF_NCPL in env_run.xml
! NOTE: if the xml variable ROF GRID in env_build.xml is set to 'null', then
!        the RTM build-namelist will set do_rtm to .false. - and will ignore
!        any change below
!----------------------------------------------------------------------------------
! ADDED FOR LENS EXPERIMENT
rtmhist_nhtfrq=0,-24
rtmhist_mfilt=1,365
rtmhist_fincl2='QCHANR:A','VOLR:A'
EOF

# ===========================
# sea ice - move 6-hourly fields to daily fields 
# ===========================
mv user_nl_cice user_nl_cice.`date +%m%d-%H%M`
cat >> user_nl_cice << EOF
! Handy Six-hourly output is turned on for 1990-2005 only
histfreq='m','d','x','x','x'
!histfreq='m','d','h','x','x'
histfreq_n=1,1,6,1,1
f_aice='mdxxx'
f_daidtt='mdxxx'
f_daidtd='mdxxx'
f_dvidtd='mdxxx'
f_dvidtt='mdxxx'
f_hs='mdxxx'
f_hi='mdxxx'
f_fswdn='mdxxx'
f_fswabs='mdxxx'
f_aicen='mdxxx'
f_apondn='mdxxx'
f_uvel='mdxxx'
f_vvel='mdxxx'
f_meltt='mdxxx'
f_meltb='mdxxx'
f_strinty='mdxxx'
f_strintx='mdxxx'
f_strairx='mdxxx'
f_strairy='mdxxx'
f_strocnx='mdxxx'
f_strocny='mdxxx'
f_fswthru='mdxxx'
f_fs='mdxxx'
f_faero_atm = 'xxxxx'
f_faero_ocn = 'xxxxx'

EOF

# ========================
# change to economy queue; change runtime from 8 to 12 hours.
# ========================
#cp $CASE.run $CASE.run.`date +%m%d-%H%M`
#mv $CASE.run tmp.run
#cat tmp.run | sed 's/8:00/12:00/;s/regular/premium/;s/P93300014/CESM0005/' > $CASE.run
#rm  tmp.run

set doThis=1

if (doThis == 1) then
# ========================
# change longterm archiver to concatenate daily ice files into monthly.
# ========================
cp $CASE.l_archive $CASE.l_archive.`date +%m%d-%H%M`
mv $CASE.l_archive tmp.l_archive
echo 'egrep -n "source" $CASEROOT/tmp.l_archive | cut -d":" -f1'
set lnum = `egrep -n "source" $CASEROOT/tmp.l_archive | cut -d":" -f1`
echo 'lnum = ' $lnum
head -$lnum tmp.l_archive > $CASE.l_archive
cat >> $CASE.l_archive << EOF


#-----------------------------
# Concatenate daily cice hist
#-----------------------------
echo -n 'Begin concat cice ' ; date
echo -n 'Module load ncl ' ; date
module load ncl
echo -n 'Module load nco ' ; date
module load nco
echo ""
cd \$DOUT_S_ROOT/ice/hist
set time=(3600 "%E %P %Uu %Ss")
time /global/u2/n/nanr/bin/concat_daily_hist_cice.csh
unset time
echo ""
echo -n 'End concat cice ' ; date

endif

# Turn off regular LT archiver
# cd \$DOUT_S_ROOT
# $CASEROOT/Tools/lt_archive.sh -m copy_dirs_hsi

#exit 0

EOF
# rm tmp.l_archive


 
# ========================
# CAM output
# ========================

 mv user_nl_cam user_nl_cam.`date +%m%d-%H%M`
cat >> user_nl_cam << EOF

! Users should add all user specific namelist changes below in the form of
! namelist_var = new_namelist_value
! These are specific changes to CAM for the LENS experiment
 pertlim = ${mbr}.d-14
 inithist='MONTHLY'
 cldfrc_rhminl = 0.8925D0
 nhtfrq=0,-24,-6
 mfilt=1,365,1460
 empty_htapes=.true.
 fincl1='ABSORB:A','ANRAIN:A','ANSNOW:A','AODDUST1:A','AODDUST2:A','AODDUST3:A',
  'AODVIS:A','AQRAIN:A','AQSNOW:A','AREI:A','AREL:A','AWNC:A','AWNI:A','CDNUMC:A',
  'CLDHGH:A','CLDICE:A','CLDLIQ:A','CLDLOW:A','CLDMED:A','CLDTOT:A','CLOUD:A',
  'DCQ:A','DTCOND:A','DTV:A','FICE:A','FLDS:A','FLNS:A','FLNSC:A','FLNT:A',
  'FLNTC:A','FLUT:A','FLUTC:A','FREQI:A','FREQL:A','FREQR:A','FREQS:A','FSDS:A',
  'FSDSC:A','FSNS:A','FSNSC:A','FSNT:A','FSNTC:A','FSNTOA:A','FSNTOAC:A',
  'ICEFRAC:A','ICIMR:A','ICWMR:A','IWC:A','LANDFRAC:A','LHFLX:A','LWCF:A',
  'NUMICE:A','NUMLIQ:A','OCNFRAC:A','OMEGA:A','OMEGAT:A','PBLH:A','PRECC:A',
  'PRECL:A','PRECSC:A','PRECSL:A','PS:A','PSL:A','Q:A','QFLX:A','QRL:A','QRS:A',
  'RELHUM:A','SHFLX:A','SNOWHICE:A','SNOWHLND:A','SOLIN:A','SRFRAD:A','SWCF:A',
  'T:A','TAUX:A','TAUY:A','TGCLDIWP:A','TGCLDLWP:A','TMQ:A','TREFHT:A','TS:A',
  'U:A','U10:A','UU:A','V:A','VD01:A','VQ:A','VT:A','VU:A','VV:A','WSUB:A','Z3:A',
  'CCN3:A','UQ:A','WGUSTD:X','WSPDSRFMX:A','TSMX:X','TSMN:M','TREFHTMX:X','TREFHTMN:M',
  'bc_a1_SRF:A','dst_a1_SRF:A','dst_a3_SRF:A','pom_a1_SRF:A','so4_a1_SRF:A',
  'so4_a2_SRF:A','so4_a3_SRF:A','soa_a1_SRF:A','soa_a2_SRF:A','BURDENSO4:A',
  'BURDENBC:A','BURDENPOM:A','BURDENSOA:A','BURDENDUST:A','BURDENSEASALT:A',
  'AODABS:A','EXTINCT:A','PHIS:A','TROP_P:A','TROP_T:A','TOT_CLD_VISTAU:A',
  'ICLDIWP:A','ICLDTWP:A','CO2:A','CO2_LND:A','CO2_OCN:A','SFCO2:A','SFCO2_LND:A',
  'SFCO2_OCN:A','TMCO2:A','TMCO2_LND:A','TMCO2_OCN:A''CO2_FFF:A', 'SFCO2_FFF:A', 'TMCO2_FFF:A'
 fincl2='PSL:A','TS:A','TREFHT:A','TREFHTMN:M','TREFHTMX:X','PRECT:A','PRECL:A',
  'PRECSL:A','PRECSC:A','PRECTMX:A','TMQ:A','Z500:A','T500:A','Q500:A','U500:A',
  'V500:A','WSPDSRFAV:A','U200:A','V200:A','T200:A','Q200:A','U850:A','V850:A',
  'T850:A','Q850:A','UBOT:A','VBOT:A','QBOT:A','Z050:A','T010:A','U010:A',
  'FSNTOA:A','FLUT:A','LHFLX:A','SHFLX:A','FSNS:A','FLNS:A','FSNSC:A','FLNSC:A',
  'TAUX:A','TAUY:A','ICEFRAC:A','bc_a1_SRF:X','dst_a1_SRF:X','dst_a3_SRF:X','pom_a1_SRF:X',
  'so4_a1_SRF:X','so4_a2_SRF:X','so4_a3_SRF:X','soa_a1_SRF:X','soa_a2_SRF:X'

! fincl3='T:I','Q:I','U:I','V:I','TS:I','PS:I','FSNS:A','FLNS:A','FSDS:A','FLDS:A',
! 'CLDTOT:A','CLDLOW:A','CLDMED:A','CLDHGH:A','TGCLDLWP:A','TGCLDIWP:A',
! 'PRECT:A','TMQ:I'

! forcing for 1955 - ~2020 created by nanr
 ext_frc_specifier              = 'SO2         -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_elev_19500115-20401215_c150715.nc',
  'bc_a1       -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_bc_elev_19500115-20401215_c150715.nc',
  'num_a1      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a1_elev_19500115-20401215_c150715.nc',
  'num_a2      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a2_elev_19500115-20401215_c150715.nc',
  'pom_a1      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_oc_elev_19500115-20401215_c150715.nc',
  'so4_a1      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a1_elev_19500115-20401215_c150715.nc',
  'so4_a2      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a2_elev_19500115-20401215_c150715.nc'
 ext_frc_type           = 'INTERP_MISSING_MONTHS'
 srf_emis_specifier             = 'DMS       -> /$CESMINPUT/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1849-2300_c120214.nc',
  'SO2       -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_surf_19500115-20401215_c150715.nc',
  'SOAG      -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_soag_1.5_surf_19500115-20401215_c150715.nc',
  'bc_a1     -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_bc_surf_19500115-20401215_c150715.nc',
  'num_a1    -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a1_surf_19500115-20401215_c150715.nc',
  'num_a2    -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a2_surf_19500115-20401215_c150715.nc',
  'pom_a1    -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_oc_surf_19500115-20401215_c150715.nc',
  'so4_a1    -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a1_surf_19500115-20401215_c150715.nc',
  'so4_a2    -> /$DPINPUT/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a2_surf_19500115-20401215_c150715.nc'
 srf_emis_type          = 'INTERP_MISSING_MONTHS'
 tracer_cnst_datapath           = '/$DPINPUT/atm/cam/chem/trop_mozart_aero/oxid'
 tracer_cnst_file               = 'oxid_rcp85_v1_1.9x2.5_L26_19450115-20351215_c150715.nc'

 bndtvghg          = '/$CESMINPUT/atm/cam/ggas/ghg_rcp85_1765-2500_c100203.nc'
 co2flux_fuel_file = '/$DPINPUT/atm/cam/ggas/co2flux_fossil_RCP85_monthly_0.9x1.25_19500115-20351215_c150715.nc'
 solar_data_file                = '/$CESMINPUT/atm/cam/solar/spectral_irradiance_Lean_1610-2140_ann_c100408.nc'
 prescribed_ozone_datapath      = '/$DPINPUT/atm/cam/ozone'
 prescribed_ozone_file          = 'ozone_rcp85_v1_1.9x2.5_L66_19500115-20351215_c150915.nc'

EOF


# ========================
# remove pertlim from first member
# ========================
  if ($mbr == 1) then
   mv user_nl_cam tmp.cam
   cat tmp.cam | sed 's/pertlim/\! pertlim/;' > user_nl_cam
   rm tmp.cam
 endif

# ===========================
# Land
# ===========================
mv user_nl_clm user_nl_clm.`date +%m%d-%H%M`
cat >> user_nl_clm << EOF
fpftdyn                 = '/$CESMINPUT/lnd/clm2/surfdata/surfdata.pftdyn_0.9x1.25_rcp8.5_simyr1850-2100_c130702.nc'
stream_fldfilename_ndep = '/$CESMINPUT/lnd/clm2/ndepdata/fndep_clm_rcp8.5_simyr1849-2106_1.9x2.5_c100428.nc'
stream_year_last_ndep = 2100


EOF

echo " Copy Restarts -------------"
if (! -d $RUNDIR) then
	echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
endif
echo 'cp ' $RESTDIR/*   $RUNDIR/
cp $RESTDIR/*   $RUNDIR/

#echo " Finished namelists for " $year " -- " $mbr "-------------"


$CASE.build >& bld.`date +%m%d-%H%M`


end
end
exit


