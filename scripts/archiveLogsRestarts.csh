#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-covid
setenv ARCHDIR  /glade/scratch/nanr/archive/
setenv LOGSDIR  /glade/campaign/collections/cmip/CMIP6/COVID/logs/
setenv RESTDIR  /glade/campaign/collections/cmip/CMIP6/COVID/restarts/COVID-gfed-2015-2018/
setenv POPDDIR  /glade/campaign/collections/cmip/CMIP6/COVID/pop.d/

set smbr =  38
set embr =  38

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-gfed-2015-2018.00${mbr}
else
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-gfed-2015-2018.0${mbr}
endif

#tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
#tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*

set srest = 2019
set erest = 2021
@ sr = $srest
@ er = $erest

cd $ARCHDIR
while ($sr <= $er) 
   tar -cvf $RESTDIR/$CASE.${sr}-01-01-00000.tar $ARCHDIR/$CASE/rest/${sr}-01-01-00000/
   @ sr ++
end

if (! -e $LOGSDIR/$CASE.logs.tar) then
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/
else
   echo "logs done"
endif

if (! -e $POPDDIR/$CASE.popd.tar) then
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif


end             # member loop

exit

