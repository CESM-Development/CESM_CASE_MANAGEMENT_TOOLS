#!/bin/csh
# Created by nanr
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-covid/pp/
setenv DOUT_S_ROOT  /glade/derecho/scratch/nanr/archive/
setenv CASEROOT /glade/derecho/scratch/$USER/post-proc/

if ( ! -d "postprocess" ) then
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   #create_postprocess -caseroot=`pwd`
endif

#cd postprocess

##cp $CESM2_TOOLS_ROOT/derecho/LR/env_timeseries.xml $CASEROOT/$CASE/postprocess/

	foreach mbr ( `seq 1 10` )
		set mbr_padZeros = `printf %02d $mbr`
		#set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-cvd-aufire-shipping.1${mbr_padZeros}
		set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-ssp245-2019-cntl.1${mbr_padZeros}
		#set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-cvd-aufire-shipping-0.2.1${mbr_padZeros}
		#set CASE = b.e21.BSSP245cmip6.f09_g17.COVID-cvd-aufire-derecho.1${mbr_padZeros}
		mkdir -p $CASEROOT/$CASE
		cd $CASEROOT/$CASE
		if ( ! -d "postprocess" ) then
			create_postprocess -caseroot=`pwd`
		endif
		cd postprocess
	        cp $CESM2_TOOLS_ROOT/timeseries $CASEROOT/$CASE/postprocess/
		pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/campaign/cgd/ccr/nanr/COVID-cvd-aufire-shipping/timeseries/$CASE
		pp_config --set CASE=$CASE
		pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
		pp_config --set ATM_GRID=0.9x1.25
		pp_config --set LND_GRID=0.9x1.25
		pp_config --set ICE_GRID=gx1v7
		pp_config --set OCN_GRID=gx1v7
		pp_config --set ICE_NX=320
		pp_config --set ICE_NY=384
		mv timeseries timeseries-OTB
		cp $CESM2_TOOLS_ROOT/timeseries $CASEROOT/$CASE/postprocess
		# there is a hard-coded CASE in the timeseries file, so we need to replace it as we go...
		sed -i "s/MY_CASE_NAME/$CASE/g" $CASEROOT/$CASE/postprocess/timeseries
                sed -i "s/tPP/t.Apm-$mbr/g" $CASEROOT/$CASE/postprocess/timeseries
		qsub timeseries
	end 

exit

