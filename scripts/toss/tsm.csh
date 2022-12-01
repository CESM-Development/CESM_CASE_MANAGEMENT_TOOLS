#!/bin/csh -fx
### set env variables

set MACHINE = aleph
set MACHINE = cheyenne
#if ($USER==jedwards)
#set test=test
#else
set test=nanr
#endif

if ($MACHINE == cheyenne) then
	setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.07
	setenv CESM2_LE_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/
	setenv MYROOT /glade/scratch/nanr/aleph/
endif
if ($MACHINE == aleph) then
	setenv CESMROOT /mnt/lustre/share/CESM/cesm2.1.4-rc.07
	setenv CESM2_LE_TOOLS_ROOT $HOME/CESM_CASE_MANAGEMENT_TOOLS
	setenv MYROOT /mnt/lustre/share/CESM
	setenv POSTPROCESS_PATH /home/jedwards/workflow/CESM_postprocessing
	source $POSTPROCESS_PATH/cesm-env2/bin/activate
endif


set COMPSET = BHISTsmbb
set RESOLN = f09_g17
set RESUBMIT = 1
set STOP_N=10
set STOP_OPTION=nyears

set smbr =  2
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb 2 $me` )
@ USE_REFDATE = 1001 + ( $mbr - 1 ) * 10

if    ($mbr < 10) then
	setenv CASENAME b.e21${test}.${COMPSET}.${RESOLN}.LE2-${USE_REFDATE}.00${mbr}
else if ($mbr >= 10 && $mbr < 100) then
	setenv CASENAME b.e21${test}.${COMPSET}.${RESOLN}.LE2-${USE_REFDATE}.0${mbr}
else
	setenv CASENAME b.e21${test}.${COMPSET}.${RESOLN}.LE2-${USE_REFDATE}.${mbr}
endif

echo $CASENAME


end             # member loop

exit

