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
  sy = 1920
  ey = 2100

  ifile  = "/glade/p/cesm/cseg/inputdata/atm/cam/volc/CCSM4_volcanic_1850-2008_prototype1.nc"
  ifile2 = "/glade/p/cesm/cseg/inputdata/atm/cam/volc/CCSM4_volcanic_1949115-21010115_prototype1_c200319.nc"
  ofile  = "/glade/p/cesm/cvwg/inputdata/atm/cam/volc/CCSM4_volcanic_"+sy+"-"+ey+"_prototype1_c"+dd+".nc"
; ofile = "CCSM4_volcanic_"+sy+"0115-"+ey+"1215_prototype1_c"+dd+".nc"

 pds1920 =  841		;     19200115,   // date(842)
 pde1920 =  852		;     19201215,   // date(853)
  pds =  781		;     19150115,   // date(782)
  pds =  840		;     19191215,   // date(841)
  pde = 1909		;     20090115,   // date(1910)

; /glade/p/cesm/cseg/inputdata/atm/cam/volc/CCSM4_volcanic_1949115-21010115_prototype1_c200319.nc
; idate from second file to 2100
  src_file2     = addfile(ifile2,"r")
    pds2 = 722 		; 20090215,   // date(723)
    pde2 = 1825 	; 21010115;  // date(1826)
    date2   =    src_file2->date(pds2:pde2)

;************************************************
  src_file     = addfile(ifile,"r")
  if(isfilepresent(ofile)) then
     system("rm "+ofile)
  end if
  dst_file     = addfile(ofile,"c")

;************************************************
    date   =    src_file->date(pds:pde)
    d1 = dimsizes(date)
    d2 = dimsizes(date2)
    d3 = d1 + d2
    lev    =    src_file->lev 
    lat    =    src_file->lat 

    odate = new((/d3/),"double")
    otime = new((/d3/),"double")
    ovolc = new((/d3,dimsizes(lev),dimsizes(lat)/),"double")
    ocolm = new((/d3,dimsizes(lat)/),"float")
    odsec = new((/d3/),"integer")

    odate(0:d1-1)     =    src_file->date(pds:pde)
    odate(d1:)        =    src_file2->date(pds2:pde2)
    otime(0:d1-1)     =    src_file->time(pds:pde)
    otime(d1:)        =    src_file2->time(pds2:pde2)
    ovolc(0:d1-1,:,:) =    src_file->MMRVOLC(pds:pde,:,:)
    ocolm(0:d1-1,:)   =    src_file->colmass(pds:pde,:)
    odsec(0:d1-1)     =    src_file->datesec(pds:pde)
    odsec(d1:)        =    src_file2->datesec(pds2:pde2)

    ocolm(0,:)   = 0.0 ; set 1919-12 to 0  (first record is 1919-12)
    ocolm(13:,:) = 0.0 ; set everything after 1920 to zero

    ovolc(0,:,:)   = 0.0 ; set 1919-12 to 0  (first record is 1919-12)
    ovolc(13:,:,:) = 0.0 ; set everything after 1920 to zero

    global    = True
    global@separator1= "------- SOURCE FILE ATTRIBUTES --------"
    copy_VarAtts(src_file, global)
    global@separator2= "------- SOURCE FILE ATTRIBUTES --------"

    global@separator3= "------- File Modifications --------"
    global@src           = "File created by nanr, using ncl script: " + sname + " to create a single volcanic forcing file for the 1920 constant forcing NATL pacemaker simulations.  MMRVOLC values are set to zero after 1920 values"
    global@creation_date = systemfunc("date")
    global@separator4= "------- File Modifications--------"

    fileattdef( dst_file, global )        ; copy file attributes to netCDF file


    dst_file->MMRVOLC = ovolc
    dst_file->date    = odate
    dst_file->utime   = otime
    dst_file->datesec = odsec
    dst_file->colmass = ocolm
   

end
