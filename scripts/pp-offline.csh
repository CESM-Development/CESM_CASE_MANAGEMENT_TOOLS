#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/cesmsf/cesm_tags/CASE_tools/cesm2-sf/
setenv ARCHDIR  /glade/scratch/cesmsf/archive/
setenv CASEROOT  /glade/work/cesmsf/CESM2-SF/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
# case name counter
set smbr =  13
set embr =  13

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG.00${mbr}
else
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG.0${mbr}
endif

cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess
pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/cesmsf/timeseries/$CASE/
#qsub ./timeseries 

if ($mbr < 10) then
   set usembr = "00"${mbr}
else
   set usembr = "0"${mbr}
endif

echo $usembr

# =========================
# change a few things
# =========================
mv timeseries timeseries-OTB
cat >> timeseries << EOF
#!/bin/bash

#PBS -N t${mbr}
#PBS -q regular
#PBS -l select=1:ncpus=36:mpiprocs=36
#PBS -l walltime=12:00:00
#PBS -A NCGD0044

##########
##
## See https://github.com/NCAR/CESM_postprocessing/wiki for details
## regarding settings for optimal performance for CESM postprocessing tools.
##
##########

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

module load impi
module load singularity/3.7.2

mpirun singularity run -B /glade,/var /glade/work/bdobbins/Containers/CESM_Postprocessing/image /opt/ncar/cesm_postprocessing/cesm-env2/bin/cesm_tseries_generator.py  --caseroot ${CASEROOT}/${CASE}/postprocess >> ./logs/timeseries.`date +%Y%m%d-%H%M%S`

EOF

# qsubcasper ./timeseries
qsubcasper -q casper -l walltime=12:00:00 -A NCGD0044 ./timeseries

end             # member loop

exit

