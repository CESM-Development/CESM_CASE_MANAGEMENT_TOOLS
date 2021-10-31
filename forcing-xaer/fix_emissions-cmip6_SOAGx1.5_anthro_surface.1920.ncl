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

  fixit = (/"emiss_anthro"/)

;;;  =============================
;;;  =============================
; extract the date/time for 2100 
  idatefile    =  "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ag-ship_surface_mol_175001-210101_0.9x1.25_c20200924.nc"
  idt = addfile(idatefile,"r")

   usedate = idt->date
   usetime = idt->time

   ; 2100
   t11=3288
   t22=3299

;;;  =============================
;;;  =============================



  ; ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_SOAGx1.5_anthro_surface_1750-2015_0.9x1.25_c20170608.nc"
  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SOAGx1.5_anthro_surface_mol_175001-210101_0.9x1.25_c20200403.nc"
  foutname = "./emissions_1920_cyclical/emissions-cmip6_SOAGx1.5_anthro_surface_1920cycling_0.9x1.25_c"+dd+".nc"

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
    global@description   = "File modified to create continuous 1920 conditions for CESM2-LE-SF"
    global@src_file           = ifile
    global@separator1= "------- Start Modifications --------"

    fileattdef( fout, global )        ; copy file attributes to netCDF file

; NOTE:
;   19190116,   // date(2029)
;   19190216,   // date(2030)
;   19190316,   // date(2031)
;   19190416,   // date(2032)
;   19190516,   // date(2033)
;   19190616,   // date(2034)
;   19190716,   // date(2035)
;   19190816,   // date(2036)
;   19190916,   // date(2037)
;   19191016,   // date(2038)
;   19191116,   // date(2039)
;   19191216,   // date(2040)
;   19200116,   // date(2041)
;   19200216,   // date(2042)
;   19200316,   // date(2043)
;   19200416,   // date(2044)
;   19200516,   // date(2045)
;   19200616,   // date(2046)
;   19200716,   // date(2047)
;   19200816,   // date(2048)
;   19200916,   // date(2049)
;   19201016,   // date(2050)
;   19201116,   // date(2051)

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

; 1919 for date/time to get the model to run
year1=2028
year2=2039

; 1920 for data
t1=2040
t2=2051

; 2100
t11=3288
t22=3299        


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
		; fill all values with the year 1920 data
		nvar(ss:ee,:,:) = tmp(t1:t2,:,:)
		ctr = ctr + 12
        end do
        ; nvar(23,:,:) = tmp(12,:,:)
	fout->$fixit$ = nvar
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
        tvar(12:23)  = usedate(t11:t22)
        ntime(12:23) = usetime(t11:t22)
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
