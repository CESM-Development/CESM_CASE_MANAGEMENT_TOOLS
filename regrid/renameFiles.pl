#!/usr/bin/perl

#  usage: files.perl < list

 while(<>)
 {
         @vars = split(/\s+/,$_);
         $file1 = @vars[0];
         $p1 = substr($file1,0,length($file1)-6);
         $p2 = substr($file1,20,);
	 #print("part1 = $p1 \n");
         print("ln -s $file1 $p1.nc\n");
 }
