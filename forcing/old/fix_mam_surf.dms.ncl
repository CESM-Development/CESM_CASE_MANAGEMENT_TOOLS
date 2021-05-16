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

  fixit = (/"dms_surf"/)

  ifile    = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_"+fixit(0)+"_1849-2006_c090804.nc"
  foutname = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/xrmd/aerocom_mam3_"+fixit(0)+"_1910-2100_c"+dd+".nc"

  system("rm "+foutname)          ; delete file if it already exists
  fout = addfile( foutname ,"c")

print("fixing file = " + foutname)

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
if (in1_vars(i) .eq."date")then
	tmp = in1->$in1_vars(i)$(0:23)
		tmp(0)  = 19100115
		tmp(1)  = 19100215
		tmp(2)  = 19100315
		tmp(3)  = 19100415
		tmp(4)  = 19100515
		tmp(5)  = 19100615
		tmp(6)  = 19100715
		tmp(7)  = 19100815
		tmp(8)  = 19100915
		tmp(9)  = 19101015
		tmp(10) = 19101115
		tmp(11) = 19101215
		tmp(12) = 21000115
		tmp(13) = 21000215
		tmp(14) = 21000315
		tmp(15) = 21000415
		tmp(16) = 21000515
		tmp(17) = 21000615
		tmp(18) = 21000715
		tmp(19) = 21000815
		tmp(20) = 21000915
		tmp(21) = 21001015
		tmp(22) = 21001115
		tmp(23) = 21001215
	fout->$in1_vars(i)$ = tmp
	delete(tmp)
else
if (in1_vars(i) .eq."DMS")then
	tmp = in1->$in1_vars(i)$(0:23,:,:)
	fout->$in1_vars(i)$ = tmp
	delete(tmp)
else
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
end if
end if


end do
end if

delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
