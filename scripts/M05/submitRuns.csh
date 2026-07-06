#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  $SCRATCH/CESM3-SMYLE
setenv CASEROOT  /glade/work/nanr/CESM3-SMYLE/cases/


# 1980, 1982, 1988, 1997, 1999, 2007, 2015.   That's 3 big El Ninos, 3 big La Ninas, and 1 neutral year.
# ...
set syr = 2000
set eyr = 2006

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

# case name counter
set smbr =  2
set embr =  5

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )

if ($mbr < 10) then
        set CASEDIR = b.e30_alpha09a.BHISTC_MTso_SMYLE.ne30_t233_wgx3.${year}-${mon}.00${mbr}
else
        set CASEDIR = b.e30_alpha09a.BHISTC_MTso_SMYLE.ne30_t233_wgx3.${year}-${mon}.0${mbr}
endif

echo $CASEROOT/$CASEDIR
cd $CASEROOT/$CASEDIR/
./xmlchange PROJECT=CESM0020
./xmlchange JOB_PRIORITY=regular
./case.submit

echo "==================================    " 
#echo $CASE 

end             # member loop
end             # member loop
end             # member loop

exit

