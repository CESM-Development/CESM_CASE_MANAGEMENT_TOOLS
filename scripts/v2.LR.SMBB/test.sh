#!/bin/bash -fe

# E3SM Water Cycle v2 run_e3sm script template.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming

#array=( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )
   array=( 0241 0261 0271 0281 0291 0101 0151 0201 0251 0301 )
refarray=( 1991 1991 1991 1991 1991 1990 1990 1990 1990 1990 )
#array=( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
#array=( 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
set ctr=0
for iyr in "${array[@]}"
do


# For debugging, uncomment libe below
#set -x

#main() {

# Year array YYYY:  

echo "Doing it!"

echo ${iyr}
echo ${refarray[$ctr]}
ctr=$((ctr+1))
#}
done
