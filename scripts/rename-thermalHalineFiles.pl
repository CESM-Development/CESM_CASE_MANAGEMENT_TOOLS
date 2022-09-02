#!/usr/bin/perl

#  usage: files.perl < list

#$lpath = "/glade2/scratch2/nanr/archive/b.e13.B1850C5CN.ne120_g16.tuning.005a/lnd/hist/";

$fstr="b.e21.B1PCTcmip6.f09_g17.rampUp.002";
#b.e21.B1850cmip6.f09_g17.thermalHaline.001

 while(<>)
 {
         @vars = split(/\s+/,$_);
         $file1 = @vars[0];
         $fend  = substr($file1,42,length($file1));
         $fnew  = $fstr.$fend;
         print("mv $file1 ./$fnew\n");
 }
