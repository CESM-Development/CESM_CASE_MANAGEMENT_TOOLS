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


i1 = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1849-2100_c140822.nc"
i2 = "/glade/p/cesmdata/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/aerocom_mam3_dms_surf_1849-2300_c120214.nc"
ofile = "dms_diff"



;************************************************
  src_file1    = addfile(i1,"r")
  src_file2    = addfile(i2,"r")

;************************************************
    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
;************************************************
    wks = gsn_open_wks("ps",ofile)
    usevar  = "DMS"
    ivar1   =    src_file1->$usevar$
    ivar2   =    src_file2->$usevar$
    date    =    src_file1->date
    lat     =    src_file1->lat
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

    a1 = new((/2,24/),"float")
    a1(0,:) = avgvar1
    a1(1,:) = avgvar2

    res = True
    res@tiMainString    = "DMS"
    res@xyLineThicknesses = (/1.0,1.0/)               ; make 2nd lines thicker
    res@xyLineColors      = (/"blue","red"/)

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
  res@pmLegendParallelPosF   = .2                  ; move units right
  res@pmLegendOrthogonalPosF = -0.5                ; move units down
  res@pmLegendWidthF         = 0.15                ; Change width and
  res@pmLegendHeightF        = 0.10                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = .04                 ; label font height
  res@xyExplicitLegendLabels = (/"120214","140822"/)

    newdate = ispan(0,23,1)
    res@tiXAxisString = "time"
    plot = gsn_xy(wks, newdate,a1,res)

end
