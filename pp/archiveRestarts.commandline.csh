#!/bin/csh
#
set disk = /glade/scratch/nanr/archive
set arcd = /glade/campaign/cgd/ccr/nanr/PPE/

#
cd ${disk}
#
#foreach case ( PPE_220_ensemble_4xCO2.220 PPE_220_ensemble_1850.220 PPE_220_ensemble_HIST-mbr1.220 PPE_220_ensemble_HIST-mbr3.220 )
foreach case ( PPE_220_ensemble_HIST-mbr2.220 )
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    #set year = `/bin/ls -1d {1865,1880,1900,1920,1940,1950,1970,1980,1990,2000,2010,2015}-*`
    set year = `/bin/ls -1d *-*`
    foreach rest ( `echo ${year}`)
      if ! ( -f ${arcd}/${case}/${case}.rest.${rest}.tar ) then
        echo "Processing restarts: "${rest}
        tar -cf ${arcd}/${case}/${case}.rest.${rest}.tar ${rest}
        if ($status == 0) then
          echo 'tar -cf '${arcd}'/'${case}'/'${case}'.rest.'${rest}'.tar '${rest}
        else
           echo 'tar -cf failed on '${case}' '${rest}
        endif
      else
         echo ${arcd}"/"${case}"/"${case}".rest."${rest}".tar exists."
      endif
    end
  endif
end
#
exit

