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

doThis = 4

if (doThis .eq. 1) then
  ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_oc_surf_19100115-21000115_xaer_c170914.nc"
  ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_oc_surf_19100115-21000115_c170901.nc"
  f1 = addfile(ifile1,"r")
  f2 = addfile(ifile2,"r")
  p1 = f1->emiss_ind
  p2 = f2->emiss_ind
end if

if (doThis .eq. 2) then
  ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a1_surf_19100115-21000115_xaer_c170914.nc"
  ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a1_surf_19100115-21000115_c170901.nc"
  f1 = addfile(ifile1,"r")
  f2 = addfile(ifile2,"r")
  p1 = f1->BC_emiss_wst
  p2 = f2->BC_emiss_wst
end if


if (doThis .eq. 3) then
  ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a2_surf_19100115-21000115_xaer_c170914.nc"
  ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_num_a2_surf_19100115-21000115_c170901.nc"
  f1 = addfile(ifile1,"r")
  f2 = addfile(ifile2,"r")
  p1 = f1->SO4_emiss_tra
  p2 = f2->SO4_emiss_tra
end if

if (doThis .eq. 4) then
  ifile1 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_surf_19100115-21000115_xaer_c170919.nc"
  ifile2 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/RCP85_mam3_so2_surf_19100115-21000115_c170901.nc"
  f1 = addfile(ifile1,"r")
  f2 = addfile(ifile2,"r")
  p1 = f1->emiss_wst
  p2 = f2->emiss_wst
end if

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
;rintMinMax(d,0)


end
