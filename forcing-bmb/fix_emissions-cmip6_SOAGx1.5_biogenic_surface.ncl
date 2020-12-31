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

   dd = systemfunc("date -u +%y%m%d")

  fixit = (/"emiss_biogenic"/)

; extract the date/time for 2100 
  idatefile    =  "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ag-ship_surface_mol_175001-210101_0.9x1.25_c20200924.nc"
  idt = addfile(idatefile,"r")
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

   usedate = idt->date
   usetime = idt->time


;;;  =============================
;;;  =============================

  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_SOAGx1.5_biogenic_surface_1750-2015_0.9x1.25_c20170322.nc"
  foutname = "./emissions_1850_cyclical/emissions-cmip6_SOAGx1.5_biogenic_surface_1850cycling_0.9x1.25_c"+dd+".nc"

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

; NOTE
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


r0 = 1188
; 1850 data
r1 = 1200
r2 = 1211
; 2100
r3 = 3288
r4 = 3299

; 1850 time/date
t1 = 1188
t2 = 1199
; 2100 time/date
t11=3288
t22=3299

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq. fixit) then
	tmp  = in1->$in1_vars(i)$
	nvar = tmp(r0:r2,:,:)
	nvar = 0.
	ctr=0
        do r=0,1
		ss = ctr
		ee = ctr+11

		nvar(ss:ee,:,:) = tmp(r1:r2,:,:)
		ctr = ctr + 12

        end do
        nvar(23,:,:) = tmp(r2,:,:)
else 
   if (in1_vars(i) .eq. "date" .or. in1_vars(i) .eq. "time") then
	tmp = in1->$in1_vars(i)$
	time = in1->time
	tvar = tmp(r0:r2)
	tvar = 0
        tvar(0:11)  = tmp(t1:t2)
        ntime = new((/24/),typeof(time))
	ntime(0:11) = time(t1:t2)
	print(in1_vars(i))
	; print(tmp(r1:r2))
	; print(tmp(r3:r4))
        tvar(12:23)  = usedate(r3:r4)
	ntime(12:23) = usetime(r3:r4)
	print(tvar)
       delete([/tmp/])
	print("tvar = " + tvar)
	if(in1_vars(i) .eq. "time") then
		delete(tvar)
	end if
else

	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
end if
end if

end do
end if


ntime!0="time"
ntime&time=ntime

nvar&time = ntime
tvar&time = ntime
printVarSummary(nvar)
fout->$fixit$ = nvar
fout->date    = tvar
;fout->time    = ntime

delete([/tvar,nvar,tmp/])



delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
