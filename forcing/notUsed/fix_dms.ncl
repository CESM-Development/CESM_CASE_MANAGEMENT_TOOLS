;*************************************************
; 
; 12 December 2011  
; author:  nanr
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;************************************************
begin

   dd = systemfunc("date -u +%y%m%d")

;************************************************
; read dms file and do linear interpolation to get value for 1920
;************************************************

ifile = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1849-2006_c090804.nc"
fout = addfile("/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1920_c090804_170829.nc","c")

in1 = addfile(ifile,"r")
in1_global= getvaratts(in1)
in1_vars = getfilevarnames(in1)
; copy global attributes
if (.not.all(ismissing(in1_global))) then
do i = 0, dimsizes(in1_global) - 1
print("copy_fileatts: global attributes->" + in1_global(i) )
fout@$in1_global(i) $ = in1@$in1_global(i)$
end do
end if
; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq."date") then
	newdate = in1->$in1_vars(i)$ + 710000
	fout->$in1_vars(i)$ = newdate(0:11)
else
if (in1_vars(i) .eq."DMS") then
	idms = in1->$in1_vars(i)$
        dms1849 = idms(0:11,:,:)
        dms2005 = idms(12:23,:,:)
	printVarSummary(dms1849)
	printVarSummary(dms2005)
        nyrs = 2005 - 1849 + 1
        x    = 2005 - 1920 + 1
	print("xyr = " + xyr)
	m = (dms2005 - dms1849) / nyrs
	dms1920 = dms2005
	dms1920 = (m * x) + dms1849
	fout->$in1_vars(i)$ = dms1920
end if
end if


end do
end if

end
