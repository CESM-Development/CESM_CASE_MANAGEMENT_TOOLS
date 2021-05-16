#!/bin/csh -f
#module load subversion

alias module 'eval `$LMOD_CMD tcsh  \!*`  && eval `$LMOD_SETTARG_CMD -s csh`'
module purge
module load ncarenv/1.3
module load intel/17.0.1
module load ncarcompilers/0.5.0
module load cylc/7.8.3
module load mpt/2.19
module load python/2.7.16
module load graphviz/2.40.1
module load pygtk

setenv CYLCDIR /glade/u/home/nanr/toolsCylc/wf_decadal-ensemble-BlueAction.che/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm1_1_2_LENS_n21
setenv MACH cheyenne
setenv COMPSET FAMIPC5CN
setenv EXP 2090const
setenv RESLN f09_f09
setenv CESMINPUT /glade/p/cesmdata/cseg/inputdata
set TOOLS_DIR=/glade/work/nanr/cesm_tags/CASE_tools/cesm1-2090/

set syr = 2090
set eyr = 2090

set smbr =   88
set embr =   88

@ ib = $syr
@ ie = $eyr

@ mb = $smbr
@ me = $embr

foreach year ( `seq $ib $ie` )

foreach mbr ( `seq $mb $me` )

# Use restarts created from case 001 for all ensemble members;  pertlim will differentiate runs.
set REFCASE    = b.e11.BRCP85C5CNBDRD.f09_g16.034
set SHORTCASE  = b.e11.${COMPSET}.${RESLN}.${EXP}.00${mbr}
if ($mbr < 10) then
	set CASENAME  = f.e11.${COMPSET}.f09_g16.${EXP}.00${mbr}
else
	set CASENAME  = f.e11.${COMPSET}.f09_g16.${EXP}.0${mbr}
endif
echo 'Year   = ' $year
echo 'Member = ' $mbr
echo 'Case   = ' $CASENAME

setenv SHORTCASEROOT /glade/scratch/nanr/
setenv CASEROOT /glade/work/$USER/2090const/$CASENAME
setenv RESTDIR //glade/scratch/nanr/archive/$REFCASE/rest/2091-01-01-00000/

setenv RUNDIR  /glade/scratch/nanr/$CASENAME/run

echo "setting up case = " $CASENAME

 if (! -d $CASEROOT) then
 	cd $CESMROOT/scripts
 	./create_newcase -case $CASEROOT -mach $MACH -compset $COMPSET -res $RESLN
 endif
 cd $CASEROOT

./xmlchange -file env_run.xml -id RUN_TYPE -val 'hybrid'
./xmlchange -file env_run.xml -id RUN_STARTDATE -val 2091-01-01
./xmlchange -file env_run.xml -id RUN_REFCASE   -val $REFCASE 
./xmlchange -file env_run.xml -id RUN_REFDATE   -val 2091-01-01
./xmlchange -file env_run.xml -id GET_REFCASE -val 'FALSE'
./xmlchange -file env_run.xml -id STOP_OPTION -val 'nmonths'
./xmlchange -file env_run.xml -id STOP_N -val '1'
./xmlchange -file env_run.xml -id RESUBMIT -val '0'
./xmlchange SSTICE_DATA_FILENAME="/glade/work/islas/CVCWG/CESM1_2080_2100/sstice_LENS_2080_to_2100_CLIM_diddled_climo.nc"

./xmlchange -file env_run.xml -id REST_N -val \$STOP_N

# set this to avoid attribute write errors that result in mismatch (jim edwards)
./xmlchange -file env_run.xml -id ICE_PIO_TYPENAME  -val 'netcdf'


# Turn on long-term archive, but modify l_archive script (below) to concatenate ice fields.
#./xmlchange -file env_run.xml -id DOUT_L_MS -val 'TRUE'

#./xmlchange -file env_run.xml -id DOUT_L_MSROOT -val '/home/c/ccsm/csm/$CASE'
#./xmlchange -file env_run.xml -id DOUT_S_SAVE_INT_REST_FILES -val TRUE

# set run and archive directories 
./xmlchange -file env_run.xml   -id DOUT_S_ROOT     -val '/glade/scratch/nanr/archive/$CASE/'
./xmlchange -file env_build.xml -id EXEROOT         -val '/glade/scratch/nanr/$CASE/bld'
./xmlchange -file env_run.xml   -id RUNDIR          -val '/glade/scratch/nanr/$CASE/run'

./cesm_setup


# ===========================
# sea ice - move 6-hourly fields to daily fields 
# ===========================
mv user_nl_cice user_nl_cice.`date +%m%d-%H%M`
cat >> user_nl_cice << EOF

EOF

# ========================
# change to economy queue; change runtime from 8 to 12 hours.
# ========================
#  !!! PROJ and WALLCLOCK are handled through a text file "header.run" in the next section below 
# ========================
#cp $CASE.run $CASE.run.`date +%m%d-%H%M`
#mv $CASE.run tmp.run
#cat  tmp.run | sed 's/01:50:00/12:00:00/' > tmp2.run
#cat tmp2.run | sed 's/###PBS -A/#PBS -A ACGD0004/;' > $CASE.run
#rm   tmp.run
#rm  tmp2.run

