;*************************************************************
;Aim: Output and draw the climatology of global SST and sea ice in certain period
;Mission:
;
;   1. Read data from SST and sea ice datasets
;   2. Post-post process to deserved results
;   3. Output and draw the SST and sea ice
;                       He Shan
;                       2018-08-12
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1---------------ice_cov
;   var2---------------ice_cov_prediddle
;   var3---------------SST_cpl
;   var4---------------SST_cpl_prediddle
;================================================

;datas
    path = "~/hes/input/SST/"
    in_name = "sst_HadOIBl_bc_1.9x2.5_1850_2017_c180507.nc"
    out_name = "sst_HadOIBl_bc_1.9x2.5_1979_2016_clim.nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;HadOIBl 1850~2013
    in_file = addfile(path + in_name, "r")

    time = in_file->time
;get the time indexs
    YYYY = cd_calendar(time, -1) / 100
    iYYYY = ind(YYYY .ge. 1979 .and. YYYY .le. 2016)

    ice = in_file->ice_cov(iYYYY,:,:)
    ice_p = in_file->ice_cov_prediddle(iYYYY,:,:)
    SST = in_file->SST_cpl(iYYYY,:,:)
    SST_p = in_file->SST_cpl_prediddle(iYYYY,:,:)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute monthly climatologies
    ice_clm = clmMonTLL(ice)
    ice_p_clm = clmMonTLL(ice_p)
    SST_clm = clmMonTLL(SST)
    SST_p_clm = clmMonTLL(SST_p)

    printVarSummary(ice_clm)
    printVarSummary(ice_p_clm)
    printVarSummary(SST_clm)
    printVarSummary(SST_p_clm)

; ==============================================================
; Mission 3. Output and draw the SST and sea ice
; ==============================================================

;overwrite a netCDF file
    out_file = addfile(path + out_name, "w")   ;HadOIBl clim
    out_file->ice_cov = (/ice_clm/)
    out_file->ice_cov_prediddle = (/ice_p_clm/)
    out_file->SST_cpl = (/SST_clm/)
    out_file->SST_cpl_prediddle = (/SST_p_clm/)

end
