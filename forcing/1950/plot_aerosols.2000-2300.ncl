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



ifiles1 = (/"ar5_mam3_so2_elev_1850-2005_c090804.nc",\
           "ar5_mam3_bc_elev_1850-2005_c090804.nc",\
           "ar5_mam3_num_a1_elev_1850-2005_c090804.nc",\
           "ar5_mam3_num_a2_elev_1850-2005_c090804.nc",\
           "ar5_mam3_oc_elev_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a1_elev_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a2_elev_1850-2005_c090804.nc",\
           "ar5_mam3_so2_surf_1850-2005_c090804.nc",\
           "ar5_mam3_soag_1.5_surf_1850-2005_c100429.nc",\
           "ar5_mam3_bc_surf_1850-2005_c090804.nc",\
           "ar5_mam3_num_a1_surf_1850-2005_c090804.nc",\
           "ar5_mam3_num_a2_surf_1850-2005_c090804.nc",\
           "ar5_mam3_oc_surf_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a1_surf_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a2_surf_1850-2005_c090804.nc"/)

ifiles3 = (/"RCP85_mam3_so2_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_bc_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a1_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a2_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_oc_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a1_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a2_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_so2_surf_2000-2300_c20120214.nc",\
           "RCP85_soag_1.5_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_bc_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a1_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a2_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_oc_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a1_surf_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a2_surf_2000-2300_c20120214.nc"/)

ifiles2 = (/"RCP85_mam3_so2_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_bc_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_num_a1_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_num_a2_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_oc_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_so4_a1_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_so4_a2_elev_2000-2100_c20110913.nc",\
           "RCP85_mam3_so2_surf_2000-2100_c20110913.nc",\
           "RCP85_soag_1.5_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_bc_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_num_a1_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_num_a2_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_oc_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_so4_a1_surf_2000-2100_c20110913.nc",\
           "RCP85_mam3_so4_a2_surf_2000-2100_c20110913.nc"/)

ofiles = (/"valid_RCP85_mam3_so2_elev_19400115-2300_c200716",\	
           "valid_RCP85_mam3_bc_elev_19400115-2300_c200716",\
           "valid_RCP85_mam3_num_a1_elev_19400115-2300_c200716",\   
           "valid_RCP85_mam3_num_a2_elev_19400115-2300_c200716",\   
           "valid_RCP85_mam3_oc_elev_19400115-2300_c200716",\
           "valid_RCP85_mam3_so4_a1_elev_19400115-2300_c200716",\   
           "valid_RCP85_mam3_so4_a2_elev_19400115-2300_c200716",\
           "valid_RCP85_mam3_so2_surf_19400115-2300_c200716",\  
           "valid_RCP85_soag_1.5_surf_19400115-2300_c200716",\
           "valid_RCP85_mam3_bc_surf_19400115-2300_c200716",\
           "valid_RCP85_mam3_num_a1_surf_19400115-2300_c200716",\   
           "valid_RCP85_mam3_num_a2_surf_19400115-2300_c200716",\  
           "valid_RCP85_mam3_oc_surf_19400115-2300_c200716",\
           "valid_RCP85_mam3_so4_a1_surf_19400115-2300_c200716",\	
           "valid_RCP85_mam3_so4_a2_surf_19400115-2300_c200716"/)  

vars = (/"grassfire",\
           "grassfire",\
           "SO4_grassfire",\
           "SO4_contvolc",\
           "grassfire",\
           "grassfire",\
           "contvolc",\
           "emiss_awb",\
           "SOAG_TERPENE",\
           "emiss_awb",\
           "BC_emiss_awb",\
           "SO4_emiss_dom",\
           "emiss_awb",\
           "emiss_awb",\
           "emiss_dom"/)

nvars = 15
do c = 0, nvars-1

print("c = " + c + " ... processing file:  " + ifiles3(c))
  ifile1 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles1(c)
  ifile2 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles2(c)
  ifile3 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles3(c)
  ofile  = ofiles(c)

  pds = 132		; if starting at 1950
  pds = 120		; if starting at 1940
  pde = 215
  nrecs = pde-pds+1
  fus = 12
  nyrs = nrecs / 12.
;print(nyrs)


;************************************************
  src_file1    = addfile(ifile1,"r")
  src_file2    = addfile(ifile2,"r")
  dst_file     = addfile(ifile3,"r")

;************************************************
    usevar = vars(c)
if (c .lt. 7)
    ivar1   =    src_file1->$usevar$(pds:pde,0,:,:)
    ivar2   =    src_file2->$usevar$(fus:,0,:,:)
    ivar3   =    dst_file->$usevar$(fus:,0,:,:)
