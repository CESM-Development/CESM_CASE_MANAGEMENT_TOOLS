#!/usr/bin/env python
import os, sys
e3smroot = "/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/"
#s2sfcstroot = os.path.join(os.path.dirname(os.path.join(os.path.abspath(__file__))), os.path.pardir)
s2sfcstroot = "/global/homes/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/"

# Machine and project
MACHINE="pm-cpu"
PROJECT="mp9"

if e3smroot is None:
    raise SystemExit("ERROR: E3SM_ROOT must be defined in environment")

_LIBDIR = os.path.join(e3smroot,"cime","scripts","Tools")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","scripts","lib")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","scripts")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","CIME","Tools")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","CIME")
sys.path.append(_LIBDIR)

import datetime, glob, shutil
# import CIME.build as build
from standard_script_setup import *
from CIME.case             import Case
from CIME.utils            import safe_copy
from argparse              import RawTextHelpFormatter
from CIME.locked_files          import lock_file, unlock_file

def parse_command_line(args, description):
    parser = argparse.ArgumentParser(description=description,
                                     formatter_class=RawTextHelpFormatter)
    CIME.utils.setup_standard_logging_options(parser)
    parser.add_argument("--date",
                        help="Specify a start Date")

    parser.add_argument("--ensemble-start",default=1,
                        help="Specify the first ensemble member")
    parser.add_argument("--ensemble-end",default=20,
                        help="Specify the last ensemble member")

    parser.add_argument("--model",help="Specify a case (e3smsmyle)", default="e3smsmyle")

    args = CIME.utils.parse_args_and_handle_standard_logging_options(args, parser)
    cdate = os.getenv("CYLC_TASK_CYCLE_POINT")

    if args.date:
        try:
            date = datetime.datetime.strptime(args.date, '%Y-%m-%d')
        except ValueError:
            raise ValueError("Incorrect data format, should be YYYY-MM-DD or YYYY-MM")
    elif cdate:
        date = datetime.datetime.strptime(cdate, '%Y-%m-%d')
    else:
        date = datetime.date.today()
        date = date.replace(day=date.day-1)

    return date.strftime("%Y-%m-%d"), args.model, int(args.ensemble_start), int(args.ensemble_end)

def stage_refcase(rundir, refdir, date, basecasename):
    if not os.path.isdir(rundir):
        os.makedirs(rundir)
    nfname = "v21.LR.SMYLE_IC.ne30np4"
    #else:
    #   nfname = "b.e21.f09_g17"
    print ("refdir="+refdir)
    print ("rundir="+rundir)
    for reffile in glob.iglob(refdir+"/*"):
        print ("theNEWFILE="+reffile)
        if os.path.basename(reffile).startswith("rpointer"):
            safe_copy(reffile, rundir)
        else:
            newfile = os.path.basename(reffile)
            newfile = os.path.join(rundir,newfile)
            if "cam.i" in newfile:
                if not "001" in newfile:
                    os.symlink(reffile,newfile.replace(".nc","-original.nc"))
            else:
                if os.path.lexists(newfile):
                    os.unlink(newfile)
                os.symlink(reffile, newfile)

def per_run_case_updates(case, date, sdrestdir):
    caseroot = case.get_value("CASEROOT")
    basecasename = os.path.basename(caseroot)[:-4]
    member = os.path.basename(caseroot)[-3:]

    unlock_file("env_case.xml",caseroot=caseroot)
    casename = basecasename+"."+member
    case.set_value("CASE",casename)
    case.flush()
    lock_file("env_case.xml",caseroot=caseroot)

    case.set_value("CONTINUE_RUN",False)
    case.set_value("BUILD_COMPLETE",True)
    case.set_value("RUN_REFDATE",date)
    case.set_value("RUN_STARTDATE",date)
    case.set_value("RUN_REFDIR",sdrestdir)

    case.case_setup()

    stage_refcase(rundir, sdrestdir, date, basecasename)
    case.set_value("BATCH_SYSTEM", "none")
    case.set_value("RUNDIR", rundir+member)
    safe_copy(os.path.join(caseroot,"env_batch.xml"),os.path.join(caseroot,"LockedFiles","env_batch.xml"))


#def build_base_case(date, baseroot, basecasename, basemonth,res, ensemble_start, compset, overwrite,
                    #sdrestdir, machine, project):
