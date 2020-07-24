#!/bin/csh -f

setenv HOMEDIR `pwd`

set smbr = 31
set embr = 40

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )

if ($mbr < 10) then
	set CASENAME = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG.00{$mbr}
else
	set CASENAME = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG.0${mbr}
endif
echo 'Member = ' $mbr
echo 'Case = ' $CASENAME

setenv CASEROOT /glade/work/cesmsf/CESM2-SF/$CASENAME

cd $CASEROOT
echo "building case = " $CASE
./$CASE.build >& bld.`date +%m%d-%H%M` 

echo "`date` - Waiting for build"
wait
echo "`date` - all build jobs are complete"


end
end
exit


