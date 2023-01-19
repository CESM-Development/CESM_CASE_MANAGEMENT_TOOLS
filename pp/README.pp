==========================
PP On Frontera -----------
==========================
#1 Add pp tools to your environment:
    .bashrc file:
	export PATH=${PATH}:/work2/04482/bpd6/frontera/cesmpp/scripts

    .tcsh:
	setenv PATH ${PATH}:/work2/04482/bpd6/frontera/cesmpp/scripts

#2 Set up pp environment, leveraging the information from your $CASEROOT

	cd $CASEROOT
	cd /work2/06091/nanr/frontera/cases/cesm13/b.e13.BDP-HR.ne120_t12.2018-11.001 

#3 Log in to a dev node to set up your pp environment 
	idev -n 1 -N 1
	create_postprocess --caseroot=$PWD
	exit (get out of idev node)

#4 Set up chunking and turn on/off components:

	cd postprocess
	cp $TOOLSROOT/pp/env_timeseries.xml .
	cp $TOOLSROOT/pp/env_postprocess.xml .


==========================
PP on cheyenne -----------
==========================
#1 add post_processing
	cd $CASEROOT
	module use /glade/work/bdobbins/Software/Modules
	module load cesm_postprocessing
	create_postprocess --caseroot=$PWD
	cd postprocess
#2 Edit:  timeseries and env_timeseries.xml, env_postprocess.xml
	Timeseries:  add project, remove ##s in top line!
	Env_timeseries.xml → check that cam hX freq match mfilt


