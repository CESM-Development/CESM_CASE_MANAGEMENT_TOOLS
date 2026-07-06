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
	#if($v eq "do_aerosols") { &aerosols; }
	 if($v eq "do_ghg"     ) { &ghg; }
	#if($v eq "do_oxid"    ) { &oxid; }
	#if($v eq "do_ozone"    ) { &ozoneL66; }
} 

sub ghg {
 	$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/ggas\/";
 	$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/ggas\/";
	$idirfu = $idirpd;
	

 	# PD trim
 	#$pds = 2029;	# 19200115
        $pds = 1909;    # 19100115,   // date(1910)
 	$pde = 3072;	# 20061215
 	# Future trim
 	$fus = 25;	# 20070115
 	#$fue = 673;	# 20601215
 	$fue = 1152;	# 21001215
 	#file name
 	$fyr = 19100115;
 	$lyr = 21001215;
 	@pdList = ("co2flux_fossil_1751-2006-monthly_0.9x1.25_c20100204.nc");
 	@fuList = ("co2flux_fossil_RCP85_2005-2100-monthly_0.9x1.25_c20101013.nc");
 	@ouList = ("co2flux_fossil_RCP85_monthly_0.9x1.25_".$fyr."-".$lyr."_c".$dd.".nc");

	&trimFile($idirpd,$idirfu,$odir,@pdList,@fuList,@ouList,$pds,$pde,$fus,$fue,$sfyr,$lyr);

}		# end ghg

sub ozoneL66 {
 	$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/ozone\/";
	$idirfu = $idirpd;
 	$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/ozone\/";

 	# PD trim
 	$pds = 852;	# 19200115
 	$pds = 792;	# 19150115
 	$pde = 1895;	# 20061115
 	# Future trim
 	$fus = 24;	# 20061215
 	#$fue = 672;	# 20601215
 	$fue = 1139;	# 20991115
 	#file name
 	$fyr = 19200115;	
 	$fyr = 19150115;	
 	#$lyr = 20601215;
 	$lyr = 20991215;
 	@pdList = ("ozone_1.9x2.5_L66_1849-2006_c130613.nc");
 	@fuList = ("ozone_1.9x2.5_L66_2005-2099_c130607.nc");
 	@ouList = ("ozone_rcp85_v1_1.9x2.5_L66_".$fyr."-".$lyr."_c".$dd.".nc");

	&trimFile($idirpd,$idirfu,$odir,@pdList,@fuList,@ouList,$pds,$pde,$fus,$fue,$sfyr,$lyr);

}		# end ozoneL66

sub oxid {
 	$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/oxid\/";
 	$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/oxid\/";
	$idirfu = $idirpd;

 	# PD trim
 	$pds =  84;	# 19150115
 	$pde = 215;	# 20061215
 	# Future trim
 	$fus = 49;	# 20150115
 	$fue = 120;	# 20651215
 	$fue = 167;	# 21051215
 	#file name
 	$fyr = 19150115;	# 19150115
 	$lyr = 20651215;	# 20651215
 	$lyr = 21051215;	# 21051215
 	@pdList = ("oxid_1.9x2.5_L26_1850-2005_c091123.nc");
 	@fuList = ("oxid_rcp85_v1_1.9x2.5_L26_1995-2105_c100202.nc");
 	@ouList = ("oxid_rcp85_v1_1.9x2.5_L26_".$fyr."-".$lyr."_c".$dd.".nc");

	&trimFile($idirpd,$idirfu,$odir,@pdList,@fuList,@ouList,$pds,$pde,$fus,$fue,$sfyr,$lyr);

}		# end oxid

sub aerosols {

$idirpd = "\/glade\/p\/cesmdata\/cseg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/";
$odir = "\/glade\/p\/cesm\/cvwg\/inputdata\/atm\/cam\/chem\/trop_mozart_aero\/emis\/new\/";
$idirfu = $idirpd;

# PD trim
$pds =  96;	# 19101215
$pds =  84;	# 19001215
$pde = 215;	# 20061115
# Future trim
$fus = 24;	# 20051215
$fue = 85;	# 20600115
$fue = 132;	# 21000115
#file name
$fyr = 19200115;	# 19200115
$fyr = 19100115;	# 19100115
$lyr = 20600115;	# 20600115
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

@ouList = ("RCP85_mam3_so2_elev_".$fyr."-".$lyr."_c".$dd.".nc", 
	   "RCP85_mam3_bc_elev_".$fyr."-".$lyr."_c".$dd.".nc",
	   "RCP85_mam3_num_a1_elev_".$fyr."-".$lyr."_c".$dd.".nc",
	   "RCP85_mam3_num_a2_elev_".$fyr."-".$lyr."_c".$dd.".nc",
	   "RCP85_mam3_oc_elev_".$fyr."-".$lyr."_c".$dd.".nc",
	   "RCP85_mam3_so4_a1_elev_".$fyr."-".$lyr."_c".$dd.".nc",
	   "RCP85_mam3_so4_a2_elev_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_so2_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_soag_1.5_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_bc_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_num_a1_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_num_a2_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_oc_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_so4_a1_surf_".$fyr."-".$lyr."_c".$dd.".nc",
           "RCP85_mam3_so4_a2_surf_".$fyr."-".$lyr."_c".$dd.".nc");

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
