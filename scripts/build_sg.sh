#!/bin/bash

dirOuter=/glade/work/cesmsf/CESM2-SF
caseBaseName=b.e21.B1850cmip6.f09_g17.CESM2-SF-AER

for imember in {009..010}; do
	caseDir=$dirOuter/$caseBaseName.$imember
	echo $caseDir
	cd $caseDir
	./case.setup --reset
	./case.setup
	qcmd -- ./case.build
done

