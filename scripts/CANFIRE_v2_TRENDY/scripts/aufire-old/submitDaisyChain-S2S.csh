#!/bin/csh 
### set env variables
### module load ncl nco

setenv MYPATH  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/

# ...
###  Change all this to match your casename
set syr = 1962
set eyr = 1962

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )
foreach day ( `seq $ib $ie` )


set CASE = v21.LR.BSMYLE_S2S.${year}-${mon}-${day}.001

echo "==================================    " 
cd $MYPATH/$CASE/case_scripts.001

cat << EOF >> do_DaisyChain.scr
#!/bin/csh

#SBATCH --account=mp9
#SBATCH --job-name=run.S2S.${year}-${mon}-${day}
#SBATCH --nodes=7
#SBATCH --exclusive 
#SBATCH -q regular
#SBATCH --constraint=cpu
#SBATCH -t 19:00:00
#SBATCH -o sout.%j
#SBATCH -e sout.%j

pwd

cd $MYPATH/$CASE/case_scripts.001
./case.submit --no-batch -v >& bsubmitout1.txt
cd $MYPATH/$CASE/case_scripts.002
./case.submit --no-batch -v >& bsubmitout2.txt
cd $MYPATH/$CASE/case_scripts.003
./case.submit --no-batch -v >& bsubmitout3.txt
cd $MYPATH/$CASE/case_scripts.004
./case.submit --no-batch -v >& bsubmitout4.txt
cd $MYPATH/$CASE/case_scripts.005
./case.submit --no-batch -v >& bsubmitout5.txt
cd $MYPATH/$CASE/case_scripts.006
./case.submit --no-batch -v >& bsubmitout6.txt
cd $MYPATH/$CASE/case_scripts.007
./case.submit --no-batch -v >& bsubmitout7.txt
cd $MYPATH/$CASE/case_scripts.008
./case.submit --no-batch -v >& bsubmitout8.txt
cd $MYPATH/$CASE/case_scripts.009
./case.submit --no-batch -v >& bsubmitout9.txt
cd $MYPATH/$CASE/case_scripts.010
./case.submit --no-batch -v >& bsubmitout10.txt
cd $MYPATH/$CASE/case_scripts.011
./case.submit --no-batch -v >& bsubmitout11.txt

wait
echo "Done!"
date

EOF

chmod u+x do_DaisyChain.scr
sbatch ./do_DaisyChain.scr


end             # day loop
end             # mon loop
end             # year loop

exit

