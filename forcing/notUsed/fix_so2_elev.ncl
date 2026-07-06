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

ifile = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so2_elev_1850-2005_c090804.nc"
foutname = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_so2_elev_1920_c090804_170830.nc"
system("rm "+foutname)          ; delete file if it already exists
fout = addfile( foutname ,"c")
; foutname = "ar5_mam3_so2_surf_1920_c090804_170830.nc"
; system("rm "+foutname)          ; delete file if it already exists
; fout = addfile( foutname ,"c")

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

    ; 19200115,   // date(97)
    ; 19200215,   // date(98)
    ; 19200315,   // date(99)
    ; 19200415,   // date(100)
    ; 19200515,   // date(101)
    ; 19200615,   // date(102)
    ; 19200715,   // date(103)
    ; 19200815,   // date(104)
    ; 19200915,   // date(105)
    ; 19201015,   // date(106)
    ; 19201115,   // date(107)
    ; 19201215,   // date(108)

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq."lat" .or. in1_vars(i) .eq."lon" .or. in1_vars(i) .eq."altitude" .or. in1_vars(i) .eq."altitude_int") then
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
else
	if (in1_vars(i) .eq."date") then
		fout->$in1_vars(i)$ = in1->$in1_vars(i)$(96:107)
	else
		fout->$in1_vars(i)$ = in1->$in1_vars(i)$(96:107,:,:,:) 
	end if
end if


end do
end if

end