def build_base_case(date, baseroot, basecasename, basemonth,res, ensemble_start, compset, overwrite,
                    sdrestdir, machine):
    caseroot = os.path.join(baseroot,basecasename+"."+date[:7]+".{:03d}".format(ensemble_start),"case_scripts")
    if overwrite and os.path.isdir(caseroot):
        shutil.rmtree(caseroot)

    user_mods_dir = os.path.join(s2sfcstroot,"user_mods","e3smsmyle")
    with Case(caseroot, read_only=False) as case:
        if not os.path.isdir(caseroot):
            #case.create(os.path.basename(caseroot), e3smroot, compset, res,
            #            run_unsupported=True, answer="r",walltime="12:00:00",
            #            user_mods_dir=user_mods_dir, pecount=pecount, project="NCGD0047", workflowid="timeseries")
            #case.create(os.path.basename(caseroot), e3smroot, compset, res, run_unsupported=True, answer="r",walltime="12:00:00",machine="pm-cpu",project="mp9")
            case.create(os.path.basename(caseroot), e3smroot, compset, res, walltime="12:00:00",machine_name="pm-cpu",driver="mct",user_mods_dirs=[user_mods_dir])
            # make sure that changing the casename will not affect these variables
            user = os.getenv("USER")
            cimeroot = os.path.join("/pscratch/sd/n/nanr/".format(user),"v21.LR.SMYLE")
            exeroot = os.path.join("/pscratch/sd/n/nanr/".format(user),"v21.LR.SMYLE/exerootdir/bld")
            case.set_value("CIME_OUTPUT_ROOT",cimeroot)
            if exeroot and os.path.exists(os.path.join(exeroot,"e3sm.exe")):
                case.set_value("EXEROOT",exeroot)
            else:
                case.set_value("EXEROOT",case.get_value("EXEROOT", resolved=True))

            case.set_value("RUNDIR",case.get_value("RUNDIR",resolved=True)+".001")

            case.set_value("RUN_TYPE","hybrid")
            # case.set_value("JOB_QUEUE","economy")
            case.set_value("GET_REFCASE",False)
            case.set_value("RUN_REFDIR",sdrestdir)
            case.set_value("RUN_REFCASE", "v21.SMYLE_IC.ne30np4.{}.01".format(date[:7]))
            case.set_value("NTHRDS", 1)

            case.set_value("STOP_OPTION","nmonths")
            case.set_value("STOP_N", 24)
            #case.set_value("REST_OPTION","nmonths")
            #case.set_value("REST_N", 24)

            case.set_value("CCSM_BGC","CO2A")
            case.set_value("EXTERNAL_WORKFLOW",True)

        nint = 3 
        n2nt = 11 
        rundir = os.path.join(baseroot,basecasename+"."+date[:7]+".{:03d}".format(ensemble_start),"run")
        #rundir = case.get_value("RUNDIR")
        #print("rundir 1 = {}".format(rundir))
        #rundir = rundir[:-n2nt]+"001/run.{:03d}".format(ensemble_start)
        #print("rundir 2 = {}".format(rundir))
        #rundir = rundir[:-nint]+"{:03d}".format(ensemble_start)
        #print("rundir 3 = {}".format(rundir))
        #case.set_value("RUNDIR",rundir)
        per_run_case_updates(case, date, sdrestdir)
        #if not exeroot:
            #build.case_build(caseroot, case=case)

        return caseroot

def clone_base_case(date, caseroot, ensemble_start, ensemble_end, sdrestdir, user_mods_dir, overwrite):

    nint=3
    cloneroot = caseroot
    for i in range(ensemble_start+1, ensemble_end+1):
        member_string = '{{0:0{0:d}d}}'.format(nint).format(i)
        if ensemble_end > ensemble_start:
            caseroot = caseroot[:-nint] + member_string
        if overwrite and os.path.isdir(caseroot):
            shutil.rmtree(caseroot)
        if not os.path.isdir(caseroot):
            with Case(cloneroot, read_only=False) as clone:
                clone.create_clone(caseroot, keepexe=True,
                                   user_mods_dir=user_mods_dir)
        with Case(caseroot, read_only=True) as case:
            # rundir is initially 00 reset to current member
            rundir = case.get_value("RUNDIR")
            rundir = rundir[:-nint]+member_string
            case.set_value("RUNDIR",rundir)
            per_run_case_updates(case, date, sdrestdir)

def _main_func(description):
    #date, basecasename = parse_command_line(sys.argv, description)
    date, model, ensemble_start, ensemble_end = parse_command_line(sys.argv, description)
    basecasename = "v21.LR.BSMYLE.ne30np4"

    # TODO make these input vars

    basemonth = int(date[5:7])
    baseyear = int(date[0:4])
    baseroot = "/pscratch/sd/n/nanr/v21.LR.SMYLE/"
    res = "ne30pg2_EC30to60E2r2"
    waccm = False
    #if model == "e3smsmyle":
       #compset = "WCYCL20TR"
    compset = "WCYCL20TR"

    print ("baseyear is {} basemonth is {}".format(baseyear,basemonth))

    overwrite = True
    sdrestdir = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init","v21.LR.SMYLE_IC.ne30np4."+date[0:7]+".01","{}".format(date))
    machine = "pm-cpu"
    project = "mp9"

    user_mods_dir = os.path.join(s2sfcstroot,"user_mods","e3smsmyle")

    # END TODO
    print("basemonth = {}".format(basemonth))
    #caseroot = build_base_case(date, baseroot, basecasename, basemonth, res, ensemble_start,
                            #compset, overwrite, sdrestdir, machine, project)
    caseroot = build_base_case(date, baseroot, basecasename, basemonth, res, ensemble_start,
                            compset, overwrite, sdrestdir,machine)
    clone_base_case(date, caseroot, ensemble_start, ensemble_end, sdrestdir, overwrite)

if __name__ == "__main__":
    _main_func(__doc__)
