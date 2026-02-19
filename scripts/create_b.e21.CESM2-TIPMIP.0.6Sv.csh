#!/bin/csh -f
### set env variables

## Tag includes sfwf SourceMods!
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.5/
setenv CESM_TOOLS /glade/work/nanr/cesm_tags/CASE_tools/cesm2-TIPMIP/

set COMPSET = B1850cmip6
set USECOMPSET = B1850cmip6
set MACHINE = derecho
set RESOLN = f09_g17
set mbr = 1
set PROJECT = P06010014

setenv CASENAME b.e21.${USECOMPSET}.f09_g17.TIPMIP_0.6Sv.00${mbr}
setenv REFCASE  b.e21.B1850.f09_g17.CMIP6-piControl.001
setenv REFDATE  0501-01-01

#setenv CASEROOT /glade/derecho/scratch/nanr/$CASENAME
setenv CASEROOT /glade/work/nanr/TIPMIP/cases/$CASENAME

cd $CESMROOT/cime/scripts/
./create_newcase --case $CASEROOT --res $RESOLN  --compset $USECOMPSET  --project $PROJECT

cd $CASEROOT

./xmlchange RUN_REFCASE=$REFCASE
./xmlchange RUN_REFDATE=$REFDATE
./xmlchange RUN_STARTDATE=0001-01-01
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=10
#./xmlchange JOB_QUEUE=economy --subgroup case.run
./xmlchange GET_REFCASE=FALSE

#./xmlchange NTASKS_ICE=36
#./xmlchange NTASKS_LND=504
#./xmlchange ROOTPE_ICE=504

./case.setup

#cp $CESM_TOOLS/user_nl_files/haline/user_nl_clm $CASEROOT/user_nl_clm
cp $CESM_TOOLS/user_nl_files/0.6Sv/user_nl_pop $CASEROOT/user_nl_pop
cp $CESM_TOOLS/user_nl_files/0.6Sv/user_nl_clm $CASEROOT/user_nl_clm
cp $CESM_TOOLS/SourceMods/src.pop/* $CASEROOT/SourceMods/src.pop/

cp /glade/work/nanr/amoc-hosing/Hosing_LabradorSea_65W45W48N65N_0To06Svin200yr-xtime.nc /glade/derecho/scratch/nanr/$CASENAME/run/

#copy restarts
echo $SCRATCH/archive/$REFCASE/rest/$REFDATE/
cp $SCRATCH/archive/$REFCASE/rest/$REFDATE/* $SCRATCH/$CASENAME/run/

./preview_namelists

#qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

