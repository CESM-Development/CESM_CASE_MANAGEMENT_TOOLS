#!/bin/bash

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-sf/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-sf/'
compset='B1850cmip6'
usecompset='B1850cmip6'
resoln='f09_g17'
tagdir='/glade/work/nanr/cesm_tags/cesm2.1.5/'
caseroot='/glade/work/nanr/DAMIP/'

mbr=2
runname='b.e21.'$usecompset'.'$resoln'.DAMIP-ssp245-vlc.00'${mbr}

casedir=$caseroot/$runname

cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset 

cd $casedir

./xmlchange CLM_NAMELIST_OPTS=use_init_interp=.true.

./xmlchange JOB_WALLCLOCK_TIME=12:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=FALSE
./xmlchange RUN_REFCASE=b.e21.B1850cmip6.f09_g17.DAMIP-hist-vlc.00${mbr}
./xmlchange RUN_REFDATE=2015-01-01
./xmlchange RUN_STARTDATE=2015-01-01
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=3
./xmlchange REST_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=11
./xmlchange NTASKS_WAV=1

./case.setup --reset
./preview_namelists

# 
cp /glade/work/nanr/cesm_tags/CASE_tools/cesm2-sf/DAMIP-no-volc/usr_nl_files/ssp245/user_nl* $casedir

rundir="/glade/derecho/scratch/nanr/b.e21.B1850cmip6.f09_g17.DAMIP-ssp245-vlc.00${mbr}/run/"

echo "made it this far"
  
  # Lastly - copy Initial conditions
    echo "Here is the RUNDIR ${rundir}"
    ics="/glade/derecho/scratch/nanr/archive/b.e21.B1850cmip6.f09_g17.DAMIP-hist-vlc.00${mbr}"

    # pre-stage ICs
    echo "${ics}/rest/2015-01-01-00000/rpointer.* ${rundir}/"
    cp ${ics}/rest/2015-01-01-00000/rpointer.* ${rundir}/
    ln -s ${ics}/rest/2015-01-01-00000/b.e21.* ${rundir}/

    qcmd -- ./case.build

done
