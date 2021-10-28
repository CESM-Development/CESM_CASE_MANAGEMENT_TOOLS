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

  fixit = (/"contvolcano"/)

  ifile    = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_a1_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc"
  foutname = "/glade/work/nanr/cmip6/DAMIP/hist-aer/inputdata/atm/cam/chem/emis/CMIP6_emissions_1850_cyclical/emissions-cmip6_num_a1_so4_contvolcano_vertical_1850cycling_0.9x1.25_c"+dd+".nc"

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

		; NOTE:

		; using the second set of 12 values 
 		; date = 8500115,   // date(1)
    		; 8500215,   // date(2)
    		; 8500315,   // date(3)
    		; 8500415,   // date(4)
    		; 8500515,   // date(5)
    		; 8500615,   // date(6)
    		; 8500715,   // date(7)
    		; 8500815,   // date(8)
    		; 8500915,   // date(9)
    		; 8501015,   // date(10)
    		; 8501115,   // date(11)
    		; 8501215,   // date(12)
    		; 18500115,   // date(13)
    		; 18500215,   // date(14)
    		; 18500315,   // date(15)
    		; 18500415,   // date(16)
    		; 18500515,   // date(17)
    		; 18500615,   // date(18)
    		; 18500715,   // date(19)
    		; 18500815,   // date(20)
    		; 18500915,   // date(21)
    		; 18501015,   // date(22)
    		; 18501115,   // date(23)
    		; 18501215,   // date(24)

		;   20100115,   // date(61)
;   20100215,   // date(62)
;   20100315,   // date(63)
;   20100415,   // date(64)
;   20100515,   // date(65)
;   20100615,   // date(66)
;   20100715,   // date(67)
;   20100815,   // date(68)
;   20100915,   // date(69)
;   20101015,   // date(70)
;   20101115,   // date(71)
;   20101215,   // date(72)


r0=0
r1=12
r2=23
r3=72
r4=83
; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq. fixit) then
	tmp  = in1->$in1_vars(i)$
	nvar = tmp(0:23,:,:,:)
	nvar = 0.
	ctr=0
        do r=0,1
		ss = ctr
		ee = ctr+11

		nvar(ss:ee,:,:,:) = tmp(12:23,:,:,:)
		ctr = ctr + 12
        end do
        nvar(23,:,:,:) = tmp(12,:,:,:)
        delete([/tmp/])
else if (in1_vars(i) .eq. "PS") then
	tmp = in1->$in1_vars(i)$
	wvar = tmp(0:23,:,:)
	wvar = 0.
        ctr=0
        do r=0,1
                ss = ctr
                ee = ctr+11
                wvar(ss:ee,:,:) = tmp(12:23,:,:)
                ctr = ctr + 12
        end do
        wvar(23,:,:) = tmp(12,:,:)
        fout->$in1_vars(i)$ = wvar
        printMinMax(wvar,0)
        delete([/wvar,tmp/])

else 
   if (in1_vars(i) .eq. "date" .or. in1_vars(i) .eq. "time") then
        tmp  = in1->$in1_vars(i)$
        time = in1->time
        tvar = tmp(r0:r2)
        tvar = 0
        tvar(0:11)  = tmp(r0:r1-1)
        ntime = new((/24/),typeof(time))
        ntime(0:11) = time(r0:r1-1)
        print(in1_vars(i))
        tvar(12:23)  = tmp(r3:r4)
        ntime(12:23) = time(r3:r4)
        print(tvar)
        print("tvar = " + tvar)
        if(in1_vars(i) .eq. "time") then
                delete(tvar)
        end if
        delete([/tmp/])

else

	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
end if
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

delete([/tvar,nvar/])


delete([/ifile,foutname,fout,in1_vars,in1_global/])

end
