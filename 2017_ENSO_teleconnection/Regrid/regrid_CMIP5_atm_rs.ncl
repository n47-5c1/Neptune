;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2.5x2.5 degree global grid
;Mission:
;
;   1. Read data from rlds, rlus, rsds & rsus datasets
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
;   var--------------rlds
;   var--------------rlus
;   var--------------rsds
;   var--------------rsus
;================================================

    in_name1  = new(19,string)
    in_name2  = new(19,string)
    in_name3  = new(19,string)
    in_name4  = new(19,string)
    out_name1 = new(19,string)
    out_name2 = new(19,string)
    out_name3 = new(19,string)
    out_name4 = new(19,string)

;data
    in_path      = "~/data-model/CMIP5/"
    in_name1(0)  = "ACCESS1-0/ACCESS1-0_Amon_historical_r1i1p1/rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name1(1)  = "ACCESS1-3/ACCESS1-3_Amon_historical_r1i1p1/rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name1(1)  = "bcc-csm1-1/bcc-csm1-1_Amon_historical_r1i1p1/rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;;    in_name1(3)  = "BNU-ESM/ua_Amon_BNU-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name1(2)  = "CanCM4/CanCM4_Amon_historical_r1i1p1/rlds_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name1(3)  = "CanESM2/CanESM2_Amon_historical_r1i1p1/rlds_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name1(4)  = "CCSM4/CCSM4_Amon_historical_r1i1p1/rlds_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;;    in_name1(7)  = "CESM1-BGC/ua_Amon_CESM1-BGC_historical_r1i1p1_185001-200512.nc"
;    in_name1(5)  = "CESM1-CAM5/CESM1-CAM5_Amon_historical_r1i1p1/rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
;;    in_name1(10) = "CESM1-CAM5-1-FV2/ua_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512.nc"
;;    in_name1(9)  = "CESM1-FASTCHEM/ua_Amon_CESM1-FASTCHEM_historical_r1i1p1_*.nc"
;;    in_name1(10) = "CESM1-WACCM/ua_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512.nc"
    in_name1(2)  = "CMCC-CESM/CMCC-CESM_Amon_historical_r1i1p1/rlds_Amon_CMCC-CESM_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name1(6)  = "CMCC-CM/CMCC-CM_Amon_historical_r1i1p1/rlds_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name1(3)  = "CMCC-CMS/CMCC-CMS_Amon_historical_r1i1p1/rlds_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name1(7)  = "CNRM-CM5/CNRM-CM5_Amon_historical_r1i1p1/rlds_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name1(4)  = "CNRM-CM5-2/CNRM-CM5-2_Amon_historical_r1i1p1/rlds_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
    in_name1(5)  = "CSIRO-Mk3-6-0/CSIRO-Mk3-6-0_Amon_historical_r1i1p1/rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;;    in_name1(16) = "EC-EARTH/"
;    in_name1(8)  = "FGOALS-g2/FGOALS-g2_Amon_historical_r1i1p1/rlds_Amon_FGOALS-g2_historical_r1i1p1_*.nc"          ;185001-200512
;    in_name1(9)  = "FGOALS-s2/FGOALS-s2_Amon_historical_r1i1p1/rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;;    in_name1(18) = "FIO-ESM/ua_Amon_FIO-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name1(10) = "GFDL-CM2p1/GFDL-CM2p1_Amon_historical_r1i1p1/rlds_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"       ;186101-204012
    in_name1(6)  = "GFDL-CM3/GFDL-CM3_Amon_historical_r1i1p1/rlds_Amon_GFDL-CM3_historical_r1i1p1_*.nc"             ;186001-200512
    in_name1(7)  = "GFDL-ESM2G/GFDL-ESM2G_Amon_historical_r1i1p1/rlds_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"       ;186101-200512
    in_name1(8)  = "GFDL-ESM2M/GFDL-ESM2M_Amon_historical_r1i1p1/rlds_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name1(11) = "GISS-E2-H/GISS-E2-H_Amon_historical_r1i1p1/rlds_Amon_GISS-E2-H_historical_r1i1p1_*.nc"          ;185001-200512
    in_name1(9)  = "GISS-E2-H-CC/GISS-E2-H-CC_Amon_historical_r1i1p1/rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc" ;185001-201012
;    in_name1(12) = "GISS-E2-R/GISS-E2-R_Amon_historical_r1i1p1/rlds_Amon_GISS-E2-R_historical_r1i1p1_*.nc"          ;185001-200512
    in_name1(10) = "GISS-E2-R-CC/GISS-E2-R-CC_Amon_historical_r1i1p1/rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc" ;185001-201012
