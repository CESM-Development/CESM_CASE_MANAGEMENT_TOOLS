#!/bin/csh
#
set disk = /glade/scratch/cesmsf/archive
set arcd = /glade/campaign/cesm/collections/CESM2-SF/restarts
#
cd ${disk}
#
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.00[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.00[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.0[11-15] )
foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.01[2-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.00[6-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-AAER.01[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.01[1-5] )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.00[6-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-EE.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.00[6-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-EE-SSP370.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.00[6-9] b.e21.B1850cmip6.f09_g17.CESM2-SF-BMB.010 )
#foreach case ( b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG.01[1-5] )
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    set year = `/bin/ls -1d {1853,1865,1880,1895,1910,1925,1940,1955,1970,1985,2000,2015}-*`
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

