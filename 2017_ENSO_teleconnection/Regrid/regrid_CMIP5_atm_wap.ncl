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
;   var--------------wap
;================================================


;data
    in_name     = new(11,string)
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/wap/"
;    in_name(0)  = "ACCESS1-0/wap_Amon_ACCESS1-0_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(1)  = "ACCESS1-3/wap_Amon_ACCESS1-3_historical_r1i1p1_*.nc"
;    in_name(2)  = "bcc-csm1-1/wap_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;;    in_name(2)  = "bcc-csm1-1-m/wap_Amon_bcc-csm1-1-m_historical_r1i1p1_*.nc"    ;185001-201212
;;    in_name(3)  = "BNU-ESM/wap_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;;    in_name(4)  = "CanCM4/wap_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(0)  = "CanESM2/wap_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;;    in_name(6)  = "CCSM4/wap_Amon_CCSM4_historical_r1i1p1_*.nc"                  ;185001-200512
;;    in_name(7)  = "CESM1-BGC/wap_Amon_CESM1-BGC_historical_r1i1p1_*.nc"
;;    in_name(8)  = "CESM1-CAM5/wap_Amon_CESM1-CAM5_historical_r1i1p1_*.nc"
;;    in_name(9)  = "CESM1-FASTCHEM/wap_Amon_CESM1-FASTCHEM_historical_r1i1p1_*.nc"
;;    in_name(10) = "CESM1-WACCM/wap_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
    in_name(0)  = "CMCC-CESM/wap_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(1)  = "CMCC-CM/wap_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name(2)  = "CMCC-CMS/wap_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name(2)  = "CNRM-CM5/wap_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name(3)  = "CNRM-CM5-2/wap_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
;    in_name(3)  = "CSIRO-Mk3-6-0/wap_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_*.nc"  ;185001-200512
;;    in_name(16) = "FGOALS-g2/wap_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
;    in_name(3)  = "FGOALS-s2/wap_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;;    in_name(18) = "FIO-ESM/wap_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(4)  = "GFDL-CM2p1/wap_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(4)  = "GFDL-CM3/wap_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200512
;    in_name(5)  = "GFDL-ESM2G/wap_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(6)  = "GFDL-ESM2M/wap_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(5)  = "GISS-E2-H/wap_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(7)  = "GISS-E2-H-CC/wap_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(6)  = "GISS-E2-R/wap_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(8)  = "GISS-E2-R-CC/wap_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(7)  = "HadCM3/wap_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
;;   in_name(28) = "HadGEM2-AO/wap_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;;/   in_name(29) = "HadGEM2-CC/wap_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
    in_name(4)  = "HadGEM2-ES/wap_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(8)  = "inmcm4/wap_Amon_inmcm4_historical_r1i1p1_*.nc"                ;185001-200512
;    in_name(9)  = "IPSL-CM5A-LR/wap_Amon_IPSL-CM5A-LR_historical_r1i1p1_*.nc"
    in_name(5)  = "IPSL-CM5A-MR/wap_Amon_IPSL-CM5A-MR_historical_r1i1p1_*.nc"
    in_name(6)  = "IPSL-CM5B-LR/wap_Amon_IPSL-CM5B-LR_historical_r1i1p1_*.nc"
    in_name(7)  = "MIROC4h/wap_Amon_MIROC4h_historical_r1i1p1_*.nc"
;    in_name(10) = "MIROC5/wap_Amon_MIROC5_historical_r1i1p1_*.nc"                ;185001-201212
;    in_name(11) = "MIROC-ESM/wap_Amon_MIROC-ESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(12) = "MIROC-ESM-CHEM/wap_Amon_MIROC-ESM-CHEM_historical_r1i1p1_*.nc"
;    in_name(13) = "MPI-ESM-LR/wap_Amon_MPI-ESM-LR_historical_r1i1p1_*.nc"
;    in_name(14) = "MPI-ESM-MR/wap_Amon_MPI-ESM-MR_historical_r1i1p1_*.nc"
    in_name(8)  = "MPI-ESM-P/wap_Amon_MPI-ESM-P_historical_r1i1p1_*.nc"
