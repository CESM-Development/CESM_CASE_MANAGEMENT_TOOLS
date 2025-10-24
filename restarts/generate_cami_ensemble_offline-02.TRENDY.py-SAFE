#!/usr/bin/env python
import os, sys, copy
e3smroot = "/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/"
s2sfcstroot = os.path.join(os.path.dirname(os.path.join(os.path.abspath(__file__))), os.path.pardir)
#PYTHONPATH=/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/cime/CIME/Tools

if e3smroot is None:
    raise SystemExit("ERROR: CESM_ROOT must be defined in environment")

# This is needed for globus_sdk
#_LIBDIR=os.path.join(os.environ.get("HOME"),".local","lib","python3.6","site-packages")
#sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","CIME","Tools")
sys.path.append(_LIBDIR)
_LIBDIR = os.path.join(e3smroot,"cime","CIME")
sys.path.append(_LIBDIR)

import datetime, random, threading, time, shutil
from standard_script_setup import *
from CIME.utils            import run_cmd, safe_copy, expect
from argparse              import RawTextHelpFormatter
#from globus_utils          import *

def parse_command_line(args, description):
    parser = argparse.ArgumentParser(description=description,
                                     formatter_class=RawTextHelpFormatter)
    CIME.utils.setup_standard_logging_options(parser)
    parser.add_argument("--date",
                        help="Specify a start Date")

    parser.add_argument("--model",help="Specify a case (e3smsmyle)", default="e3smsmyle")

    parser.add_argument("--ensemble-start",default=1,
                        help="Specify the first ensemble member")
    parser.add_argument("--ensemble-end",default=40,
                        help="Specify the last ensemble member")

    args = CIME.utils.parse_args_and_handle_standard_logging_options(args, parser)
    cdate = os.environ.get("CYLC_TASK_CYCLE_POINT")

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

    return date.strftime("%Y-%m-%d"), args.model,int(args.ensemble_start),int(args.ensemble_end)

