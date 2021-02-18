;====================================================================
; reads a CAM sst climo file, modifies a selected variable,
; and writes out a new CCSM sst climo file with mods included 
; see string "MODIFICATIONS", to find where to insert your modfications
; cshields, sep 03

; Code reads in standard CAM boundary condition forcing file, and substitutes the
; long-term average values for TS (-273.15) in place of SST_cpl and ICEFRAC values for 
; ice_cpl.

; adapted by nanr to read multi-year records and modify the time and/or date stamp
; 5jan2012 modified from:  sst_cami_create_100212.ncl

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;==========================================================

begin

dd = systemfunc("date -u +%y%m%d")

ifile = "/glade/p/cesmdata/cseg/inputdata/atm/waccm/lb/LBC_1750-2015_CMIP6_GlobAnnAvg_c180926.nc"
fo = "LBC_1750-2015_CMIP6_GlobAnnAvg_co2_evolving_c"+dd+".nc"

grabdate = 100

nvals = 266

in1  = addfile(ifile,"r")

system("rm "+fo)
fout = addfile(fo, "c")

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
if (in1_vars(i) .eq. "CO2"  .or. in1_vars(i) .eq."lat" .or. in1_vars(i) .eq."lon"  .or. \
    in1_vars(i) .eq."time" .or. in1_vars(i) .eq."date") then
        fout->$in1_vars(i)$ = in1->$in1_vars(i)$
else
        tmp  = in1->$in1_vars(i)$
        nvar = tmp
        nvar = 0.
        ctr=0
        do r=0,nvals-1
                nvar(r,:) = tmp(100,:)
        end do
        fout->$in1_vars(i)$ = nvar
        delete([/tmp,nvar/])
end if

end do
end if

sname = get_script_name()

    global    = True
    global@revised  = "File created by nanr, using ncl script: " + sname + "."
    global@creation_date = systemfunc("date")
    global@history= "------- Revised for DAMIP to create evolving GHG + constant 1850 values for remainder of GHGs--------"

    fileattdef( fout, global )        ; copy file attributes to netCDF file





end 
