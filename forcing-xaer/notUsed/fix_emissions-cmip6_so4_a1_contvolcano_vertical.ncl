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

  fixit = (/"contvolcano","PS"/)

; first extract the date/time for 2100 
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

   ; 2100
   t11=3288
   t22=3299

;;;  =============================
;;;  =============================


  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_so4_a1_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc"
  foutname = "./emissions_1850_cyclical/emissions-cmip6_so4_a1_contvolcano_vertical_1850cycling_0.9x1.25_c"+dd+".nc"

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
;   8501215,   // date(12)
;  18500115,   // date(13)

;   20051015,   // date(58)
;   20051115,   // date(59)
;   20051215,   // date(60)
;   20100115,   // date(61)
;   20100215,   // date(62)
;   20100315,   // date(63)
;  ....
;   20101115,   // date(71)
;   20101215,   // date(72)
;   50000115,   // date(73)
;   50000215,   // date(74)
; ....
;   50001115,   // date(83)
;   50001215;  // date(84)


; 1849 for date/time to get the model to run
; year1=1188
; year2=1199

; 1850 
; year1=1200
; year2=1199
year1=12
year2=23

; 1850 for data
t1=12
t2=23

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
	nvar = tmp(r0:r2,:,:,:)
	nvar = 0.
	ctr=0
        do r=0,1
		ss = ctr
		ee = ctr+11
		; fill all values with the year 1850 data
		nvar(ss:ee,:,:,:) = tmp(t1:t2,:,:,:)
		ctr = ctr + 12
        end do
        ; nvar(23,:,:,:) = tmp(12,:,:,:)
	printVarSummary(nvar)
	fout->$fixit(0)$ = nvar
        delete([/tmp,nvar/])
else 
	if (in1_vars(i) .eq. fixit(1) ) then
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
		;print("What's the problem here ;; i = " + i +"   " + fixit(i))
		printVarSummary(nvar)
		fout->$fixit(1)$ = nvar
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
end if

end do
end if


delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
