#!/bin/csh
#
set disk = /glade/scratch/nanr/archive
set arcd = /glade/campaign/cesm/development/cvcwg/cvwg/b.e21.BSSP585cmip6.f09_g17.CESM2-LE/restarts
#
cd ${disk}
#
foreach case ( b.e21.BSSP585cmip6.f09_g17.CESM2-LE.00[0-9] b.e21.BSSP585cmip6.f09_g17.CESM2-LE.010 )
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    set year = `/bin/ls -1d {2021}-*`
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

