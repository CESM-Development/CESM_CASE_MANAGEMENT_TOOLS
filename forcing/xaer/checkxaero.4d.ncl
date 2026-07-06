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

; ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_elev_19100115-21000115_xaer_c170913.nc"
; ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_elev_19100115-21000115_c170901.nc"
; f1 = addfile(ifile1,"r")
; f2 = addfile(ifile2,"r")

  ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a1_elev_19100115-21000115_xaer_c170917.nc"
  ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so4_a1_elev_19100115-21000115_c170901.nc"
  f1 = addfile(ifile1,"r")
  f2 = addfile(ifile2,"r")

  p1 = f1->emiss_ene(:,0,:,:)
  p2 = f2->emiss_ene(:,0,:,:)

  lat   = f1->lat
  lon   = f1->lon

  jlat  = dimsizes( lat )

  rad    = 4.0*atan(1.0)/180.0
  re     = 6371220.0
  rr     = re*rad

  clat   = cos(lat*rad)

  gp1 = wgt_areaave(p1, clat, 1.0, 1)
  gp2 = wgt_areaave(p2, clat, 1.0, 1)

print("p1 = " + gp1 + " -- p2 = " + gp2)

; d = p2 - p1
;printMinMax(d,0)


end
