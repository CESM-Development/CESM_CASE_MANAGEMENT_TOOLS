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
; read file and extract 1920
;************************************************

fixit = (/"so2_surf","soag_1.5_surf","bc_surf","num_a1_surf","num_a2_surf","oc_surf","so4_a1_surf","so4_a2_surf"/)

do f = 0, dimsizes(fixit)-1

if (fixit(f) .eq. "soag_1.5_surf") then
  ifile = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_"+fixit(f)+"_1850-2005_c100429.nc"
  foutname = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_"+fixit(f)+"_1920_c100429_170830.nc"
; foutname = "ar5_mam3_"+fixit(f)+"_1920_c100429_170830.nc"
else
  ifile = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_"+fixit(f)+"_1850-2005_c090804.nc"
  foutname = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/ar5_mam3_"+fixit(f)+"_1920_c090804_170830.nc"
; foutname = "ar5_mam3_"+fixit(f)+"_1920_c090804_170830.nc"
end if

; system("rm "+foutname)          ; delete file if it already exists
; fout = addfile( foutname ,"c")

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
if (in1_vars(i) .eq."lat" .or. in1_vars(i) .eq."lon") then
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
else
	if (in1_vars(i) .eq."date") then
		fout->$in1_vars(i)$ = in1->$in1_vars(i)$(96:107)
	else
		fout->$in1_vars(i)$ = in1->$in1_vars(i)$(96:107,:,:) 
	end if
end if


end do
end if

delete([/ifile,foutname,fout,in1_vars,in1_global/])

end do


end
