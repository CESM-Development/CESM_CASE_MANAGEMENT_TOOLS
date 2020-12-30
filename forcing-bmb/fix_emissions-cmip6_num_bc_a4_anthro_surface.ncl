;*************************************************
; 
; october 2019 - DAMIP
; author:  nanr
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;************************************************
begin

   dd = systemfunc("date -u +%Y%m%d")

  fixit = (/"num_bc_a4_anthro"/)


  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_bc_a4_anthro_surface_1750-2015_0.9x1.25_c20170608.nc"
  foutname = "./emissions_1850_cyclical/emissions-cmip6_num_bc_a4_anthro_surface_1850cycling_0.9x1.25_c"+dd+".nc"

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

sname = get_script_name()

    global    = True
    global@separator2= "------- End Modifications--------"
    ;copy_VarAtts(ifile, global)
    global@script    = sname 
    global@revisions    = "nanr"
    global@creation_date = systemfunc("date")
    global@project   = "CESM2-LE-SF"
    global@description   = "File modified to create continuous 1850 conditions for CESM2-LE-SF"
    global@src_file           = ifile
    global@separator1= "------- Start Modifications --------"

    fileattdef( fout, global )        ; copy file attributes to netCDF file

; NOTE:
;   18491216,   // date(1200)
;   18500116,   // date(1201)
;   18500216,   // date(1202)
;   18500316,   // date(1203)
;   18500416,   // date(1204)
;   18500516,   // date(1205)
;   18500616,   // date(1206)
;   18500716,   // date(1207)
;   18500816,   // date(1208)
;   18500916,   // date(1209)
;   18501016,   // date(1210)
;   18501116,   // date(1211)
;   18501216,   // date(1212)


;   20131216,   // date(3168)
;   20140116,   // date(3169)
;   20140216,   // date(3170)
;   20140316,   // date(3171)
;   20140416,   // date(3172)
;   20140516,   // date(3173)
;   20140616,   // date(3174)
;   20140716,   // date(3175)
;   20140816,   // date(3176)
;   20140916,   // date(3177)
;   20141016,   // date(3178)
;   20141116,   // date(3179)
;   20141216,   // date(3180)




; 1850
t1=1200
t2=1211

; 2100
t11=3168
t22=3179	

r0=0
r1=12
r2=23

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
print("invars = " + in1_vars)
print("fixing = " + in1_vars(i))
if (in1_vars(i) .eq. fixit(0) ) then
	tmp  = in1->$in1_vars(i)$
	; create variable with 2 years worth of space
	nvar = tmp(r0:r2,:,:)
	nvar = 0.
	ctr=0
        do r=0,1
		ss = ctr
		ee = ctr+11
		; fill all values with the year 1850 data
		nvar(ss:ee,:,:) = tmp(t1:t2,:,:)
		ctr = ctr + 12
        end do
        ; nvar(23,:,:) = tmp(12,:,:)
	fout->$fixit$ = nvar
        delete([/tmp,nvar/])
else 
   if (in1_vars(i) .eq. "date" .or. in1_vars(i) .eq. "time") then
        tmp  = in1->$in1_vars(i)$
        time = in1->time
        tvar = tmp(r0:r2)
        tvar = 0
        tvar(0:11)  = tmp(t1:t2)
        ntime = new((/24/),typeof(time))
        ntime(0:11) = time(t1:t2)
        print(in1_vars(i))
        tvar(12:23)  = tmp(t11:t22)
        ntime(12:23) = time(t11:t22)
        print(tvar)
        print("tvar = " + tvar)
	ntime!0="time"
	ntime&time=ntime
	tvar&time = ntime

	fout->$in1_vars(i)$    = tvar
	delete([/tvar,tmp/])
    else 
	fout->$in1_vars(i)$ = in1->$in1_vars(i)$ 
    end if
end if

end do
end if


delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
