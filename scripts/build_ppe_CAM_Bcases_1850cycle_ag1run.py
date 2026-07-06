#!/usr/bin/env python3
      
import os, sys
from netCDF4 import Dataset
from itertools import islice
# This script must be run in an environment with netCDF4 python libraries 
# active and the ability to build cesm cases.
# On Cheyenne, the best way to do this is from an interactive session.
# > qsub -X -I -l select=1:ncpus=36:mpiprocs=36 -l walltime=02:30:00 -q regular -A P93300642
# > conda activate my_env
# > ./build_ppe_CAM_cases_SST_ag151-200.py

# Edit below to set up your cases
#cesmroot = '/glade/u/home/trude/src/PUMASDevelopment/CAM'
cesmroot = '/glade/u/home/trude/src/cam6_3_026_ppe/'
cesmroot = '/glade/work/nanr/cesm_tags/cesm2_3_beta06/'
basecasename = "PPE_220_ensemble_1850"
baseroot = os.path.join("/glade/work/nanr/cam_dev","ppe_cases",basecasename)
res = "f09_g17"
compset = "B1850"
# sst_filename = "/glade/p/cesmdata/cseg/inputdata/atm/cam/sst/sst_HadOIBl_bc_0.9x1.25_2000climo_SST+4K_c180601.nc"
# sst_filename = "/glade/p/cesm/cseg/inputdata/atm/cam/sst/sst_HadOIBl_bc_0.9x1.25_2000climo_c180511.nc"

#paramfile = "/glade/work/fasullo/CESM2PPE/parameter_20_28_w_control.nc"
#paramfile = "/glade/work/fasullo/CESM2PPE/parameter_38_128_w_control.nc"
#paramfile = "/glade/work/fasullo/CESM2PPE/parameter_139_175_w_control.nc"
paramfile = "/glade/work/fasullo/CESM2PPE/parameter_212_220_w_control.nc"
#paramfile = "/glade/work/fasullo/CESM2PPE/parameter_250_262_w_control.nc"



# ++TE: do not change ensemble_startval
# Three digit value for the member wishing to be done - 1 based index (wish to do 20, 28, 38         128         139         175, 212         220         250         263) 
ensemble_startval = "001" 
basecase_startval = "000"
project = "P04010022"
wall_time = "12:00:00"
specify_user_num_sims = False # If True, use "user_num_sims" number of sims. This will
                             # use the first X values of each parameter, and will 
                             # probably crash if you specify more simulations than
                             # parameter values in your paramfile. 
                             # If False, automatically create the same number of cases
                             # as param values in the paramfile. This is the safest 
                             # option.
user_num_sims = 1

# Currently only number of years set (no months or days)
# Will be the same in every case
stop_yrs = 5
rest_yrs = 1

# REFCASE settings below are optional
# Will be the same in every case
ref_case_get = True
ref_case_name = "b.e21.B1850.f09_g17.CMIP6-piControl.001"
ref_date = "1251"
ref_case_path = "cesm2_init"

## CAM_CONFIG_OPTS
cam_conopts = "-cosp"

