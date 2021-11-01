#!/bin/csh 
### set env variables
module load ncl nco

setenv REFROOT  /glade/scratch/nanr/archive/b.e21.B1850.f09_g17.CMIP6-piControl.001/rest/
setenv RUNROOT  /glade/scratch/cesmsf/
setenv REFCASE  b.e21.B1850.f09_g17.CMIP6-piControl.001

# ...
#foreach exper ( EE GHG AAER BMB )
foreach exper ( RMDR )

# case name counter
set smbr =  1
set embr =  10

@ mb = $smbr
@ me = $embr

@ mb = $smbr
@ me = $embr

# reference name counter
@ mmm = ($smbr * 2) - 1

foreach mbr ( `seq $mb  $me` )

@ USE_REFDATE = 1001 + ( $mmm - 1 ) * 10
@ mmm+=2

setenv REFDATE  ${USE_REFDATE}


if ($mbr < 10) then
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-${exper}.00${mbr}
else
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-${exper}.0${mbr}
endif


#echo "==================================    " 
#echo $CASE 
echo 'Member = ' $mbr
echo 'Case   = ' $CASE


   #echo    $REFROOT/$REFDATE-01-01-00000/rpointer* $RUNROOT/$CASE/run/
   cp    $REFROOT/$REFDATE-01-01-00000/rpointer* $RUNROOT/$CASE/run/
   ln -s $REFROOT/$REFDATE-01-01-00000/b.e21*    $RUNROOT/$CASE/run/

end             # member loop
end             # member loop

