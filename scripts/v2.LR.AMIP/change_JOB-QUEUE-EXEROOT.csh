#!/bin/csh 
### set env variables

foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )

set CASEROOT = /global/cscratch1/sd/nanr/E3SMv2-AMIP/v2.LR.AMIP20TR_${mbr}/case_scripts
set RUNROOT  = /global/cscratch1/sd/nanr/E3SMv2-AMIP/v2.LR.AMIP20TR_${mbr}/run
set REFROOT  = /global/cscratch1/sd/nanr/archive/AMIP/v2.LR.historical_${mbr}/archive/rest/1976-01-01-00000/

cd $CASEROOT/
./xmlchange EXEROOT=/global/cscratch1/sd/nanr/E3SMv2-AMIP/EXEROOT/build/
#./xmlchange JOB_QUEUE=debug --subgroup case.st_archive
#./xmlchange JOB_WALLCLOCK_TIME=00:30:00 --subgroup case.st_archive

#mv case.st_archive tmp.st_archive
#cat tmp.st_archive | sed 's/101/1/' > case.st_archive

cd $RUNROOT/
cp $REFROOT/rpointer* .
ln -s $REFROOT/v2.*.nc .

end             # mbr loop

exit

