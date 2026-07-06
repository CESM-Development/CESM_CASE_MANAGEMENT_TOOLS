#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-SSP585-LE/
#setenv ARCHSTEVE  /glade/scratch/yeager/SMYLE-PACEMAKER/archive/
setenv TSERIES  /glade/campaign/cesm/development/cvcwg/cvwg/b.e21.BSSP585cmip6.f09_g17.CESM2-LE/cpl/
setenv LOGSDIR  /glade/campaign/cesm/development/cvcwg/cvwg/b.e21.BSSP585cmip6.f09_g17.CESM2-LE/logs/
setenv RESTDIR  /glade/campaign/cesm/development/cvcwg/cvwg/b.e21.BSSP585cmip6.f09_g17.CESM2-LE/restarts/
setenv POPDDIR  /glade/campaign/cesm/development/cvcwg/cvwg/b.e21.BSSP585cmip6.f09_g17.CESM2-LE/popd/

#setenv ARCHSTEVE  /glade/scratch/yeager/SMYLE-PACEMAKER/archive/
setenv ARCHNANR  /glade/scratch/$USER/archive/


# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSSP585cmip6.f09_g17.CESM2-LE.00${mbr}
else
        set CASE = b.e21.BSSP585cmip6.f09_g17.CESM2-LE.0${mbr}
endif

set USE_ARCHDIR = $ARCHNANR

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
else
   cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/
   echo "cpl done"
endif
if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/
else
   echo "logs done"
endif
# if (! -e $RESTDIR/$CASE.rest.tar) then
   # cd $USE_ARCHDIR
   # tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
# else
   # echo "rest done"
# endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif

end             # member loop

exit

