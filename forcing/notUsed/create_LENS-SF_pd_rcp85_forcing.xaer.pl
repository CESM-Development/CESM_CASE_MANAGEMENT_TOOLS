#!/usr/bin/perl

# written by Nan Rosenbloom
# July 2015

# Documentation:
# Trim first few years from RCP85 forcing files and join with PD forcing.


$dd = `date +%y%m%d`;
chop($dd);
chdir("/glade\/scratch\/nanr\/");
system("pwd");

@ivars = ("do_ozone","do_oxid","do_aerosols","do_ghg");

foreach $v (@ivars)
{
	print("v = $v\n");
	 if($v eq "do_aerosols") { &aerosols; }
} 

sub aerosols {

$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/";
$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/";
$idirfu = $idirpd;

# PD trim
$pds =  84;	# 19001215
$pde = 215;	# 20061115
# Future trim
$fus = 24;	# 20051215
$fue = 133;	# 21000115
#file name
$fyr = 19100115;	# 19100115
$lyr = 21000115;	# 21000115

@pdList = ("ar5_mam3_so2_elev_1850-2005_c090804.nc", 
	   "ar5_mam3_bc_elev_1850-2005_c090804.nc",
	   "ar5_mam3_num_a1_elev_1850-2005_c090804.nc",
	   "ar5_mam3_num_a2_elev_1850-2005_c090804.nc",
	   "ar5_mam3_oc_elev_1850-2005_c090804.nc",
	   "ar5_mam3_so4_a1_elev_1850-2005_c090804.nc",
	   "ar5_mam3_so4_a2_elev_1850-2005_c090804.nc",
           "ar5_mam3_so2_surf_1850-2005_c090804.nc",
           "ar5_mam3_soag_1.5_surf_1850-2005_c100429.nc",
           "ar5_mam3_bc_surf_1850-2005_c090804.nc",
           "ar5_mam3_num_a1_surf_1850-2005_c090804.nc",
           "ar5_mam3_num_a2_surf_1850-2005_c090804.nc",
           "ar5_mam3_oc_surf_1850-2005_c090804.nc",
	   "ar5_mam3_so4_a1_surf_1850-2005_c090804.nc",
	   "ar5_mam3_so4_a2_surf_1850-2005_c090804.nc");

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

@ouList = ("RCP85_mam3_so2_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc", 
	   "RCP85_mam3_bc_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
	   "RCP85_mam3_num_a1_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
	   "RCP85_mam3_num_a2_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
	   "RCP85_mam3_oc_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
	   "RCP85_mam3_so4_a1_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
	   "RCP85_mam3_so4_a2_elev_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_so2_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_soag_1.5_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_bc_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_num_a1_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_num_a2_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_oc_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_so4_a1_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc",
           "RCP85_mam3_so4_a2_surf_".$fyr."-".$lyr."_xaer_c".$dd.".nc");

	&trimFile($idirpd,$idirfu,$odir,@pdList,@fuList,@ouList,$pds,$pde,$fus,$fue,$sfyr,$lyr);

}	# end aerosols sub loop

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
