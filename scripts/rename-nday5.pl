#!/usr/bin/perl

#  Rename pop.h.5day files pop.h.nday5
#  usage: rename-nday5.pl < list5 > doit
#  chmod u+x doit

 while(<>)
 {
         @vars = split(/\s+/,$_);
         $ifile = @vars[0];
	 $n = substr($ifile,55,5);
	 $pre = substr($ifile,0,55);
	 $post = substr($ifile,59,length($ifile));
	 #$n = substr($ifile,15,length($ifile-5));
	 #$n = substr($ifile,5,length($ifile-10));
	 #print("$n\n");
	 #print("$pre\n");
	 #print("$post\n");
         print("mv $ifile $pre"."nday5"."$post \n");
 }
