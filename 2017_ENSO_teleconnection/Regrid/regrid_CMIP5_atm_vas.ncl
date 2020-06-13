;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from vas datasets
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
;   var--------------vas
;================================================


;data
    in_name     = new (1,string)
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/vas/"
;    in_name(0)  = "ACCESS1-0/vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
;    in_name(1)  = "ACCESS1-3/vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name(2)  = "bcc-csm1-1/vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name(3)  = "bcc-csm1-1-m/vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
;    in_name(4)  = "BNU-ESM/vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;;    in_name(5)  = "CanCM4/vas_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name(5)  = "CanESM2/vas_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;;    in_name(7)  = "CCSM4/vas_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;;    in_name(8)  = "CESM1-BGC/vas_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;;    in_name(9)  = "CESM1-CAM5/vas_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;;    in_name(10) = "CESM1-CAM5-1-FV2/vas_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;;    in_name(11) = "CESM1-FASTCHEM/vas_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512.nc"
;;    in_name(12) = "CESM1-WACCM/vas_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
;    in_name(6)  = "CMCC-CESM/vas_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(7)  = "CMCC-CM/vas_Amon_CMCC-CM_historical_r1i1p1_*.nc"
;    in_name(8)  = "CMCC-CMS/vas_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name(0)  = "CNRM-CM5/vas_Amon_CNRM-CM5_historical_r1i1p1_*.nc"            ;185001-200512
;    in_name(1)  = "CNRM-CM5-2/vas_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
;    in_name(10) = "CSIRO-Mk3-6-0/vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;;    in_name(18) = "EC-EARTH/vas_Amon_EC-EARTH_historical_r1i1p1_*.nc"            ;185001-200912
;;    in_name(19) = "FGOALS-g2/vas_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
;    in_name(11) = "FGOALS-s2/vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;;    in_name(21) = "FIO-ESM/vas_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(12) = "GFDL-CM2p1/vas_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-204012
    in_name(0)  = "GFDL-CM3/vas_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200512
;    in_name(13) = "GFDL-ESM2G/vas_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
;    in_name(14) = "GFDL-ESM2M/vas_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name(15) = "GISS-E2-H/vas_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(16) = "GISS-E2-H-CC/vas_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(17) = "GISS-E2-R/vas_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name(18) = "GISS-E2-R-CC/vas_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
;    in_name(19) = "HadCM3/vas_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
;    in_name(20) = "HadGEM2-AO/vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
;    in_name(21) = "HadGEM2-CC/vas_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
;    in_name(22) = "HadGEM2-ES/vas_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name(23) = "inmcm4/vas_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name(24) = "IPSL-CM5A-LR/vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(25) = "IPSL-CM5A-MR/vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(26) = "IPSL-CM5B-LR/vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(27) = "MIROC4h/vas_Amon_MIROC4h_historical_r1i1p1_*.nc"              ;195001-200512
;    in_name(28) = "MIROC5/vas_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name(29) = "MIROC-ESM/vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name(30) = "MIROC-ESM-CHEM/vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name(31) = "MPI-ESM-LR/vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name(32) = "MPI-ESM-MR/vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
;    in_name(33) = "MPI-ESM-P/vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name(34) = "MRI-CGCM3/vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
;    in_name(3)  = "MRI-ESM1/vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name(35) = "NorESM1-M/vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
;    in_name(36) = "NorESM1-ME/vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod        = dimsizes (in_name)

    single = False
;    single = (/True,True,True,True,True,True,False,False,False,False,True,True,False,False,False,False,\
;               False,False,False,False,True,False,False,True,True,True,True,False,True,True,True,True,True,True,True,True,True/)

;output
    out_name     = new (nmod,string)
    out_path     = "~/data-model/CMIP5-hes/vas/historical/"
;    out_name(0)  = "vas_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "vas_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(2)  = "vas_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(3)  = "vas_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(4)  = "vas_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(5)  = "vas_Amon_CanESM2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(6)  = "vas_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(7)  = "vas_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(8)  = "vas_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(0)  = "vas_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(1)  = "vas_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(10)  = "vas_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(11) = "vas_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(12) = "vas_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_2.5x2.5.nc"
    out_name(0)  = "vas_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(13) = "vas_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(14) = "vas_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2.5x2.5.nc"
;    out_name(15) = "vas_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(16) = "vas_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(17) = "vas_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(18) = "vas_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2.5x2.5.nc"
;    out_name(19) = "vas_Amon_HadCM3_historical_r1i1p1_185912-200512_2.5x2.5.nc"
;    out_name(20) = "vas_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2.5x2.5.nc"
;    out_name(21) = "vas_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(22) = "vas_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2.5x2.5.nc"
;    out_name(23) = "vas_Amon_inmcm4_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(24) = "vas_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(25) = "vas_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(26) = "vas_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(27) = "vas_Amon_MIROC4h_historical_r1i1p1_195001-200512_2.5x2.5.nc"
;    out_name(28) = "vas_Amon_MIROC5_historical_r1i1p1_185001-201212_2.5x2.5.nc"
;    out_name(29) = "vas_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(30) = "vas_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(31) = "vas_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(32) = "vas_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(33) = "vas_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(34) = "vas_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(3)  = "vas_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2.5x2.5.nc"
;    out_name(35) = "vas_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2.5x2.5.nc"
;    out_name(36) = "vas_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2.5x2.5.nc"

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
     vas  = in->vas
;     ts   = lonFlip (in->ts)
;     ts   = short2flt (in->ts)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     vas   = in[:]->vas
     time  = in[:]->time
     delete (files)
    end if

;    printVarSummary (vas)
;    printVarSummary (time)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    print (i+" Regriding...")

;Regrid the data
    vas_regrid = ESMF_regrid (vas,Opt)
;    printVarSummary (ts_regrid)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim = dimsizes (vas_regrid)
lat = vas_regrid&lat
lon = vas_regrid&lon

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
filevardef (fout,"vas", typeof(vas_regrid),getvardims(vas_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"vas", vas_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->vas  = (/vas_regrid/)

delete ([/in,vas,time,vas_regrid,fout/])      ;will change next iteration

end do

end
