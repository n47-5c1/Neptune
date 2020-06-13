;*************************************************************
;Aim: Output and draw the climatology of global SST and sea ice in certain period
;Mission:
;
;   1. Read data from SST and sea ice datasets
;   2. Post-post process to deserved results
;   3. Output and draw the SST and sea ice
;                       He Shan
;                       2015-08-28
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

    year1 = 1950
    year2 = 2014

;ENSO SST
    latH = 6.2035
    lonH = 24.814
    latN = latH
    latS = -latH
    lonM = 260.
    lonL = lonM - lonH
    lonR = lonM + lonH

;datas
    path = "~/hes/input/SST/"
    in_name = "sst_HadOIBl_bc_1.9x2.5_1850_2014_c150416.nc"
    ref_name = "sst_HadOIBl_bc_1.9x2.5_1979_2014_clim.nc"
;    out_name = "sst_HadOIBl_bc_1.9x2.5_"+year1+"_"+year2+"_clim.nc"
    out_name = "sst_HadOIBl_bc_1.9x2.5_1982_1997_27degC_neg.nc"

    pi = 3.141592654

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;HadOIBl 1850~2013
    in_file = addfile (path + in_name, "r")
    ref_file = addfile (path + ref_name, "r")

    time = in_file->time
    lon = in_file->lon
    lat = in_file->lat
    ice = in_file->ice_cov
    ice_p = in_file->ice_cov_prediddle
    SST = in_file->SST_cpl
    SST_p = in_file->SST_cpl_prediddle

    datesec = in_file->datesec(:23)

    date_ref = ref_file->date
    datesec_ref = ref_file->datesec
    time_ref = ref_file->time
    ice_ref = ref_file->ice_cov
    ice_p_ref = ref_file->ice_cov_prediddle
    SST_ref = ref_file->SST_cpl
    SST_p_ref = ref_file->SST_cpl_prediddle

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;get the time indexs
    YYYY = cd_calendar(time, -1) / 100
;    iYYYY = ind (YYYY.ge.year1 .and. YYYY.le.year2)
    iENSO1 = ind(YYYY .eq. 1982 .or. YYYY .eq. 1997)
    iENSO2 = ind(YYYY .eq. 1983 .or. YYYY .eq. 1998)

    date_clm = new(24, integer)
    copy_VarMeta(date_ref, date_clm(:11))
    date_clm&time = (/time(:23)/)
    date_clm = (/116,215,316,416,516,616,716,816,916,1016,1116,1216,10116,10215,10316,10416,10516,10616,10716,10816,10916,11016,11116,11216/)

    datesec_clm = new(24, integer)
    copy_VarMeta(datesec_ref, datesec_clm(:11))
    datesec_clm&time = (/time(:23)/)
    datesec_clm = (/datesec/)

    time_clm = new(24, double)
    copy_VarMeta(time_ref, time_clm(:11))
    time_clm&time = (/time(:23)/)
    time_clm = (/time(:23)/)

;---------------------------------------------------------------
;compute monthly climatologies
/;
    ice_clm = clmMonTLL (ice(iYYYY,:,:))
    ice_p_clm = clmMonTLL (ice_p(iYYYY,:,:))
    SST_clm = clmMonTLL (SST(iYYYY,:,:))
    SST_p_clm = clmMonTLL (SST_p(iYYYY,:,:))
;/
    ice0 = clmMonTLL(ice(iENSO1,:,:))
    ice_p0 = clmMonTLL(ice_p(iENSO1,:,:))
    SST0 = clmMonTLL(SST(iENSO1,:,:))
    SST_p0 = clmMonTLL(SST_p(iENSO1,:,:))
    ice1 = clmMonTLL(ice(iENSO2,:,:))
    ice_p1 = clmMonTLL(ice_p(iENSO2,:,:))
    SST1 = clmMonTLL(SST(iENSO2,:,:))
    SST_p1 = clmMonTLL(SST_p(iENSO2,:,:))

