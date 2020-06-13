;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2x2 degree global grid
;Mission:
;
;   1. Read data from ts datasets
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
;   var--------------ts
;================================================

    a      = addfile ("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
    lsdata = a->LSMASK

;data
;    in_path     = "~/data-model/CMIP5-RCP/atmos/mon/ts/"
    in_path     = "~/data-model/CMIP5-Historical/atmos/mon/ts/"
    in_name     = new(49,string)
/;
    in_name(0)  = "ACCESS1-0/ts_Amon_ACCESS1-0_rcp85_r1i1p1_200601-210012.nc"
    in_name(1)  = "ACCESS1-3/ts_Amon_ACCESS1-3_rcp85_r1i1p1_200601-210012.nc"
    in_name(2)  = "bcc-csm1-1/ts_Amon_bcc-csm1-1_rcp85_r1i1p1_*.nc"             ;200601-230012
    in_name(3)  = "CanESM2/ts_Amon_CanESM2_rcp85_r1i1p1_200601-210012.nc"
    in_name(4)  = "CMCC-CESM/ts_Amon_CMCC-CESM_rcp85_r1i1p1_*.nc"               ;200601-210012
    in_name(5)  = "CMCC-CM/ts_Amon_CMCC-CM_rcp85_r1i1p1_*.nc"
    in_name(6)  = "CMCC-CMS/ts_Amon_CMCC-CMS_rcp85_r1i1p1_*.nc"
    in_name(7)  = "CNRM-CM5/ts_Amon_CNRM-CM5_rcp85_r1i1p1_*.nc"                 ;200601-230012
    in_name(8)  = "CSIRO-Mk3-6-0/ts_Amon_CSIRO-Mk3-6-0_rcp85_r1i1p1_*.nc"
    in_name(9)  = "GFDL-CM3/ts_Amon_GFDL-CM3_rcp85_r1i1p1_*.nc"                 ;200601-210012
    in_name(10) = "GFDL-ESM2G/ts_Amon_GFDL-ESM2G_rcp85_r1i1p1_*.nc"
    in_name(11) = "GFDL-ESM2M/ts_Amon_GFDL-ESM2M_rcp85_r1i1p1_*.nc"
    in_name(12) = "GISS-E2-H/ts_Amon_GISS-E2-H_rcp85_r1i1p1_*.nc"               ;200601-230012
    in_name(13) = "GISS-E2-H-CC/ts_Amon_GISS-E2-H-CC_rcp85_r1i1p1_*.nc"         ;200601-210012
    in_name(14) = "GISS-E2-R/ts_Amon_GISS-E2-R_rcp85_r1i1p1_*.nc"               ;200601-230012
    in_name(15) = "GISS-E2-R-CC/ts_Amon_GISS-E2-R-CC_rcp85_r1i1p1_*.nc"         ;200601-210012
    in_name(16) = "HadGEM2-CC/ts_Amon_HadGEM2-CC_rcp85_r1i1p1_*.nc"             ;200512-210012
    in_name(17) = "HadGEM2-ES/ts_Amon_HadGEM2-ES_rcp85_r1i1p1_*.nc"             ;200512-229912
    in_name(18) = "inmcm4/ts_Amon_inmcm4_rcp85_r1i1p1_200601-210012.nc"
    in_name(19) = "IPSL-CM5A-LR/ts_Amon_IPSL-CM5A-LR_rcp85_r1i1p1_200601-230012.nc"
    in_name(20) = "IPSL-CM5A-MR/ts_Amon_IPSL-CM5A-MR_rcp85_r1i1p1_200601-210012.nc"
    in_name(21) = "IPSL-CM5B-LR/ts_Amon_IPSL-CM5B-LR_rcp85_r1i1p1_200601-210012.nc"
    in_name(22) = "MIROC5/ts_Amon_MIROC5_rcp85_r1i1p1_200601-210012.nc"
    in_name(23) = "MIROC-ESM/ts_Amon_MIROC-ESM_rcp85_r1i1p1_200601-210012.nc"
    in_name(24) = "MIROC-ESM-CHEM/ts_Amon_MIROC-ESM-CHEM_rcp85_r1i1p1_200601-210012.nc"
    in_name(25) = "MPI-ESM-LR/ts_Amon_MPI-ESM-LR_rcp85_r1i1p1_*.nc"             ;200601-230012
    in_name(26) = "MPI-ESM-MR/ts_Amon_MPI-ESM-MR_rcp85_r1i1p1_200601-210012.nc"
    in_name(27) = "MRI-CGCM3/ts_Amon_MRI-CGCM3_rcp85_r1i1p1_200601-210012.nc"
    in_name(28) = "NorESM1-M/ts_Amon_NorESM1-M_rcp85_r1i1p1_200601-210012.nc"
    in_name(29) = "NorESM1-ME/ts_Amon_NorESM1-ME_rcp85_r1i1p1_*.nc"             ;200601-210012

    in_name(0)  = "ACCESS1-0/ts_Amon_ACCESS1-0_rcp45_r1i1p1_200601-210012.nc"
    in_name(0)  = "ACCESS1-3/ts_Amon_ACCESS1-3_rcp45_r1i1p1_200601-210012.nc"
    in_name(1)  = "bcc-csm1-1/ts_Amon_bcc-csm1-1_rcp45_r1i1p1_*.nc"             ;200601-230012
    in_name(2)  = "CanESM2/ts_Amon_CanESM2_rcp45_r1i1p1_*.nc"
    in_name(0)  = "CMCC-CM/ts_Amon_CMCC-CM_rcp45_r1i1p1_*.nc"                   ;200601-210012
    in_name(1)  = "CMCC-CMS/ts_Amon_CMCC-CMS_rcp45_r1i1p1_*.nc"
    in_name(1)  = "CSIRO-Mk3-6-0/ts_Amon_CSIRO-Mk3-6-0_rcp45_r1i1p1_*.nc"       ;200601-230012
    in_name(3)  = "GFDL-CM2p1/ts_Amon_GFDL-CM2p1_rcp45_r1i1p1_*.nc"             ;200601-206012  !!
    in_name(2)  = "GFDL-CM3/ts_Amon_GFDL-CM3_rcp45_r1i1p1_*.nc"
    in_name(2)  = "GFDL-ESM2G/ts_Amon_GFDL-ESM2G_rcp45_r1i1p1_*.nc"             ;200601-210012
    in_name(3)  = "GFDL-ESM2M/ts_Amon_GFDL-ESM2M_rcp45_r1i1p1_*.nc"
    in_name(4)  = "GISS-E2-H/ts_Amon_GISS-E2-H_rcp45_r1i1p1_*.nc"               ;200601-230012
    in_name(5)  = "GISS-E2-H-CC/ts_Amon_GISS-E2-H-CC_rcp45_r1i1p1_*.nc"         ;200601-210012
    in_name(4)  = "GISS-E2-R/ts_Amon_GISS-E2-R_rcp45_r1i1p1_*.nc"               ;200601-230012
    in_name(5)  = "GISS-E2-R-CC/ts_Amon_GISS-E2-R-CC_rcp45_r1i1p1_*.nc"         ;200601-210012
;!    in_name(28) = "HadCM3/ts_Amon_HadCM3_rcp45_r1i1p1_*.nc"                     ;200601-203512
    in_name(6)  = "HadGEM2-CC/ts_Amon_HadGEM2-CC_rcp45_r1i1p1_*.nc"             ;200512-210012
    in_name(7)  = "HadGEM2-ES/ts_Amon_HadGEM2-ES_rcp45_r1i1p1_*.nc"             ;200512-229912
    in_name(6)  = "inmcm4/ts_Amon_inmcm4_rcp45_r1i1p1_200601-210012.nc"
    in_name(3)  = "IPSL-CM5A-LR/ts_Amon_IPSL-CM5A-LR_rcp45_r1i1p1_200601-230012.nc"
    in_name(7)  = "IPSL-CM5A-MR/ts_Amon_IPSL-CM5A-MR_rcp45_r1i1p1_*.nc"         ;200601-230012
    in_name(8)  = "IPSL-CM5B-LR/ts_Amon_IPSL-CM5B-LR_rcp45_r1i1p1_200601-210012.nc"
    in_name(8)  = "MIROC5/ts_Amon_MIROC5_rcp45_r1i1p1_200601-210012.nc"
    in_name(9)  = "MIROC-ESM/ts_Amon_MIROC-ESM_rcp45_r1i1p1_*.nc"               ;200601-230012
    in_name(4)  = "MIROC-ESM-CHEM/ts_Amon_MIROC-ESM-CHEM_rcp45_r1i1p1_200601-210012.nc"
    in_name(9)  = "MPI-ESM-LR/ts_Amon_MPI-ESM-LR_rcp45_r1i1p1_*.nc"             ;200601-230012
    in_name(10) = "MPI-ESM-MR/ts_Amon_MPI-ESM-MR_rcp45_r1i1p1_200601-210012.nc"
    in_name(5)  = "MRI-CGCM3/ts_Amon_MRI-CGCM3_rcp45_r1i1p1_200601-210012.nc"
    in_name(11) = "NorESM1-M/ts_Amon_NorESM1-M_rcp45_r1i1p1_*.nc"               ;200601-230012
    in_name(6)  = "NorESM1-ME/ts_Amon_NorESM1-ME_rcp45_r1i1p1_200601-210212.nc"
;/
    in_name(0)  = "ACCESS1-0/ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name(1)  = "ACCESS1-3/ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
    in_name(2)  = "bcc-csm1-1/ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
    in_name(3)  = "bcc-csm1-1-m/ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212.nc"
    in_name(4)  = "BNU-ESM/ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(5)  = "CanCM4/ts_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
    in_name(6)  = "CanESM2/ts_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
    in_name(7)  = "CCSM4/ts_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
    in_name(8)  = "CESM1-BGC/ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
    in_name(9)  = "CESM1-CAM5/ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
    in_name(10) = "CESM1-CAM5-1-FV2/ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
    in_name(11) = "CESM1-FASTCHEM/ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512.nc"
    in_name(12) = "CESM1-WACCM/ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
    in_name(13) = "CMCC-CESM/ts_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(14) = "CMCC-CM/ts_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name(15) = "CMCC-CMS/ts_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
    in_name(16) = "CNRM-CM5/ts_Amon_CNRM-CM5_historical_r1i1p1_*.nc" 
    in_name(17) = "CNRM-CM5-2/ts_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"        ;185001-200512
    in_name(18) = "CSIRO-Mk3-6-0/ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
    in_name(19) = "FGOALS-g2/ts_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;190001-201412
    in_name(20) = "FGOALS-s2/ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
    in_name(21) = "FIO-ESM/ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(22) = "GFDL-CM2p1/ts_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"        ;186101-200512
    in_name(23) = "GFDL-CM3/ts_Amon_GFDL-CM3_historical_r1i1p1_*.nc"            ;186001-200512
    in_name(24) = "GFDL-ESM2G/ts_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"        ;186101-200512
    in_name(25) = "GFDL-ESM2M/ts_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
    in_name(26) = "GISS-E2-H/ts_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(27) = "GISS-E2-H-CC/ts_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"    ;185001-201012
    in_name(28) = "GISS-E2-R/ts_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
    in_name(29) = "GISS-E2-R-CC/ts_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"    ;185001-201012
    in_name(30) = "HadCM3/ts_Amon_HadCM3_historical_r1i1p1_*.nc"                ;185912-200512
    in_name(31) = "HadGEM2-AO/ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
    in_name(32) = "HadGEM2-CC/ts_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"        ;185912-200511
    in_name(33) = "HadGEM2-ES/ts_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
    in_name(34) = "inmcm4/ts_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
    in_name(35) = "IPSL-CM5A-LR/ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name(36) = "IPSL-CM5A-MR/ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name(37) = "IPSL-CM5B-LR/ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name(38) = "MIROC4h/ts_Amon_MIROC4h_historical_r1i1p1_*.nc"              ;195001-200512
    in_name(39) = "MIROC5/ts_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
    in_name(40) = "MIROC-ESM/ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
    in_name(41) = "MIROC-ESM-CHEM/ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
    in_name(42) = "MPI-ESM-LR/ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
    in_name(43) = "MPI-ESM-MR/ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name(44) = "MPI-ESM-P/ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
    in_name(45) = "MRI-CGCM3/ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name(46) = "MRI-ESM1/ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
    in_name(47) = "NorESM1-M/ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name(48) = "NorESM1-ME/ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod = dimsizes (in_name)

;    single = (/True,True,False,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,True,True,True,True,True,\
;               True,True,False,True,True,True,False/)
    single = (/True,True,True,True,True,True,True,True,True,True,True,True,True,False,False,False,False,False,True,False,True,True,False,False,False,\
               False,False,False,False,False,False,True,False,False,True,True,True,True,False,True,True,True,True,True,True,True,True,True,True/)

;output
;    out_path     = "~/data-model/CMIP5-hes/ts/rcp85/"
;    out_path     = "~/data-model/CMIP5-hes/ts/rcp45/"
;    out_path     = "~/data-model/CMIP5-hes/ts/historical/"
    out_path     = "~/data-model/CMIP5-hes/ts-land/historical/"
    out_name      = new(nmod,string)
/;
    out_name(0)  = "ts_Amon_ACCESS1-0_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(1)  = "ts_Amon_ACCESS1-3_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(2)  = "ts_Amon_bcc-csm1-1_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(3)  = "ts_Amon_CanESM2_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(4)  = "ts_Amon_CMCC-CESM_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(5)  = "ts_Amon_CMCC-CM_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(6)  = "ts_Amon_CMCC-CMS_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(7)  = "ts_Amon_CNRM-CM5_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(8)  = "ts_Amon_CSIRO-Mk3-6-0_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(9)  = "ts_Amon_GFDL-CM3_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(10) = "ts_Amon_GFDL-ESM2G_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(11) = "ts_Amon_GFDL-ESM2M_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(12) = "ts_Amon_GISS-E2-H_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(13) = "ts_Amon_GISS-E2-H-CC_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(14) = "ts_Amon_GISS-E2-R_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(15) = "ts_Amon_GISS-E2-R-CC_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(16) = "ts_Amon_HadGEM2-CC_rcp85_r1i1p1_200512-210012_2x2.nc"
    out_name(17) = "ts_Amon_HadGEM2-ES_rcp85_r1i1p1_200512-229912_2x2.nc"
    out_name(18) = "ts_Amon_inmcm4_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(19) = "ts_Amon_IPSL-CM5A-LR_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(20) = "ts_Amon_IPSL-CM5A-MR_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(21) = "ts_Amon_IPSL-CM5B-LR_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(22) = "ts_Amon_MIROC5_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(23) = "ts_Amon_MIROC-ESM_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(24) = "ts_Amon_MIROC-ESM-CHEM_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(25) = "ts_Amon_MPI-ESM-LR_rcp85_r1i1p1_200601-230012_2x2.nc"
    out_name(26) = "ts_Amon_MPI-ESM-MR_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(27) = "ts_Amon_MRI-CGCM3_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(28) = "ts_Amon_NorESM1-M_rcp85_r1i1p1_200601-210012_2x2.nc"
    out_name(29) = "ts_Amon_NorESM1-ME_rcp85_r1i1p1_200601-210012_2x2.nc"

    out_name(0)  = "ts_Amon_ACCESS1-0_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(0)  = "ts_Amon_ACCESS1-3_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(1)  = "ts_Amon_bcc-csm1-1_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(2)  = "ts_Amon_CanESM2_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(0)  = "ts_Amon_CMCC-CM_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(1)  = "ts_Amon_CMCC-CMS_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(1)  = "ts_Amon_CSIRO-Mk3-6-0_rcp45_r1i1p1_200601-230012_2x2.nc"
;    out_name(3)  = "ts_Amon_GFDL-CM2p1_rcp45_r1i1p1_200601-206012_2x2.nc"             ;!!
    out_name(2)  = "ts_Amon_GFDL-CM3_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(2)  = "ts_Amon_GFDL-ESM2G_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(3)  = "ts_Amon_GFDL-ESM2M_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(4)  = "ts_Amon_GISS-E2-H_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(5)  = "ts_Amon_GISS-E2-H-CC_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(4)  = "ts_Amon_GISS-E2-R_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(5)  = "ts_Amon_GISS-E2-R-CC_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(6)  = "ts_Amon_HadGEM2-CC_rcp45_r1i1p1_200512-210012_2x2.nc"
    out_name(7)  = "ts_Amon_HadGEM2-ES_rcp45_r1i1p1_200512-229912_2x2.nc"
    out_name(6)  = "ts_Amon_inmcm4_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(3)  = "ts_Amon_IPSL-CM5A-LR_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(7)  = "ts_Amon_IPSL-CM5A-MR_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(8)  = "ts_Amon_IPSL-CM5B-LR_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(8)  = "ts_Amon_MIROC5_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(9)  = "ts_Amon_MIROC-ESM_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(4)  = "ts_Amon_MIROC-ESM-CHEM_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(9)  = "ts_Amon_MPI-ESM-LR_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(10) = "ts_Amon_MPI-ESM-MR_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(5)  = "ts_Amon_MRI-CGCM3_rcp45_r1i1p1_200601-210012_2x2.nc"
    out_name(11) = "ts_Amon_NorESM1-M_rcp45_r1i1p1_200601-230012_2x2.nc"
    out_name(6)  = "ts_Amon_NorESM1-ME_rcp45_r1i1p1_200601-210212_2x2.nc"
;/
    out_name(0)  = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(1)  = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(2)  = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
    out_name(3)  = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
    out_name(4)  = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(5)  = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
    out_name(6)  = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(7)  = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(8)  = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(9)  = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(10) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(11) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(12) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(13) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(14) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(15) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(16) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(17) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(18) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(19) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
    out_name(20) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(21) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(22) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
    out_name(23) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
    out_name(24) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
    out_name(25) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
    out_name(26) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(27) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
    out_name(28) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(29) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
    out_name(30) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
    out_name(31) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
    out_name(32) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
    out_name(33) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
    out_name(34) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(35) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(36) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(37) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(38) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
    out_name(39) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
    out_name(40) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(41) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(42) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(43) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(44) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(45) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(46) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
    out_name(47) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
    out_name(48) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"

;Set up options for regridding
    Opt = True

    Opt@SrcTitle    = "CMIP Grid"
;    Opt@SrcRegional = True
    Opt@WgtFileName = "CMIP_2_2x2.nc"
    Opt@SrcFileName = "src_SCRIP_CMIP.nc"

;    Opt@DstRegional = True
    Opt@DstGridType = "2x2"
    Opt@DstLLCorner = (/ -88,   0/)
    Opt@DstURCorner = (/  88, 358/)

;    Opt@InterpMethod   = "bilinear"
    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

do i = 0, nmod-1
    
    if (single(i)) then
     in   = addfile (in_path + in_name(i),"r")
     ts   = in->ts
;     ts   = lonFlip (in->ts)
;     ts   = short2flt (in->ts)
     time = in->time
    else
     files = systemfunc ("ls "+in_path + in_name(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in    = addfiles (files,"r")
     ListSetType (in, "cat")
     ts    = in[:]->ts
     time  = in[:]->time
     delete (files)
    end if

    ts = where (ts.lt.-1.8+273.15,-1.8+273.15,ts)
;    printVarSummary (ts)
;    printVarSummary (time)

;masking of data
    lsm = landsea_mask (lsdata,ts&lat,ts&lon)
    lmask = where (lsm.eq.1.or.lsm.eq.3.or.lsm.eq.4 , 0, 1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    print (i+" Regriding...")

;    Opt@SrcMask2D = lmask
;    Opt@SrcInputFileName = in_path + in_name(i)

;Regrid the data
    ts_regrid = ESMF_regrid (ts,Opt)
    ts_regrid = where (ts_regrid.lt.-1.8+273.15,-1.8+273.15,ts_regrid)
;    printVarSummary (ts_regrid)
    print (min(ts_regrid)-273.15)

;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim = dimsizes (ts_regrid)
lat = ts_regrid&lat
lon = ts_regrid&lon

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
filevardef (fout,"lat" ,typeof(lat),      getvardims(lat))
filevardef (fout,"lon" ,typeof(lon),      getvardims(lon))
filevardef (fout,"ts",  typeof(ts_regrid),getvardims(ts_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout,"time",time)
filevarattdef (fout,"lat", lat)
filevarattdef (fout,"lon", lon)
filevarattdef (fout,"ts",  ts_regrid)

;output only the data values
fout->time = (/time/)
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->ts   = (/ts_regrid/)

delete ([/in,ts,time,lsm,lmask,Opt@SrcMask2D,ts_regrid,fout/])      ;will change next iteration

end do

end
