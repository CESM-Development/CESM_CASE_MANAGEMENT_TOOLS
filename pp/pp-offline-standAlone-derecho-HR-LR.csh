#!/bin/csh 
### set env variables
module load ncl nco

#setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/pp-offline/
setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm13-ne120_g16/pp/
setenv INPUT_DATA  /glade/derecho/scratch/$USER/archive/
setenv CASEROOT /glade/derecho/scratch/$USER/post-proc/

# module use /glade/work/bdobbins/Software/Modules
# module load cesm_postprocessing_derecho

# ...
# case name counter
set CASE = b.e13.BHISTC5.HR-LR-derecho-1920.ne120_g16.001
set CASE = b.e13.BRCP85C5.HR-LR-derecho-1920.ne120_g16.001

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE


if ( ! -d "postprocess" ) then
   echo "creating postprocess directory"
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

# =========================
# change a few things
# =========================
	        pp_config --set DOUT_S_ROOT=$INPUT_DATA/$CASE/
	        pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/campaign/cesm/development/cvcwg/cvwg/HR-LR/timeseries/$CASE/
	        pp_config --set CASE=$CASE
	        pp_config --set ATM_GRID=ne120np4
	        pp_config --set LND_GRID=ne120np4
	        pp_config --set ICE_GRID=gx1v6
	        pp_config --set OCN_GRID=gx1v6
	        pp_config --set ICE_NX=320
	        pp_config --set ICE_NY=384

                mv timeseries timeseries-OTB
                cp $CESM2_TOOLS_ROOT/timeseries $CASEROOT/$CASE/postprocess
                # there is a hard-coded CASE in the timeseries file, so we need to replace it as we go...
                sed -i "s/MY_CASE/$CASE/g" $CASEROOT/$CASE/postprocess/timeseries
                qsub timeseries


echo "Made it here"
#echo "Edit CASENAME in post-proc/timeseries file and then submit"

exit

