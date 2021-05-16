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

  fixit = (/"num_a1_elev"/)

  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1849-2300_c120214.nc"
  foutname = "/glade/scratch/nanr/2090/RCP85_mam3_dms_surf_2090const_c"+dd+".nc"

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
if ( in1_vars(i) .eq."DMS" ) then
	tmp  = in1->$in1_vars(i)$
	fout->$in1_vars(i)$ = tmp(0:11,:,:)
	delete(tmp)
elseif ( in1_vars(i) .eq."date" ) then
	tmp  = in1->$in1_vars(i)$
        ndate = tmp(0:11)
        ndate(0)  = 20900116
        ndate(1)  = 20900214
        ndate(2)  = 20900316
        ndate(3)  = 20900415
        ndate(4)  = 20900516
        ndate(5)  = 20900615
        ndate(6)  = 20900716
        ndate(7)  = 20900816
        ndate(8)  = 20900915
        ndate(9)  = 20901016
        ndate(10) = 20901115
        ndate(11) = 20901216
	fout->$in1_vars(i)$ = ndate
	delete(tmp)
else
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
end if


end do
end if

delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