;    in_name1(13) = "HadCM3/HadCM3_Amon_historical_r1i1p1/rlds_Amon_HadCM3_historical_r1i1p1_*.nc"                   ;185912-200512
;*    in_name1(28) = "HadGEM2-AO/HadGEM2-AO_Amon_historical_r1i1p1/rlds_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"   ;rlds/rsds
    in_name1(11) = "HadGEM2-CC/HadGEM2-CC_Amon_historical_r1i1p1/rlds_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"       ;185912-200511
    in_name1(12) = "HadGEM2-ES/HadGEM2-ES_Amon_historical_r1i1p1/rlds_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name1(14) = "inmcm4/inmcm4_Amon_historical_r1i1p1/rlds_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name1(15) = "IPSL-CM5A-LR/IPSL-CM5A-LR_Amon_historical_r1i1p1/rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name1(13) = "IPSL-CM5A-MR/IPSL-CM5A-MR_Amon_historical_r1i1p1/rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name1(14) = "IPSL-CM5B-LR/IPSL-CM5B-LR_Amon_historical_r1i1p1/rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name1(15) = "MIROC4h/MIROC4h_Amon_historical_r1i1p1/rlds_Amon_MIROC4h_historical_r1i1p1_*.nc"                ;195001-200512
;    in_name1(16) = "MIROC5/MIROC5_Amon_historical_r1i1p1/rlds_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name1(17) = "MIROC-ESM/MIROC-ESM_Amon_historical_r1i1p1/rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name1(18) = "MIROC-ESM-CHEM/MIROC-ESM-CHEM_Amon_historical_r1i1p1/rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name1(19) = "MPI-ESM-LR/MPI-ESM-LR_Amon_historical_r1i1p1/rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name1(20) = "MPI-ESM-MR/MPI-ESM-MR_Amon_historical_r1i1p1/rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name1(16) = "MPI-ESM-P/MPI-ESM-P_Amon_historical_r1i1p1/rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name1(21) = "MRI-CGCM3/MRI-CGCM3_Amon_historical_r1i1p1/rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name1(17) = "MRI-ESM1/MRI-ESM1_Amon_historical_r1i1p1/rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name1(22) = "NorESM1-M/NorESM1-M_Amon_historical_r1i1p1/rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name1(18) = "NorESM1-ME/NorESM1-ME_Amon_historical_r1i1p1/rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"
    nmod = dimsizes (in_name1)

    in_name2(0)  = "ACCESS1-0/ACCESS1-0_Amon_historical_r1i1p1/rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name2(1)  = "ACCESS1-3/ACCESS1-3_Amon_historical_r1i1p1/rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name2(1)  = "bcc-csm1-1/bcc-csm1-1_Amon_historical_r1i1p1/rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name2(2)  = "CanCM4/CanCM4_Amon_historical_r1i1p1/rlus_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name2(3)  = "CanESM2/CanESM2_Amon_historical_r1i1p1/rlus_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name2(4)  = "CCSM4/CCSM4_Amon_historical_r1i1p1/rlus_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name2(5)  = "CESM1-CAM5/CESM1-CAM5_Amon_historical_r1i1p1/rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
    in_name2(2)  = "CMCC-CESM/CMCC-CESM_Amon_historical_r1i1p1/rlus_Amon_CMCC-CESM_historical_r1i1p1_*.nc"
;    in_name2(6)  = "CMCC-CM/CMCC-CM_Amon_historical_r1i1p1/rlus_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name2(3)  = "CMCC-CMS/CMCC-CMS_Amon_historical_r1i1p1/rlus_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name2(7)  = "CNRM-CM5/CNRM-CM5_Amon_historical_r1i1p1/rlus_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name2(4)  = "CNRM-CM5-2/CNRM-CM5-2_Amon_historical_r1i1p1/rlus_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
    in_name2(5)  = "CSIRO-Mk3-6-0/CSIRO-Mk3-6-0_Amon_historical_r1i1p1/rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name2(8)  = "FGOALS-g2/FGOALS-g2_Amon_historical_r1i1p1/rlus_Amon_FGOALS-g2_historical_r1i1p1_*.nc"
