#!/bin/csh -f

setenv CESMROOT /glade/work/nanr/cesm_tags/cesm1_1_2_LENS_n21
setenv MACH cheyenne
setenv COMPSET FAMIPC5CN
setenv EXP 2090const
setenv RESLN f09_f09
setenv CESMINPUT /glade/p/cesmdata/cseg/inputdata
set TOOLS_DIR=/glade/work/nanr/cesm_tags/CASE_tools/cesm1-2090/

set mbr =   1

set REFCASE    = b.e11.BRCP85C5CNBDRD.f09_g16.034
if ($mbr < 10) then
	set CASENAME  = f.e11.${COMPSET}.${RESLN}.${EXP}.00${mbr}
else
	set CASENAME  = f.e11.${COMPSET}.${RESLN}.${EXP}.0${mbr}
endif
echo 'Member = ' $mbr
echo 'Case   = ' $CASENAME

setenv CASEROOT /glade/work/$USER/2090const/$CASENAME
setenv RESTDIR  /glade/scratch/nanr/archive/$REFCASE/rest/2091-01-01-00000/
setenv RUNDIR   /glade/scratch/$USERS/$CASENAME/run

echo "setting up case = " $CASENAME

 if (! -d $CASEROOT) then
 	cd $CESMROOT/scripts
 	./create_newcase -case $CASEROOT -mach $MACH -compset $COMPSET -res $RESLN
 endif
 cd $CASEROOT

./xmlchange -file env_run.xml -id RUN_TYPE -val 'hybrid'
./xmlchange -file env_run.xml -id RUN_STARTDATE -val 0001-01-01
./xmlchange -file env_run.xml -id RUN_REFCASE   -val $REFCASE 
./xmlchange -file env_run.xml -id RUN_REFDATE   -val 2091-01-01
./xmlchange -file env_run.xml -id GET_REFCASE -val 'FALSE'
./xmlchange -file env_run.xml -id STOP_OPTION -val 'nmonths'
./xmlchange -file env_run.xml -id STOP_N -val '1'
./xmlchange -file env_run.xml -id RESUBMIT -val '0'
./xmlchange SSTICE_DATA_FILENAME="/glade/work/islas/CVCWG/CESM1_2080_2100/sstice_LENS_2080_to_2100_CLIM_diddled_climo.nc"
./xmlchange SSTICE_YEAR_ALIGN=1
./xmlchange SSTICE_YEAR_START=0
./xmlchange SSTICE_YEAR_END=0
./xmlchange -file env_run.xml -id REST_N -val \$STOP_N

# set this to avoid attribute write errors that result in mismatch (jim edwards)
./xmlchange -file env_run.xml -id ICE_PIO_TYPENAME  -val 'netcdf'

./cesm_setup

cp $TOOLS_DIR/user_nl_files/fcase/* $CASEROOT/
ln -s /glade/scratch/islas/CVCWG/F2090_INIT/2091-01-01-00000/b.e11.BRCP85C5CNBDRD.f09_g16.001.cam.i.2091-01-01-00000.nc $RUNDIR/
ln -s /glade/scratch/islas/CVCWG/F2090_INIT/2091-01-01-00000/b.e11.BRCP85C5CNBDRD.f09_g16.001.rtm.r.2091-01-01-00000.nc $RUNDIR/

echo " Copy Restarts -------------"
if (! -d $RUNDIR) then
	echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
endif
echo 'cp ' $RESTDIR/*   $RUNDIR/
cp $RESTDIR/*   $RUNDIR/

qcmd -- ./$CASENAME.build >& bld.`date +%m%d-%H%M`


exit


