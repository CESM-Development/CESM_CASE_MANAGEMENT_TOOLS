#!/bin/csh
#
set disk = /glade/scratch/cesmsf/archive
set arcd = /glade/campaign/cesm/collections/CESM2-SF/restarts
#
cd ${disk}
#
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.00[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB-SSP370.00[1-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB-SSP370.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG-SSP370.00[1-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG-SSP370.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.10[1-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.110 )
foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.11[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER-SSP370.01[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB-SSP370.01[1-5] )
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    set year = `/bin/ls -1d {2030,2051}-*`
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

