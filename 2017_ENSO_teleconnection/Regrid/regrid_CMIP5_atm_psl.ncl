;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from psl datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2018-01-16
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------psl
;================================================


;data
    in_name     = new (4,string)
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/psl/"
;    in_name(0)  = "ACCESS1-0/psl_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
;    in_name(1)  = "ACCESS1-3/psl_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name(2)  = "bcc-csm1-1/psl_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(3)  = "bcc-csm1-1-m/psl_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
;    in_name(4)  = "BNU-ESM/psl_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(5)  = "CanCM4/psl_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(6)  = "CanESM2/psl_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name(7)  = "CCSM4/psl_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name(8)  = "CESM1-BGC/psl_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;    in_name(9)  = "CESM1-CAM5/psl_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;    in_name(10) = "CESM1-CAM5-1-FV2/psl_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;    in_name(11) = "CESM1-FASTCHEM/psl_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(12) = "CESM1-WACCM/psl_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(13) = "CMCC-CESM/psl_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(14) = "CMCC-CM/psl_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(15) = "CMCC-CMS/psl_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
    in_name(0)  = "CNRM-CM5/psl_Amon_CNRM-CM5_historical_r1i1p1_*.nc"            ;185001-200512
    in_name(1)  = "CNRM-CM5-2/psl_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
;    in_name(17) = "CSIRO-Mk3-6-0/psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name(18) = "EC-EARTH/psl_Amon_EC-EARTH_historical_r1i1p1_*.nc"            ;185001-200912
;    in_name(19) = "FGOALS-g2/psl_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
;    in_name(20) = "FGOALS-s2/psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name(21) = "FIO-ESM/psl_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(22) = "GFDL-CM2p1/psl_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-204012
;    in_name(23) = "GFDL-CM3/psl_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200512
;    in_name(24) = "GFDL-ESM2G/psl_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
    in_name(2)  = "GFDL-ESM2M/psl_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(25) = "GISS-E2-H/psl_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(26) = "GISS-E2-H-CC/psl_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(27) = "GISS-E2-R/psl_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(28) = "GISS-E2-R-CC/psl_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(29) = "HadCM3/psl_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
;    in_name(30) = "HadGEM2-AO/psl_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(31) = "HadGEM2-CC/psl_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
;    in_name(32) = "HadGEM2-ES/psl_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(33) = "inmcm4/psl_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name(34) = "IPSL-CM5A-LR/psl_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(35) = "IPSL-CM5A-MR/psl_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(36) = "IPSL-CM5B-LR/psl_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(37) = "MIROC4h/psl_Amon_MIROC4h_historical_r1i1p1_*.nc"              ;195001-200512
;    in_name(38) = "MIROC5/psl_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name(39) = "MIROC-ESM/psl_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(40) = "MIROC-ESM-CHEM/psl_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(41) = "MPI-ESM-LR/psl_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(42) = "MPI-ESM-MR/psl_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(43) = "MPI-ESM-P/psl_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name(44) = "MRI-CGCM3/psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name(3)  = "MRI-ESM1/psl_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name(45) = "NorESM1-M/psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
;    in_name(46) = "NorESM1-ME/psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod        = dimsizes (in_name)

    single = (/False,False,False,True/)
;    single = (/True,True,True,True,True,True,True,True,True,True,True,True,True,False,False,False,False,True,False,False,True,True,False,False,False,False,\
;               False,False,False,False,True,False,False,True,True,True,True,False,True,True,True,True,True,True,True,True,True/)

;output
    out_name     = new (nmod,string)
    out_path     = "~/data-model/CMIP5-hes/psl/historical/"
;    out_name(0)  = "psl_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "psl_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(2)  = "psl_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(3)  = "psl_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(4)  = "psl_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(5)  = "psl_Amon_CanCM4_historical_r1i1p1_196101-200512_2.5x2.5.nc"
;    out_name(6)  = "psl_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "psl_Amon_CCSM4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "psl_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(9)  = "psl_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10) = "psl_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(11) = "psl_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(12) = "psl_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(13) = "psl_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(14) = "psl_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(15) = "psl_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(0)  = "psl_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(1)  = "psl_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(17) = "psl_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(18) = "psl_Amon_EC-EARTH_historical_r1i1p1_185001-200912.nc"
;    out_name(19) = "psl_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2.5x2.5.nc"
;    out_name(20) = "psl_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(21) = "psl_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(22) = "psl_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012.nc"
;    out_name(23) = "psl_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(24) = "psl_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
    out_name(2)  = "psl_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(25) = "psl_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(26) = "psl_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(27) = "psl_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(28) = "psl_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(29) = "psl_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    out_name(30) = "psl_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(31) = "psl_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(32) = "psl_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(33) = "psl_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(34) = "psl_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(35) = "psl_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(36) = "psl_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(37) = "psl_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(38) = "psl_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(39) = "psl_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(40) = "psl_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(41) = "psl_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(42) = "psl_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(43) = "psl_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(44) = "psl_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
    out_name(3)  = "psl_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
;    out_name(45) = "psl_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(46) = "psl_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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
     psl  = in->psl
;     ts   = lonFlip (in->ts)
;     ts   = short2flt (in->ts)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     psl   = in[:]->psl
     time  = in[:]->time
     delete (files)
    end if

    printVarSummary (psl)
;    printVarSummary (time)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    print (i+" Regriding...")

;Regrid the data
    psl_regrid = ESMF_regrid (psl,Opt)
;    printVarSummary (ts_regrid)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim = dimsizes (psl_regrid)
lat = psl_regrid&lat
lon = psl_regrid&lon

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
filevardef (fout,"time",typeof(time),      getvardims(time))
filevardef (fout,"lat" ,typeof(lat),       getvardims(lat))
filevardef (fout,"lon" ,typeof(lon),       getvardims(lon))
filevardef (fout,"psl", typeof(psl_regrid),getvardims(psl_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"psl", psl_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->psl  = (/psl_regrid/)

delete ([/in,psl,time,psl_regrid,fout/])      ;will change next iteration

end do

end
