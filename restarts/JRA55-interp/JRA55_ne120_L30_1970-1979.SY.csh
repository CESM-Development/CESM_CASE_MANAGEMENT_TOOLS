#! /bin/tcsh -vx
##
##----------------------------- PBS deck -------------------------------------------
##
#PBS -l walltime=06:00:00
#PBS -A CESM0021
#PBS -q htc
#PBS -l select=1:ncpus=1
#PBS -N regrid
#PBS -r n
#PBS -j oe
##
##----------------------------------------------------------------------------------
##

set echo

setenv CASE                JRA55_ne120_L30
setenv TOOLDIR             /glade/p/cesm/espwg/JRA55_regridded_to_CAM/tools
setenv MYTMPDIR            /glade/scratch/$LOGNAME/inputIC_${CASE}
#setenv MYTMPDIRO           /glade/scratch/$LOGNAME/tmp_workdir.$$
setenv MYTMPDIRO           /glade/scratch/$LOGNAME/tmp_workdir
setenv ARCHIVE_DIR         /glade/scratch/$LOGNAME/analyses_output_ne120
setenv ANALYSIS_REPOSITORY /gpfs/fs1/collections/rda/data/ds628.0

mkdir -p $MYTMPDIR
mkdir -p $MYTMPDIRO
mkdir -p $ARCHIVE_DIR
cd       $MYTMPDIRO
#cp    -p $TOOLDIR/regrid_dir/* .  || goto end0
WRAPIT MAKEIC.stub MAKEIC.f90          || goto end0

# Reference date to put on output file (YYYYMMDD)

setenv REF_DATE     19580101

# Years/Months

setenv YEAR_START            1979
setenv YEAR_END              1979
setenv MONTH_START              1
setenv MONTH_END               12

setenv DYCORE                  se       # Dycore ("eul", "fv", or "se" are the current choices)
setenv PRECISION            float       # "double" or "float" are the current choices of output precision
setenv PTRM                    -1       # "M" spectral truncation (for "eul" dycore only; ignored for other dycores; "-1" = no trunc)
setenv PTRN                    -1       # "N" spectral truncation (for "eul" dycore only; ignored for other dycores; "-1" = no trunc)
setenv PTRK                    -1       # "K" spectral truncation (for "eul" dycore only; ignored for other dycores; "-1" = no trunc)
setenv PLAT                   192       # Number of latitudes  on output IC file (ignored for unstructured grids)
setenv PLON                   288       # Number of longitudes on output IC file (ignored for unstructured grids)
setenv CAM_UNSTRUCT_NCOLS   48602       # CAM-SE output resolution (1   deg; Ignored for lat/lon grids)
setenv CAM_UNSTRUCT_NCOLS  777602       # CAM-SE output resolution (1/4 deg; Ignored for lat/lon grids)
setenv PLEV                    30       # Number of vert levs on output IC file
                                        # (if PLEV = 0, no vertical dimension in output file)
setenv BIN_FACTOR_SMOOTHING    64       # Smoothed by way of expanded bin boxes (> 1 ==> level of smoothing (typical range: 4-100))
setenv BIN_FACTOR_SMOOTHING    -1       # Smoothed by way of expanded bin boxes (< 1 ==> automatic smoothing (recommended - only done
                                        # when regridding from coarse to fine grids))
setenv BIN_FACTOR_SMOOTHING     1       # Smoothed by way of expanded bin boxes (= 1 ==> no smoothing)

# Full input file pathname  (disk or HPSS) from which to pull hyai, hybi, hyam, hybm info to define OUTPUT levels
# (must be a CAM file or a file with level info in CAM format)

setenv FNAME_lev_info           $TOOLDIR/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001.cam.i.1982-01-01-00000.nc

@ YEAR  = ${YEAR_START}

while(${YEAR} <= ${YEAR_END})

  @ MONTH  = ${MONTH_START}

  while(${MONTH} <= ${MONTH_END})

    setenv YEAR_STR               ${YEAR}
    setenv MONTH_STR              ${MONTH}
    if($MONTH < 10) then
      setenv MONTH_STR 0${MONTH}
    endif

# Full input file pathnames (disk or HPSS) from which to pull fields to be regridded
# (up to 6 files)