# ========================
# add email to inform LSF messages
# ========================
#cp $CASE.run $CASE.run.`date +%m%d-%H%M`
#mv $CASE.run tmp.run
#echo 'egrep -n "LAYOUT" tmp.run | cut -d":" -f1'
#set lnum1 = `egrep -n "LAYOUT" tmp.run | cut -d":" -f1`
#echo 'lnum = ' $lnum1
#set lnum2 = `wc tmp.run | cut -d" " -f2`
#@ diff1 = $lnum2 - $lnum1 + 2
#tail -$diff1 tmp.run > tmp.body

# ========================
# fix name in header
# ========================
#cat header.run | sed 's/-N DOH/-N PD.'$yearm1'-11.'$mbr'/;' > header2.run 
#cat /glade/u/home/nanr/ccp/decadalPrediction/decadalPrediction-ASD/setup-cheyenne/header.run | sed 's/-N DOH/-N PD.'$yearm1'-11.'$mbr'/;' > header2.run
#cat header2.run tmp.body > $CASE.run
#rm tmp.run
#rm tmp.body
#rm header2.run


# ========================
# change longterm archiver to concatenate daily ice files into monthly.
# ========================
#cp $CASE.l_archive $CASE.l_archive.`date +%m%d-%H%M`
#mv $CASE.l_archive tmp.l_archive
#echo 'egrep -n "source" $CASEROOT/tmp.l_archive | cut -d":" -f1'
#set lnum = `egrep -n "source" $CASEROOT/tmp.l_archive | cut -d":" -f1`
#echo 'lnum = ' $lnum
#head -$lnum tmp.l_archive > $CASE.l_archive
#cat >> $CASE.l_archive << EOF


#-----------------------------
# Concatenate daily cice hist
#-----------------------------
#echo -n 'Begin concat cice ' ; date
#echo -n 'Module load ncl ' ; date
#module load ncl
#echo -n 'Module load nco ' ; date
#module load nco
#echo ""
#cd \$DOUT_S_ROOT/ice/hist
#set time=(3600 "%E %P %Uu %Ss")
#time /global/u2/n/nanr/bin/concat_daily_hist_cice.csh
#unset time
#echo ""
#echo -n 'End concat cice ' ; date
#
# Turn off regular LT archiver
# cd \$DOUT_S_ROOT
# $CASEROOT/Tools/lt_archive.sh -m copy_dirs_hsi

#exit 0

#EOF
#rm tmp.l_archive

 
# ========================
# CAM output
# ========================

 #mv user_nl_cam user_nl_cam.`date +%m%d-%H%M`
 #cp $TOOLS_DIR/user_nl_files/user_nl_cam $CASEROOT

cp $TOOLS_DIR/user_nl_files/fcase/* $CASEROOT/
ln -s /glade/scratch/islas/CVCWG/F2090_INIT/2091-01-01-00000/b.e11.BRCP85C5CNBDRD.f09_g16.001.cam.i.2091-01-01-00000.nc $RUNDIR/
ln -s /glade/scratch/islas/CVCWG/F2090_INIT/2091-01-01-00000/b.e11.BRCP85C5CNBDRD.f09_g16.001.rtm.r.2091-01-01-00000.nc $RUNDIR/


# ===========================
# Land
# ===========================
#mv user_nl_clm user_nl_clm.`date +%m%d-%H%M`
#cat >> user_nl_clm << EOF
#fpftdyn                 = '/$CESMINPUT/lnd/clm2/surfdata/surfdata.pftdyn_0.9x1.25_rcp8.5_simyr1850-2100_c130702.nc'
#stream_fldfilename_ndep = '/$CESMINPUT/lnd/clm2/ndepdata/fndep_clm_rcp8.5_simyr1849-2106_1.9x2.5_c100428.nc'
#stream_year_last_ndep = 2100


#EOF

echo " Copy Restarts -------------"
if (! -d $RUNDIR) then
	echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
endif
echo 'cp ' $RESTDIR/*   $RUNDIR/
cp $RESTDIR/*   $RUNDIR/

echo " Finished namelists for " $year " -- " $mbr "-------------"


 qcmd -- ./$CASENAME.build >& bld.`date +%m%d-%H%M`

 #$CYLCDIR/create_postproc -c ${CESMROOT} -d True -r $CASEROOT -a NCGD0011 -t cesm1_1_2_LENS_n21
end             # member loop
 #$CYLCDIR/create_cylc -s b.e11.BDP_BA${NEX}.f09_g16.${yearm1}-11.00.$smbr-$embr.suite -a NCGD0011 -e nanr@ucar.edu --start $smbr --end $embr -d True -r ${SHORTCASEROOT}/$SHORTCASE
end             # year loop

exit


