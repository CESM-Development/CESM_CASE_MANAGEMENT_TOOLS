#!/usr/bin/env python
import glob
import os
import shutil
srcpath="/proj/CESM2/archive/"
testcase="b.e21.BHISTsmbb.f09_g17.LE2-1011.001/"
destpath="/proj/jedwards/restarts/"
dryrun = True

for restyr in glob.iglob(srcpath+testcase+"/rest/*"):
    yr = int(os.path.basename(restyr)[0:4])
    mon = int(os.path.basename(restyr)[5:7])
    if (yr >= 1850 and yr <= 1870) or (yr >= 2010 and yr <= 2015):
        if mon != 1:
            # first delete unneeded files, then move directory
            for _file in glob.iglob(restyr+"/*.h*"):
                print ("Removing {}".format(_file))
                if not dryrun:
                    os.remove(_file)
            print("moving dir {}".format(restyr))
            if not dryrun:
                shutil.move(restyr, restyr.replace(srcpath,destpath))
        else:
            newdir = restyr.replace(srcpath,destpath)
            print("create dir {}".format(newdir))
            if not dryrun:
                os.makedirs(newdir)
            for _file in glob.iglob(restyr+"/*"):
                if ".h" not in _file:
                    print("Copy {} to {}".format(_file, newdir))
                    if not dryrun:
                        shutil.copy(_file,newdir)

    elif mon != 1:
        try:
            print("Remove dir {} yr {} mon {}".format(restyr, yr, mon))
            if not dryrun:
                shutil.rmtree(restyr)
        except OSError as e:
            print("ERROR: %s - %s.".format(e.filename, e.strerror))
