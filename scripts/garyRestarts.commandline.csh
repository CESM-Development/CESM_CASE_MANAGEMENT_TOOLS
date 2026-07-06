#!/bin/csh
#
set disk = /glade/derecho/scratch/nanr/archive
#set disk = /glade/campaign/cgd/ccr/yeager/WISHBONE/history-files
set arcd = /glade/campaign/cgd/ccr/yeager/WISHBONE/restarts
#
cd ${disk}
#
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-089.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-115.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-115.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-112.001 b.e13.SPNA-derecho.ne120_t12.SY-105.001 b.e13.SPNA-derecho.ne120_t12.SY-115.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-089.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-096.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-100.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-112.001 )
#foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-121.001  b.e13.SPNA-derecho.ne120_t12.SY-130.001 )
foreach case ( b.e13.SPNA-derecho.ne120_t12.SY-112.001 )
  date
  if ! ( -d ${arcd}/${case} ) then
    mkdir -p ${arcd}/${case}
  endif
  if ( -d ${disk}/${case}/rest ) then
    cd ${disk}/${case}/rest
    set year = `/bin/ls -1d 0*-01-*`
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

