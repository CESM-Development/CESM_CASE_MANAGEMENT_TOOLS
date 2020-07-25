#!/bin/bash
membeg=1
memend=5

base="/glade/work/asphilli/CESM2-pacemaker/cases/"

for imem in `seq $membeg $memend` ; do 
  memstr=`printf %03d $imem`
  echo $memstr
  cd $base"/b.e21.BHISTcmip6.f09_g17.pacemaker_pacific."$memstr
  cp /glade/work/nanr/cesm_tags/CASE_tools/cesm2-pacemaker/SourceMods/src.pop/* ./SourceMods/src.pop
  cp /glade/work/nanr/cesm_tags/CASE_tools/cesm2-pacemaker/user_nl_files/user_nl_cam .
  ./xmlchange CONTINUE_RUN=FALSE 
done

#cd /glade/work/nanr/CESM2-pacemaker/cases/b.e21.BHISTcmip6.f09_g17.pacemaker_pacific.001/* 
