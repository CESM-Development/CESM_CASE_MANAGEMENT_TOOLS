#!/bin/csh 
### set env variables

#foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )

set CASEROOT = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.SSP370-smbb_${mbr}/case_scripts
set RUNROOT  = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.SSP370-smbb_${mbr}/run
set REFROOT  = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.historical-smbb_${mbr}/archive/rest/2015-01-01-00000/

set doThis = 0
if (doThis == 1) then
cd $CASEROOT/
./xmlchange EXEROOT=/global/cscratch1/sd/nanr/E3SMv2/EXEROOT/build/
./xmlchange JOB_QUEUE=debug --subgroup case.st_archive
./xmlchange JOB_WALLCLOCK_TIME=00:30:00 --subgroup case.st_archive

mv case.st_archive tmp.st_archive
cat tmp.st_archive | sed 's/101/1/' > case.st_archive

endif

cd $RUNROOT/
echo $REFROOT/rpointer.atm
cp $REFROOT/rpointer* .
ln -s $REFROOT/v2.*.nc .

end             # mbr loop

exit

