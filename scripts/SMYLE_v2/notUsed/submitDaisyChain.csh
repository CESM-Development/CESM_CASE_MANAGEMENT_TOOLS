#!/bin/csh 
### set env variables
### module load ncl nco

setenv DOUT  /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/

# ...
set syr = 1962
set eyr = 1962

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 02 )

# case name counter
set smbr =  1
set embr =  1

@ mb = $smbr
@ me = $embr

set CASE = v21.LR.BSMYLE_v2.${year}-${mon}.001

foreach mbr ( `seq $mb $me` )

set padded_mbr = `printf "%03d" $mbr`
set CASEDIR = case_scripts.${padded_mbr}


echo "==================================    " 
#echo $CASE 
    cd $DOUT/$CASE/$CASEDIR

cat << EOF >> do_daisychain.scr
#!/bin/csh

#SBATCH --account=mp9
#SBATCH --job-name=run.v21.LR.BSMYLE_v2.${year}-${mon}.${padded_mbr}
#SBATCH --nodes=7
#SBATCH --exclusive 
#SBATCH -q regular
#SBATCH --constraint=cpu
#SBATCH -t 19:00:00
#SBATCH -o sout.%j
#SBATCH -e sout.%j

pwd

cd /pscratch/sd/n/nanr/v21.LR.BSMYLE_v2/v21.LR.BSMYLE_v2.${year}-${mon}.001/case_scripts.${padded_mbr}
./xmlchange STOP_N=7
./xmlchange REST_N=7

# now while on compute node, submit in sequence, 4 times -- or 4*7=28 months
./case.submit --no-batch -v >& bsubmitout0.txt
./xmlchange CONTINUE_RUN=TRUE
./case.submit --no-batch -v >& bsubmitout1.txt
./case.submit --no-batch -v >& bsubmitout2.txt
./case.submit --no-batch -v >& bsubmitout3.txt

wait
echo "Done!"
date

EOF

chmod u+x do_daisychain.scr
sbatch ./do_daisychain.scr


end             # member loop
end             # member loop
end             # member loop

exit