;    in_name2(9)  = "FGOALS-s2/FGOALS-s2_Amon_historical_r1i1p1/rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name2(10) = "GFDL-CM2p1/GFDL-CM2p1_Amon_historical_r1i1p1/rlus_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"
    in_name2(6)  = "GFDL-CM3/GFDL-CM3_Amon_historical_r1i1p1/rlus_Amon_GFDL-CM3_historical_r1i1p1_*.nc"
    in_name2(7)  = "GFDL-ESM2G/GFDL-ESM2G_Amon_historical_r1i1p1/rlus_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"
    in_name2(8)  = "GFDL-ESM2M/GFDL-ESM2M_Amon_historical_r1i1p1/rlus_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name2(11) = "GISS-E2-H/GISS-E2-H_Amon_historical_r1i1p1/rlus_Amon_GISS-E2-H_historical_r1i1p1_*.nc"
    in_name2(9)  = "GISS-E2-H-CC/GISS-E2-H-CC_Amon_historical_r1i1p1/rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"
;    in_name2(12) = "GISS-E2-R/GISS-E2-R_Amon_historical_r1i1p1/rlus_Amon_GISS-E2-R_historical_r1i1p1_*.nc"
    in_name2(10) = "GISS-E2-R-CC/GISS-E2-R-CC_Amon_historical_r1i1p1/rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"
;    in_name2(13) = "HadCM3/HadCM3_Amon_historical_r1i1p1/rlus_Amon_HadCM3_historical_r1i1p1_*.nc"
    in_name2(11) = "HadGEM2-CC/HadGEM2-CC_Amon_historical_r1i1p1/rlus_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"
    in_name2(12) = "HadGEM2-ES/HadGEM2-ES_Amon_historical_r1i1p1/rlus_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name2(14) = "inmcm4/inmcm4_Amon_historical_r1i1p1/rlus_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name2(15) = "IPSL-CM5A-LR/IPSL-CM5A-LR_Amon_historical_r1i1p1/rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name2(13) = "IPSL-CM5A-MR/IPSL-CM5A-MR_Amon_historical_r1i1p1/rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name2(14) = "IPSL-CM5B-LR/IPSL-CM5B-LR_Amon_historical_r1i1p1/rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name2(15) = "MIROC4h/MIROC4h_Amon_historical_r1i1p1/rlus_Amon_MIROC4h_historical_r1i1p1_*.nc"
;    in_name2(16) = "MIROC5/MIROC5_Amon_historical_r1i1p1/rlus_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name2(17) = "MIROC-ESM/MIROC-ESM_Amon_historical_r1i1p1/rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name2(18) = "MIROC-ESM-CHEM/MIROC-ESM-CHEM_Amon_historical_r1i1p1/rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name2(19) = "MPI-ESM-LR/MPI-ESM-LR_Amon_historical_r1i1p1/rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name2(20) = "MPI-ESM-MR/MPI-ESM-MR_Amon_historical_r1i1p1/rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name2(16) = "MPI-ESM-P/MPI-ESM-P_Amon_historical_r1i1p1/rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name2(21) = "MRI-CGCM3/MRI-CGCM3_Amon_historical_r1i1p1/rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name2(17) = "MRI-ESM1/MRI-ESM1_Amon_historical_r1i1p1/rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name2(22) = "NorESM1-M/NorESM1-M_Amon_historical_r1i1p1/rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name2(18) = "NorESM1-ME/NorESM1-ME_Amon_historical_r1i1p1/rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"

    in_name3(0)  = "ACCESS1-0/ACCESS1-0_Amon_historical_r1i1p1/rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name3(1)  = "ACCESS1-3/ACCESS1-3_Amon_historical_r1i1p1/rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name3(1)  = "bcc-csm1-1/bcc-csm1-1_Amon_historical_r1i1p1/rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name3(2)  = "CanCM4/CanCM4_Amon_historical_r1i1p1/rsds_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name3(3)  = "CanESM2/CanESM2_Amon_historical_r1i1p1/rsds_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name3(4)  = "CCSM4/CCSM4_Amon_historical_r1i1p1/rsds_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name3(5)  = "CESM1-CAM5/CESM1-CAM5_Amon_historical_r1i1p1/rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
    in_name3(2)  = "CMCC-CESM/CMCC-CESM_Amon_historical_r1i1p1/rsds_Amon_CMCC-CESM_historical_r1i1p1_*.nc"
;    in_name3(6)  = "CMCC-CM/CMCC-CM_Amon_historical_r1i1p1/rsds_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name3(3)  = "CMCC-CMS/CMCC-CMS_Amon_historical_r1i1p1/rsds_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name3(7)  = "CNRM-CM5/CNRM-CM5_Amon_historical_r1i1p1/rsds_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name3(4)  = "CNRM-CM5-2/CNRM-CM5-2_Amon_historical_r1i1p1/rsds_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
    in_name3(5)  = "CSIRO-Mk3-6-0/CSIRO-Mk3-6-0_Amon_historical_r1i1p1/rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name3(8)  = "FGOALS-g2/FGOALS-g2_Amon_historical_r1i1p1/rsds_Amon_FGOALS-g2_historical_r1i1p1_*.nc"
