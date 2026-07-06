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

; GHG
  pd1 = "co2flux_fossil_1751-2006-monthly_0.9x1.25_c20100204.nc"
  pd2 = "co2flux_fossil_RCP85_2005-2100-monthly_0.9x1.25_c20101013.nc"


  ifile1 = "/glade/p/cesm/cseg/inputdata/atm/cam/ggas/" + pd1
  ifile2 = "/glade/p/cesm/cseg/inputdata/atm/cam/ggas/" + pd2
  ifile3 = "/glade/u/home/nanr/ccp/DecadalPrediction/forcing/inputdata/atm/cam/ggas/co2flux_fossil_RCP85_monthly_0.9x1.25_19500115-20351215_c150715.nc"
  ofile  = "valid_co2flux_fossil_RCP85_monthly_0.9x1.25_19500115-20351215_c150715"

  pds = 2389
  pde = 3072
  nrecs = pde-pds+1
  fus = 25
  fue = 372
  nyrs = nrecs / 12.


;************************************************
  src_file1    = addfile(ifile1,"r")
  src_file2    = addfile(ifile2,"r")
  dst_file     = addfile(ifile3,"r")

;************************************************
    usevar = "CO2_flux"
    ivar1   =    src_file1->$usevar$(pds:pde,:,:)
    ivar2   =    src_file2->$usevar$(fus:fue,:,:)
    ivar3   =    dst_file->$usevar$
    time    =    dst_file->time
    date    =    dst_file->date
    lat     =    dst_file->lat
    nlat    =    dimsizes(lat)

    usetime = doubletoint(time / 365.)
    tmp = floattoint(date * 0.0001)
    fyr = tmp(0)
    lyr = tmp(dimsizes(tmp)-1)

    ; calculate global weights
    gw   = latGauWgt(nlat, "lat", "gaussian weights", "")

    ; create global weighted areal averages
    avgvar1 = wgt_areaave(ivar1,gw,1.0,0)
    avgvar2 = wgt_areaave(ivar2,gw,1.0,0)
    avgvar3 = wgt_areaave(ivar3,gw,1.0,0)


    a1 = month_to_annual(avgvar1,1)
    a2 = month_to_annual(avgvar2,1)
    a3 = month_to_annual(avgvar3,1)

    rav1 = runave_Wrap(a1,5,0)
    rav2 = runave_Wrap(a2,5,0)
    rav3 = runave_Wrap(a3,5,0)

    tt  = dimsizes(rav3)

    newvar = new((/3,tt/),"double")

    iyrs = floattoint(nyrs)

    newvar(0,0:iyrs-1) = rav1
    newvar(1,iyrs:)    = rav2
    newvar(2,:) = rav3

    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
    wks = gsn_open_wks("ps",ofile)

    res = True
    res@tiMainString  = "Compare forcing"
    res@tiYAxisString = usevar
    res@xyLineThicknesses = (/1.0,2.0,1.0/)               ; make 2nd lines thicker
    res@xyLineColors      = (/"blue","red","green"/)          ; change line color

    res@pmLegendDisplayMode    = "Always"            ; turn on legend
    res@pmLegendSide           = "Top"               ; Change location of 
    res@pmLegendParallelPosF   = .5                  ; move units right
    res@pmLegendOrthogonalPosF = -0.5                ; move units down
    res@lgPerimOn              = False               ; turn off box around
    res@lgLabelFontHeightF     = 0.73                 ; label font height
    res@xyExplicitLegendLabels = (/"20th","RCP85","StitchedForcing"/)         ; create explicit labels

    res@tiXAxisString = "time"
    tvec = ispan(fyr,lyr,1)
    plot = gsn_xy(wks, tvec,newvar,res)

end