def get_rvals(date, ensemble_start,ensemble_end, model):
    random.seed(int(date[0:4])+int(date[5:7])+int(date[8:10]))
    rvals = random.sample(range(1001),k=ensemble_end//2)
    print("Rvals are {}".format(rvals))

## me
    month = date[5:7]
    year  = date[0:3]
    local_path = "/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/S2S_perts_DIFF"
    perturb_files = []
    ovals = copy.deepcopy(rvals)
    for i in range(ensemble_start,ensemble_end, 2):
        print ("1ST HERE rvals[{}] = {}".format((i-1)//2,rvals[(i-1)//2]))
        perturb_file = os.path.join(local_path+"/{}".format(month),
                                        "v2.LR.historical_daily-cami_0241.eam.i.M{}.diff.{:03}.nc".format(month,rvals[(i-1)//2]))
        if not os.path.isfile(perturb_file):
              print ("FIRST Missing file for rval = ",perturb_file, rvals[(i-1)//2])
              print ("original rval = ",rvals[(i-1)//2],"new rval = ",rvals[(i-1)//2]+1)
              perturb_file2 = os.path.join(local_path+"/{}".format(month),
                                        "v2.LR.historical_daily-cami_0241.eam.i.M{}.diff.{:03}.nc".format(month,rvals[(i-1)//2]+1))
              if os.path.isfile(perturb_file2):
                    print ("old rvals[{}] = {}".format((i-1)//2,ovals[(i-1)//2]))
                    rvals[(i-1)//2] = rvals[(i-1)//2]+1
                    print ("new rvals[{}] = {}".format((i-1)//2,rvals[(i-1)//2]))
              if not os.path.isfile(perturb_file2):
                    print ("SECOND missing file for rval = ",perturb_file2, rvals[(i-1)//2]+1)
                    print ("original rval = ",ovals[(i-1)//2],"new rval = ",rvals[(i-1)//2]+12)
                    perturb_file3 = os.path.join(local_path+"/{}".format(month),
                                        "v2.LR.historical_daily-cami_0241.eam.i.M{}.diff.{:03}.nc".format(month,rvals[(i-1)//2]+2))
                    if os.path.isfile(perturb_file3):
                          print ("old rvals[{}] = {}".format((i-1)//2,ovals[(i-1)//2]))
                          rvals[(i-1)//2] = rvals[(i-1)//2]+2
                          print ("new rvals[{}] = {}".format((i-1)//2,rvals[(i-1)//2]))
                    if not os.path.isfile(perturb_file3):
                          print ("STILL missing file for rval = ",perturb_file3, rvals[(i-1)//2]+2)
                          print ("original rval = ",ovals[(i-1)//2],"new rval = ",rvals[(i-1)//2]+3)
                          perturb_file4 = os.path.join(local_path+"/{}".format(month),
                                        "v2.LR.historical_daily-cami_0241.eam.i.M{}.diff.{:03}.nc".format(month,rvals[(i-1)//2]+3))
                          if os.path.isfile(perturb_file4):
                                print ("old rvals[{}] = {}".format((i-1)//2,ovals[(i-1)//2]))
                                rvals[(i-1)//2] = rvals[(i-1)//2]+3
                                print ("new rvals[{}] = {}".format((i-1)//2,rvals[(i-1)//2]))
                          if not os.path.isfile(perturb_file4):
                                 print ("STILL missing file for rval = ",perturb_file4, rvals[(i-1)//2]+3)
                                 print ("FAILING")
                                 exit
## me

    #rvals_file = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/initial_conditions/","cases","eamic_"+date+".{}-{}.txt".format(ensemble_start,ensemble_end))
    #fake_rvals = copy.deepcopy(rvals)
    #fake_rvals[(2-1)//2] = fake_rvals[(3-1)//2]
    #if not check_unique_using_set(fake_rvals):
    if not check_unique_using_set(rvals):
        print("The RVALS list is not unique. Exiting the script.")
        for i in range(ensemble_start,ensemble_end, 2):
             #print ("Non-Unique fake_rvals[{}] = {}".format((i-1)//2,fake_rvals[(i-1)//2]))
             #print ("original rval = ",ovals[(i-1)//2],"Non-Unique new rval = ",fake_rvals[(i-1)//2])
             print ("original rval = ",ovals[(i-1)//2],"Non-Unique new rval = ",rvals[(i-1)//2])
        sys.exit(1)  
    else:
        print("RVALS list is unique. ")

    rvals_file = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init","v21.LR.SMYLE_IC_TRENDY."+date[0:7]+".01","eamic_"+date+".{}-{}.txt".format(ensemble_start,ensemble_end))
    old_rvals_file = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init","v21.LR.SMYLE_IC_TRENDY."+date[0:7]+".01","eamic_"+date+".{}-{}.txt-old".format(ensemble_start,ensemble_end))

    # Check if the file exists
    if os.path.isfile(rvals_file):
        # Rename the file
        shutil.move(rvals_file, old_rvals_file)
        print(f"File renamed from {rvals_file} to {old_rvals_file}")

    if not os.path.isfile(rvals_file):
        with open(rvals_file,"w") as fd:
            fd.write("{}".format(rvals))

    return rvals

def create_eam_ic_perturbed(original, ensemble_start,ensemble_end, date, baserundir, model, outroot="v21.LR.SMYLE_IC_TRENDY.pert.eam.i.", factor=0.15):
    rvals = get_rvals(date, ensemble_start,ensemble_end, model)

    outfile = os.path.join(baserundir,outroot+date+"-00000.nc")
    # first link the original ic file to the 0th ensemble member
    if os.path.exists(outfile):
        os.unlink(outfile)
    expect(os.path.isfile(original),"ERROR file {} not found".format(original))
    #print("Linking {} to {}".format(original, outfile))
    #rundir = os.path.dirname(outfile)
    #print("Linking {} to {}".format(original, os.path.join(rundir,os.path.basename(original))))
    #if os.path.isdir(rundir):
        #shutil.rmtree(rundir)
    #os.makedirs(rundir)
    #os.symlink(original, outfile)
    #os.symlink(original, os.path.join(rundir,os.path.basename(original)))

    # for each pair of ensemble members create an ic file with same perturbation opposite sign
    month = date[5:7]
    year  = date[0:3]

    

    local_path = "/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/S2S_perts_DIFF"
    perturb_files = []
    for i in range(ensemble_start,ensemble_end, 2):
        print ("2ND HERE rvals[{}] = {}".format((i-1)//2,rvals[(i-1)//2]))
        perturb_file = os.path.join("{}".format(month),
                                        "v2.LR.historical_daily-cami_0241.eam.i.M{}.diff.{:03}.nc".format(month,rvals[(i-1)//2]))
        print ("AFTER")
        dirname = os.path.dirname(os.path.join(local_path,perturb_file))
        if not os.path.isdir(dirname):
            print("Creating directory {}".format(dirname))
            os.makedirs(dirname)
        perturb_files.append(perturb_file)

    pertroot = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init","v21.LR.SMYLE_IC_TRENDY."+date[0:7]+".01","pert.01")

    for i in range(ensemble_start,ensemble_end, 2):
        pfile = os.path.join(local_path, perturb_files.pop(0))
        outfile1 = os.path.join(pertroot[:-2]+"{:02d}".format(i), outroot+date+"-tmp.nc")
        outfile2 = os.path.join(pertroot[:-2]+"{:02d}".format(i+1), outroot+date+"-tmp.nc")
        print("Creating perturbed init file {}".format(outfile1))
        print("Creating perturbed init file {}".format(outfile2))
        print("Using perturb_file {}".format(pfile))
        t = threading.Thread(target=create_perturbed_init_file,args=(original, pfile, outfile1, factor))
        t.start()
        t = threading.Thread(target=create_perturbed_init_file,args=(original, pfile, outfile2, -1*factor))
        t.start()
    while(threading.active_count() > 1):
        time.sleep(1)

    if False:
        for i in range(ensemble_start, ensemble_end, 2):
            outfile1 = os.path.join(pertroot[:-2]+"{:02d}".format(i), outroot+date+"-00000.nc")
            outfile2 = os.path.join(pertroot[:-2]+"{:02d}".format(i+1), outroot+date+"-00000.nc")
            outdir1 = baserundir[:-3]+"{:03d}".format(i)
            outdir2 = baserundir[:-3]+"{:03d}".format(i+1)
            origfile = os.path.basename(original)
            print("{} {} ".format(outfile1, os.path.join(outdir1,origfile)))
            print("{} {} ".format(outfile2, os.path.join(outdir2,origfile)))
            for outdir in (outdir1,outdir2):
               if not os.path.isdir(outdir):
                  os.mkdir(outdir)
                  print("outdir = {} ".format(outdir))
            if i != 1:
               if os.path.isfile(os.path.join(outdir1,origfile)):
                  os.unlink(os.path.join(outdir1,origfile))
               os.symlink(outfile1, os.path.join(outdir1,origfile))
               print("I made it here = {} ".format(outdir))
            if os.path.isfile(os.path.join(outdir2,origfile)):
                  os.unlink(os.path.join(outdir2,origfile))
            os.symlink(outfile2, os.path.join(outdir2,origfile))


def create_perturbed_init_file(original, perturb_file, outfile, weight):
    ncflint = "ncflint"
    if not os.path.isdir(os.path.dirname(outfile)):
        os.makedirs(os.path.dirname(outfile))
    pertfile = outfile.replace("-tmp.nc","-00000.nc")
    if os.path.isfile(pertfile):
        print("Found existing file {}".format(pertfile))
        return # file exists nothing more to do
    safe_copy(original, outfile)
    if "BWHIST" in original:
        cmd = ncflint + " -A -v US,VS,T,Q,PS -w {},1.0 {} {} {}".format(weight, perturb_file, original, outfile)
    else:
        #cmd = ncflint+" -O -C -v lat,lon,slat,slon,lev,ilev,hyai,hybi,hyam,hybm,US,VS,T,Q,PS -w {},1.0 {} {} {}".format(weight, perturb_file, original, outfile)
        cmd = ncflint+" -O -C -v time_bnds,lev,ilev,hyai,hybi,hyam,hybm,U,V,T,Q,PS -w {},1.0 {} {} {}".format(weight, perturb_file, original, outfile)
    run_cmd(cmd, verbose=True)
    if os.path.isfile(outfile):
        os.rename(outfile, outfile.replace("-tmp.nc","-00000.nc"))
    else:
        print("Rename of {} failed".format(outfile))

def _main_func(description):
    date, model,ensemble_start,ensemble_end = parse_command_line(sys.argv, description)

    sdrestdir = os.path.join("/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init","v21.LR.SMYLE_IC_TRENDY."+date[0:7]+".01","{}".format(date))
    user = os.getenv("USER")
    baserundir = os.path.join("/pscratch/sd/n/{}/".format(user),"v21.SMYLE","v21.LR.BSMYLE."+date[0:7]+".001","run.{:03d}".format(ensemble_start))
    eaminame = os.path.join(sdrestdir,"v21.LR.SMYLE_IC_TRENDY.{}.01.eam.i.{date}-00000.nc".format(date[:7],date=date))
    outroot = "v21.LR.SMYLE_IC_TRENDY.pert.eam.i."

    create_eam_ic_perturbed(eaminame,ensemble_start,ensemble_end, date,baserundir, model, outroot=outroot)

def check_unique_using_set(lst):
    return len(lst) == len(set(lst))

if __name__ == "__main__":
    _main_func(__doc__)