;    in_name(15) = "MRI-CGCM3/wap_Amon_MRI-CGCM3_historical_r1i1p1_*.nc"
    in_name(9)  = "MRI-ESM1/wap_Amon_MRI-ESM1_historical_r1i1p1_*.nc"            ;185101-200512
;    in_name(16) = "NorESM1-M/wap_Amon_NorESM1-M_historical_r1i1p1_*.nc"        ;185001-200512
    in_name(10) = "NorESM1-ME/wap_Amon_NorESM1-ME_historical_r1i1p1_*.nc"
    nmod = dimsizes (in_name)

    single = (/False,False,False,False,False,False,False,False,False,False,False/)
;    single = (/False,False,True,False,False,False,False,False,False/)
;    single = (/True,False,False,True,False,False,False,False,False,False,False,False,False,False,False,False,False/)
;    single = (/False,False,False,True,True,True,False,False,False,False,True,False,False,False,True,False,False,True,True,False,False,False,\
;               False,False,False,False,False,False,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False/)

;output
    out_name     = new(nmod,string)
    out_path     = "~/data-model/CMIP5-hes/wap/historical/"
;    out_name(0)  = "wap_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "wap_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(2)  = "wap_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(2)  = "wap_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(3)  = "wap_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(4)  = "wap_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
;    out_name(0)  = "wap_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(6)  = "wap_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "wap_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "wap_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(9)  = "wap_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "wap_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(0)  = "wap_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(1)  = "wap_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(2)  = "wap_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(2)  = "wap_Amon_CNRM-CM5_historical_r1i1p1_195001-200512_2.5x2.5.nc"
    out_name(3)  = "wap_Amon_CNRM-CM5-2_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(3)  = "wap_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(16) = "wap_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    out_name(3)  = "wap_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(18) = "wap_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(4)  = "wap_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(4)  = "wap_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(5)  = "wap_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(6)  = "wap_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(5)  = "wap_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "wap_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(6)  = "wap_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "wap_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(7)  = "wap_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    out_name(28) = "wap_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(29) = "wap_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
    out_name(4)  = "wap_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(8)  = "wap_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(9)  = "wap_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(5)  = "wap_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(6)  = "wap_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(7)  = "wap_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(10) = "wap_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(11) = "wap_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(12) = "wap_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(13) = "wap_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(14) = "wap_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(8)  = "wap_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(15) = "wap_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(9)  = "wap_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
;    out_name(16) = "wap_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(10) = "wap_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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

do i = 10,nmod-1
    
    if (single(i)) then
     in   = addfile (in_path + in_name(i),"r")
     wap   = in->wap
;     wap   = lonFlip (in->wap)
;     wap   = short2flt (in->wap)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     wap   = in[:]->wap
     time  = in[:]->time
     delete (files)
    end if

;    printVarSummary (wap)
;    printVarSummary (time)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    print (i+" Regriding...")

;    Opt@SrcMask2D = lmask
;    Opt@SrcInputFileName = in_path + in_name(i)

;Regrid the data
    wap_regrid = ESMF_regrid (wap,Opt)
;    printVarSummary (wap_regrid)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (wap_regrid)
plev = wap_regrid&plev
lat  = wap_regrid&lat
lon  = wap_regrid&lon

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
filevardef (fout,"wap",  typeof(wap_regrid),getvardims(wap_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"plev",plev)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"wap",  wap_regrid)

;output only the data values
fout->time = (/time/)
fout->plev = (/plev/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->wap   = (/wap_regrid/)

;delete ([/in,wap,time,lmask,Opt@SrcMask2D,wap_regrid,fout/])      ;will change next iteration
delete ([/in,wap,time,plev,wap_regrid,fout/])      ;will change next iteration

end do

end
