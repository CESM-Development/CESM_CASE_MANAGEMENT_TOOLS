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

  fixit = (/"bc_surf"/)

  ifile    = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_"+fixit(0)+"_19100115-21000115_c170919.nc"
  foutname = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/xrmd/RCP85_mam3_"+fixit(0)+"_19100115-21000115_xrmd_c"+dd+".nc"

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
if (in1_vars(i) .eq."date"  .or. in1_vars(i) .eq."lat" .or. in1_vars(i) .eq."lon") then
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
else
	tmp  = in1->$in1_vars(i)$
	nvar = tmp
	nvar = 0.
	ctr=0
        do r=0,19
		ss = ctr
		ee = ctr+11
		nvar(ss:ee,:,:) = tmp(12:23,:,:)
		ctr = ctr + 12
        end do
        nvar(240,:,:) = tmp(12,:,:)
	fout->$in1_vars(i)$ = nvar
	delete(tmp)
end if
end do
end if

delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
