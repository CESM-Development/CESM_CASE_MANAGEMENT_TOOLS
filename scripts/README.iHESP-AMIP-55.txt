!! =============
!!   https://docs.google.com/document/d/1vtDeGIp0pz0GH7Alv1A83dJYEwWjen3W3F5BRadWgPc/edit
!! =============
AMIP @ year 55  
FAMIPC5 (1950-2050 transient)

November 27, 2019
________________
1. Check out the iHesp code base
________________
CESMROOT:         git clone https://github.com/ihesp/cesm.git -b  cesm-ihesp-hires1.0.23  cesm-ihesp-hires1.0.23
                  cd cesm-ihesp-hires1.0.23
                ./manage_externals/checkout_externals
________________
2.  Case details - FAMIPC5
________________
CESM tag:             cesm-ihesp-hires1.0.23
CESMROOT:             /path_to_codebase/cesm-ihesp-hires1.0.23
COMPSET:                 FAMIPC5
RESOLN:               ne120_ne120_mt12
TAGNAME:              cesm-ihesp
MACHINE:              frontera
CASENAME:             f.e13.${COMPSET}.${RESOLN}.${TAGNAME}-1950-2050.00${mbr}
CASEROOT:             /path_to_case/$CASENAME
RUNDIR:               /path_to_scratch/$CASENAME/run
________________
3.  Case Setup - FAMIPC5 
________________
Best choices for pecount are 21600, 28800, 43200, 86400 (max)
1950-2050 transient:  hybrid run 
	cd $CESMROOT/cime/scripts/
       ./create_newcase --case $CASEROOT --res $RESOLN  --mach $MACHINE --compset FAMIPC5 --pecount 21600
________________
cd $CASEROOT 
./xmlchange --append CAM_CONFIG_OPTS=-cosp
./case.setup 

cp /scratch1/06091/nanr/Namelists/user_nl_clm.HRMIP.26nov $CASEROOT/user_nl_clm
cp /scratch1/06091/nanr/Namelists/user_nl_cam.HRMIP.26nov $CASEROOT/user_nl_cam
cp /scratch1/06091/nanr/Namelists/user_nl_cice.HRMIP.26nov $CASEROOT/user_nl_cice
cp /scratch1/06091/nanr/Namelists/user_nl_docn.HRMIP.26nov $CASEROOT/user_nl_docn
cp /scratch1/06091/nanr/Namelists/user_docn.streams.txt.prescribed $CASEROOT/
________________

./xmlchange RUN_TYPE=hybrid
./xmlchange RUN_REFCASE=B.E.13.B1950C5.ne120_t12.cesm-ihesp-1950cntl.011
./xmlchange RUN_REFDATE=0055-01-01
./xmlchange RUN_STARTDATE=1950-01-01
./xmlchange STOP_OPTION=nyears
./xmlchange STOP_N=10
./xmlchange ICE_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
./xmlchange OCN_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
./xmlchange SSTICE_GRID_FILENAME=/scratch1/06091/nanr/SST-highres/domain.ocn.0.25x0.25_mask.181109.nc
./xmlchange SSTICE_YEAR_ALIGN=1950
./xmlchange SSTICE_YEAR_START=1950
./xmlchange SSTICE_YEAR_END=1960

cp /work/02503/edwardsj/CESM/inputdata/ccsm4_init/B.E.13.B1950C5.ne120_t12.cesm-ihesp-1950cntl.011/0055-01-01/rpointer* $RUNDIR
ln -s /work/02503/edwardsj/CESM/inputdata/ccsm4_init/B.E.13.B1950C5.ne120_t12.cesm-ihesp-1950cntl.011/0055-01-01/B.E.* $RUNDIR
