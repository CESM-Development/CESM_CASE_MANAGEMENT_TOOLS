#!/bin/bash

useyear=2000
usemonth=11

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/'
usecompset='BHISTC_LTso_SMYLE'
usetag='e30_beta06'
resoln='ne30pg3_t232_wg37'
tagdir='/glade/work/nanr/cesm_tags/cesm3_sandbox/cesm3_0_beta06/'
caseroot='/glade/work/nanr/CESM3-SMYLE/'

main_case_root='b.'$usetag'.'$usecompset'.'$resoln'.'${useyear}'-'${usemonth}'.001'

for mbr in $(seq -f "%03g" 1 1)
do

echo "setting up member ${mbr}"

runname=b.e21.$usecompset.$resoln.$useyear-$usemonth.$mbr
casedir=$caseroot/$runname

cd $casedir

./case.submit

done
