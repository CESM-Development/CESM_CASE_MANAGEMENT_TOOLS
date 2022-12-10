#!/bin/bash
#!!! warning - I've set the following in user_nl_cam
#ncdata='/glade/scratch/islas/archive/b.e21.B1850.f09_f09_mg17.L83_ogw2.001/rest/0037-01-01-00000/b.e21.B1850.f09_f09_mg17.L83_ogw2.001.cam.i.0037-01-01-00000.nc'


mbr='002'

if [[ ${mbr} == 001 ]] 
then
restyear='0106'
userest='0106-01-01'
   echo 'member -= ${mbr} and rest = ${restyear}'
fi
if [[ ${mbr} == 002 ]] 
then
    restyear='0100'
    userest='0100-01-01'
    echo ${restyear}
    echo '/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/'
fi
if [[ ${mbr} == 003 ]] 
then
   restyear='0970'
   echo 'member - ${mbr} and rest = ${restyear}'
fi
echo 'Here I am'
echo ${restyear}'-01-01'

echo ./xmlchange RUN_TYPE='hybrid'
echo ./xmlchange RUN_REFDIR=$userest
echo #./xmlchange RUN_REFDIR='/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/'
echo ./xmlchange RUN_REFCASE='b.e21.B1850.f09_g17.L83_cam6.001'
echo ./xmlchange RUN_REFDATE=${userest}
echo ./xmlchange RUN_STARTDATE='1979-01-01'
