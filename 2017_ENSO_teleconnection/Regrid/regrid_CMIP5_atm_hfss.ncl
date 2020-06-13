;*************************************************************
;Aim: Interpolating deserved data from one grid to a T69 degree global grid
;Mission:
;
;   1. Read data from hfss datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2018-01-31
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------hfss
;================================================

    in_name  = new(5,string)
    out_name = new(5,string)

;data
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/hfss/"
;    in_name(0)  = "ACCESS1-0/hfss_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
;    in_name(1)  = "ACCESS1-3/hfss_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name(2)  = "bcc-csm1-1/hfss_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(3)  = "bcc-csm1-1-m/hfss_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
;    in_name(4)  = "BNU-ESM/hfss_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(5)  = "CanCM4/hfss_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(6)  = "CanESM2/hfss_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(7)  = "CCSM4/hfss_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name(8)  = "CESM1-BGC/hfss_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-CAM5/hfss_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/hfss_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(11) = "CESM1-FASTCHEM/hfss_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(12) = "CESM1-WACCM/hfss_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(13) = "CMCC-CESM/hfss_Amon_CMCC-CESM_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(14) = "CMCC-CM/hfss_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(15) = "CMCC-CMS/hfss_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
    in_name(0)  = "CNRM-CM5/hfss_Amon_CNRM-CM5_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(1)  = "CNRM-CM5-2/hfss_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
;    in_name(16) = "CSIRO-Mk3-6-0/hfss_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name(17) = "FGOALS-g2/hfss_Amon_FGOALS-g2_historical_r1i1p1_*.nc"        ;190001-201412
;    in_name(18) = "FGOALS-s2/hfss_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(19) = "FIO-ESM/hfss_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(2)  = "GFDL-CM2p1/hfss_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"      ;186101-200512
    in_name(3)  = "GFDL-CM3/hfss_Amon_GFDL-CM3_historical_r1i1p1_*.nc"          ;186001-200512
;    in_name(21) = "GFDL-ESM2G/hfss_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"      ;186101-200512
;    in_name(22) = "GFDL-ESM2M/hfss_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(23) = "GISS-E2-H/hfss_Amon_GISS-E2-H_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(24) = "GISS-E2-H-CC/hfss_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"  ;185001-201012
;    in_name(25) = "GISS-E2-R/hfss_Amon_GISS-E2-R_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(26) = "GISS-E2-R-CC/hfss_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"  ;185001-201012
;    in_name(27) = "HadCM3/hfss_Amon_HadCM3_historical_r1i1p1_*.nc"              ;185912-200512
;    in_name(28) = "HadGEM2-AO/hfss_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(29) = "HadGEM2-CC/hfss_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"      ;185912-200511
;    in_name(30) = "HadGEM2-ES/hfss_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(31) = "inmcm4/hfss_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name(32) = "IPSL-CM5A-LR/hfss_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(33) = "IPSL-CM5A-MR/hfss_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(34) = "IPSL-CM5B-LR/hfss_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(35) = "MIROC4h/hfss_Amon_MIROC4h_historical_r1i1p1_*.nc"            ;195001-200512
;    in_name(36) = "MIROC5/hfss_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name(37) = "MIROC-ESM/hfss_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(38) = "MIROC-ESM-CHEM/hfss_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(39) = "MPI-ESM-LR/hfss_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(40) = "MPI-ESM-MR/hfss_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(41) = "MPI-ESM-P/hfss_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name(42) = "MRI-CGCM3/hfss_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name(4)  = "MRI-ESM1/hfss_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name(43) = "NorESM1-M/hfss_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
;    in_name(44) = "NorESM1-ME/hfss_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod = dimsizes (in_name)

    single = (/False,False,False,False,True/)
;    single = (/True,True,True,True,True,True,True,True,True,True,True,True,True,False,False,False,True,False,True,True,False,False,False,False,False,False,False,False,True,False,\
;               False,True,True,True,True,False,True,True,True,True,True,True,True,True,True/)

;output
    out_path     = "~/data-model/CMIP5-hes/hfss/historical/"
;    out_name(0)  = "hfss_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(1)  = "hfss_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(2)  = "hfss_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(3)  = "hfss_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(4)  = "hfss_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(5)  = "hfss_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name(6)  = "hfss_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(7)  = "hfss_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(8)  = "hfss_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(9)  = "hfss_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(10) = "hfss_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(11) = "hfss_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(12) = "hfss_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(13) = "hfss_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(14) = "hfss_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(15) = "hfss_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    out_name(0)  = "hfss_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name(1)  = "hfss_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(16) = "hfss_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(17) = "hfss_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
;    out_name(18) = "hfss_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(19) = "hfss_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(2)  = "hfss_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    out_name(3)  = "hfss_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
;    out_name(21) = "hfss_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
;    out_name(22) = "hfss_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name(23) = "hfss_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(24) = "hfss_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name(25) = "hfss_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(26) = "hfss_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name(27) = "hfss_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    out_name(28) = "hfss_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
;    out_name(29) = "hfss_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
;    out_name(30) = "hfss_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name(31) = "hfss_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(32) = "hfss_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(33) = "hfss_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(34) = "hfss_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(35) = "hfss_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
;    out_name(36) = "hfss_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(37) = "hfss_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(38) = "hfss_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(39) = "hfss_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(40) = "hfss_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(41) = "hfss_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(42) = "hfss_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name(4)  = "hfss_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name(43) = "hfss_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(44) = "hfss_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

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

do i=0,nmod-1
    
    if (single(i)) then
     in   = addfile (in_path + in_name(i),"r")
     hfss = in->hfss
;     ua   = lonFlip (in->ua)
;     ua   = short2flt (in->ua)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     hfss  = in[:]->hfss
     time  = in[:]->time
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
    hfss_regrid = ESMF_regrid (hfss,Opt)
    if (i.eq.0)then
     printVarSummary (hfss)
     printVarSummary (hfss_regrid)
    end if
;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (hfss_regrid)
lat  = hfss_regrid&lat
lon  = hfss_regrid&lon

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
filevardef (fout,"time",typeof(time),       getvardims(time))
filevardef (fout,"lat", typeof(lat),        getvardims(lat))
filevardef (fout,"lon", typeof(lon),        getvardims(lon))
filevardef (fout,"hfss",typeof(hfss_regrid),getvardims(hfss_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"hfss",hfss_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->hfss = (/hfss_regrid/)

;delete ([/in,ua,time,lmask,Opt@SrcMask2D,ua_regrid,fout/])      ;will change next iteration
delete ([/in,hfss,time,hfss_regrid,fout/])

end do

end
