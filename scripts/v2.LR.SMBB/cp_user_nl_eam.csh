#!/bin/csh 
### set env variables

#foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
foreach mbr ( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )

set CASEROOT = /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.historical-smbb_${mbr}/case_scripts

cp /global/u2/n/nanr/CESM_tools/e3sm/v2/user_nl_files/HISTsmbb/user_nl_eam $CASEROOT/

end             # mbr loop

exit

