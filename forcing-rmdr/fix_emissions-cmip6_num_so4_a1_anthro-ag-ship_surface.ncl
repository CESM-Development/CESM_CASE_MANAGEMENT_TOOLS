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

  fixit = (/"emiss_ag_sol_was","emiss_shipping"/)

  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a1_anthro-ag-ship_surface_mol_175001-210101_0.9x1.25_c20200924.nc";
  foutname = "./emissions_1850_cyclical/emissions-cmip6_num_so4_a1_anthro-ag-ship_surface_1850cycling_0.9x1.25_c"+dd+".nc"

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
;   18481216,   // date(1188)
;   18490116,   // date(1189)
;   18490216,   // date(1190)
;   18490316,   // date(1191)
;   18490416,   // date(1192)
;   18490516,   // date(1193)
;   18490616,   // date(1194)
;   18490716,   // date(1195)
;   18490816,   // date(1196)
;   18490916,   // date(1197)
;   18491016,   // date(1198)
;   18491116,   // date(1199)

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


;   20901216,   // date(3288)
;   21000116,   // date(3289)
;   21000215,   // date(3290)
;   21000316,   // date(3291)
;   21000416,   // date(3292)
;   21000516,   // date(3293)
;   21000616,   // date(3294)
;   21000716,   // date(3295)
;   21000816,   // date(3296)
;   21000916,   // date(3297)
;   21001016,   // date(3298)
;   21001116,   // date(3299)
;   21001216,   // date(3300)
;   21010116;  // date(3301)


; 1849 for date/time to get the model to run
year1=1188
year2=1199

; 1850 for data
t1=1200
t2=1211

; 2100
t11=3288
t22=3299	

r0=0
r1=12
r2=23
r3=72
r4=83

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
print("invars = " + in1_vars)
print("fixing = " + in1_vars(i))
;;  Use 1850 data
if (in1_vars(i) .eq. fixit(0) .or. in1_vars(i) .eq. fixit(1)) then
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
	fout->$in1_vars(i)$ = nvar
        delete([/tmp,nvar/])
else 
;;  Use 1849 date/time
   if (in1_vars(i) .eq. "date" .or. in1_vars(i) .eq. "time") then
        tmp  = in1->$in1_vars(i)$
        time = in1->time
        tvar = tmp(r0:r2)
        tvar = 0
        tvar(0:11)  = tmp(year1:year2)
        ntime = new((/24/),typeof(time))
        ntime(0:11) = time(year1:year2)
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
