#!/bin/csh 
### set env variables

#foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )

set CASEROOT = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.SSP370-smbb_${mbr}/case_scripts
set RUNROOT  = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.SSP370-smbb_${mbr}/run
set REFROOT  = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.historical-smbb_${mbr}/archive/rest/2015-01-01-00000/

cd $CASEROOT/
./xmlchange RUN_REFCASE=v2.LR.historical-smbb_${mbr}
./xmlchange RUN_REFDIR=$REFROOT


end             # mbr loop

exit

