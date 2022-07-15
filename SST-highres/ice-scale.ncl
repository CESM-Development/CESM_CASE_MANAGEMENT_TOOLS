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

  syr = 1950
  lyr = 1950

do y = syr,lyr
  uyr = y

  ifile1 = "sst_HADISST_0.25_MOHC-HADISST-"+uyr+"0101-"+uyr+"1231.nc"
  ofile1 = "sst_HADISST_0.25_MOHC-HADISST-s-"+uyr+"0101-"+uyr+"1231.nc"

  in1  = addfile("/glade/scratch/nanr/SST-highres/to-scale/"+ifile1,"r")
  system("rm " + "/glade/scratch/nanr/SST-highres/to-scale/"+ofile1)
  of1  = addfile("/glade/scratch/nanr/SST-highres/to-scale/"+ofile1,"c")



of1@author = "created by nanr; Script="+get_script_name + " on " + dd
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
  oice  = ice * 0.01
  ;oice  = where(ismissing(ice), 0., ice*0.01)

  print("I'm here")

  of1->SST_cpl = sst
  of1->ice_cov = oice

  delete([/sst,ice/])

end do

end