## User_nl_cam text that will be cloned in every ensemble case
## Text in user_nl_cam will appear exactly as in this string specifier
## use 4xco2 values of 1138 and associated methane/n2o increases
user_nl_string = """
cosp_passive=.true.

&rad_cnst_nl
 rad_diag_1            = 'A:Q:H2O', 'N:O2:O2', 'N:CO2:CO2', 'N:ozone:O3', 'N:N2O:N2O',
    'N:CH4:CH4', 'N:CFC11:CFC11', 'N:CFC12:CFC12'
/

&camexp

empty_htapes = .true.
nhtfrq=0,-24
mfilt=1,30
avgflag_pertape='A','A'
fincl1 =
'ADRAIN',
'ADSNOW',
'ANRAIN',
'ANSNOW',
'AODDUST',
'AODVIS',
'AQRAIN',
'AQSNOW',
'AREI',
'AREL',
'AWNC',
'AWNI',
'CAPE',
'CCN3',
'CDNUMC',
'CLDHGH',
'CLDICE',
'CLDLIQ',
'CLDLOW',
'CLDMED',
'CLDTOT',
'CLOUD',
'CONCLD',
'DMS',
'FICE',
'FLDS',
'FLDS_d1',
'FLNS',
'FLNSC',
'FLNSC_d1',
'FLNS_d1',
'FLNT',
'FLNTC',
'FLNTCLR',
'FLNTCLR_d1',
'FLNTC_d1',
'FLNT_d1',
'FLUT',
'FLUTC',
'FLUTC_d1',
'FLUT_d1',
'FREQCLR',
'FREQCLR_d1',
'FREQI',
'FREQL',
'FREQR',
'FREQS',
'FREQZM',
'FSDS',
'FSDSC',
'FSDSC_d1',
'FSDS_d1',
'FSNS',
'FSNSC',
'FSNSC_d1',
'FSNS_d1',
'FSNT',
'FSNTC',
'FSNTC_d1',
'FSNTOA',
'FSNTOAC',
'FSNTOAC_d1',
'FSNTOA_d1',
'FSNT_d1',
'FSUTOA',
'FSUTOA_d1',
'ICEFRAC',
'ICIMR',
'ICWMR',
'IWC',
'LANDFRAC',
'LHFLX',
'LWCF',
'LWCF_d1',
'NUMICE',
'NUMLIQ',
'NUMRAI',
'NUMSNO',
'OMEGA',
'PBLH',
'PHIS',
'PRECC',
'PRECL',
'PRECSC',
'PRECSL',
'PS',
'PSL',
'Q',
'QRL',
'QRL_d1',
'QRS',
'QRS_d1',
'RAINQM',
'RELHUM',
'SHFLX',
'SL',
'SNOWHICE',
'SNOWHLND',
'SNOWQM',
'SO2',
'SOAG',
'SOLIN',
'SOLIN_d1',
'SWCF',
'SWCF_d1',
'T',
'TAUGWX',
'TAUGWY',
'TAUX',
'TAUY',
'TGCLDCWP',
'TGCLDIWP',
'TGCLDLWP',
'THETAL',
'TMQ',
'TREFHT',
'TS',
'TSMN',
'TSMX',
'U',
'U10',
'V',
'WSUB',
'Z3',
'bc_a1',
'bc_a4',
'dst_a1',
'dst_a2',
'dst_a3',
'ncl_a1',
'ncl_a2',
'ncl_a3',
'num_a1',
'num_a2',
'num_a3',
'num_a4',
'pom_a1',
'pom_a4',
'so4_a1',
'so4_a2',
'so4_a3',
'soa_a1',
'soa_a2',
'ACTREL',
'ACTNL',
'ACTREI',
'FCTL',
'FCTI',
'ACTNI',
'AREFL',
'FREFL',
'FISCCP1_COSP',
'CLDTOT_ISCCP',
'MEANCLDALB_ISCCP',
'MEANPTOP_ISCCP',
'MEANTAU_ISCCP',
'MEANTB_ISCCP',
'MEANTBCLR_ISCCP',
'ICE_ICLD_VISTAU',
'SNOW_ICLD_VISTAU',
'LIQ_ICLD_VISTAU',
'TOT_CLD_VISTAU',
'TOT_ICLD_VISTAU',
'CLWMODIS',
'CLTMODIS',
'CLIMODIS',
'TAUTMODIS',
'TAUWMODIS',
'REFFCLWMODIS',
'REFFCLIMODIS',
'PCTMODIS',
'LWPMODIS',
'IWPMODIS',
'CMFMCDZM',
'Z500',
'V850',
'T850',
'TREFHT',
'U200',
'U850',
'V200',
'V850'
fincl2=
'Z500',
'V850',
'T850',
'TREFHT',
'U200',
'U850',
'V200',
'V850',
'PRECC',
'PSL',
'TGCLDLWP',
'TGCLDIWP',
'TMQ',
'U10',
'SWCF',
'SHFLX',
'RHREFHT',
'PS',
'CLDTOT',
'CDNUMC',
'PRECL',
'OMEGA500',
'LWCF'
/


"""
## No /EOF needed for python

## Should not be a need to edit below this line ##
if cesmroot is None:
    raise SystemExit("ERROR: CESM_ROOT must be defined in environment")
_LIBDIR = os.path.join(cesmroot,"cime","scripts","Tools")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(cesmroot,"cime","scripts","lib")
sys.path.append(_LIBDIR)

import datetime, glob, shutil
import CIME.build as build
from standard_script_setup import *
from CIME.case             import Case
from CIME.utils            import safe_copy
from argparse              import RawTextHelpFormatter
from CIME.locked_files          import lock_file, unlock_file

def per_run_case_updates(case, ensemble_str, nint, paramdict, ensemble_idx):
    print(">>>>> BUILDING CLONE CASE...")
    caseroot = case.get_value("CASEROOT")
    basecasename = os.path.basename(caseroot)[:-nint]

    unlock_file("env_case.xml",caseroot=caseroot)
    casename = basecasename+ensemble_str
    case.set_value("CASE",casename)
    #case.set_value("SSTICE_DATA_FILENAME", sst_filename)
    rundir = case.get_value("RUNDIR")
    rundir = rundir[:-nint]+ensemble_str
    case.set_value("RUNDIR",rundir)
    case.flush()
    lock_file("env_case.xml",caseroot=caseroot)
    print("...Casename is {}".format(casename))
    print("...Caseroot is {}".format(caseroot))
    print("...Rundir is {}".format(rundir))

    # Add user_nl updates for each run                                                        

    paramLines = []