;    in_name3(9)  = "FGOALS-s2/FGOALS-s2_Amon_historical_r1i1p1/rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name3(10) = "GFDL-CM2p1/GFDL-CM2p1_Amon_historical_r1i1p1/rsds_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"
    in_name3(6)  = "GFDL-CM3/GFDL-CM3_Amon_historical_r1i1p1/rsds_Amon_GFDL-CM3_historical_r1i1p1_*.nc"
    in_name3(7)  = "GFDL-ESM2G/GFDL-ESM2G_Amon_historical_r1i1p1/rsds_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"
    in_name3(8)  = "GFDL-ESM2M/GFDL-ESM2M_Amon_historical_r1i1p1/rsds_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name3(11) = "GISS-E2-H/GISS-E2-H_Amon_historical_r1i1p1/rsds_Amon_GISS-E2-H_historical_r1i1p1_*.nc"
    in_name3(9)  = "GISS-E2-H-CC/GISS-E2-H-CC_Amon_historical_r1i1p1/rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"
;    in_name3(12) = "GISS-E2-R/GISS-E2-R_Amon_historical_r1i1p1/rsds_Amon_GISS-E2-R_historical_r1i1p1_*.nc"
    in_name3(10) = "GISS-E2-R-CC/GISS-E2-R-CC_Amon_historical_r1i1p1/rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"
;    in_name3(13) = "HadCM3/HadCM3_Amon_historical_r1i1p1/rsds_Amon_HadCM3_historical_r1i1p1_*.nc"
;/    in_name3(28) = "HadGEM2-AO/HadGEM2-AO_Amon_historical_r1i1p1/rsds_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512.nc"
    in_name3(11) = "HadGEM2-CC/HadGEM2-CC_Amon_historical_r1i1p1/rsds_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"
    in_name3(12) = "HadGEM2-ES/HadGEM2-ES_Amon_historical_r1i1p1/rsds_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name3(14) = "inmcm4/inmcm4_Amon_historical_r1i1p1/rsds_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name3(15) = "IPSL-CM5A-LR/IPSL-CM5A-LR_Amon_historical_r1i1p1/rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name3(13) = "IPSL-CM5A-MR/IPSL-CM5A-MR_Amon_historical_r1i1p1/rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name3(14) = "IPSL-CM5B-LR/IPSL-CM5B-LR_Amon_historical_r1i1p1/rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name3(15) = "MIROC4h/MIROC4h_Amon_historical_r1i1p1/rsds_Amon_MIROC4h_historical_r1i1p1_*.nc"
;    in_name3(16) = "MIROC5/MIROC5_Amon_historical_r1i1p1/rsds_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name3(17) = "MIROC-ESM/MIROC-ESM_Amon_historical_r1i1p1/rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name3(18) = "MIROC-ESM-CHEM/MIROC-ESM-CHEM_Amon_historical_r1i1p1/rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name3(19) = "MPI-ESM-LR/MPI-ESM-LR_Amon_historical_r1i1p1/rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name3(20) = "MPI-ESM-MR/MPI-ESM-MR_Amon_historical_r1i1p1/rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name3(16) = "MPI-ESM-P/MPI-ESM-P_Amon_historical_r1i1p1/rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name3(21) = "MRI-CGCM3/MRI-CGCM3_Amon_historical_r1i1p1/rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name3(17) = "MRI-ESM1/MRI-ESM1_Amon_historical_r1i1p1/rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name3(22) = "NorESM1-M/NorESM1-M_Amon_historical_r1i1p1/rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name3(18) = "NorESM1-ME/NorESM1-ME_Amon_historical_r1i1p1/rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"

    in_name4(0)  = "ACCESS1-0/ACCESS1-0_Amon_historical_r1i1p1/rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512.nc"
    in_name4(1)  = "ACCESS1-3/ACCESS1-3_Amon_historical_r1i1p1/rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512.nc"
;    in_name4(1)  = "bcc-csm1-1/bcc-csm1-1_Amon_historical_r1i1p1/rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212.nc"
;    in_name4(2)  = "CanCM4/CanCM4_Amon_historical_r1i1p1/rsus_Amon_CanCM4_historical_r1i1p1_196101-200512.nc"
;    in_name4(3)  = "CanESM2/CanESM2_Amon_historical_r1i1p1/rsus_Amon_CanESM2_historical_r1i1p1_185001-200512.nc"
;    in_name4(4)  = "CCSM4/CCSM4_Amon_historical_r1i1p1/rsus_Amon_CCSM4_historical_r1i1p1_185001-200512.nc"
;    in_name4(5)  = "CESM1-CAM5/CESM1-CAM5_Amon_historical_r1i1p1/rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512.nc"
    in_name4(2)  = "CMCC-CESM/CMCC-CESM_Amon_historical_r1i1p1/rsus_Amon_CMCC-CESM_historical_r1i1p1_*.nc"
