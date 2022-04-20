#!/bin/csh 
### set env variables

foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )

set CASEROOT = /global/cscratch1/sd/nanr/E3SMv2/v2.LR.SSP370_${mbr}/case_scripts

cd $CASEROOT/
./xmlchange JOB_QUEUE=debug --subgroup case.st_archive
./xmlchange JOB_WALLCLOCK_TIME=00:30:00 --subgroup case.st_archive

mv case.st_archive tmp.st_archive
cat tmp.st_archive | sed 's/101/1/' > case.st_archive
end             # mbr loop

exit

