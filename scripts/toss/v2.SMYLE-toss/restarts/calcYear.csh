#! /bin/csh -fxv 

setenv TOOLS_ROOT /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/
 set syr = 2021
 set eyr = 2021
 set mon = 11

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

# ocn/ice
# years used for ICs:   0306 (1958) - 0336 (1988)
#1958 = 0306
#1959 = 0307
# ...
#1988 = 0336

set ocncase = 20230123.GMPAS-JRA1p4.TL319_EC30to60E2r2.anvil
set first_rest_year = 1958
set ocean_base_year = 306


# Comment:  year translation:  if ($year == 2018 ) set ocnyr = 0366
# years used for ICs:   0306 (1958) - 0366 (2018)
# atmyr 1958 = ocnyr 306
@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set ocndir = /pscratch/sd/l/lvroekel/cycle6_monthly-restarts/restarts_monthly/

echo 'Input year: $year == OCN year:  ${ocnyr}'

set icefname   = ${ocncase}.mpassi.rst.0${ocnyr}-${mon}-01_00000.nc 
set poprfname  = ${ocncase}.mpaso.rst.0${ocnyr}-${mon}-01_00000.nc  


echo $icefname
echo ls -l $ocndir/$poprfname

end

exit
 
 



