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

  fixit = (/"oxid"/)

  ifile    = "/glade/work/nanr/cmip6/ihesp-HiRes/inputdata/atm/cam/chem/trop_mozart_aero/oxid/oxid_rcp85_v1_1.9x2.5_L26_19450115-20551215_c190517.nc"
  foutname = "/glade/work/nanr/cmip6/ihesp-HiRes/inputdata/atm/cam/chem/trop_mozart_aero/oxid/oxid_rcp85_v1_1.9x2.5_L26_1950_c190517.nc"

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
fout@$in1_global(i)$ = in1@$in1_global(i)$
end do
end if
fout@comment = "nanr:  averaging years 1945+1955 to create values for 1950 (" + systemfunc("pwd") + get_script_name() + ")"


; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq."date" .or. in1_vars(i) .eq."datesec" .or. in1_vars(i) .eq. "time")then
	dtmp = in1->$in1_vars(i)$(0:11)
        if (in1_vars(i) .eq."date" ) then
		dtmp(0)  = 19500115
		dtmp(1)  = 19500215
		dtmp(2)  = 19500315
		dtmp(3)  = 19500415
		dtmp(4)  = 19500515
		dtmp(5)  = 19500615
		dtmp(6)  = 19500715
		dtmp(7)  = 19500815
		dtmp(8)  = 19500915
		dtmp(9)  = 19501015
		dtmp(10) = 19501115
		dtmp(11) = 19501215
	end if
        if (in1_vars(i) .eq."time" ) then
		do m = 0, 12 - 1
			dtmp(m)  = dtmp(m) + 1825.
		end do
	end if
	print("writing out mods" + dtmp)
	dtmp&time=dtmp
	fout->$in1_vars(i)$ = dtmp
	delete(dtmp)
else
if (in1_vars(i) .eq."PS")then
	tmp  = in1->$in1_vars(i)$(0:23,:,:)
	otmp = tmp(0:11,:,:)
	do m = 0, 12 - 1
		otmp(m,:,:) = (tmp(m,:,:) + tmp(m+12,:,:)) / 2
	end do
	fout->$in1_vars(i)$ = otmp
	delete([/tmp,otmp/])
else
if (in1_vars(i) .eq."H2O2" .or. in1_vars(i) .eq."HO2" .or. in1_vars(i) .eq."NO3" .or. in1_vars(i) .eq."OH" .or. in1_vars(i) .eq."O3")then
	tmp  = in1->$in1_vars(i)$(0:23,:,:,:)
	;otmp = dim_avg_Wrap(tmp(lev|:,lat|:,lon|:,time|:))
	otmp = tmp(0:11,:,:,:)
	do m = 0, 12 - 1
		otmp(m,:,:,:) = (tmp(m,:,:,:) + tmp(m+12,:,:,:)) / 2
	end do
	fout->$in1_vars(i)$ = otmp
	delete([/tmp,otmp/])
else
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
end if
end if
end if

end do
end if

delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
