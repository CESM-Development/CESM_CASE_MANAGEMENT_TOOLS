#!/usr/bin/perl

# written by Nan Rosenbloom
# July 2015

# Documentation:
# Trim first few years from RCP85 forcing files and join with PD forcing.


$dd = `date +%y%m%d`;
chop($dd);
chdir("/glade\/scratch\/nanr\/");
system("pwd");

#@ivars = ("do_ozone","do_oxid","do_aerosols","do_ghg");
@ivars = ("do_aerosols");

foreach $v (@ivars)
{
	print("v = $v\n");
	if($v eq "do_aerosols") { &aerosols; }
	# if($v eq "do_ghg"     ) { &ghg; }
	# if($v eq "do_oxid"    ) { &oxid; }
	#if($v eq "do_ozone"    ) { &ozoneL66; }
} 

sub aerosols {

$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/";
#$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/";
$odir = "\/glade\/scratch\/nanr\/2090\/";

$idirfu = $idirpd;

print("I made it here\n");

# Future trim
$fus = 120;	# 20900115
$fue = 131;	# 20901215
#file name
#$fyr = 20900115;	# 20061215
#$lyr = 20901215;	# 20401215

@fuList = ("RCP85_mam3_so2_elev_2000-2300_c20120214.nc", 
	   "RCP85_mam3_bc_elev_2000-2300_c20120214.nc",
	   "RCP85_mam3_num_a1_elev_2000-2300_c20120214.nc",
	   "RCP85_mam3_num_a2_elev_2000-2300_c20120214.nc",
	   "RCP85_mam3_oc_elev_2000-2300_c20120214.nc",
	   "RCP85_mam3_so4_a1_elev_2000-2300_c20120214.nc",
	   "RCP85_mam3_so4_a2_elev_2000-2300_c20120214.nc",
           "RCP85_mam3_so2_surf_2000-2300_c20120214.nc",
           "RCP85_soag_1.5_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_bc_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_num_a1_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_num_a2_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_oc_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_so4_a1_surf_2000-2300_c20120214.nc",
           "RCP85_mam3_so4_a2_surf_2000-2300_c20120214.nc");

@ouList = ("RCP85_mam3_so2_elev_constant_2090_c".$dd.".nc", 
	   "RCP85_mam3_bc_elev_constant_2090_c".$dd.".nc",
	   "RCP85_mam3_num_a1_elev_constant_2090_c".$dd.".nc",
	   "RCP85_mam3_num_a2_elev_constant_2090_c".$dd.".nc",
	   "RCP85_mam3_oc_elev_constant_2090_c".$dd.".nc",
	   "RCP85_mam3_so4_a1_elev_constant_c".$dd.".nc",
	   "RCP85_mam3_so4_a2_elev_constant_2090_c".$dd.".nc",
           "RCP85_mam3_so2_surf_constant_2090_c".$dd.".nc",
           "RCP85_soag_1.5_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_bc_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_num_a1_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_num_a2_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_oc_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_so4_a1_surf_constant_2090_c".$dd.".nc",
           "RCP85_mam3_so4_a2_surf_constant_2090_c".$dd.".nc");

        print("Got here 1!\n");
	&cutFile($idirpd,$idirfu,$odir,@fuList,@ouList,$fus,$fue);
        print("Got here 2!\n");

}	# end aerosols sub loop
sub cutFile {
$ctr = 0;
foreach $ifile (@fuList) {
	$usenum = $ifile;
	$usefu = $idirfu.$fuList[$ctr];
	$useou = $odir.$ouList[$ctr];
        print("Got here!\n");
	my $script = $0;
	print("usenum = $usenum\n");
	print("usefu  = $usefu\n");
	print("useou  = $useou\n");

	# trim future files
 	 print("ncks -d time,$fus,$fue $usefu $useou\n");
	system("ncks -d time,$fus,$fue $usefu $useou");

 	print("ncatted -a history,global,a,c,'Created by nanr using $script' $useou\n");
       system("ncatted -a history,global,a,c,'Created by nanr using $script' $useou");
	
	$ctr++;

}
}
	

sub trimFile {
$ctr = 0;
foreach $ifile (@pdList) {
	$usenum = $ifile;
	$usepd = $idirpd.$ifile;
	$usefu = $idirfu.$fuList[$ctr];
	$useou = $odir.$ouList[$ctr];
	my $script = $0;
	print("usenum = $usenum\n");
	print("usepd  = $usepd\n");
	print("usefu  = $usefu\n");
	print("useou  = $useou\n");

	# trim PD files
 	 print("ncks -d time,$pds,$pde $usepd pdtmp.nc\n");
	system("ncks -d time,$pds,$pde $usepd pdtmp.nc");
	
	# trim future files
 	 print("ncks -d time,$fus,$fue $usefu futmp.nc\n");
	system("ncks -d time,$fus,$fue $usefu futmp.nc");
	
 	 print("ncrcat pdtmp.nc futmp.nc $useou\n");
	system("ncrcat pdtmp.nc futmp.nc $useou");

 	print("ncatted -a history,global,a,c,'Created by nanr using $script' $useou\n");
       system("ncatted -a history,global,a,c,'Created by nanr using $script' $useou");
	
	 print("rm pdtmp.nc\n");
        system("rm pdtmp.nc\n");
	 print("rm futmp.nc\n");
        system("rm futmp.nc\n");

	$ctr++;

}
}	# Do the trimming subroutine



end
