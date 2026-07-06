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
  sy = 1915
  ey = 2100

  ifile = "/glade/p/cesm/cseg/inputdata/atm/cam/volc/CCSM4_volcanic_1850-2008_prototype1.nc"
  ofile = "/glade/p/cesm/cvwg/inputdata/atm/cam/volc/CCSM4_volcanic_"+sy+"0115-"+ey+"1215_prototype1_c"+dd+".nc"
; ofile = "CCSM4_volcanic_"+sy+"0115-"+ey+"1215_prototype1_c"+dd+".nc"

; pds =  841		;     19200115,   // date(842)
  pds =  781		;     19150115,   // date(782)
  pde = 1908		;     20081215,   // date(1909)

nyrs = ey-sy+1
lyrs = ey-2009+1

dnt = (ey-2009+1)*12 



  nd = new((/dnt/),"double")
  nt = new((/dnt/),"float")
  nt!0 = "time"
  calyr   = 20090115
  ctr   = 0
  do y = 0,lyrs-1
        uyr = calyr+y*10000
        do m = 0,11
                nd(ctr) = uyr + 100*m
                nt(ctr) = 2009. + y + m/12.
                ctr = ctr + 1
        end do
  end do

  tottime = nyrs*12


;************************************************
  src_file     = addfile(ifile,"r")
  if(isfilepresent(ofile)) then
     system("rm "+ofile)
  end if
  dst_file     = addfile(ofile,"c")

;************************************************
    date   =    src_file->date(pds:pde)
    itime  =    src_file->time(pds:pde)
    lev    =    src_file->lev 
    lat    =    src_file->lat 
    volc   =    src_file->MMRVOLC(pds:pde,:,:)
    colm   =    src_file->colmass(pds:pde,:)
    dsec   =    src_file->datesec(pds:pde)

    newdate    = new((/tottime/),"double")
    newdsec    = new((/tottime/),"integer")
    newtime    = new((/tottime/),"float")
    newvolc    = new((/tottime,dimsizes(lev),dimsizes(lat)/),"double")
    newcolm    = new((/tottime,dimsizes(lat)/),"float")
 
    newtime!0 = "time"

    isize = dimsizes(date)
    newdsec(0:isize-1) = dsec
    newdsec(isize:)    = 0

    newcolm(0:isize-1,:) = colm
    newcolm(isize:,:)    = 0.0

    newvolc(0:isize-1,:,:) = volc
    newvolc(isize:,:,:)    = 0.0

    newdate(0:isize-1) = date
    newdate(isize:)    = (/nd/)

    ctr=0
    do y = 0,nyrs-1
        do m = 0,11
             ;  newtime(ctr) = 1920. + y + m/12.
                newtime(ctr) = 1915. + y + m/12.
                ctr = ctr + 1
        end do
    end do

    global    = True
    global@separator1= "------- SOURCE FILE ATTRIBUTES --------"
    copy_VarAtts(src_file, global)
    global@separator2= "------- SOURCE FILE ATTRIBUTES --------"

    global@separator3= "------- File Modifications --------"
    global@src           = "File created by nanr, using ncl script: " + sname + " to create a single volcanic forcing file for the decadal prediction simulations.  MMRVOLC values are set to zero from 2009-2100"
    global@creation_date = systemfunc("date")
    global@separator4= "------- File Modifications--------"

    fileattdef( dst_file, global )        ; copy file attributes to netCDF file


    dst_file->MMRVOLC = newvolc
    dst_file->date    = newdate
    dst_file->utime   = (/newtime/)
    dst_file->datesec = newdsec
    dst_file->colmass = newcolm
   

end