;    in_name4(6)  = "CMCC-CM/CMCC-CM_Amon_historical_r1i1p1/rsus_Amon_CMCC-CM_historical_r1i1p1_*.nc"
    in_name4(3)  = "CMCC-CMS/CMCC-CMS_Amon_historical_r1i1p1/rsus_Amon_CMCC-CMS_historical_r1i1p1_*.nc"
;    in_name4(7)  = "CNRM-CM5/CNRM-CM5_Amon_historical_r1i1p1/rsus_Amon_CNRM-CM5_historical_r1i1p1_*.nc"
    in_name4(4)  = "CNRM-CM5-2/CNRM-CM5-2_Amon_historical_r1i1p1/rsus_Amon_CNRM-CM5-2_historical_r1i1p1_*.nc"
    in_name4(5)  = "CSIRO-Mk3-6-0/CSIRO-Mk3-6-0_Amon_historical_r1i1p1/rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512.nc"
;    in_name4(8)  = "FGOALS-g2/FGOALS-g2_Amon_historical_r1i1p1/rsus_Amon_FGOALS-g2_historical_r1i1p1_*.nc"
;    in_name4(9)  = "FGOALS-s2/FGOALS-s2_Amon_historical_r1i1p1/rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512.nc"
;    in_name4(10) = "GFDL-CM2p1/GFDL-CM2p1_Amon_historical_r1i1p1/rsus_Amon_GFDL-CM2p1_historical_r1i1p1_*.nc"
    in_name4(6)  = "GFDL-CM3/GFDL-CM3_Amon_historical_r1i1p1/rsus_Amon_GFDL-CM3_historical_r1i1p1_*.nc"
    in_name4(7)  = "GFDL-ESM2G/GFDL-ESM2G_Amon_historical_r1i1p1/rsus_Amon_GFDL-ESM2G_historical_r1i1p1_*.nc"
    in_name4(8)  = "GFDL-ESM2M/GFDL-ESM2M_Amon_historical_r1i1p1/rsus_Amon_GFDL-ESM2M_historical_r1i1p1_*.nc"
;    in_name4(11) = "GISS-E2-H/GISS-E2-H_Amon_historical_r1i1p1/rsus_Amon_GISS-E2-H_historical_r1i1p1_*.nc"
    in_name4(9)  = "GISS-E2-H-CC/GISS-E2-H-CC_Amon_historical_r1i1p1/rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_*.nc"
;    in_name4(12) = "GISS-E2-R/GISS-E2-R_Amon_historical_r1i1p1/rsus_Amon_GISS-E2-R_historical_r1i1p1_*.nc"
    in_name4(10) = "GISS-E2-R-CC/GISS-E2-R-CC_Amon_historical_r1i1p1/rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_*.nc"
;    in_name4(13) = "HadCM3/HadCM3_Amon_historical_r1i1p1/rsus_Amon_HadCM3_historical_r1i1p1_*.nc"
    in_name4(11) = "HadGEM2-CC/HadGEM2-CC_Amon_historical_r1i1p1/rsus_Amon_HadGEM2-CC_historical_r1i1p1_*.nc"
    in_name4(12) = "HadGEM2-ES/HadGEM2-ES_Amon_historical_r1i1p1/rsus_Amon_HadGEM2-ES_historical_r1i1p1_*.nc"
;    in_name4(14) = "inmcm4/inmcm4_Amon_historical_r1i1p1/rsus_Amon_inmcm4_historical_r1i1p1_185001-200512.nc"
;    in_name4(15) = "IPSL-CM5A-LR/IPSL-CM5A-LR_Amon_historical_r1i1p1/rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
    in_name4(13) = "IPSL-CM5A-MR/IPSL-CM5A-MR_Amon_historical_r1i1p1/rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512.nc"
    in_name4(14) = "IPSL-CM5B-LR/IPSL-CM5B-LR_Amon_historical_r1i1p1/rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512.nc"
    in_name4(15) = "MIROC4h/MIROC4h_Amon_historical_r1i1p1/rsus_Amon_MIROC4h_historical_r1i1p1_*.nc"            ;
