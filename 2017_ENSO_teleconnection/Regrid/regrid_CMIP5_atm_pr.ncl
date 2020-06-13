;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from pr datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2018-04-11
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------pr
;================================================

;data
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/pr/"
    in_name     = new(37,string)
    in_name(0)  = "ACCESS1-0/pr_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name(1)  = "ACCESS1-3/pr_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
    in_name(2)  = "bcc-csm1-1/pr_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(1)  = "bcc-csm1-1-m/pr_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
;    in_name(3)  = "BNU-ESM/pr_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(2)  = "CanCM4/pr_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
    in_name(3)  = "CanESM2/pr_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(4)  = "CCSM4/pr_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name(7)  = "CESM1-BGC/ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;    in_name(5)  = "CESM1-CAM5/pr_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/ua_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-FASTCHEM/ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_*.nc"
;    in_name(10) = "CESM1-WACCM/ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
    in_name(4)  = "CMCC-CESM/pr_Amon_CMCC-CESM_historical_r1i1p1_*.nc"              ;185001-200512
    in_name(5)  = "CMCC-CM/pr_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name(6)  = "CMCC-CMS/pr_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
    in_name(7)  = "CNRM-CM5/pr_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name(8)  = "CNRM-CM5-2/pr_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
    in_name(9)  = "CSIRO-Mk3-6-0/pr_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name(16) = "EC-EARTH/"
;    in_name(8)  = "FGOALS-g2/pr_Amon_FGOALS-g2_historical_r1i1p1_*.nc"              ;190001-201412
    in_name(10) = "FGOALS-s2/pr_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(18) = "FIO-ESM/ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(11) = "GFDL-CM2p1/pr_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"            ;186101-204012
    in_name(12) = "GFDL-CM3/pr_Amon_GFDL-CM3_historical_r1i1p1_*.nc"                ;186001-200512
    in_name(13) = "GFDL-ESM2G/pr_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512.nc"
    in_name(14) = "GFDL-ESM2M/pr_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512.nc"
    in_name(15) = "GISS-E2-H/pr_Amon_GISS-E2-H_historical_r1i1p1_*.nc"              ;185001-200512
    in_name(16) = "GISS-E2-H-CC/pr_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"        ;185001-201012
    in_name(17) = "GISS-E2-R/pr_Amon_GISS-E2-R_historical_r1i1p1_*.nc"              ;192601-200512
    in_name(18) = "GISS-E2-R-CC/pr_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"        ;185001-201012
    in_name(19) = "HadCM3/pr_Amon_HadCM3_historical_r1i1p1_*.nc"                    ;185912-200512
;    in_name(28) = "HadGEM2-AO/pr_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
    in_name(20) = "HadGEM2-CC/pr_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"            ;185912-200511
    in_name(21) = "HadGEM2-ES/pr_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
    in_name(22) = "inmcm4/pr_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
    in_name(23) = "IPSL-CM5A-LR/pr_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name(24) = "IPSL-CM5A-MR/pr_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name(25) = "IPSL-CM5B-LR/pr_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name(26) = "MIROC4h/pr_Amon_MIROC4h_historical_r1i1p1_*.nc"                  ;195001-200512
    in_name(27) = "MIROC5/pr_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
    in_name(28) = "MIROC-ESM/pr_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(29) = "MIROC-ESM-CHEM/pr_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
    in_name(30) = "MPI-ESM-LR/pr_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
    in_name(31) = "MPI-ESM-MR/pr_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name(32) = "MPI-ESM-P/pr_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
    in_name(33) = "MRI-CGCM3/pr_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name(34) = "MRI-ESM1/pr_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
    in_name(35) = "NorESM1-M/pr_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name(36) = "NorESM1-ME/pr_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod = dimsizes (in_name)

    single = (/True,True,True,True,False,False,False,False,False,True,True,False,False,True,True,False,False,False,False,False,False,False,True,True,True,True,False,\
               True,True,True,True,True,True,True,True,True,True/)

