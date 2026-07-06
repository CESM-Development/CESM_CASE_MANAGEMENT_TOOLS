#!/bin/csh
#
set disk = /glade/derecho/scratch/nanr/archive
#set disk = /glade/campaign/cgd/ccr/AMOC/cesm2/history-files
set arcd = /glade/campaign/cgd/ccr/AMOC/cesm2/restarts
#
cd ${disk}
#
foreach case ( b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.001 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.002 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.003 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.004 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.005 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.006 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.007 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.008 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.009 b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.010)

  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    set year = `/bin/ls -1d {2021}-*`
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

