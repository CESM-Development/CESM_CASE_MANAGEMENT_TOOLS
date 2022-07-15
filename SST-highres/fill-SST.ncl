load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;************************************************
begin
  print ("=========================================")
  print ("Starting:  fill-SST.ncl")
  print ("Start Time: "+systemfunc("date") )
  print ("=========================================")
  wkdir   = getenv(".")

  dd = systemfunc("date -u +%y%m%d")

  syr = 2004
  lyr = 2004

do y = syr,lyr
  uyr = y

  ifile1 = "sst_HADISST_0.25_MOHC-HADISST-"+uyr+"0101-"+uyr+"1231.noleap.nc"
  ofile1 = "sst_HADISST_0.25_MOHC-HADISST-"+uyr+"0101-"+uyr+"1231.nc"

  in1  = addfile("/glade/scratch/nanr/SST-highres/"+ifile1,"r")
  system("rm " + "/glade/scratch/nanr/SST-highres/"+ofile1)
  of1  = addfile("/glade/scratch/nanr/SST-highres/"+ofile1,"c")



of1@author = "created by nanr; poisson_fill forcing.  Script="+get_script_name + " on " + dd
; copy global attributes from SST file
in1_global= getvaratts(in1)
in1_vars  = getfilevarnames(in1)
; copy global attributes
if (.not.all(ismissing(in1_global))) then
do i = 0, dimsizes(in1_global) - 1
	;print("copy_fileatts: global attributes->" + in1_global(i) )
	of1@$in1_global(i) $ = in1@$in1_global(i)$
end do
end if

  sst   = in1->SST_cpl           ; (say) (time,lat,lon)
  ice   = in1->ice_cov           ; (say) (time,lat,lon)

  guess     = 1                ; use zonal means
  is_cyclic = True             ; cyclic [global]
  nscan     = 1500             ; usually much less than this
  eps       = 1.e-2            ; variable dependent
  relc      = 0.6              ; relaxation coefficient
  opt       = 0                ; not used

  poisson_grid_fill( sst, is_cyclic, guess, nscan, eps, relc, opt)
  poisson_grid_fill( ice, is_cyclic, guess, nscan, eps, relc, opt)

  of1->SST_cpl = sst
  of1->ice_cov = ice


end do

end

