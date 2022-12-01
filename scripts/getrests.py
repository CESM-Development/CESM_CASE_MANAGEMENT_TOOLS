#!/usr/bin/env python
import glob
import os
import shutil
srcpath="/proj/CESM2/archive/"
destpath="/proj/jedwards/restarts/"
dryrun = False
dryrun = True

for restyr in glob.iglob(srcpath+"*/rest/*"):
    yr = int(os.path.basename(restyr)[0:4])
    mon = int(os.path.basename(restyr)[5:7])
    newdir = restyr.replace(srcpath,destpath)
    if os.path.isdir(newdir):
        print("Skipping {}, directory exists".format(newdir))
        continue
    if (yr >= 1850 and yr <= 1870) or (yr >= 2010 and yr <= 2030) or (yr >= 2080 and yr <=2100):
        if mon != 1:
            # first delete unneeded files, then move directory
            for _file in glob.iglob(restyr+"/*.r?h*"):
                print ("Removing {}".format(_file))
                if not dryrun:
                    os.remove(_file)
            print("moving dir {}".format(restyr))
            if not dryrun and not os.path.isdir(newdir):
                try:
                    shutil.move(restyr, restyr.replace(srcpath,destpath))
                except OSError as e:
                    print("ERROR: {} - {}.".format(e.filename, e.strerror))
        else:
            print("create dir {}".format(newdir))
            if not dryrun and not os.path.isdir(newdir):
                os.makedirs(newdir)
            for _file in glob.iglob(restyr+"/*"):
                if ".h" not in _file and ".rh" not in _file:
                    print("Copy {} to {}".format(_file, newdir))
                    if not dryrun:
                        shutil.copy(_file,newdir)

    elif mon != 1:
        try:
            print("Remove dir {} yr {} mon {}".format(restyr, yr, mon))
            if not dryrun:
                shutil.rmtree(restyr)
        except OSError as e:
            print("ERROR: {} - {}.".format(e.filename, e.strerror))

    if yr > 2015 and yr != 2101 and mon == 1 and os.path.basename(restyr)[3] != '5':
        print("Remove dir {} yr {} mon {}".format(restyr, yr, mon))
        if not dryrun:
            try:
                shutil.rmtree(restyr)
            except:
                print("No permission to remove {}".format(restyr))
# check the run directory for pop.rh.ecosys.nyear1 files which were not being properly archived
#for casedir in glob.iglob("/proj/CESM2/output/*BHIST*"):
#    for _file in glob.iglob(casedir +"/run/*pop.rh.ecosys.nyear1*"):
#        yr = int(os.path.basename(_file)[58:62])
#        fulldate = os.path.basename(_file)[58:74]
#
#        if (yr >= 1850 and yr <= 1870) or (yr >= 2010 and yr <= 2015):
#            print("copy {} to {}".format(_file, os.path.join(destpath, os.path.basename(casedir), "rest", fulldate)))
#            if not dryrun:
#                shutil.copy(_file, os.path.join(destpath, os.path.basename(casedir), "rest", fulldate))