;    in_name4(16) = "MIROC5/MIROC5_Amon_historical_r1i1p1/rsus_Amon_MIROC5_historical_r1i1p1_185001-201212.nc"
;    in_name4(17) = "MIROC-ESM/MIROC-ESM_Amon_historical_r1i1p1/rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512.nc"
;    in_name4(18) = "MIROC-ESM-CHEM/MIROC-ESM-CHEM_Amon_historical_r1i1p1/rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512.nc"
;    in_name4(19) = "MPI-ESM-LR/MPI-ESM-LR_Amon_historical_r1i1p1/rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512.nc"
;    in_name4(20) = "MPI-ESM-MR/MPI-ESM-MR_Amon_historical_r1i1p1/rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512.nc"
    in_name4(16) = "MPI-ESM-P/MPI-ESM-P_Amon_historical_r1i1p1/rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512.nc"
;    in_name4(21) = "MRI-CGCM3/MRI-CGCM3_Amon_historical_r1i1p1/rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512.nc"
    in_name4(17) = "MRI-ESM1/MRI-ESM1_Amon_historical_r1i1p1/rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512.nc"
;    in_name4(22) = "NorESM1-M/NorESM1-M_Amon_historical_r1i1p1/rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512.nc"
    in_name4(18) = "NorESM1-ME/NorESM1-ME_Amon_historical_r1i1p1/rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512.nc"

    single = (/True,True,False,False,False,True,False,False,False,False,False,False,False,True,True,False,True,True,True/)
;    single = (/True,True,True,True,True,True,False,False,False,True,False,False,False,False,True,True,True,True,True,True,True,True,True/)

;output
    out_path1     = "~/data-model/CMIP5-hes/rlds/historical/"
    out_name1(0)  = "rlds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(1)  = "rlds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(1)  = "rlds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name1(2)  = "rlds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name1(3)  = "rlds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(4)  = "rlds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(5)  = "rlds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(2)  = "rlds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(6)  = "rlds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(3)  = "rlds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(7)  = "rlds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(4)  = "rlds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(5)  = "rlds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(8)  = "rlds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(9)  = "rlds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(10) = "rlds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    out_name1(6)  = "rlds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    out_name1(7)  = "rlds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    out_name1(8)  = "rlds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name1(11) = "rlds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(9)  = "rlds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name1(12) = "rlds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(10) = "rlds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name1(13) = "rlds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;*    out_name1(28) = "rlds_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    out_name1(11) = "rlds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    out_name1(12) = "rlds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name1(14) = "rlds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(15) = "rlds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(13) = "rlds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(14) = "rlds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(15) = "rlds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
;    out_name1(16) = "rlds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name1(17) = "rlds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(18) = "rlds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(19) = "rlds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(20) = "rlds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(16) = "rlds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name1(21) = "rlds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(17) = "rlds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name1(22) = "rlds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    out_name1(18) = "rlds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    out_path2     = "~/data-model/CMIP5-hes/rlus/historical/"
    out_name2(0)  = "rlus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(1)  = "rlus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(1)  = "rlus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name2(2)  = "rlus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name2(3)  = "rlus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(4)  = "rlus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(5)  = "rlus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(2)  = "rlus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(6)  = "rlus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(3)  = "rlus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(7)  = "rlus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(4)  = "rlus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(5)  = "rlus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(8)  = "rlus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(9)  = "rlus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(10) = "rlus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    out_name2(6)  = "rlus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    out_name2(7)  = "rlus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    out_name2(8)  = "rlus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name2(11) = "rlus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(9)  = "rlus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name2(12) = "rlus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(10) = "rlus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name2(13) = "rlus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    out_name2(11) = "rlus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    out_name2(12) = "rlus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name2(14) = "rlus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(15) = "rlus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(13) = "rlus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(14) = "rlus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(15) = "rlus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
;    out_name2(16) = "rlus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name2(17) = "rlus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(18) = "rlus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(19) = "rlus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(20) = "rlus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(16) = "rlus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name2(21) = "rlus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(17) = "rlus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name2(22) = "rlus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    out_name2(18) = "rlus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    out_path3     = "~/data-model/CMIP5-hes/rsds/historical/"
    out_name3(0)  = "rsds_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(1)  = "rsds_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(1)  = "rsds_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name3(2)  = "rsds_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name3(3)  = "rsds_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(4)  = "rsds_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(5)  = "rsds_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(2)  = "rsds_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(6)  = "rsds_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(3)  = "rsds_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(7)  = "rsds_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(4)  = "rsds_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(5)  = "rsds_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(8)  = "rsds_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(9)  = "rsds_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(10) = "rsds_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    out_name3(6)  = "rsds_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    out_name3(7)  = "rsds_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    out_name3(8)  = "rsds_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name3(11) = "rsds_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(9)  = "rsds_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name3(12) = "rsds_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(10) = "rsds_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name3(13) = "rsds_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
