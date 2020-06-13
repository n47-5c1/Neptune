;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from va datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2017-01-05
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------va
;================================================

    in_name  = new(3,string)
    out_name = new(3,string)

;data
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/va/"
;    in_name(0)  = "ACCESS1-0/va_Amon_ACCESS1-0_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(1)  = "ACCESS1-3/va_Amon_ACCESS1-3_historical_r1i1p1_*.nc"
    in_name(0)  = "bcc-csm1-1/va_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(2)  = "bcc-csm1-1-m/va_Amon_bcc-csm1-1-m_historical_r1i1p1_*.nc"    ;185001-201212
;    in_name(3)  = "BNU-ESM/va_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(4)  = "CanCM4/va_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(5)  = "CanESM2/va_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(6)  = "CCSM4/va_Amon_CCSM4_historical_r1i1p1_*.nc"                  ;185001-200512
;    in_name(7)  = "CESM1-BGC/va_Amon_CESM1-BGC_historical_r1i1p1_*.nc"
;    in_name(8)  = "CESM1-CAM5/va_Amon_CESM1-CAM5_historical_r1i1p1_*.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/va_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-FASTCHEM/va_Amon_CESM1-FASTCHEM_historical_r1i1p1_*.nc"
;    in_name(10) = "CESM1-WACCM/va_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(11) = "CMCC-CESM/va_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(12) = "CMCC-CM/va_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(13) = "CMCC-CMS/va_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name(14) = "CNRM-CM5/va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512.nc"
    in_name(1)  = "CNRM-CM5-2/va_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"        ;185001-200512
;    in_name(15) = "CSIRO-Mk3-6-0/va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_*.nc"  ;185001-200512
;    in_name(16) = "FGOALS-g2/va_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
;    in_name(17) = "FGOALS-s2/va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(18) = "FIO-ESM/va_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(19) = "GFDL-CM2p1/va_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-204012 add
;    in_name(20) = "GFDL-CM3/va_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200412
;    in_name(21) = "GFDL-ESM2G/va_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(22) = "GFDL-ESM2M/va_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(23) = "GISS-E2-H/va_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(24) = "GISS-E2-H-CC/va_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(25) = "GISS-E2-R/va_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(26) = "GISS-E2-R-CC/va_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(27) = "HadCM3/va_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
;    in_name(28) = "HadGEM2-AO/va_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(29) = "HadGEM2-CC/va_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
;    in_name(30) = "HadGEM2-ES/va_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(31) = "inmcm4/va_Amon_inmcm4_historical_r1i1p1_*.nc"                ;185001-200512
;    in_name(32) = "IPSL-CM5A-LR/va_Amon_IPSL-CM5A-LR_historical_r1i1p1_*.nc"
;    in_name(33) = "IPSL-CM5A-MR/va_Amon_IPSL-CM5A-MR_historical_r1i1p1_*.nc"
;    in_name(34) = "IPSL-CM5B-LR/va_Amon_IPSL-CM5B-LR_historical_r1i1p1_*.nc"
;    in_name(35) = "MIROC4h/va_Amon_MIROC4h_historical_r1i1p1_*.nc"
;    in_name(36) = "MIROC5/va_Amon_MIROC5_historical_r1i1p1_*.nc"                ;185001-201212
;    in_name(37) = "MIROC-ESM/va_Amon_MIROC-ESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(38) = "MIROC-ESM-CHEM/va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_*.nc"
;    in_name(39) = "MPI-ESM-LR/va_Amon_MPI-ESM-LR_historical_r1i1p1_*.nc"
;    in_name(40) = "MPI-ESM-MR/va_Amon_MPI-ESM-MR_historical_r1i1p1_*.nc"
;    in_name(41) = "MPI-ESM-P/va_Amon_MPI-ESM-P_historical_r1i1p1_*.nc"
;    in_name(42) = "MRI-CGCM3/va_Amon_MRI-CGCM3_historical_r1i1p1_*.nc"
    in_name(2)  = "MRI-ESM1/va_Amon_MRI-ESM1_historical_r1i1p1_*.nc"            ;185101-200512
;    in_name(43) = "NorESM1-M/va_Amon_NorESM1-M_historical_r1i1p1_*.nc"
;    in_name(44) = "NorESM1-ME/va_Amon_NorESM1-ME_historical_r1i1p1_*.nc"
    nmod = dimsizes (in_name)

    single = (/True,False,False/)
;    single = (/False,False,False,True,True,True,False,False,False,False,True,False,False,False,True,False,False,True,True,False,False,False,\
;               False,False,False,False,False,False,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False/)

;output
    out_path     = "~/data-model/CMIP5-hes/va/historical/"
;    out_name(0)  = "va_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "va_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(0)  = "va_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(2)  = "va_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(3)  = "va_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(4)  = "va_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
;    out_name(5)  = "va_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(6)  = "va_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "va_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "va_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "va_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(9)  = "va_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "va_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(11) = "va_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(12) = "va_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(13) = "va_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(14) = "va_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    out_name(1)  = "va_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(15) = "va_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(16) = "va_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    out_name(17) = "va_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(18) = "va_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(19) = "va_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
;    out_name(20) = "va_Amon_GFDL-CM3_historical_r1i1p1_186001-200412_2.5x2.5.nc"
;    out_name(21) = "va_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(22) = "va_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(23) = "va_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(24) = "va_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(25) = "va_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(26) = "va_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(27) = "va_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    out_name(28) = "va_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(29) = "va_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(30) = "va_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(31) = "va_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(32) = "va_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(33) = "va_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(34) = "va_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(35) = "va_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(36) = "va_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(37) = "va_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(38) = "va_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(39) = "va_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(40) = "va_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(41) = "va_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(42) = "va_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(2)  = "va_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
;    out_name(43) = "va_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(44) = "va_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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
;do i=28,nmod-1
    
    if (single(i)) then
     in   = addfile (in_path + in_name(i),"r")
     va   = in->va
;     va   = lonFlip (in->va)
;     va   = short2flt (in->va)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     va    = in[:]->va
     time  = in[:]->time
     delete (files)
    end if

;    printVarSummary (va)
;    printVarSummary (time)

; ==============================================================
; Mission 2. Post-post process data to deserved resulva
; ==============================================================

    print (i+" Regriding...")

;    Opt@SrcMask2D = lmask
;    Opt@SrcInputFileName = in_path + in_name(i)

;Regrid the data
    va_regrid = ESMF_regrid (va,Opt)
;    printVarSummary (va_regrid)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (va_regrid)
plev = va_regrid&plev
lat  = va_regrid&lat
lon  = va_regrid&lon

print (plev)

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
filevardef (fout,"va",  typeof(va_regrid),getvardims(va_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"plev",plev)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"va",  va_regrid)

;output only the data values
fout->time = (/time/)
fout->plev = (/plev/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->va   = (/va_regrid/)

;delete ([/in,va,time,lmask,Opt@SrcMask2D,va_regrid,fout/])      ;will change next iteration
delete ([/in,va,time,plev,va_regrid,fout/])      ;will change next iteration

end do

end
