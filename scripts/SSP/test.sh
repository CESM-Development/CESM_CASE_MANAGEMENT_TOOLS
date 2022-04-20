#!/bin/bash -fe

# E3SM Water Cycle v2 run_e3sm script template.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming


# For debugging, uncomment libe below
#set -x

echo "Here I am"

main() {
# Year array YYYY:  
declare -a arr=( "0111" "0121" "0131" )

echo "${arr[0]}", "${arr[1]}" 
## declare an array variable
##declare -a arr=("element1" "element2" "element3")
for i in "${arr[@]}"
do
        echo "WAHAAi"
        echo "$i"
done
 #set myvar = "${arr[0]}"
    
}

main

#echo "myvari == ",${myvar}
