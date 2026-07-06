#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-covid
setenv ARCHDIR  /glade/derecho/scratch/nanr/archive/
setenv LOGSDIR  /glade/campaign/cgd/ccr/nanr/COVID-cvd-aufire-shipping/logs/
setenv RESTDIR  /glade/campaign/cgd/ccr/nanr/COVID-cvd-aufire-shipping/restarts/
setenv POPDDIR  /glade/campaign/cgd/ccr/nanr/COVID-cvd-aufire-shipping/popd/

set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
	#set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-cvd-aufire-shipping.10${mbr}
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-ssp245-2019-cntl.10${mbr}
else
	#set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-cvd-aufire-shipping.1${mbr}
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-ssp245-2019-cntl.1${mbr}
endif

#tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
#tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*

set srest = 2024
set erest = 2024
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

