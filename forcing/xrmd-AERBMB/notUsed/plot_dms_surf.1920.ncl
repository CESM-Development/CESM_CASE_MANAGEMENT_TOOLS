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
  pd1 = "aerocom_mam3_dms_surf_1849-2006_c090804.nc"
  pd2 = "aerocom_mam3_dms_surf_1920_c090804_c180129.nc"


  ifile1 = "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + pd1
  ifile3 = "/glade/p/cesm/cvwg/inputdata/atm/cam/chem/trop_mozart_aero/emis/" + pd2
  ofile  = "valid_mam3_dms_surf_1920_c090804_c181029"

  ifile4 =   "/glade/p/cesm/cseg/inputdata/atm/cam/chem/trop_mozart_aero/oxid/oxid_rcp85_v1_1.9x2.5_L26_1920_c190517.nc"

  pds = 0
  pde = 23
  nrecs = pde-pds+1
  nyrs = nrecs / 12.


;************************************************
  src_file1    = addfile(ifile1,"r")
  dst_file     = addfile(ifile3,"r")
  gw_file      = addfile(ifile4,"r")

;************************************************
    usevar = "DMS"
    ivar1   =    src_file1->$usevar$(pds:pde,:,:)
    ivar3   =    dst_file->$usevar$(:,:,:)
    date    =    dst_file->date
    lat     =    dst_file->lat
    nlat    =    dimsizes(lat)

    indate = floattoint(date * 0.0001)
    fyr = indate(0)
    lyr = indate(dimsizes(indate)-1)
    nyrs = floattoint(dimsizes(indate) / 12.)

    ; calculate global weights
    ; gw   = latGauWgt(nlat, "lat", "gaussian weights", "")
    gw   =    gw_file->gw

    ; create global weighted areal averages
    avgvar1 = wgt_areaave(ivar1,gw,1.0,0)
    avgvar3 = wgt_areaave(ivar3,gw,1.0,0)


    a1    = avgvar3
    a3    = avgvar3

    newdate = new((/12/),"integer")
    do m = 0,11
    	a1(m) = (avgvar1(m) + avgvar1(m+12)) / 2
	newdate(m) = m+1
    end do

    rav1 = a1
    rav3 = a3

    tt  = dimsizes(rav3)

    newvar  = new((/2,tt/),"double")
    
    newvar(0,0:dimsizes(rav1)-1) = rav1
    newvar(1,:) = rav3

    if(isfilepresent(ofile)) then
       system("rm "+ofile)
    end if
    wks = gsn_open_wks("ps",ofile)

    res = True
    res@tiMainString  = "Compare forcing"
    res@tiYAxisString = usevar
    res@xyLineThicknesses = (/1.0,1.0/)               ; make 2nd lines thicker
    res@xyLineColors      = (/"blue","green"/)          ; change line color
    res@xyMarkers      = (/6,16/)
    res@xyMarkLineMode  = "MarkLines"

    res@pmLegendDisplayMode    = "Always"            ; turn on legend
    res@pmLegendSide           = "Top"               ; Change location of 
    res@pmLegendParallelPosF   = .5                  ; move units right
    res@pmLegendOrthogonalPosF = -0.5                ; move units down
    res@lgPerimOn              = False               ; turn off box around
    res@lgLabelFontHeightF     = 0.73                 ; label font height
    res@xyExplicitLegendLabels = (/"1849-2006","1950"/)

    res@tiXAxisString = "month"
    ; tvec = ispan(fyr,lyr,1)
    ; plot = gsn_xy(wks, tvec,newvar,res)
    plot = gsn_xy(wks, newdate,newvar,res)

end
