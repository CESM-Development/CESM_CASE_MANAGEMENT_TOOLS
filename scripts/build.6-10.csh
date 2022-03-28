#!/bin/csh -f

setenv HOMEDIR `pwd`

set smbr = 6
set embr = 10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )

if ($mbr < 10) then
	set CASENAME = b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.00{$mbr}
else
	set CASENAME = b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.0${mbr}
endif
echo 'Member = ' $mbr
echo 'Case = ' $CASENAME

setenv CASEROOT /glade/work/cesmsf/CESM2-SF/$CASENAME

cd $CASEROOT

if ($mbr == $smbr) then
	set masterroot = $CASENAME
	echo "building case = " $CASENAME
	./case.setup --reset; ./case.setup; qcmd -- ./$CASENAME.build >& bld.`date +%m%d-%H%M` 
	echo "`date` - Waiting for build"
	wait
	echo "`date` - build jobs are complete"
else
	./case.setup --reset; ./case.setup
	./xmlchange EXEROOT=/glade/scratch/cesmsf/$masterroot/bld/
	./xmlchange BUILD_COMPLETE=TRUE
endif



end
end
exit