;output
    out_path     = "~/data-model/CMIP5-hes/pr/historical/"
    out_name     = new (nmod,string)
    out_name(0)  = "pr_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name(1)  = "pr_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
    out_name(2)  = "pr_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
    out_name(3)  = "pr_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
    out_name(4)  = "pr_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(5)  = "pr_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(6)  = "pr_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    out_name(7)  = "pr_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name(8)  = "pr_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    out_name(9)  = "pr_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name(10) = "pr_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
    out_name(11) = "pr_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    out_name(12) = "pr_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    out_name(13) = "pr_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    out_name(14) = "pr_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
    out_name(15) = "pr_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    out_name(16) = "pr_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
    out_name(17) = "pr_Amon_GISS-E2-R_historical_r1i1p1_192601-200512_T62.nc"
    out_name(18) = "pr_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
    out_name(19) = "pr_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    out_name(20) = "pr_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    out_name(21) = "pr_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
    out_name(22) = "pr_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
    out_name(23) = "pr_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name(24) = "pr_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name(25) = "pr_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name(26) = "pr_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
    out_name(27) = "pr_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
    out_name(28) = "pr_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(29) = "pr_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(30) = "pr_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name(31) = "pr_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name(32) = "pr_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
    out_name(33) = "pr_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name(34) = "pr_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
    out_name(35) = "pr_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    out_name(36) = "pr_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

;Set up options for regridding
    Opt = True

    Opt@SrcTitle    = "CMIP Grid"
;    Opt@SrcRegional = True
    Opt@WgtFileName = "CMIP_2_T62.nc"
    Opt@SrcFileName = "src_SCRIP_CMIP.nc"

;---Generate lat/lons for Gaussian grid
    NLAT = 94
    MLON = 192                              
    latG = latGau    (NLAT, "lat", "latitude" , "degrees_north")  
    lonG = lonGlobeF (MLON, "lon", "longitude", "degrees_east" )  

;    Opt@DstRegional = True
    Opt@DstGridLat = latG
    Opt@DstGridLon = lonG

;    Opt@InterpMethod   = "bilinear"
    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;do i=0,nmod-1
do i=12,12
    
    if (single(i)) then
     in = addfile (in_path + in_name(i),"r")
     pr = in->pr
;     ua   = lonFlip (in->ua)
;     ua   = short2flt (in->ua)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in = addfiles (files,"r")
     ListSetType (in, "cat")
     pr = in[:]->pr
     time = in[:]->time
     delete ([/files/])
    end if

;    printVarSummary (ua)
;    printVarSummary (time)

; ==============================================================
; Mission 2. Post-post process data to deserved resulua
; ==============================================================

    print (i+" Regriding...")

;    Opt@SrcMask2D = lmask
;    Opt@SrcInputFileName = in_path + in_name(i)

;Regrid the data
    pr_regrid = ESMF_regrid (pr,Opt)
;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (pr_regrid)
lat  = pr_regrid&lat
lon  = pr_regrid&lon

system ("rm -f "+out_path+out_name(i))

fout = addfile (out_path+out_name(i),"c")

setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time","lat","lon"/)  
dimSizes = (/dim(0),dim(1),dim(2)/) 
dimUnlim = (/True,False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"time",typeof(time),     getvardims(time))
filevardef (fout,"lat", typeof(lat),      getvardims(lat))
filevardef (fout,"lon", typeof(lon),      getvardims(lon))
filevardef (fout,"pr",  typeof(pr_regrid),getvardims(pr_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"pr",pr_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->pr   = (/pr_regrid/)

;delete ([/in,ua,time,lmask,Opt@SrcMask2D,ua_regrid,fout/])      ;will change next iteration
delete ([/in,pr,time,pr_regrid,fout/])      ;will change next iteration

end do

end