else
    ivar1   =    src_file1->$usevar$(pds:pde,:,:)
    ivar2   =    src_file2->$usevar$(fus:,:,:)
    ivar3   =    dst_file->$usevar$(fus:,:,:)
end if
    sdate   =    src_file1->date(pds:pde)
    date    =    dst_file->date(24:)
    lat     =    dst_file->lat
    nlat    =    dimsizes(lat)

    indate  = floattoint( date * 0.0001)
    sindate = floattoint(sdate * 0.0001)

    fyr = indate(0)
    sfyr = sindate(0)
    lyr = indate(dimsizes(indate)-1)
    syrs = floattoint(dimsizes(sindate)/ 12.)
    nyrs = floattoint(dimsizes( indate)/ 12.)
    tyrs = floattoint((dimsizes(indate) + dimsizes(sindate))/ 12.)
 ;print("fyr = " + indate(0) )
 ;print("sfyr = " + sindate(0) )
 ;print(" nyrs = " + nyrs)
 ;print(" lyr = " + lyr)

    ; calculate global weights
    gw   = latGauWgt(nlat, "lat", "gaussian weights", "")

    ; create global weighted areal averages
    avgvar1 = wgt_areaave(ivar1,gw,1.0,0)
    avgvar2 = wgt_areaave(ivar2,gw,1.0,0)
    avgvar3 = wgt_areaave(ivar3,gw,1.0,0)
; printVarSummary(avgvar1)
; printVarSummary(avgvar2)
; printVarSummary(avgvar3)


    a1 = month_to_annual(avgvar1,1)
    a2 = month_to_annual(avgvar2,1)
    a3 = month_to_annual(avgvar3,1)
; printVarSummary(a1)
; printVarSummary(a2)
; printVarSummary(a3)
;exit

    rav1 = a1
    rav2 = a2
    rav3 = a3

    ; two points of the forcing overlap, 2005 and 2006
    tt  = dimsizes(rav3) + dimsizes(rav1) - 1

    iyrs = floattoint(tyrs)

    newvar  = new((/3,tt/),"double")
    newdate = new((/iyrs/),"integer")

    rec = 0
    do year = 0,syrs-1
	print("sindate(rec) = " + year + " -- " + sindate(rec))
	newdate(year) = sindate(rec)
	rec = rec + 12
    end do
    rec = 0
    do year = syrs,tyrs-1
	print("indate(rec) = " + year + " -- " + indate(rec))
	newdate(year) = indate(rec)
	rec = rec + 12
    end do
print("Newdate = " + newdate)
print("rav1 = " + rav1)
print("=====")
print("=====")
print(rav2)
print("=====")
print(rav3)
print("=====")
;exit
    d12 = dimsizes(rav1)+dimsizes(rav2)
    d13 = dimsizes(rav1)+dimsizes(rav3)
    newvar(0,0:dimsizes(rav1)-1) = rav1
    newvar(1,dimsizes(rav1)-1:d12-2) = rav2
    newvar(2,dimsizes(rav1)-1:d13-2) = rav3
print("Newvar = " + newvar)
print("Newdate = " + newdate)

    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
    wks = gsn_open_wks("ps",ofile)

    res = True
    res@tiMainString  = "Compare forcing"
    res@tiYAxisString = usevar
    res@xyLineThicknesses = (/1.0,2.0,1.0/)               ; make 2nd lines thicker
    res@xyLineColors      = (/"blue","red","green"/)          ; change line color
    res@xyMarkers      = (/6,6,16/)
    res@xyMarkLineMode  = "MarkLines"


    res@pmLegendDisplayMode    = "Always"            ; turn on legend
    res@pmLegendSide           = "Top"               ; Change location of 
    res@pmLegendParallelPosF   = .5                  ; move units right
    res@pmLegendOrthogonalPosF = -0.5                ; move units down
    res@lgPerimOn              = False               ; turn off box around
    res@lgLabelFontHeightF     = 0.73                 ; label font height
    res@xyExplicitLegendLabels = (/"20th","2100","2300"/)         ; create explicit labels

    res@tiXAxisString = "time"
    ; tvec = ispan(fyr,lyr,1)
    ; plot = gsn_xy(wks, tvec,newvar,res)
    plot = gsn_xy(wks, newdate,newvar,res)

    delete([/rav1,rav2,rav3,newvar,a1,a2,a3,avgvar1,avgvar2,avgvar3,plot,ivar1,ivar2,ivar3/])

end do
end
