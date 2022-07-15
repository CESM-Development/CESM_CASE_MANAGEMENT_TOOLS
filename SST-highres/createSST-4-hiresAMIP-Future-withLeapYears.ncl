load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;************************************************
begin
  print ("=========================================")
  print ("Starting:  createSST-4-hiresAMIP-future.ncl")
  print ("Start Time: "+systemfunc("date") )
  print ("=========================================")
  wkdir   = getenv(".")

  dd = systemfunc("date -u +%y%m%d")

  syr = 2015
  lyr = 2050

do y = syr,lyr
  uyr = y

  ifile1 = "tos_input4MIPs_SSTsAndSeaIce_HighResMIP_MOHC-highresSST-future-1-0-1_gn_"+uyr+"0101-"+uyr+"1231.nc"
  ifile2 = "siconc_input4MIPs_SSTsAndSeaIce_HighResMIP_MOHC-highresSST-future-1-0-1_gn_"+uyr+"0101-"+uyr+"1231.nc"
  ofile1 = "sst_input4MIPs_HighResMIP_MOHC-highresSST-future."+uyr+"0101-"+uyr+"1231.nc"

  in1  = addfile("/glade/scratch/nanr/SST-highres/future/download/"+ifile1,"r")
  in2  = addfile("/glade/scratch/nanr/SST-highres/future/download/"+ifile2,"r")
  system("rm " + "/glade/scratch/nanr/SST-highres/future/withleapYears/"+ofile1)
  of1  = addfile("/glade/scratch/nanr/SST-highres/future/withleapYears/"+ofile1,"c")

; vars       = getfilevarnames (in)
; nvars      = dimsizes(vars)

of1@author = "created by nanr; hiResAMIP forcing.  Script="+get_script_name + " on " + dd
; copy global attributes from SST file
in1_global= getvaratts(in1)
in1_vars = getfilevarnames(in1)
; copy global attributes
if (.not.all(ismissing(in1_global))) then
do i = 0, dimsizes(in1_global) - 1
;print("copy_fileatts: global attributes->" + in1_global(i) )
of1@$in1_global(i) $ = in1@$in1_global(i)$
end do
end if

; copy global attributes from sea ice file
in2_global= getvaratts(in2)
in2_vars = getfilevarnames(in2)
; copy global attributes
if (.not.all(ismissing(in2_global))) then
do i = 0, dimsizes(in2_global) - 1
if (in2_global(i) .eq. "tracking_id" .or. in2_global(i) .eq. "realm" .or. in2_global(i) .eq. "variable_id")
;print("copy_fileatts: global attributes->" + in2_global(i) )
of1@$in2_global(i) $ = in2@$in2_global(i)$
end if
end do
end if


  lat  = dble2flt(in1->latitude)
  lon  = dble2flt(in1->longitude)
  nlat = dimsizes(lat)
  nlon = dimsizes(lon)
  	SST_cpl = in1->tos
  	ice_cov = in2->siconc * 0.01
  	filedimdef(of1,"time",-1,True) 

  	lat!0 = "lat"
  	lon!0 = "lon"
  	SST_cpl!0 = "time"
  	SST_cpl!1 = "lat"
  	SST_cpl&lat = lat
  	SST_cpl!2   = "lon"
  	SST_cpl&lon = lon
  	copy_VarCoords(SST_cpl,ice_cov)
  	;of1->time_bnds = in1->time_bnds
  	of1->SST_cpl = SST_cpl
  	of1->ice_cov = ice_cov

  	delete([/lat,lon,SST_cpl,ice_cov/])


;===================================================================
; make time an UNLIMITED dimension; recommended  for most applications
;===================================================================



end do

end

