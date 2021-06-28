#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-covid/
setenv DOUT_S_ROOT  /glade/scratch/nanr/archive/
#setenv CASEROOT /glade/scratch/nanr/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
# case name counter
set smbr =  26
set embr =  42

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-gfed-2015-2018.00${mbr}
else
        set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-gfed-2015-2018.0${mbr}
endif

setenv CASEROOT /glade/work/nanr/CESM2-covid/
if (! -d $CASEROOT/$CASE) then
   mkdir -p $CASEROOT/$CASE
endif
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/nanr/timeseries/$CASE/
./pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/collections/cdg/timeseries-cmip6/$CASE/
./pp_config --set CASE=$CASE
./pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
./pp_config --set ATM_GRID=0.9x1.25
./pp_config --set LND_GRID=0.9x1.25
./pp_config --set ICE_GRID=gx1v7
./pp_config --set OCN_GRID=gx1v7
./pp_config --set ICE_NX=320
./pp_config --set ICE_NY=384



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

#PBS -N cvd${usembr}
#PBS -q regular
#PBS -l select=1:ncpus=36:mpiprocs=36
#PBS -l walltime=12:00:00
#PBS -A CESM0019


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

mpirun singularity run -B /glade,/var /glade/work/bdobbins/Containers/CESM_Postprocessing/image /opt/ncar/cesm_postprocessing/cesm-env2/bin/cesm_tseries_generator.py  --caseroot $CASEROOT/$CASE/postprocess >> ./logs/timeseries.`date +%Y%m%d-%H%M%S`

EOF

qsub ./timeseries

end             # member loop

exit

