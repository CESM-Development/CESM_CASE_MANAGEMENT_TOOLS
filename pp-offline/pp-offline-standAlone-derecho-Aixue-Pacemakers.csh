#!/bin/csh
# Created by nanr
# Redone by sglanvil (Sep/26/2023) 
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-historicalPacemaker/pp-offline
setenv DOUT_S_ROOT  /glade/derecho/scratch/nanr/archive/
#setenv DOUT_S_ROOT  /glade/campaign/cgd/ccr/AMOC/cesm2/history-files/
setenv CASEROOT /glade/derecho/scratch/$USER/post-proc/

#mkdir -p $CASEROOT/$CASE
#cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   #module purge
   #module load ncarenv/23.09
   module load intel
   module load intel-mpi/2021.10.0
   module load apptainer
   #create_postprocess -caseroot=`pwd`
endif

#cd postprocess

##cp $CESM2_TOOLS_ROOT/derecho/LR/env_timeseries.xml $CASEROOT/$CASE/postprocess/

	foreach mbr ( `seq 1 1` )
		set mbr_padZeros = `printf %03d $mbr`
		#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-PAC_15d50m.derecho.${mbr_padZeros}
		#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-ATL_15d50m.derecho.${mbr_padZeros}
		#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-PAC_15d50m.derecho.${mbr_padZeros}
		#set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-ATL_15d50m.derecho.${mbr_padZeros}
		#set CASE = b.e21.BHISTcmip6.f09_g17.HIST-IND_15d50m.derecho.${mbr_padZeros}
		set CASE = b.e21.BSSP585cmip6.f09_g17.HIST-IND_15d50m.derecho.${mbr_padZeros}
		mkdir -p $CASEROOT/$CASE
		cd $CASEROOT/$CASE
		if ( ! -d "postprocess" ) then
			create_postprocess -caseroot=`pwd`
		endif
		cd postprocess
	        cp $CESM2_TOOLS_ROOT/timeseries $CASEROOT/$CASE/postprocess/
		#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/derecho/scratch/$USER/timeseries/$CASE
                pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/campaign/cgd/ccr/AMOC/cesm2/timeseries/$CASE
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
                sed -i "s/t-PAC.PP/t.Apm-$mbr/g" $CASEROOT/$CASE/postprocess/timeseries
		qsub timeseries
	end 

exit

