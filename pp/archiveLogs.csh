#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-PPE-CAM/
setenv ARCHDIR  /glade/scratch/nanr/archive/
setenv CAMPDIR  /glade/campaign/cgd/ccr/nanr/PPE/
setenv LOGSDIR  $CAMPDIR/logs
setenv RESTDIR  $CAMPDIR/restarts
setenv POPDDIR  $CAMPDIR/pop.d_files

set CASE = PPE_220_ensemble_1850.220
set CASE = PPE_220_ensemble_4xCO2.220
set CASE = PPE_220_ensemble_HIST-mbr1.220
set CASE = PPE_220_ensemble_HIST-mbr3.220
set CASE = PPE_220_ensemble_HIST-mbr2.220

if (! -e $LOGSDIR/$CASE.logs.tar) then
tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*
else
echo "logs complete"
endif


set doRestarts = 0
if ($doRestarts == 1) then
#set srest = 1252
#set erest = 1306
set srest = 1850
set erest = 1920
@ sr = $srest
@ er = $erest

#if (doRestarts == 1) then
  if (! -d $RESTDIR/$CASE) then
  mkdir $RESTDIR/$CASE
  endif

  while ($sr <= $er) 
     tar -cvf $RESTDIR/$CASE/$CASE.${sr}-01-01-00000.tar $ARCHDIR/$CASE/rest/${sr}-01-01-00000/
     @ sr += 3
  end
endif

endif

exit