;*    out_name3(28) = "rsds_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_T62.nc"
    out_name3(11) = "rsds_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    out_name3(12) = "rsds_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name3(14) = "rsds_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(15) = "rsds_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(13) = "rsds_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(14) = "rsds_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(15) = "rsds_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
;    out_name3(16) = "rsds_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name3(17) = "rsds_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(18) = "rsds_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(19) = "rsds_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(20) = "rsds_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(16) = "rsds_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name3(21) = "rsds_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(17) = "rsds_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name3(22) = "rsds_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    out_name3(18) = "rsds_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

    out_path4     = "~/data-model/CMIP5-hes/rsus/historical/"
    out_name4(0)  = "rsus_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(1)  = "rsus_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(1)  = "rsus_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_T62.nc"
;    out_name4(2)  = "rsus_Amon_CanCM4_historical_r1i1p1_196101-200512_T62.nc"
;    out_name4(3)  = "rsus_Amon_CanESM2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(4)  = "rsus_Amon_CCSM4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(5)  = "rsus_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(2)  = "rsus_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(6)  = "rsus_Amon_CMCC-CM_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(3)  = "rsus_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(7)  = "rsus_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(4)  = "rsus_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(5)  = "rsus_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(8)  = "rsus_Amon_FGOALS-g2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(9)  = "rsus_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(10) = "rsus_Amon_GFDL-CM2p1_historical_r1i1p1_186101-204012_T62.nc"
    out_name4(6)  = "rsus_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_T62.nc"
    out_name4(7)  = "rsus_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_T62.nc"
    out_name4(8)  = "rsus_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_T62.nc"
;    out_name4(11) = "rsus_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(9)  = "rsus_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name4(12) = "rsus_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(10) = "rsus_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_T62.nc"
;    out_name4(13) = "rsus_Amon_HadCM3_historical_r1i1p1_185912-200512_T62.nc"
    out_name4(11) = "rsus_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_T62.nc"
    out_name4(12) = "rsus_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_T62.nc"
;    out_name4(14) = "rsus_Amon_inmcm4_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(15) = "rsus_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(13) = "rsus_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(14) = "rsus_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(15) = "rsus_Amon_MIROC4h_historical_r1i1p1_195001-200512_T62.nc"
;    out_name4(16) = "rsus_Amon_MIROC5_historical_r1i1p1_185001-201212_T62.nc"
;    out_name4(17) = "rsus_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(18) = "rsus_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(19) = "rsus_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(20) = "rsus_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(16) = "rsus_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_T62.nc"
;    out_name4(21) = "rsus_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(17) = "rsus_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_T62.nc"
;    out_name4(22) = "rsus_Amon_NorESM1-M_historical_r1i1p1_185001-200512_T62.nc"
    out_name4(18) = "rsus_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_T62.nc"

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
     in1  = addfile (in_path + in_name1(i),"r")
     in2  = addfile (in_path + in_name2(i),"r")
     in3  = addfile (in_path + in_name3(i),"r")
     in4  = addfile (in_path + in_name4(i),"r")
     rlds = in1->rlds
     rlus = in2->rlus
     rsds = in3->rsds
     rsus = in4->rsus
;     ua   = lonFlip (in->ua)
;     ua   = short2flt (in->ua)
     time = in1->time
    else
     files1 = systemfunc ("ls "+in_path + in_name1(i))
     files2 = systemfunc ("ls "+in_path + in_name2(i))
     files3 = systemfunc ("ls "+in_path + in_name3(i))
     files4 = systemfunc ("ls "+in_path + in_name4(i))
     setfileoption ("nc","SuppressClose",False)   ;close too many files
     in1    = addfiles (files1,"r")
     in2    = addfiles (files2,"r")
     in3    = addfiles (files3,"r")
     in4    = addfiles (files4,"r")
     ListSetType (in1, "cat")
     ListSetType (in2, "cat")
     ListSetType (in3, "cat")
     ListSetType (in4, "cat")
     rlds  = in1[:]->rlds
     rlus  = in2[:]->rlus
     rsds  = in3[:]->rsds
     rsus  = in4[:]->rsus
     time  = in1[:]->time
     delete ([/files1,files2,files3,files4/])
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
    rlds_regrid = ESMF_regrid (rlds,Opt)
    rlus_regrid = ESMF_regrid (rlus,Opt)
    rsds_regrid = ESMF_regrid (rsds,Opt)
    rsus_regrid = ESMF_regrid (rsus,Opt)
    if (i.eq.0)then
     printVarSummary (rlus)
     printVarSummary (rlus_regrid)
    end if
