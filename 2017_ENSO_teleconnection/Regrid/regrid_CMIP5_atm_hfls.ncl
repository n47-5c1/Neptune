;*************************************************************
;Aim: Interpolating deserved data from one grid to a T69 degree global grid
;Mission:
;
;   1. Read data from hfls datasets
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
;   var--------------hfls
;================================================

    in_name  = new(5,string)
    out_name = new(5,string)

;data
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/hfls/"
;    in_name(0)  = "ACCESS1-0/hfls_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
;    in_name(1)  = "ACCESS1-3/hfls_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name(2)  = "bcc-csm1-1/hfls_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(3)  = "bcc-csm1-1-m/hfls_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
;    in_name(4)  = "BNU-ESM/hfls_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(5)  = "CanCM4/hfls_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(6)  = "CanESM2/hfls_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(7)  = "CCSM4/hfls_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name(8)  = "CESM1-BGC/hfls_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-CAM5/hfls_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/hfls_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(11) = "CESM1-FASTCHEM/hfls_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(12) = "CESM1-WACCM/hfls_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(13) = "CMCC-CESM/hfls_Amon_CMCC-CESM_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(14) = "CMCC-CM/hfls_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(15) = "CMCC-CMS/hfls_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
    in_name(0)  = "CNRM-CM5/hfls_Amon_CNRM-CM5_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(1)  = "CNRM-CM5-2/hfls_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
;    in_name(16) = "CSIRO-Mk3-6-0/hfls_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name(17) = "FGOALS-g2/hfls_Amon_FGOALS-g2_historical_r1i1p1_*.nc"        ;190001-201412
;    in_name(18) = "FGOALS-s2/hfls_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(19) = "FIO-ESM/hfls_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(2)  = "GFDL-CM2p1/evspsbl_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"   ;186101-200512
    in_name(3)  = "GFDL-CM3/hfls_Amon_GFDL-CM3_historical_r1i1p1_*.nc"          ;186001-200512
;    in_name(20) = "GFDL-ESM2G/hfls_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"      ;186101-200512
;    in_name(21) = "GFDL-ESM2M/hfls_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(22) = "GISS-E2-H/hfls_Amon_GISS-E2-H_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(23) = "GISS-E2-H-CC/hfls_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"  ;185001-201012
;    in_name(24) = "GISS-E2-R/hfls_Amon_GISS-E2-R_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(25) = "GISS-E2-R-CC/hfls_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"  ;185001-201012
;    in_name(26) = "HadCM3/hfls_Amon_HadCM3_historical_r1i1p1_*.nc"              ;185912-200512
;    in_name(27) = "HadGEM2-AO/hfls_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(28) = "HadGEM2-CC/hfls_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"      ;185912-200511
;    in_name(29) = "HadGEM2-ES/hfls_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(30) = "inmcm4/hfls_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name(31) = "IPSL-CM5A-LR/hfls_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(32) = "IPSL-CM5A-MR/hfls_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(33) = "IPSL-CM5B-LR/hfls_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(34) = "MIROC4h/hfls_Amon_MIROC4h_historical_r1i1p1_*.nc"            ;195001-200512
;    in_name(35) = "MIROC5/hfls_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name(36) = "MIROC-ESM/hfls_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(37) = "MIROC-ESM-CHEM/hfls_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(38) = "MPI-ESM-LR/hfls_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(39) = "MPI-ESM-MR/hfls_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(40) = "MPI-ESM-P/hfls_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name(41) = "MRI-CGCM3/hfls_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name(4)  = "MRI-ESM1/hfls_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name(42) = "NorESM1-M/hfls_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
;    in_name(43) = "NorESM1-ME/hfls_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod = dimsizes (in_name)

    single = (/False,False,False,False,True/)
;    single = (/True,True,True,True,True,True,True,True,True,True,True,True,True,False,False,False,True,False,True,True,False,False,False,False,False,False,False,True,False,False,\
;               True,True,True,True,False,True,True,True,True,True,True,True,True,True/)

;output
    out_path     = "~/data-model/CMIP5-hes/hfls/historical/"
;    out_name(0)  = "hfls_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(1)  = "hfls_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(2)  = "hfls_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(3)  = "hfls_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(4)  = "hfls_Amon_BNU-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(5)  = "hfls_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name(6)  = "hfls_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(7)  = "hfls_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(8)  = "hfls_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(9)  = "hfls_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(10) = "hfls_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(11) = "hfls_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(12) = "hfls_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(13) = "hfls_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(14) = "hfls_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(15) = "hfls_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
    out_name(0)  = "hfls_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name(1)  = "hfls_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(16) = "hfls_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(17) = "hfls_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_T62.nc"
;    out_name(18) = "hfls_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(19) = "hfls_Amon_FIO-ESM_historical_r1i1p1_185001-200512_T62.nc"
    out_name(2)  = "hfls_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_T62.nc"
    out_name(3)  = "hfls_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
;    out_name(20) = "hfls_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
;    out_name(21) = "hfls_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name(22) = "hfls_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(23) = "hfls_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name(24) = "hfls_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(25) = "hfls_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name(26) = "hfls_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;    out_name(27) = "hfls_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
;    out_name(28) = "hfls_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
;    out_name(29) = "hfls_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name(30) = "hfls_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(31) = "hfls_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(32) = "hfls_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(33) = "hfls_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(34) = "hfls_Amon_MIROC4h_historical_r1i1p1_195001-20051_T62.nc"
;    out_name(35) = "hfls_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name(36) = "hfls_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(37) = "hfls_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(38) = "hfls_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(39) = "hfls_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(40) = "hfls_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(41) = "hfls_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name(4)  = "hfls_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name(42) = "hfls_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
;    out_name(43) = "hfls_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

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
     hfls = in->hfls
;     ua   = lonFlip (in->ua)
;     ua   = short2flt (in->ua)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     if (i.eq.2) then
      hfls = in[:]->evspsbl
      hfls = hfls*2.43*10.^6.   ;kg/m2/s -> W/m2
     else
      hfls  = in[:]->hfls
     end if
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
    hfls_regrid = ESMF_regrid (hfls,Opt)
    if (i.eq.0)then
     printVarSummary (hfls)
     printVarSummary (hfls_regrid)
    end if
;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (hfls_regrid)
lat  = hfls_regrid&lat
lon  = hfls_regrid&lon

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
filevardef (fout,"hfls",typeof(hfls_regrid),getvardims(hfls_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"hfls",hfls_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->hfls = (/hfls_regrid/)

;delete ([/in,ua,time,lmask,Opt@SrcMask2D,ua_regrid,fout/])      ;will change next iteration
delete ([/in,hfls,time,hfls_regrid,fout/])

end do

end
