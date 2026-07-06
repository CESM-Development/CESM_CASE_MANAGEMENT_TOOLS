#!/bin/csh
#
set disk = /glade/derecho/scratch/nanr/archive
set disk = /glade/campaign/cgd/ccr/AMOC/cesm2/history-files
set arcd = /glade/campaign/cgd/ccr/AMOC/cesm2/restarts
#
cd ${disk}
#
#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-PAC_15d50m.derecho.001 )
#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.003 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.004 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.005 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.006 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.007 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.008 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.009 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.010 )
foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.003 b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.008 )
	#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.002 )
	##b.e21.BHISTcmip6.f09_g17.HIST-PAC_15d50m.derecho.005 
#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.002 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.003 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.004 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.005 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.006 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.007 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.008 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.009 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.010)
#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.001 )
#foreach case ( b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.006 b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.008 )
	#b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.006 
	#b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.008 
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    #set year = `/bin/ls -1d {1990}-*`
    set year = `/bin/ls -1d {1910,1920,1940,1960,1970,1985,1990,2010,2015}-*`
    #set year = `/bin/ls -1d {1865,1880,1895,1910,1925,1940,1955,1970,1985,1990,2000,2015}-*`
    #set year = `/bin/ls -1d `
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