#    ens_idx = int(ensemble_str)-int(ensemble_startval)
    ens_idx = int(ensemble_idx)-int(ensemble_startval)
    print('ensemble_index')
    print(ens_idx)
    for var in paramdict.keys():
        paramLines.append("{} = {}\n".format(var,paramdict[var][ens_idx]))

    usernlfile = os.path.join(caseroot,"user_nl_cam")
    print("...Writing to user_nl file: "+usernlfile)
    file1 = open(usernlfile, "a")
    file1.writelines(paramLines)
    file1.close()

    print(">> Clone {} case_setup".format(ensemble_str))
    case.case_setup()
    print(">> Clone {} create_namelists".format(ensemble_str))
    case.create_namelists()
    print(">> Clone {} submit".format(ensemble_str))
    #case.submit()


def build_base_case(baseroot, basecasename, res, compset, overwrite):
    print(">>>>> BUILDING BASE CASE...")
    caseroot = os.path.join(baseroot,basecasename+'.'+basecase_startval)
    if overwrite and os.path.isdir(caseroot):
        shutil.rmtree(caseroot)
    with Case(caseroot, read_only=False) as case:
        if not os.path.isdir(caseroot):
            case.create(os.path.basename(caseroot), cesmroot, compset, res,
                        machine_name="cheyenne", driver="mct",
                        run_unsupported=True, answer="r",walltime=wall_time, 
                        project=project)
            # make sure that changing the casename will not affect these variables                                           
            case.set_value("EXEROOT",case.get_value("EXEROOT", resolved=True))
            case.set_value("RUNDIR",case.get_value("RUNDIR",resolved=True)+".00")

            case.set_value("RUN_TYPE","hybrid")
            case.set_value("GET_REFCASE",ref_case_get)
            case.set_value("RUN_REFCASE",ref_case_name)
            case.set_value("RUN_REFDIR",ref_case_path)
            case.set_value("STOP_OPTION","nyears")
            case.set_value("STOP_N",stop_yrs)
            case.set_value("REST_OPTION","nyears")
            case.set_value("REST_N",rest_yrs)

            case.set_value("CAM_CONFIG_OPTS", 
                           case.get_value("CAM_CONFIG_OPTS",resolved=True)+' '+cam_conopts)


        rundir = case.get_value("RUNDIR")
        caseroot = case.get_value("CASEROOT")
        
        print(">> base case_setup...")
        case.case_setup()
        
        print(">> base case write user_nl_cam...")
        usernlfile = os.path.join(caseroot,"user_nl_cam")
        funl = open(usernlfile, "a")
        funl.write(user_nl_string)
        funl.close()
        
        print(">> base case_build...")
        build.case_build(caseroot, case=case)

        return caseroot

def clone_base_case(caseroot, ensemble, overwrite, paramdict, ensemble_num):
    print(">>>>> CLONING BASE CASE...")
    print(ensemble)
    startval = ensemble_startval
    nint = len(ensemble_startval)
    cloneroot = caseroot
    for i in range(int(startval), int(startval)+ensemble):
        ensemble_idx = '{{0:0{0:d}d}}'.format(nint).format(i)
        member_string = ensemble_num[i-1]
        print("member_string="+member_string)
        if ensemble > 1:
            caseroot = caseroot[:-nint] + member_string
        if overwrite and os.path.isdir(caseroot):
            shutil.rmtree(caseroot)
        if not os.path.isdir(caseroot):
            with Case(cloneroot, read_only=False) as clone:
                clone.create_clone(caseroot, keepexe=True)
        with Case(caseroot, read_only=False) as case:
            per_run_case_updates(case, member_string, nint, paramdict, ensemble_idx)


def take(n, iterable):
    "Return first n items of the iterable as a list"
    return list(islice(iterable, n))


def _main_func(description):

    print ("Starting SCAM PPE case creation, building, and submission script")
    print ("Base case name is {}".format(basecasename))
    print ("Parameter file is "+paramfile)

    overwrite = True

    # read in NetCDF parameter file
    inptrs = Dataset(paramfile,'r')
    print ("Variables in paramfile:")
    print (inptrs.variables.keys())
    print ("Dimensions in paramfile:")
    print (inptrs.dimensions.keys())
    num_sims = inptrs.dimensions['nmb_sim'].size
    num_vars = len(inptrs.variables.keys())-1
    ensemble_num = inptrs['Sample_nmb']
    print('ensemble_num')
    print(ensemble_num)
    print(ensemble_num[0])
    if specify_user_num_sims:
        num_sims = user_num_sims

    print ("Number of sims = {}".format(num_sims))
    print ("Number of params = {}".format(num_vars))


    # Save a pointer to the netcdf variables
    paramdict = inptrs.variables
    del paramdict['Sample_nmb']

    # Create and build the base case that all PPE cases are cloned from
    caseroot = build_base_case(baseroot, basecasename, res,
                            compset, overwrite)

    # Pass in a dictionary with all of the parameters and their values
    # for each PPE simulation 
    # This code clones the base case, using the same build as the base case,
    # Adds the namelist parameters from the paramfile to the user_nl_cam 
    # file of each new case, does a case.set up, builds namelists, and 
    # submits the runs.
    clone_base_case(caseroot, num_sims, overwrite, paramdict, ensemble_num)

    inptrs.close()

if __name__ == "__main__":
    _main_func(__doc__)

