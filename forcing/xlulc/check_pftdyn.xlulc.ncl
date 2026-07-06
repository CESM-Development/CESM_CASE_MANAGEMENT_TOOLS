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
  sy = 1915	; (65)	pad the file from 1915-2020
  uy = 1920	; (70)	1920 is the year we will repeat
  ey = 2020

  ifile = "/glade/p/cesmdata/cseg/inputdata/lnd/clm2/surfdata/surfdata.pftdyn_0.9x1.25_simyr1850-2005_c091008.nc"
  tfile = "/glade/p/cesmdata/cseg/inputdata/lnd/clm2/surfdata/surfdata.pftdyn_0.9x1.25_rcp2.6_simyr1850-2100_c100323.nc"
  ofile = "surfdata.pftdyn_0.9x1.25_simyr1920-2020_"+dd+".nc"

  pds =  70		;     19150115,   // date(782)
  pde = 170		;     19150115,   // date(782)


;************************************************
  src_file1     = addfile(ifile,"r")
  t1            = src_file1->time(pds)
  p1            = src_file1->PCT_PFT(pds,:,:,:)
  src_file2     = addfile(tfile,"r")
  t2            = src_file2->time(pds)
  t22           = src_file2->time(pde)
  p2            = src_file2->PCT_PFT(pds,:,:,:)

  diff = p1 
  diff = p1 - p2
  printMinMax(diff,0)
  print(t2)
  print(t22)


    global    = True
    global@separator1= "------- SOURCE FILE ATTRIBUTES --------"
    copy_VarAtts(src_file1, global)
    global@separator2= "------- SOURCE FILE ATTRIBUTES --------"

    global@separator3= "------- File Modifications --------"
    global@src           = "File created by nanr, using ncl script: " + sname + " to create a 1920-constant lulc forcing file."
    global@creation_date = systemfunc("date")
    global@separator4= "------- File Modifications--------"

    fileattdef( ofile, global )        ; copy file attributes to netCDF file


    ofile->MMRVOLC = newvolc
    ofile->date    = newdate
    ofile->utime   = (/newtime/)
    ofile->datesec = newdsec
    ofile->colmass = newcolm



end
