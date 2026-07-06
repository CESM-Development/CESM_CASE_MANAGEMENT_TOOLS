#! /bin/csh -fxv

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/

# ==================================
# generate perturbed cam.i.restarts
# ==================================
#set syr = 1970
#set eyr = 2020
#set syr = 1970
#set eyr = 2019
set syr = 2020
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 05 )

setenv CYLC_TASK_CYCLE_POINT ${year}-${mon}-01
cd ${CESM2_TOOLS_ROOT}/restarts/
./generate_cami_ensemble_offline.L93.py

end
end

exit
