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

;************************************************
; read in PD Volc file and extend the zeros into the future.
;************************************************

  sname = get_script_name()

  ifile1 = "/glade2/scratch2/nanr/archive/b.e11.B20TRLENS_RCP85.f09_g16.xghg.006/ocn/hist/b.e11.B20TRLENS_RCP85.f09_g16.xghg.006.pop.h.1920-02.nc"
  ifile2 = "/glade2/scratch2/nanr/archive/b.e11.B20TRLENS_RCP85.f09_g16.xghg.006/ocn/hist/b.e11.B20TRLENS_RCP85.f09_g16.xghg.006.pop.h.2005-02.nc"

  var = "ATM_CO2"

  i1 = addfile(ifile1,"r")
  i2 = addfile(ifile2,"r")

  p1 = i1->ATM_CO2
  p2 = i2->ATM_CO2

  d = p2 - p1
printMinMax(d,0)


end
