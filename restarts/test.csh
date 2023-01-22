#! /bin/csh -fxv 

#  We are only doing Nov. 1 starts for HR DP. The dates to run are:
#  1982, 1984, 1986, 1988, 1990, 1992, 1994
#  That's 7 start dates. After we finish these, we'll decide whether to do 1980 or 1996 as the 8th start date.

set mach = frontera
set mach = cheyenne
if ($mach == "cheyenne") then
	set SCRATCH = /glade/scratch/nanr/
        set atmdir  = /glade/p/cesm/espwg/JRA55_regridded_to_CAM/ne120_L30/
	set ocnpath = /glade/campaign/collections/cmip/CMIP6/iHESP/FOSI/HR/
	#set ocnpath = /glade/scratch/nanr/archive/
	#set ocnpath = /glade/scratch/fredc/archive/g.e21.GIAF.TL319_t13.5thCyc.ice.001/rest/0269-11-01-00000
        #set restdir = /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/1982-01-01-00000/
        #set lndpath = /glade/scratch/jedwards/
        set lndpath = /glade/scratch/nanr/archive/
	#set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.001
	#set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.1990-05-01.001
	set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.rerun-gen-restarts.001
else
	set atmdir = /scratch1/06091/nanr/JRA55/
	set ocnpath = /scratch1/06090/fredc/
        set lndpath = /scratch1/06091/nanr/archive/
	set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.gen-restarts.001
endif

set syr = 1982
set eyr = 1982
set syr = 1990
set eyr = 1990
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.1990-05-01.001
set syr = 1992
set eyr = 1992
#set syr = 1994
#set eyr = 1994
set syr = 1996
set eyr = 1996
#=======
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.${syr}-01-01.001
set syr = 1998
set eyr = 1998
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.rerun-gen-restarts.001
set syr = 2020
set eyr = 2020

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib 2 $ie` )
#foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# ocn/ice
set ocncase = g.e21.GIAF.TL319_t13.5thCyc.ice.001
set first_rest_year = 1958
set ocean_base_year = 245

# Comment:  year translation:  if ($year == 2018 ) set ocnyr = 0305
# Cycle 5 of the HR FOSI should be a 61-year simulation with
# sim-year 0245-0305  == his-year 1958-2018
# years used for ICs:   0245 (1958) - 0305 (2018)
# atmyr 1958 = ocnyr 245

@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set ocndir = ${ocnpath}/g.e21.GIAF.TL319_t13.5thCyc.ice.001/rest/0${ocnyr}-${mon}-01-00000/


echo $ocnyr

#set icefname   = ${ocncase}.cice.r.0${ocnyr}-${mon}-01-00000.nc 
#set poprfname  = ${ocncase}.pop.r.0${ocnyr}-${mon}-01-00000.nc  
set icefname   = ${ocncase}.cice4.r.tx01v2.0${ocnyr}-${mon}-01-00000.nc 
set poprfname  = ${ocncase}.pop.r.tx01v2.0${ocnyr}-${mon}-01-00000.nc  
#set icefname   = g.e21.GIAF.TL319_t13.5thCyc.ice.001.cice4.r.tx01v2.0269-11-01-00000.nc
#set poprfname  = g.e21.GIAF.TL319_t13.5thCyc.ice.001.pop.r.tx01v2.0269-11-01-00000.nc
set poprofname = ${ocncase}.pop.ro.0${ocnyr}-${mon}-01-00000    
set poprhfname = ${ocncase}.pop.rh.ecosys.nyear1.0${ocnyr}-${mon}-01-00000.nc 
#set popwwfname = ${ocncase}.ww3.r.0${ocnyr}-${mon}-01-00000    

echo $icefname
echo $poprfname

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end
end

exit
 
 



