;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from ua datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2017-09-14
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------ua
;================================================

    in_name  = new(3,string)
    out_name = new(3,string)

;data
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/ua/"
;    in_name(0)  = "ACCESS1-0/ua_Amon_ACCESS1-0_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(1)  = "ACCESS1-3/ua_Amon_ACCESS1-3_historical_r1i1p1_*.nc"
    in_name(0)  = "bcc-csm1-1/ua_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(2)  = "bcc-csm1-1-m/ua_Amon_bcc-csm1-1-m_historical_r1i1p1_*.nc"    ;185001-201212
;    in_name(3)  = "BNU-ESM/ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(4)  = "CanCM4/ua_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(5)  = "CanESM2/ua_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(6)  = "CCSM4/ua_Amon_CCSM4_historical_r1i1p1_*.nc"                  ;185001-200512
;    in_name(7)  = "CESM1-BGC/ua_Amon_CESM1-BGC_historical_r1i1p1_*.nc"
;    in_name(8)  = "CESM1-CAM5/ua_Amon_CESM1-CAM5_historical_r1i1p1_*.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/ua_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-FASTCHEM/ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_*.nc"
;    in_name(10) = "CESM1-WACCM/ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(11) = "CMCC-CESM/ua_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(12) = "CMCC-CM/ua_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(13) = "CMCC-CMS/ua_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name(14) = "CNRM-CM5/ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512.nc"
    in_name(1)  = "CNRM-CM5-2/ua_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(15) = "CSIRO-Mk3-6-0/ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_*.nc"  ;185001-200512
;    in_name(16) = "FGOALS-g2/ua_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
;    in_name(17) = "FGOALS-s2/ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(18) = "FIO-ESM/ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(19) = "GFDL-CM2p1/ua_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-204012 add
;    in_name(20) = "GFDL-CM3/ua_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200412
;    in_name(21) = "GFDL-ESM2G/ua_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(22) = "GFDL-ESM2M/ua_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(23) = "GISS-E2-H/ua_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(24) = "GISS-E2-H-CC/ua_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(25) = "GISS-E2-R/ua_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(26) = "GISS-E2-R-CC/ua_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(27) = "HadCM3/ua_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
;    in_name(28) = "HadGEM2-AO/ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(29) = "HadGEM2-CC/ua_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
;    in_name(30) = "HadGEM2-ES/ua_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(31) = "inmcm4/ua_Amon_inmcm4_historical_r1i1p1_*.nc"                ;185001-200512
;    in_name(32) = "IPSL-CM5A-LR/ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_*.nc"
;    in_name(33) = "IPSL-CM5A-MR/ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_*.nc"
;    in_name(34) = "IPSL-CM5B-LR/ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_*.nc"
;    in_name(35) = "MIROC4h/ua_Amon_MIROC4h_historical_r1i1p1_*.nc"
;    in_name(36) = "MIROC5/ua_Amon_MIROC5_historical_r1i1p1_*.nc"                ;185001-201212
;    in_name(37) = "MIROC-ESM/ua_Amon_MIROC-ESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(38) = "MIROC-ESM-CHEM/ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_*.nc"
;    in_name(39) = "MPI-ESM-LR/ua_Amon_MPI-ESM-LR_historical_r1i1p1_*.nc"
;    in_name(40) = "MPI-ESM-MR/ua_Amon_MPI-ESM-MR_historical_r1i1p1_*.nc"
;    in_name(41) = "MPI-ESM-P/ua_Amon_MPI-ESM-P_historical_r1i1p1_*.nc"
;    in_name(42) = "MRI-CGCM3/ua_Amon_MRI-CGCM3_historical_r1i1p1_*.nc"
    in_name(2)  = "MRI-ESM1/ua_Amon_MRI-ESM1_historical_r1i1p1_*.nc"            ;185101-200512
;    in_name(43) = "NorESM1-M/ua_Amon_NorESM1-M_historical_r1i1p1_*.nc"
;    in_name(44) = "NorESM1-ME/ua_Amon_NorESM1-ME_historical_r1i1p1_*.nc"
    nmod = dimsizes (in_name)

    single = (/True,False,False/)
;    single = (/False,False,False,True,True,True,False,False,False,False,True,False,False,False,True,False,False,True,True,False,False,False,\
;               False,False,False,False,False,False,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False/)

;output
    out_path     = "~/data-model/CMIP5-hes/ua/historical/"
;    out_name(0)  = "ua_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "ua_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(0)  = "ua_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(2)  = "ua_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(3)  = "ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(4)  = "ua_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
;    out_name(5)  = "ua_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(6)  = "ua_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "ua_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "ua_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(9)  = "ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(11) = "ua_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(12) = "ua_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(13) = "ua_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(14) = "ua_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    out_name(1)  = "ua_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(15) = "ua_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(16) = "ua_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    out_name(17) = "ua_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(18) = "ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(19) = "ua_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
;    out_name(20) = "ua_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
;    out_name(21) = "ua_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(22) = "ua_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(23) = "ua_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(24) = "ua_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(25) = "ua_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(26) = "ua_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(27) = "ua_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    out_name(28) = "ua_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(29) = "ua_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(30) = "ua_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(31) = "ua_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(32) = "ua_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(33) = "ua_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(34) = "ua_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(35) = "ua_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(36) = "ua_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(37) = "ua_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(38) = "ua_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(39) = "ua_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(40) = "ua_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(41) = "ua_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(42) = "ua_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(2)  = "ua_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
;    out_name(43) = "ua_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(44) = "ua_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

;Set up options for regridding
    Opt = True

    Opt@SrcTitle    = "CMIP Grid"
;    Opt@SrcRegional = True
    Opt@WgtFileName = "CMIP_2_2.5x2.5.nc"
    Opt@SrcFileName = "src_SCRIP_CMIP.nc"

;    Opt@DstRegional = True
    Opt@DstGridType = "2.5x2.5"
    Opt@DstLLCorner = (/ -90,   0/)
    Opt@DstURCorner = (/  90, 357.5/)

;    Opt@InterpMethod   = "bilinear"
    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

do i=0,nmod-1
    
    if (single(i)) then
     in   = addfile (in_path + in_name(i),"r")
     ua   = in->ua
;     ua   = lonFlip (in->ua)
;     ua   = short2flt (in->ua)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     ua    = in[:]->ua
     time  = in[:]->time
     delete (files)
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
    ua_regrid = ESMF_regrid (ua,Opt)
;    printVarSummary (ua_regrid)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (ua_regrid)
plev = ua_regrid&plev
lat  = ua_regrid&lat
lon  = ua_regrid&lon

print ((/plev/))

system ("rm -f "+out_path+out_name(i))

fout = addfile (out_path+out_name(i),"c")

setfileoption (fout,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time","plev","lat","lon"/)  
dimSizes = (/dim(0),dim(1),dim(2),dim(3)/) 
dimUnlim = (/True,False,False,False/)   

filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"time",typeof(time),     getvardims(time))
filevardef (fout,"plev",typeof(plev),     getvardims(plev))
filevardef (fout,"lat", typeof(lat),      getvardims(lat))
filevardef (fout,"lon", typeof(lon),      getvardims(lon))
filevardef (fout,"ua",  typeof(ua_regrid),getvardims(ua_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"plev",plev)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"ua",  ua_regrid)

;output only the data values
fout->time = (/time/)
fout->plev = (/plev/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->ua   = (/ua_regrid/)

;delete ([/in,ua,time,lmask,Opt@SrcMask2D,ua_regrid,fout/])      ;will change next iteration
delete ([/in,ua,time,plev,ua_regrid,fout/])      ;will change next iteration

end do

end
