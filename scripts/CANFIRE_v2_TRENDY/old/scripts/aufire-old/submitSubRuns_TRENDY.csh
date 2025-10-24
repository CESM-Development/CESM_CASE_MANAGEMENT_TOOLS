#!/bin/csh

#SBATCH --account=mp9
#SBATCH --job-name=NanTest
#SBATCH -N 7
#SBATCH -q regular
#SBATCH --constraint=cpu
#SBATCH -t 19:00:00
#SBATCH -o sout.%j
#SBATCH -e sout.%j

pwd

cd case1
./xmlchange STOP_N=7
./xmlchange REST_N=7

# now while on compute node, submit in sequence, 5 times -- or 15 months
./case.submit --no-batch -v >& bsubmitout0.txt
./case.submit --no-batch -v >& bsubmitout1.txt
./case.submit --no-batch -v >& bsubmitout2.txt
./case.submit --no-batch -v >& bsubmitout3.txt

wait
echo "Done!"
date
