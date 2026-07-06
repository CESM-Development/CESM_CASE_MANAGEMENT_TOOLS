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
  pd1 = "oxid_1.9x2.5_L26_1850-2005_c091123.nc"
  pd2 = "oxid_rcp85_v1_1.9x2.5_L26_1995-2105_c100202.nc"


  ifile1 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/oxid/" + pd1
  ifile2 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/oxid/" + pd2
  ifile3 = "/glade/u/home/nanr/ccp/DecadalPrediction/forcing/inputdata/atm/cam/chem/trop_mozart_aero/oxid/oxid_rcp85_v1_1.9x2.5_L26_19450115-20351215_c150715.nc"
  ofile  = "valid_oxid_rcp85_v1_1.9x2.5_L26_19450115-20351215_c150715"

  pds = 120
  pde = 215
  nrecs = pde-pds+1
  fus = 48
  fue = 83
  nyrs = nrecs / 12.


;************************************************
  src_file1    = addfile(ifile1,"r")
  src_file2    = addfile(ifile2,"r")
  dst_file     = addfile(ifile3,"r")

;************************************************
    usevar = "NO3"
    ivar1   =    src_file1->$usevar$(pds:pde,0,:,:)
    ivar2   =    src_file2->$usevar$(fus:fue,0,:,:)
    ivar3   =    dst_file->$usevar$(:,0,:,:)
    time    =    dst_file->time
    date    =    dst_file->date
    lat     =    dst_file->lat
    nlat    =    dimsizes(lat)

    indate = floattoint(date * 0.0001)
    fyr = indate(0)
    lyr = indate(dimsizes(indate)-1)
    nyrs = floattoint(dimsizes(indate) / 12.)

    ; calculate global weights
    ; gw   = latGauWgt(nlat, "lat", "gaussian weights", "")
    gw   =    dst_file->gw

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

    tt  = dimsizes(rav3)

    iyrs = floattoint(nyrs)
    ; iyrs = nyrs

    newvar  = new((/3,tt/),"double")
    newdate = new((/iyrs/),"integer")

    rec = 0
    do year = 0,iyrs-1
	newdate(year) = indate(rec)
	rec = rec + 12
    end do
print(indate)
print(newdate)


printVarSummary(rav1)
    newvar(0,0:dimsizes(rav1)-1) = rav1
    newvar(1,dimsizes(rav1):)    = rav2
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
    ; tvec = ispan(fyr,lyr,1)
    ; plot = gsn_xy(wks, tvec,newvar,res)
    plot = gsn_xy(wks, newdate,newvar,res)

end
