;*************************************************
; 
; 24oct2021
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

ifiles1 = (/"emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a2_anthro-res_surface_mol_175001-210101_0.9x1.25_c20200924.nc",\
           "emissions-cmip6_num_a2_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc",\
           "emissions-cmip6_SO2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc",\
           "emissions-cmip6_so4_a1_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc",\
           "emissions-cmip6_so4_a2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc"/)

ifiles3 = (/"emissions-cmip6_num_so4_a2_anthro-res_surface_1920cycling_0.9x1.25_c20211024.nc",\
           "emissions-cmip6_num_a2_so4_contvolcano_vertical_1850cycling_0.9x1.25_c191116.nc",\
           "emissions-cmip6_SO2_contvolcano_vertical_1850cycling_0.9x1.25_c191116.nc",\
           "emissions-cmip6_so4_a1_contvolcano_vertical_1850cycling_0.9x1.25_c191116.nc",\
           "emissions-cmip6_so4_a2_contvolcano_vertical_1850cycling_0.9x1.25_c191116.nc"/)



ofiles = (/"valid_anthro.ps"/)

;names   = (/"CH4_elev","num_a1_so4","num_a2_so4","SO2_contvolc","so4_a1_anthro","so4_a1_contvolc","so4_a2_contvolc"/)
;names   = (/"num_a1_so4","num_a2_so4","SO2_contvolc","so4_a1_anthro","so4_a1_contvolc","so4_a2_contvolc"/)
names   = (/"emiss_res_tran","num_a2_so4","SO2_contvolc","so4_a1_anthro","so4_a1_contvolc","so4_a2_contvolc"/)



nfiles = 5
nfiles = 1
do c = 0, nfiles-1

print("c = " + c + " ... processing file:  " + ifiles3(c))
  ifile1 = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/" + ifiles1(c)
  ifile3 = "emissions_1920_cyclical/" + ifiles3(c)
  ofile  = ofiles(c)

  pds =  2028
  pde = 3299
  nrecs = pde-pds+1
  nyrs = nrecs / 12.

;************************************************
  src_file1    = addfile(ifile1,"r")
  dst_file     = addfile(ifile3,"r")

;************************************************
    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
;************************************************
  wks = gsn_open_wks("ps",ofile)
  if (c .eq. 0) then
    fvars = "emiss_res_tran"
  end if

    nvars = dimsizes(fvars)
    plot = new(nvars,graphic)
do v = 0, nvars-1
    usevar = fvars(v)
    print("usevar = " + usevar)
    ivar1   =    src_file1->$usevar$(pds:pde,:,:)
    ivar3   =    dst_file->$usevar$(0:23,:,:)
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
    avgvar3 = wgt_areaave(ivar3,gw,1.0,0)

    a1 = month_to_annual(avgvar1,1)
    a3 = month_to_annual(avgvar3,1)

    rav1 = a1
    rav3 = a3

    tt   = dimsizes(rav1) 
    iyrs = floattoint(nyrs2)

    newvar  = new((/2,tt/),"double")
    newdate = new((/iyrs/),"integer")

    rec = 0
    do year = 0,iyrs-1
	newdate(year) = indate(rec)
	rec = rec + 12
    end do
    newvar(0,0:dimsizes(rav1)-1) = rav1
    newvar(1,:dimsizes(rav3)-1) = rav3

    print(dimsizes(rav1))
    print(dimsizes(rav3))

    res = True
    res@gsnDraw		= False
    res@gsnFrame        = False
    res@tiMainString    = usevar
    res@xyMarkLineMode = "MarkLines"               ; Markers *and* lines
    res@xyLineThicknesses = (/1.0,2.0/)               ; make 2nd lines thicker
    res@xyMarkers      = (/0,16/)
    res@xyLineColors      = (/"blue","red"/)          ; change line color
    res@xyMarkerThicknesses = (/8.0,4.0/)               ; make 2nd lines thicker

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   = .2                  ; move units right
  res@pmLegendOrthogonalPosF = -0.5                ; move units down
  res@pmLegendWidthF         = 0.25                ; Change width and
  res@pmLegendHeightF        = 0.10                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .08                 ; label font height
  res@xyExplicitLegendLabels = (/"CMIP6","1920constant"/)         ; create explicit labels

    res@tiXAxisString = "time"
    plot(v) = gsn_xy(wks, newdate,newvar,res)

    ; delete([/indate,date,rav1,rav2,rav3,newvar,a1,a2,a3,avgvar1,avgvar2,avgvar3,ivar1,ivar2,ivar3/])

end do		; fvars loop
;************************************************
; create panel
;************************************************
  resP                     = True                ; modify the panel plot
                                                 ; new resource added in NCL V6.4.0
  resP@gsnPanelMainString = names(c)
                                                 ; use this for NCL V6.3.0 and earlier
  resP@lbLabelFontHeightF  = 0.07               ; make labels smaller
    resP@xyExplicitLegendLabels = (/"CMIP6","1920constant"/)         ; create explicit labels
    if (c .ne. 2) then
    	nv = nvars/2 + 1
    	nv = nvars
    	gsn_panel(wks,plot,(/nv,2/),resP)
    else
    	gsn_panel(wks,plot,(/3,3/),resP)
    end if

    delete([/plot/])
end do		; file loop
end
