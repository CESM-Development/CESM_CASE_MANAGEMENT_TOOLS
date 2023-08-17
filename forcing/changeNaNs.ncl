
;-----------------------------------------------------------
;  Calculate spatial EOF / PC pairs, and save to data file
;
;  Assumes data has dimensions (time, lat, lon)
;-----------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;-------------------
;  USER DEFINED
;-------------------

 ifile = "/glade/work/whokim/cesm_forcing/NAO_forcing/WISHBONE/SHF_SPNA_DJFM_NAO_2X_forcing_ERA5_to_TL319_t13.nc"
 ofile = "SHF_SPNA_DJFM_NAO_2X_forcing_ERA5_to_TL319_t13_zeros.nc"


;------------------------------------------
;  Get files and variables
;------------------------------------------

;setfileoption("nc","format","netcdf4")
in1 = addfile(ifile,"r")
if(isfilepresent(ofile)) then
      system("rm "+ofile)
end if
fout = addfile(ofile,"c")
in1_global= getvaratts(in1)
in1_vars = getfilevarnames(in1)
; copy global attributes
if (.not.all(ismissing(in1_global))) then
        do i = 0, dimsizes(in1_global) - 1
                ; print("copy_fileatts: global attributes->" + in1_global(i) )
                fout@$in1_global(i)$ = in1@$in1_global(i)$
        end do
end if

; copy variables
valid_types = (/"integer","float","double"/)
do i = 0, dimsizes(in1_vars) - 1
		print("starting to process :: " + in1_vars(i))
        		y = in1->$in1_vars(i)$
  			if(any(typeof(y).eq.valid_types)) then
			print("Now I am processing :: " + in1_vars(i))
				printVarSummary(y)
				printMinMax(y,0)
				xmsg = default_fillvalue(typeof(y))
				y@_FillValue = xmsg
                                y = where(ismissing(y),0,y)
				printMinMax(y,0)
				delete(xmsg)
			end if
        		fout->$in1_vars(i)$ = y
			delete(y)
end do


end
