#!/bin/csh -fxv 

foreach  case ( soil_ind )
#foreach member (  `seq -w 01 99`  )
foreach member ( 26 100 )
set casename = $case-$member 
set casename01 = ${case}-01

set myhome = /glade/u/home/hteng 
set caseroot = $myhome/soil/{$casename}


#restart
cd  /glade/scratch/hteng/$casename/run
cp /glade/p/cgd/ccr/people/hteng/CAM5.ctrl/CAM5.ctrl-{$member}.tar .
tar xvf CAM5.ctrl-{$member}.tar
rm CAM5.ctrl-{$member}.tar
mv CAM5.ctrl-{$member}/* .
rmdir CAM5.ctrl-{$member} 

cd $caseroot
qsub -A P93300014 $casename.run 
end 
end 
exit