;compute difference
    diff_SST0 = SST0 - 27.
    diff_SST_p0 = SST_p0 - 27.
    diff_SST1 = SST1 - 27.
    diff_SST_p1 = SST_p1 - 27.

    dim = dimsizes(SST0)
    latC = tofloat(conform_dims(dim, lat, 1))
    lonC = tofloat(conform_dims(dim, lon, 2))
    diff_SST0 = (/diff_SST0 * abs(cos(0.5 * pi * latC / latH)) * abs(cos(0.5 * pi * (lonC - lonM) / lonH))/)
    diff_SST_p0 = (/diff_SST_p0 * abs(cos(0.5 * pi * latC / latH)) * abs(cos(0.5 * pi * (lonC - lonM) / lonH))/)
    diff_SST1 = (/diff_SST1 * abs(cos(0.5 * pi * latC / latH)) * abs(cos(0.5 * pi * (lonC - lonM) / lonH))/)
    diff_SST_p1 = (/diff_SST_p1 * abs(cos(0.5 * pi * latC / latH)) * abs(cos(0.5 * pi * (lonC - lonM) / lonH))/)

    SST0 = (/where(latC.ge.latS .and. latC.le.latN .and. lonC.ge.lonL .and. lonC.le.lonR .and. diff_SST0.ge.0.,\
           SST0 - 2 * diff_SST0, SST0)/)
    SST_p0 = (/where(latC.ge.latS .and. latC.le.latN .and. lonC.ge.lonL .and. lonC.le.lonR .and. diff_SST_p0.ge.0.,\
           SST_p0 - 2 * diff_SST_p0, SST_p0)/)
    SST1 = (/where(latC.ge.latS .and. latC.le.latN .and. lonC.ge.lonL .and. lonC.le.lonR .and. diff_SST1.ge.0.,\
           SST1 - 2 * diff_SST1, SST1)/)
    SST_p1 = (/where(latC.ge.latS .and. latC.le.latN .and. lonC.ge.lonL .and. lonC.le.lonR .and. diff_SST_p1.ge.0.,\
           SST_p1 - 2 * diff_SST_p1, SST_p1)/)

;---------------------------------------------------------------
    ice_clm = new((/24,dim(1),dim(2)/), float)
    copy_VarMeta(ice_ref, ice_clm(:11,:,:))
    ice_clm&time = (/time(:23)/)
    ice_clm(:11,:,:) = (/ice0/)
    ice_clm(12:,:,:) = (/ice1/)
    
    ice_p_clm = new((/24,dim(1),dim(2)/), float)
    copy_VarMeta(ice_p_ref, ice_p_clm(:11,:,:))
    ice_p_clm&time = (/time(:23)/)
    ice_p_clm(:11,:,:) = (/ice_p0/)
    ice_p_clm(12:,:,:) = (/ice_p1/)
    
    SST_clm = new((/24,dim(1),dim(2)/), float)
    copy_VarMeta(SST_ref, SST_clm(:11,:,:))
    SST_clm&time = (/time(:23)/)
    SST_clm(:11,:,:) = (/SST0/)
    SST_clm(12:,:,:) = (/SST1/)
    
    SST_p_clm = new((/24,dim(1),dim(2)/), float)
    copy_VarMeta(SST_p_ref, SST_p_clm(:11,:,:))
    SST_p_clm&time = (/time(:23)/)
    SST_p_clm(:11,:,:) = (/SST_p0/)
    SST_p_clm(12:,:,:) = (/SST_p1/)

    print(date_clm)
    print(datesec_clm)
    print(time_clm)
    printVarSummary(ice_clm)
    printVarSummary(ice_p_clm)
    printVarSummary(SST_clm)
    printVarSummary(SST_p_clm)

; ==============================================================
; Mission 3. Output and draw the SST and sea ice
; ==============================================================

;overwrite a netCDF file
    out_file = addfile(path + out_name, "w")   ;HadOIBl clim
    out_file->date = date_clm
    out_file->datesec = datesec_clm
    out_file->time = time_clm
    out_file->ice_cov = ice_clm
    out_file->ice_cov_prediddle = ice_p_clm
    out_file->SST_cpl = SST_clm
    out_file->SST_cpl_prediddle = SST_p_clm

end
