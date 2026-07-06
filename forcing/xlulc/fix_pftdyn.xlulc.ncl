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
  sy = 1920	; (70)	1920 is the year we will repeat
  ey = 2020

  ifile = "/glade/p/cesm/cvwg/inputdata/lnd/clm2/surfdata/surfdata.pftdyn_0.9x1.25_simyr1920-forcing-2020_c180521.nc"
  ofile = "/glade/p/cesm/cvwg/inputdata/lnd/clm2/surfdata/xlulc/surfdata.pftdyn_0.9x1.25_simyr1920-2020.1920-constant_xlulc_c180521.nc"


;************************************************
  if(isfilepresent(ofile)) then
     system("rm "+ofile)
  end if
  fout     = addfile(ofile,"c")

;************************************************

in1 = addfile(ifile,"r")
in1_global= getvaratts(in1)
in1_vars = getfilevarnames(in1)
; copy global attributes
if (.not.all(ismissing(in1_global))) then
do i = 0, dimsizes(in1_global) - 1
print("copy_fileatts: global attributes->" + in1_global(i) )
fout@$in1_global(i) $ = in1@$in1_global(i)$
end do
end if

; copy variables
if (.not.all(ismissing(in1_vars))) then
do i = 0, dimsizes(in1_vars) - 1
if (in1_vars(i) .eq. "HARVEST_VH1" .or. in1_vars(i) .eq. "HARVEST_VH2" .or. \
    in1_vars(i) .eq. "HARVEST_SH1" .or. in1_vars(i) .eq. "HARVEST_SH2" .or. in1_vars(i) .eq. "HARVEST_SH3" .or. \
    in1_vars(i) .eq. "GRAZING") then
        tmp  = in1->$in1_vars(i)$
        nvar = tmp
	do y = 0,100
        nvar(y,:,:) = tmp(0,:,:)
	end do
        fout->$in1_vars(i)$ = nvar
        delete([/tmp,nvar/])
else if (in1_vars(i) .eq. "PCT_PFT") then
        	tmp  = in1->$in1_vars(i)$
        	nvar = tmp
		do y = 0,100
        	nvar(y,:,:,:) = tmp(0,:,:,:)
		end do
        	fout->$in1_vars(i)$ = nvar
        	delete([/tmp,nvar/])
	else
        	fout->$in1_vars(i)$ = in1->$in1_vars(i)$
	end if
end if


end do
end if


    global    = True
    global@separator1= "------- SOURCE FILE ATTRIBUTES --------"
    copy_VarAtts(in1, global)
    global@separator2= "------- SOURCE FILE ATTRIBUTES --------"

    global@separator3= "------- File Modifications --------"
    global@src           = "File created by nanr, using ncl script: " + sname + " to create a constant 1920 lulc forcing file."
    global@creation_date = systemfunc("date")
    global@separator4= "------- File Modifications--------"

    fileattdef( fout, global )        ; copy file attributes to netCDF file

   

end
