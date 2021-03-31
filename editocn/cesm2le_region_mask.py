#!/usr/bin/env python
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --exclusive
#SBATCH --account P93300606
#SBATCH --time 24:00:00
#SBATCH --export ALL

import os, glob, threading, subprocess, time

def _file_correct_region_mask(ocnfile, dryrun=True):
#    if "pop.h.nday1." in ocnfile:
#        var = ocnfile[ocnfile.find("pop.h.nday1.")+12:-21]
#    elif "pop.h.ecosys.nday1." in ocnfile:
#        var = ocnfile[ocnfile.find("pop.h.ecosys.nday1.")+19:-21]
#    elif "pop.h.ecosys.nyear1." in ocnfile:
#        var = ocnfile[ocnfile.find("pop.h.ecosys.nyear1.")+20:-13]
#    else:
#        var = ocnfile[ocnfile.find("pop.h.")+6:-17]
#    cmd = "/glade/u/apps/dav/opt/nco/4.9.5/gnu/9.1.0/bin/ncap2 -s'where(REGION_MASK == REGION_MASK@_FillValue) {}={}@_FillValue; where(REGION_MASK == REGION_MASK@_FillValue) REGION_MASK=0;' {} {}.tmp".format(var,var,ocnfile,ocnfile)
    cmd = "/glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/editocn.exe {}".format(ocnfile)
    if dryrun:
        print("cmd is {}".format(cmd))
    else:
        proc = subprocess.Popen(cmd, shell=True)
        output, errput = proc.communicate()
        stat = proc.wait()

def _main():
    base_file_path="/glade/campaign/cesm/collections/CESM2-LE/archive/b.e21.BHISTsmbb.f09_g17.LE2-1231.011/ocn/proc/tseries.new/*"

    dryrun = False

    for ocnfile in glob.iglob(base_file_path + "/*"):
        print("ocnfile is {}".format(ocnfile))
        t = threading.Thread(target=_file_correct_region_mask, args=(ocnfile, dryrun))
        t.start()
        while(threading.active_count() > 32):
            time.sleep(60)

    while(threading.active_count() > 1):
        time.sleep(5)

if __name__ == "__main__":
    _main()