#echo `${ANALYSIS_REPOSITORY}/anl_surf/${YEAR_STR}/anl_surf.001_pres.reg_tl319.${YEAR_STR}${MONTH_STR}01*
#exit

    setenv FNAME0         ${ANALYSIS_REPOSITORY}/anl_mdl/${YEAR_STR}/anl_mdl.033_ugrd.reg_tl319.${YEAR_STR}${MONTH_STR}0100_${YEAR_STR}${MONTH_STR}1018
    setenv FNAME1         ${ANALYSIS_REPOSITORY}/anl_mdl/${YEAR_STR}/anl_mdl.034_vgrd.reg_tl319.${YEAR_STR}${MONTH_STR}0100_${YEAR_STR}${MONTH_STR}1018
    setenv FNAME2         ${ANALYSIS_REPOSITORY}/anl_mdl/${YEAR_STR}/anl_mdl.011_tmp.reg_tl319.${YEAR_STR}${MONTH_STR}0100_${YEAR_STR}${MONTH_STR}1018
    setenv FNAME3         ${ANALYSIS_REPOSITORY}/anl_mdl/${YEAR_STR}/anl_mdl.051_spfh.reg_tl319.${YEAR_STR}${MONTH_STR}0100_${YEAR_STR}${MONTH_STR}1018
    #setenv FNAME4         `ls ${ANALYSIS_REPOSITORY}/anl_surf/${YEAR_STR}/anl_surf.001_pres.reg_tl319.${YEAR_STR}${MONTH_STR}01*`
    setenv FNAME4         ${ANALYSIS_REPOSITORY}/anl_surf/${YEAR_STR}/anl_surf.001_pres.reg_tl319.${YEAR_STR}010100_${YEAR_STR}123118
    setenv FNAME5         $TOOLDIR/PHIS_model_and_JRA55_analysis_ne120.nc

# Regrid ALL fields from FNAME0, if it is a CAM file (otherwise, just regrid the fields listed below)

    setenv REGRID_ALL     False

# Time slice to pull from each file (YYYYMMDDSSSSS or time index (0, 1, 2, 3, etc.))
    setenv DATE_CUR       ${YEAR_STR}${MONTH_STR}0100000
    setenv FDATE          ${DATE_CUR},${DATE_CUR},${DATE_CUR},${DATE_CUR},${DATE_CUR},0

# List of fields to be regridded (must contain, at minimum, U, V [or US and VS, if fv dycore], T, Q, and PS)
# PHIS from the native analysis and PHIS from the output grid must be read in to adjust the state variables based on
# topography differences.

    setenv FIELDS         U,V,T,Q,PS,PHIS_analysis,PHIS

# Input analysis file index in which each field can be found (0, 1, 2, 3, 4, or 5)

    setenv SOURCE_FILES   0,1,2,3,4,5,5

## Input file type (The "FTYPE" list maps to the above list of filenames)

##---------------------------------------------------------------------------------
## Current input file types:    CAM
##                              YOTC_PS_Z
##                              YOTC_sfc
##                              YOTC_sfc_fcst
##                              YOTC_sh
##                              ECMWF_gg
##                              ECMWF_sh
##                              NASA_MERRA
##                              NASA_MERRA_PREVOCA
##                              NASA_YOTC
##                              JRA_25
##                              JRA_55
##                              Era_Interim_627.0_sc
##                              ERA40_ds117.2
##                              ECMWF_DYNAMO
##                              ECMWF_IFS_L137
##                              ERA5_630.0
##---------------------------------------------------------------------------------

    setenv FTYPE          JRA_55,JRA_55,JRA_55,JRA_55,JRA_55,CAM

# Processing options

    setenv VORT_DIV_TO_UV False     # U/V determined from vort/div input
    setenv OUTPUT_PHIS    True      # Copy output PHIS to the output initial file.
    setenv ATM_FILE_OUT   $CASE.cam2.i.${YEAR_STR}-${MONTH_STR}-01-00000.nc
    setenv FNAME          $FNAME0,$FNAME1,$FNAME2,$FNAME3,$FNAME4,$FNAME5

    /bin/rm done
    ncl ./makeIC.ncl                              || goto end0
    if ( !(-e done) )                                goto end0

    /bin/mv $MYTMPDIRO/$ATM_FILE_OUT $ARCHIVE_DIR || goto end0

    @ MONTH = ${MONTH} + 1
  end 

  @ YEAR = ${YEAR} + 1
end 

end0:

exit
