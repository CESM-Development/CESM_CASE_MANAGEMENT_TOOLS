#!/bin/csh 
### set env variables
### module load ncl nco


# ...
# case name counter

#setenv DOUT  /pscratch/sd/n/nanr/v2.LR.SMBB-SF/v2.LR.SSP370-BMB-SF_0161/archive/
#set CASE = v2.LR.SSP370-BMB-SF_0161
#foreach yr (2020 2025 2030 2035 2040 2045 2050 2054 )

setenv DOUT  /pscratch/sd/n/nanr/v2.LR.SMBB-SF/v2.LR.SSP370-BMB-SF_0141/archive/
set CASE = v2.LR.SSP370-BMB-SF_0141
foreach yr (2020 2025 2030 2035 2040 2045 2050 2051 )
cd $DOUT/rest/${yr}-01-01-00000
sed -i '/^[[:space:]]*#/! s|-SMBB|-BMB-SF|g' rpointer.atm rpointer.lnd rpointer.rof rpointer.drv
echo `pwd`
end


echo "==================================    " 
#echo $CASE 

exit

