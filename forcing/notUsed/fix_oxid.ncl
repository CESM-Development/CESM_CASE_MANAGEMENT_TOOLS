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
; read in PD Volc file and extend the zeros into the future.
;************************************************

; ifile = addfile("oxid_1.9x2.5_L26_1915_c091123_170829.nc","r")
; ofile = addfile("oxid_1.9x2.5_L26_1920_c091123_170829.nc","c")

ifile = "oxid_1.9x2.5_L26_1915_c091123_170829.nc"
fout = addfile("/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/oxid/oxid_1.9x2.5_L26_1920_c091123_170829.nc","c")

; idate = ifile->date
; odate = idate + 50000

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
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$ + 50000
else
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
	print("writing var ->" + in1_vars(i) )
end if
end do
end if

end
