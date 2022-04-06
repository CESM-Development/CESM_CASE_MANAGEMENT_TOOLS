start_yr=2002
ensemble=001
#SRC_PREFIX=/scratch1/06921/agopal/archive
#DEST_PREFIX=/scratch1/06921/agopal/compressed/
#email=agopal@tamu.edu
SRC_PREFIX=/scratch1/06091/nanr/archive
DEST_PREFIX=/scratch1/06091/nanr/compressed/
project=ATM20005
email=nanr@ucar.edu

end_yr=$((start_yr+5))
CASE=b.e13.BDP-HR.ne120_t12.${start_yr}-11.${ensemble}
compress_script=/work/06921/agopal/frontera/compress_test/compress_prefix.py
comp_suffix=hist


declare -a CompArray=("atm"  "cpl"  "esp"  "ice"  "lnd"  "logs"  "ocn"  "rest"  "rof")
#declare -a CompArray=("ocn" "esp" "lnd"  "logs"  "rest"  "rof")

write_jobscript () {
  
cat > $1/compress_$2.slurm <<EOM
#!/bin/bash
#SBATCH -J cmp_${2}           # Job name
#SBATCH -o cmp_${2}.o%j       # Name of stdout output file
#SBATCH -e cmp_${2}.e%j       # Name of stderr error file
#SBATCH -p $5          # Queue (partition) name
#SBATCH -N 1               # Total # of nodes 
#SBATCH -n $3              # Total # of mpi tasks
#SBATCH -t $4        # Run time (hh:mm:ss)
#SBATCH -A $project
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH --mail-user=$email

ml intel
ml impi
ml netcdf
source /home1/06921/agopal/ncar_utils/bin/activate


EOM
}

append_jobscript () {
printf  "ibrun $compress_script -f $3 -p $2 \n" >> $1/compress_${4}.slurm
}

append_jobscript_exclude () {
xfile=$(basename $4)
printf  "ibrun $compress_script -f $3 -p $1/rest/$2 -x $4 \n" >> $1/compress_${5}.slurm
printf  "nccopy -d 1 $4 $1/rest/$2/cmpr_$xfile \n" >> $1/batch
}

append_launcher() {
printf "module load launcher \n" >> $1/compress_${2}.slurm
printf "export LAUNCHER_JOB_FILE=$1/batch \n" >> $1/compress_${2}.slurm
printf "export LAUNCHER_SCHED=dynamic \n" >> $1/compress_${2}.slurm
printf "export LAUNCHER_WORKDIR=$1 \n" >> $1/compress_${2}.slurm
printf "/opt/apps/launcher/3.7/paramrun" >> $1/compress_${2}.slurm
}

mkdir -p $DEST_PREFIX/$CASE


cp /work/06921/agopal/frontera/transpose/jobPub.sh $DEST_PREFIX/$CASE/tseries.slurm

#sed -i -e "s|myarchiveDir|${SRC_PREFIX}|g" $DEST_PREFIX/$CASE/tseries.slurm
#sed -i -e "s|myoutDir|${DEST_PREFIX}\/${CASE}|g" $DEST_PREFIX/$CASE/tseries.slurm
#sed -i -e "s/dummyCASE/${CASE}/g" $DEST_PREFIX/$CASE/tseries.slurm
#sed -i -e "s/stYEAR/${start_yr}/g" $DEST_PREFIX/$CASE/tseries.slurm
#sed -i -e "s/endYEAR/${end_yr}/g" $DEST_PREFIX/$CASE/tseries.slurm
#sed -i -e "s/myproject/${project}/g" $DEST_PREFIX/$CASE/tseries.slurm

cp /work/06921/agopal/frontera/transpose/jobPub2.sh $DEST_PREFIX/$CASE/tseries2.slurm

#start_YR=2086
#end_YR=2102

cp /work/06921/agopal/frontera/transpose/jobPub3.sh $DEST_PREFIX/$CASE/tseries3.slurm

sed -i -e "s|myarchiveDir|${SRC_PREFIX}|g" $DEST_PREFIX/$CASE/tseries*
sed -i -e "s|myoutDir|${DEST_PREFIX}\/${CASE}|g" $DEST_PREFIX/$CASE/tseries*
sed -i -e "s/dummyCASE/${CASE}/g" $DEST_PREFIX/$CASE/tseries*
sed -i -e "s/stYEAR/${start_yr}/g" $DEST_PREFIX/$CASE/tseries*
sed -i -e "s/endYEAR/${end_yr}/g" $DEST_PREFIX/$CASE/tseries*
sed -i -e "s/myproject/${project}/g" $DEST_PREFIX/$CASE/tseries*
#ARCHIVE_DIR=/scratch1/06921/agopal/archive/
#ARCHIVE_DIR=myarchiveDir
#OUT_DIR=myoutDir





for comp in ${CompArray[@]}; do
   echo $comp


   case_dir=$DEST_PREFIX/$CASE/
   output_base=$DEST_PREFIX/$CASE/$comp

   input_prefix=$SRC_PREFIX/$CASE/$comp/$comp_suffix
   echo $input_prefix
   input_base=$SRC_PREFIX/$CASE/$comp


   case $comp in

     atm)
       mkdir -p $output_base/$comp_suffix
     ;;

     ocn)
       mkdir -p $output_base/$comp_suffix
       cp $input_prefix/$CASE.pop.d* $output_base/$comp_suffix/
     ;;

     ice)
       mkdir -p $output_base/$comp_suffix
     ;;

     lnd)
       mkdir -p $output_base/$comp_suffix
       write_jobscript $case_dir "lnd" "20" "02:00:00" "development"
       append_jobscript $case_dir $output_base/$comp_suffix "$input_prefix/$CASE.clm2.h{0..1}.*.nc" "lnd"
     ;;

     rof)
       mkdir -p $output_base/$comp_suffix
       write_jobscript $case_dir "rof" "20" "02:00:00" "development"
       append_jobscript $case_dir $output_base/$comp_suffix "$input_prefix/$CASE.rtm.h{0..1}.*.nc" "rof"
     ;;

     rest)
       mkdir -p $output_base
       write_jobscript $case_dir "rest" "20" "02:00:00" "development"
       write_jobscript $case_dir "rest1" "5" "04:00:00" "small"
       append_launcher $case_dir "rest1"
       for subdir in $input_base/*/
       do
         subdir0=$(basename $subdir)
         echo $subdir0 
         mkdir -p $output_base/$subdir0
         cp $input_base/$subdir0/rpointer* $output_base/$subdir0/
         #cp $input_base/$subdir0/$CASE.cam.r.*.nc $output_base/$subdir0/
         append_jobscript_exclude $case_dir $subdir0 "$input_base/$subdir0/$CASE.*.nc" "$input_base/$subdir0/$CASE.cam.r.$subdir0.nc" "rest"
       done
     ;;


     logs)
       mkdir -p $output_base
       cp $input_base/* $output_base/  
     ;;
     *)
       echo -n "unknown"
      ;;
     esac  


done

