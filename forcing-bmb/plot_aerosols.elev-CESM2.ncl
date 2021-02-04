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



ifiles1 = (/"
           "ar5_mam3_bc_elev_1850-2005_c090804.nc",\
           "ar5_mam3_num_a1_elev_1850-2005_c090804.nc",\
           "ar5_mam3_num_a2_elev_1850-2005_c090804.nc",\
           "ar5_mam3_oc_elev_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a1_elev_1850-2005_c090804.nc",\
           "ar5_mam3_so4_a2_elev_1850-2005_c090804.nc"/)

ifiles2 = (/"RCP85_mam3_so2_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_bc_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a1_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_num_a2_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_oc_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a1_elev_2000-2300_c20120214.nc",\
           "RCP85_mam3_so4_a2_elev_2000-2300_c20120214.nc"/)

ifiles3 = (/"emissions-cmip6_bc_a4_anthro_surface_1850cycling_0.9x1.25_c20201230.nc"

ofiles = (/"valid_bc_a4_anthro_surface.ps"/)

names   = (/"so2_elev","bc_elev","num_a1_elev","num_a2_elev","oc_elev","so4_a1_elev","so4_a2_elev"/)

so2   = (/"emiss_ag_sol_was"/)

bc    = (/"forestfire","grassfire"/)
oc    = (/"forestfire","grassfire"/)

na1   = (/"BC_forestfire","BC_grassfire","OC_grassfire","OC_forestfire",\
	  "SO4_contvolc","SO4_emiss_ene","SO4_emiss_ind","SO4_forestfire","SO4_grassfire"/)
na2   = (/"SO4_contvolc"/)



nfiles = 7
do c = 0, nfiles-1

print("c = " + c + " ... processing file:  " + ifiles3(c))
  ifile1 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles1(c)
  ifile2 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles2(c)
  ifile3 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + ifiles3(c)
  ofile  = ofiles(c)

  pds =  84
  pde = 215
  nrecs = pde-pds+1
  fus =  24
  fue = 143
  nyrs = nrecs / 12.
  sue = 239


;************************************************
  src_file1    = addfile(ifile1,"r")
  src_file2    = addfile(ifile2,"r")
  dst_file     = addfile(ifile3,"r")

;************************************************
    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
;************************************************
    wks = gsn_open_wks("ps",ofile)
  if (c .eq. 0) then
    fvars = so2
  end if
  if (c .eq. 1) then
    delete(fvars)
    fvars = bc
  end if
  if (c .eq. 2) then
    delete(fvars)
    fvars = na1
  end if
  if (c .eq. 3) then
    delete(fvars)
    fvars = na2
  end if
  if (c .eq. 4) then
    delete(fvars)
    fvars = oc
  end if
  if (c .eq. 5) then
    delete(fvars)
    fvars = so4a1
  end if
  if (c .eq. 6) then
    delete(fvars)
    fvars = so4a2
  end if
print("fvars = " + fvars)


    nvars = dimsizes(fvars)
    plot = new(nvars,graphic)
do v = 0, nvars-1
    usevar = fvars(v)
print("usevar = " + usevar)
if (c .lt. 7)
    ivar1   =    src_file1->$usevar$(pds:pde,0,:,:)
    ivar2   =    src_file2->$usevar$(fus:fue,0,:,:)
    ivar3   =    dst_file->$usevar$(:sue,0,:,:)
else
    ivar1   =    src_file1->$usevar$(pds:pde,:,:)
    ivar2   =    src_file2->$usevar$(fus:fue,:,:)
    ivar3   =    dst_file->$usevar$(:sue,:,:)
end if
    date    =    dst_file->date
    lat     =    dst_file->lat
    nlat    =    dimsizes(lat)


    indate = floattoint(date * 0.0001)

    fyr = indate(0)
    lyr = indate(dimsizes(indate)-1)
    nyrs2 = floattoint(dimsizes(indate) / 12.)

    ; calculate global weights
    gw   = latGauWgt(nlat, "lat", "gaussian weights", "")

    ; create global weighted areal averages
    avgvar1 = wgt_areaave(ivar1,gw,1.0,0)
    avgvar2 = wgt_areaave(ivar2,gw,1.0,0)
    avgvar3 = wgt_areaave(ivar3,gw,1.0,0)

   a1 = month_to_annual(avgvar1,1)
   a2 = month_to_annual(avgvar2,1)
   a3 = month_to_annual(avgvar3,1)

    rav1 = a1
    rav2 = a2
    rav3 = a3

    tt   = dimsizes(rav1) + dimsizes(rav2)
    ttt  = dimsizes(rav3)
    iyrs = floattoint(nyrs2)

    newvar  = new((/3,tt/),"double")
    newdate = new((/iyrs/),"integer")

    rec = 0
    do year = 0,iyrs-1
	newdate(year) = indate(rec)
	rec = rec + 12
    end do
    newvar(0,0:dimsizes(rav1)-1) = rav1
    newvar(1,dimsizes(rav1):)    = rav2
    newvar(2,:dimsizes(rav3)-1) = rav3

    res = True
    res@gsnDraw		= False
    res@gsnFrame        = False
    res@tiMainString    = usevar
    res@xyLineThicknesses = (/1.0,1.0,2.0/)               ; make 2nd lines thicker
    res@xyLineColors      = (/"blue","black","red"/)          ; change line color

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   = .2                  ; move units right
  res@pmLegendOrthogonalPosF = -0.5                ; move units down
  res@pmLegendWidthF         = 0.15                ; Change width and
  res@pmLegendHeightF        = 0.10                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .04                 ; label font height
  res@xyExplicitLegendLabels = (/"20TH","RCP85","LENS-SF"/)         ; create explicit labels

    res@tiXAxisString = "time"
    plot(v) = gsn_xy(wks, newdate,newvar,res)

    delete([/indate,date,rav1,rav2,rav3,newvar,a1,a2,a3,avgvar1,avgvar2,avgvar3,ivar1,ivar2,ivar3/])

end do		; fvars loop
;************************************************
; create panel
;************************************************
  resP                     = True                ; modify the panel plot
                                                 ; new resource added in NCL V6.4.0
  resP@gsnPanelMainString = names(c)
                                                 ; use this for NCL V6.3.0 and earlier
  resP@lbLabelFontHeightF  = 0.007               ; make labels smaller
    resP@xyExplicitLegendLabels = (/"20th","RCP85","StitchedForcing"/)         ; create explicit labels
    if (c .ne. 2) then
    	nv = nvars/2 + 1
    	gsn_panel(wks,plot,(/nv,2/),resP)
    else
    	gsn_panel(wks,plot,(/3,3/),resP)
    end if

    delete([/plot/])
end do		; file loop
end