;    Opt@SkipSrcGrid = True
;    Opt@SkipDstGrid = True
;    Opt@SkipWgtGen  = True

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim  = dimsizes (rlds_regrid)
lat  = rlds_regrid&lat
lon  = rlds_regrid&lon

system ("rm -f "+out_path1+out_name1(i))
system ("rm -f "+out_path2+out_name2(i))
system ("rm -f "+out_path3+out_name3(i))
system ("rm -f "+out_path4+out_name4(i))

fout1 = addfile (out_path1+out_name1(i),"c")
fout2 = addfile (out_path2+out_name2(i),"c")
fout3 = addfile (out_path3+out_name3(i),"c")
fout4 = addfile (out_path4+out_name4(i),"c")

setfileoption (fout1,"DefineMode",True)
setfileoption (fout2,"DefineMode",True)
setfileoption (fout3,"DefineMode",True)
setfileoption (fout4,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time","lat","lon"/)  
dimSizes = (/dim(0),dim(1),dim(2)/) 
dimUnlim = (/True,False,False/)   

filedimdef (fout1,dimNames,dimSizes,dimUnlim)
filedimdef (fout2,dimNames,dimSizes,dimUnlim)
filedimdef (fout3,dimNames,dimSizes,dimUnlim)
filedimdef (fout4,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout1,"time",typeof(time),       getvardims(time))
filevardef (fout2,"time",typeof(time),       getvardims(time))
filevardef (fout3,"time",typeof(time),       getvardims(time))
filevardef (fout4,"time",typeof(time),       getvardims(time))
filevardef (fout1,"lat", typeof(lat),        getvardims(lat))
filevardef (fout2,"lat", typeof(lat),        getvardims(lat))
filevardef (fout3,"lat", typeof(lat),        getvardims(lat))
filevardef (fout4,"lat", typeof(lat),        getvardims(lat))
filevardef (fout1,"lon", typeof(lon),        getvardims(lon))
filevardef (fout2,"lon", typeof(lon),        getvardims(lon))
filevardef (fout3,"lon", typeof(lon),        getvardims(lon))
filevardef (fout4,"lon", typeof(lon),        getvardims(lon))
filevardef (fout1,"rlds",typeof(rlds_regrid),getvardims(rlds_regrid))
filevardef (fout2,"rlus",typeof(rlus_regrid),getvardims(rlus_regrid))
filevardef (fout3,"rsds",typeof(rsds_regrid),getvardims(rsds_regrid))
filevardef (fout4,"rsus",typeof(rsus_regrid),getvardims(rsus_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout1,"time",time)
filevarattdef (fout2,"time",time)
filevarattdef (fout3,"time",time)
filevarattdef (fout4,"time",time)
filevarattdef (fout1,"lat", lat)
filevarattdef (fout2,"lat", lat)
filevarattdef (fout3,"lat", lat)
filevarattdef (fout4,"lat", lat)
filevarattdef (fout1,"lon", lon)
filevarattdef (fout2,"lon", lon)
filevarattdef (fout3,"lon", lon)
filevarattdef (fout4,"lon", lon)
filevarattdef (fout1,"rlds",rlds_regrid)
filevarattdef (fout2,"rlus",rlus_regrid)
filevarattdef (fout3,"rsds",rsds_regrid)
filevarattdef (fout4,"rsus",rsus_regrid)

;output only the data values
fout1->time = (/time/)
fout2->time = (/time/)
fout3->time = (/time/)
fout4->time = (/time/)
fout1->lat  = (/lat/)
fout2->lat  = (/lat/)
fout3->lat  = (/lat/)
fout4->lat  = (/lat/)
fout1->lon  = (/lon/) 
fout2->lon  = (/lon/) 
fout3->lon  = (/lon/) 
fout4->lon  = (/lon/) 
fout1->rlds = (/rlds_regrid/)
fout2->rlus = (/rlus_regrid/)
fout3->rsds = (/rsds_regrid/)
fout4->rsus = (/rsus_regrid/)

;delete ([/in,ua,time,lmask,Opt@SrcMask2D,ua_regrid,fout/])      ;will change next iteration
delete ([/in1,in2,in3,in4,rlds,rlus,rsds,rsus,time,rlds_regrid,rlus_regrid,rsds_regrid,rsus_regrid,fout1,fout2,fout3,fout4/])      ;will change next iteration

end do

end
