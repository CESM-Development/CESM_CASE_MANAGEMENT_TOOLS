#!/bin/csh
#
set disk = /glade/scratch/nanr/archive
set disk = /glade/derecho/scratch/nanr/archive
set arcd = /glade/campaign/cgd/cesm/L83/restarts
set arcd = /glade/campaign/cesm/development/cvcwg/cvwg/L83/restarts
#
#
#foreach case ( b.e21.BHISTcmip6.f09_g17.L83_cam6.003 )
#foreach case ( b.e21.BHISTcmip6.f09_g17.L83_cam6.002 )
foreach case ( b.e21.BSSP370cmip6.f09_g17.L83_cam6.002 b.e21.BSSP370cmip6.f09_g17.L83_cam6.003 )
#foreach case ( f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_SSP370.001 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_SSP370.002 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_SSP370.003 )
#foreach case ( f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6.001 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6.002 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6.003 )
#foreach case ( f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_SSP370.001 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_SSP370.002 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_SSP370.003 )
#foreach case ( f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_clim.001 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_clim.002 f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_clim.003 )
#foreach case ( b.e21.BSSP370cmip6.f09_g17.L83_cam6.001 )
  date
  cd ${disk}
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

