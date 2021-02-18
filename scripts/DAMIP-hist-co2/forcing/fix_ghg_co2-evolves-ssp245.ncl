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

  sname = get_script_name()

  fixit = (/"CO2_LBC"/)

  src_file1    = "/glade/p/cesmdata/cseg/inputdata/atm/waccm/lb/LBC_2014-2500_CMIP6_SSP245_0p5degLat_GlobAnnAvg_c190301.nc"
  foutname = "LBC_2014-2500_CMIP6_SSP245_0p5degLat_GlobAnnAvg_fixed-CH4-N2O-CFCs-with-co2-evolving_c"+dd+".nc"
  ;foutname = "/glade/work/nanr/cmip6/DAMIP/hist-co2/inputdata/atm/waccm/lb/LBC_2014-2500_CMIP6_SSP245_0p5degLat_GlobAnnAvg_fixed-CH4-N2O-CFCs-with-co2-evolving_c"+dd+".nc"

  system("rm "+foutname)          ; delete file if it already exists
  dst_file = addfile( foutname ,"c")

print("fixing file = " + foutname)

in1 = addfile(src_file1,"r")
in1_global= getvaratts(in1)
in1_vars = getfilevarnames(in1)

    global    = True
    copy_VarAtts(src_file1, global)
    global@separator2= "------- File Modifications --------"
    global@src = "Modified by nanr, using ncl script: " + sname + ": to allow CO2 to evolve while other GHGs are held constant at 1850 values"
    global@creation_date = systemfunc("date")
    global@separator3= "------- File Modifications--------"

    fileattdef( dst_file, global )        ; copy file attributes to netCDF file

;copy global attributes
 if (.not.all(ismissing(in1_global))) then
 do i = 0, dimsizes(in1_global) - 1
 print("copy_fileatts: global attributes->" + in1_global(i) )
 dst_file@$in1_global(i) $ = in1@$in1_global(i)$
 end do
 end if


itime = in1->time
filedimdef(dst_file,"time",-1,True)

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq. "N2O_LBC" .or. in1_vars(i) .eq. "CH4_LBC" .or. in1_vars(i) .eq. "CFC11eq_LBC" .or. in1_vars(i) .eq. "CF2CL2_LBC" )
      ; set values equal to year 1850
      if (in1_vars(i) .eq. "N2O_LBC" )
                tmp  = in1->$in1_vars(i)$
                nvar = tmp
                nvar = 0.
                print("var = " + in1_vars(i))
                do y=0,dimsizes(itime)-1
                        nvar(y,:) = 275.68e-9
                end do
                dst_file->$in1_vars(i)$ = nvar
                delete([/tmp,nvar/])
      end if
      if (in1_vars(i) .eq. "CH4_LBC" )
                tmp  = in1->$in1_vars(i)$
                nvar = tmp
                nvar = 0.
                print("var = " + in1_vars(i))
                do y=0,dimsizes(itime)-1
                        nvar(y,:) = 791.6e-9
                end do
                dst_file->$in1_vars(i)$ = nvar
                delete([/tmp,nvar/])
      end if
      if (in1_vars(i) .eq. "CFC11eq_LBC" )
                tmp  = in1->$in1_vars(i)$
                nvar = tmp
                nvar = 0.
                print("var = " + in1_vars(i))
                do y=0,dimsizes(itime)-1
                        nvar(y,:) = 12.48e-12
                end do
                dst_file->$in1_vars(i)$ = nvar
                delete([/tmp,nvar/])
      end if
      if (in1_vars(i) .eq. "CFC12eq_LBC" )
                tmp  = in1->$in1_vars(i)$
                nvar = tmp
                nvar = 0.
                print("var = " + in1_vars(i))
                do y=0,dimsizes(itime)-1
                        nvar(y,:) = 0.0
                end do
                dst_file->$in1_vars(i)$ = nvar
                delete([/tmp,nvar/])
        end if
else
	; copy GHG from in1 2015-2100 to new file
	dst_file->$in1_vars(i)$ = in1->$in1_vars(i)$
end if
end do
end if

end
