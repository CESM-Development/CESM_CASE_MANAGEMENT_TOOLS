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
  foutname = "/glade/work/nanr/cmip6/ihesp-HiRes/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_"+fixit(0)+"_1950_c090804_c"+dd+".nc"

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
	tmp = in1->$in1_vars(i)$(0:11)
		tmp(0)  = 19500115
		tmp(1)  = 19500215
		tmp(2)  = 19500315
		tmp(3)  = 19500415
		tmp(4)  = 19500515
		tmp(5)  = 19500615
		tmp(6)  = 19500715
		tmp(7)  = 19500815
		tmp(8)  = 19500915
		tmp(9)  = 19501015
		tmp(10) = 19501115
		tmp(11) = 19501215
	fout->$in1_vars(i)$ = tmp
	delete(tmp)
else
if (in1_vars(i) .eq."DMS")then
	tmp = in1->$in1_vars(i)$(0:11,:,:)
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
