;*************************************************************
;Aim: Draw a bar chart of the maximum cross regression coefficients of 3-month means of area average of monthly SSTAs removed trend in the tropical
;     Indian Ocean as well as in the tropical North Atlantic onto the NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       Shan He
;                       2019-06-06
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------ts
;================================================

process = False

;data
;HadISST1   1870/01 - , 1x1
in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NOAA ERSST 1854/01 - , 2x2
in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v5.nc"
;COBE SST   1891/01 - , 1x1
in_name3 = "~/hes/ENSO/Regrid/COBE_sst_2x2.nc"
in_path = "~/data-model/CMIP5-hes/ts/historical/"
in_name = new(37, string)
in_name(0) = "ts_Amon_ACCESS1-0_historical_r1i1p1_185001-200512_2x2.nc"
in_name(1) = "ts_Amon_ACCESS1-3_historical_r1i1p1_185001-200512_2x2.nc"
in_name(2) = "ts_Amon_bcc-csm1-1_historical_r1i1p1_185001-201212_2x2.nc"
;in_name(3) = "ts_Amon_bcc-csm1-1-m_historical_r1i1p1_185001-201212_2x2.nc"
;in_name(4) = "ts_Amon_BNU-ESM_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(5) = "ts_Amon_CanCM4_historical_r1i1p1_196101-200512_2x2.nc"
in_name(3) = "ts_Amon_CanESM2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(6) = "ts_Amon_CCSM4_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(7) = "ts_Amon_CESM1-BGC_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(8) = "ts_Amon_CESM1-CAM5_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(9) = "ts_Amon_CESM1-CAM5-1-FV2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(10) = "ts_Amon_CESM1-FASTCHEM_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(11) = "ts_Amon_CESM1-WACCM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(4) = "ts_Amon_CMCC-CESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(5) = "ts_Amon_CMCC-CM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(6) = "ts_Amon_CMCC-CMS_historical_r1i1p1_185001-200512_2x2.nc"
in_name(7) = "ts_Amon_CNRM-CM5_historical_r1i1p1_185001-200512_2x2.nc"
in_name(8) = "ts_Amon_CNRM-CM5-2_historical_r1i1p1_185001-200512_2x2.nc"
in_name(9) = "ts_Amon_CSIRO-Mk3-6-0_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(17) = "ts_Amon_FGOALS-g2_historical_r1i1p1_190001-201412_2x2.nc"
in_name(10) = "ts_Amon_FGOALS-s2_historical_r1i1p1_185001-200512_2x2.nc"
;in_name(19) = "ts_Amon_FIO-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(11) = "ts_Amon_GFDL-CM2p1_historical_r1i1p1_186101-200512_2x2.nc"
in_name(12) = "ts_Amon_GFDL-CM3_historical_r1i1p1_186001-200512_2x2.nc"
in_name(13) = "ts_Amon_GFDL-ESM2G_historical_r1i1p1_186101-200512_2x2.nc"
in_name(14) = "ts_Amon_GFDL-ESM2M_historical_r1i1p1_186101-200512_2x2.nc"
in_name(15) = "ts_Amon_GISS-E2-H_historical_r1i1p1_185001-200512_2x2.nc"
in_name(16) = "ts_Amon_GISS-E2-H-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name(17) = "ts_Amon_GISS-E2-R_historical_r1i1p1_185001-200512_2x2.nc"
in_name(18) = "ts_Amon_GISS-E2-R-CC_historical_r1i1p1_185001-201012_2x2.nc"
in_name(19) = "ts_Amon_HadCM3_historical_r1i1p1_185912-200512_2x2.nc"
;in_name(28) = "ts_Amon_HadGEM2-AO_historical_r1i1p1_186001-200512_2x2.nc"
in_name(20) = "ts_Amon_HadGEM2-CC_historical_r1i1p1_185912-200511_2x2.nc"
in_name(21) = "ts_Amon_HadGEM2-ES_historical_r1i1p1_185912-200511_2x2.nc"
in_name(22) = "ts_Amon_inmcm4_historical_r1i1p1_185001-200512_2x2.nc"
in_name(23) = "ts_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name(24) = "ts_Amon_IPSL-CM5A-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name(25) = "ts_Amon_IPSL-CM5B-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name(26) = "ts_Amon_MIROC4h_historical_r1i1p1_195001-200512_2x2.nc"
in_name(27) = "ts_Amon_MIROC5_historical_r1i1p1_185001-201212_2x2.nc"
in_name(28) = "ts_Amon_MIROC-ESM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(29) = "ts_Amon_MIROC-ESM-CHEM_historical_r1i1p1_185001-200512_2x2.nc"
in_name(30) = "ts_Amon_MPI-ESM-LR_historical_r1i1p1_185001-200512_2x2.nc"
in_name(31) = "ts_Amon_MPI-ESM-MR_historical_r1i1p1_185001-200512_2x2.nc"
in_name(32) = "ts_Amon_MPI-ESM-P_historical_r1i1p1_185001-200512_2x2.nc"
in_name(33) = "ts_Amon_MRI-CGCM3_historical_r1i1p1_185001-200512_2x2.nc"
in_name(34) = "ts_Amon_MRI-ESM1_historical_r1i1p1_185101-200512_2x2.nc"
in_name(35) = "ts_Amon_NorESM1-M_historical_r1i1p1_185001-200512_2x2.nc"
in_name(36) = "ts_Amon_NorESM1-ME_historical_r1i1p1_185001-200512_2x2.nc"
nmod = dimsizes(in_name)

;time
yS = 1958
yE = 2004
season = (/"NDJ","DJF","JFM","FMA","MAM","AMJ","MJJ","JJA"/)
maxlag = dimsizes(season)

;cold tongue
latN = 6
latS = -6
lonW = 180
lonE = 270

;tropical Indian Ocean
latN1 = 10
latS1 = -10
lonW1 = 50
lonE1 = 100

;tropical Atlantic
latN2 = 25
latS2 = 5
lonW2 = 305
lonE2 = 345

a = 1.0 - 0.4 / 2.0
;a = 1.0 - 0.35 / 2.0
;a = 1.0 - 0.3 / 2.0
CI = new((/2,3,2/), float)

rTIO = new((/maxlag,nmod/),float)
rTNA = new((/maxlag,nmod/),float)

;Fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./bar_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
out_name = "bar_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP"

;text
text1 = "a)"
;text2 = "max[~F14~R~BF~CTI~F18~o~F~SSTA(~F8~t~F~)~N~]"
text2 = "SST responses to ENSO"
text3 = (/"(10~S~-1~N~ ~F35~J~F~C/~F35~J~F~C)","Data set"/)
;text4 = (/"~F33~a","~F33~b","~F33~g","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
text4 = (/"~F33~a","0","1","2","3","4","5","6","7","8","9","~F33~F","A","B","C","D","E","F","G","H","I",\
          "J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"/)
text5 = (/"2.5% "," 97.5%","TIO","TNA"/)

colors = (/"lightpink","red","cyan","blue"/)

if(process)then

    mnmx = new((/2,nmod+3,3/), float)

    do i = 0 , nmod-1

        print (i+" ing...")
; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    
        in = addfile (in_path + in_name(i),"r")

;get the time indexes
        time  = in->time
        year  = cd_calendar(time, -1) / 100
        iYYYY = ind(year.ge.yS .and. year.le.yE)

        sst = in->ts(iYYYY,:,:)
;        sst = lonFlip(in->ts(iYYYY,{latN:latS},:))

        if(i.eq.0)then 
            in1 = addfile(in_name1, "r")
            in2 = addfile(in_name2, "r")
            in3 = addfile(in_name3, "r")
            time1 = in1->time
            time2 = in2->time
            time3 = in3->time
            year1 = cd_calendar(time1, -1) / 100
            year2 = cd_calendar(time2, -1) / 100
            year3 = cd_calendar(time3, -1) / 100
            iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
            iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
            iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
            sst1 = in1->sst(iYYYY1,:,:)
            sst2 = in2->sst(iYYYY2,:,:)
            sst3 = in3->sst(iYYYY3,:,:)
        end if

;-------------------------------------------------------------
;creat weights: cos(lat)
        rad = 4.0 * atan(1.0) / 180.0
        gw = in->lat
        gw = cos(rad * gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
        clm  = clmMonTLL(sst)
        SSTA = calcMonAnomTLL(sst, clm)
        SSTA = (/dtrend_msg_n(SSTA&time, SSTA, False, False, 0)/)

;compute seasonal means
        SSTA_3M = month_to_seasonN(SSTA, season)

;--------------------------------------------------------------
;cold tongue (NDJ)
        CTI = wgt_areaave_Wrap(SSTA_3M(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1.0, 0)
        dim = dimsizes (CTI)
;tropical Indian Ocean
        TIO = wgt_areaave_Wrap(SSTA_3M(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1.0, 0)
;tropical Atlantic
        TNA = wgt_areaave_Wrap(SSTA_3M(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1.0, 0)

;--------------------------------------------------------------
;compute linear regression
        rTIO(:,i) = (/regCoef(CTI, TIO)/)
        rTNA(:,i) = (/regCoef(CTI, TNA)/)
        rTIO(1:,i) = (/regCoef(CTI(:dim-2), TIO(1:,1:))/)
        rTNA(1:,i) = (/regCoef(CTI(:dim-2), TNA(1:,1:))/)

        inds = (/maxind(rTIO(:,i))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI, TIO(inds,:))
        else 
            rc = regline_stats(CTI(:dim-2), TIO(inds,1:))
        end if
        mnmx(0,i+3,0) = (/rc/)
        mnmx(0,i+3,1:) = (/rc@b95/)

        inds = (/maxind(rTNA(:,i))/)
        if(inds.eq.0)then
            rc = regline_stats(CTI, TNA(inds,:))
        else 
            rc = regline_stats(CTI(:dim-2), TNA(inds,1:))
        end if
        mnmx(1,i+3,0) = (/rc/)
        mnmx(1,i+3,1:) = (/rc@b95/)

        if(i.eq.0)then
            copy_VarCoords(TIO, rTIO(:,0))
            copy_VarCoords(TNA, rTNA(:,0))

            clm1 = clmMonTLL(sst1)
            clm2 = clmMonTLL(sst2)
            clm3 = clmMonTLL(sst3)
            SSTA1 = calcMonAnomTLL(sst1, clm1)
            SSTA2 = calcMonAnomTLL(sst2, clm2)
            SSTA3 = calcMonAnomTLL(sst3, clm3)
            SSTA1 = (/dtrend_msg_n(SSTA1&time, SSTA1, False, False, 0)/)
            SSTA2 = (/dtrend_msg_n(SSTA2&time, SSTA2, False, False, 0)/)
            SSTA3 = (/dtrend_msg_n(SSTA3&time, SSTA3, False, False, 0)/)
            SSTA_3M1 = month_to_seasonN(SSTA1, season)
            SSTA_3M2 = month_to_seasonN(SSTA2, season)
            SSTA_3M3 = month_to_seasonN(SSTA3, season)
            CTI1 = wgt_areaave_Wrap(SSTA_3M1(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1.0, 0)
            CTI2 = wgt_areaave_Wrap(SSTA_3M2(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1.0, 0)
            CTI3 = wgt_areaave_Wrap(SSTA_3M3(0,:,{latN:latS},{lonW:lonE}), gw({latN:latS}), 1.0, 0)
            TIO1 = wgt_areaave_Wrap(SSTA_3M1(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1.0, 0)
            TIO2 = wgt_areaave_Wrap(SSTA_3M2(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1.0, 0)
            TIO3 = wgt_areaave_Wrap(SSTA_3M3(:,:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1.0, 0)
            TNA1 = wgt_areaave_Wrap(SSTA_3M1(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1.0, 0)
            TNA2 = wgt_areaave_Wrap(SSTA_3M2(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1.0, 0)
            TNA3 = wgt_areaave_Wrap(SSTA_3M3(:,:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1.0, 0)
            rTIO1 = regCoef(CTI1, TIO1)
            rTIO2 = regCoef(CTI2, TIO2)
            rTIO3 = regCoef(CTI3, TIO3)
            rTNA1 = regCoef(CTI1, TNA1)
            rTNA2 = regCoef(CTI2, TNA2)
            rTNA3 = regCoef(CTI3, TNA3)
            rTIO1(1:) = regCoef(CTI1(:dim-2), TIO1(1:,1:))
            rTIO2(1:) = regCoef(CTI2(:dim-2), TIO2(1:,1:))
            rTIO3(1:) = regCoef(CTI3(:dim-2), TIO3(1:,1:))
            rTNA1(1:) = regCoef(CTI1(:dim-2), TNA1(1:,1:))
            rTNA2(1:) = regCoef(CTI2(:dim-2), TNA2(1:,1:))
            rTNA3(1:) = regCoef(CTI3(:dim-2), TNA3(1:,1:))
            copy_VarCoords(TIO1, rTIO1)
            copy_VarCoords(TIO2, rTIO2)
            copy_VarCoords(TIO3, rTIO3)
            copy_VarCoords(TNA1, rTNA1)
            copy_VarCoords(TNA2, rTNA2)
            copy_VarCoords(TNA3, rTNA3)
            
            inds = maxind(rTIO1)
            if(inds.eq.0)then
                rc = regline_stats(CTI1, TIO1(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), TIO1(inds,1:))
            end if
            mnmx(0,0,0) = (/rc/)
            mnmx(0,0,1:) = (/rc@b95/)
            CI(0,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            inds = maxind(rTIO2)
            if(inds.eq.0)then
                rc = regline_stats(CTI2, TIO2(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), TIO2(inds,1:))
            end if
            mnmx(0,1,0) = (/rc/)
            mnmx(0,1,1:) = (/rc@b95/)
            CI(0,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            inds = maxind(rTIO3)
            if(inds.eq.0)then
                rc = regline_stats(CTI3, TIO3(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), TIO3(inds,1:))
            end if
            mnmx(0,2,0) = (/rc/)
            mnmx(0,2,1:) = (/rc@b95/)
            CI(0,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(0,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            inds = maxind(rTNA1)
            if(inds.eq.0)then
                rc = regline_stats(CTI1, TNA1(inds,:))
            else 
                rc = regline_stats(CTI1(:dim-2), TNA1(inds,1:))
            end if
            mnmx(1,0,0) = (/rc/)
            mnmx(1,0,1:) = (/rc@b95/)
            CI(1,0,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,0,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            inds = maxind(rTNA2)
            if(inds.eq.0)then
                rc = regline_stats(CTI2, TNA2(inds,:))
            else 
                rc = regline_stats(CTI2(:dim-2), TNA2(inds,1:))
            end if
            mnmx(1,1,0) = (/rc/)
            mnmx(1,1,1:) = (/rc@b95/)
            CI(1,1,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,1,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            inds = maxind(rTNA3)
            if(inds.eq.0)then
                rc = regline_stats(CTI3, TNA3(inds,:))
            else 
                rc = regline_stats(CTI3(:dim-2), TNA3(inds,1:))
            end if
            mnmx(1,2,0) = (/rc/)
            mnmx(1,2,1:) = (/rc@b95/)
            CI(1,2,0) = (/rc - cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)
            CI(1,2,1) = (/rc + cdft_t(a, rc@MSE_dof) * sqrt(rc@MSE) / (rc@Xstd * sqrt(rc@N-1) )/)

            do x = 0, 1
                do y = 0, 2
                    print((/mnmx(x,y,0)/))
                    print((/CI(x,y,:)/))
                end do
            end do
exit
        end if

        delete([/time,year/])

    end do

    mnmx!0 = "region"
    mnmx!1 = "member"
    mnmx!2 = "value"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

    ndim = dimsizes(mnmx)

    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","member","value"/)
    dimSizes = (/ndim/)
    dimUnlim = (/False,False,False/)   

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "member", "integer", "member")
    filevardef(fout, "value", "integer", "value")
    filevardef(fout, "mnmx", typeof(mnmx), getvardims(mnmx))

;Copy attributes associated with each variable to the file
;    filevarattdef(fout, "mnmx", mnmx)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->member = ispan(1, nmod+3, 1)
    fout->value = ispan(1, 3, 1)
    fout->mnmx = (/mnmx/)
else
    in   = addfile (out_data,"r")
    mnmx = in->mnmx
end if

printVarSummary(mnmx)
print((/mnmx(:,0,:)/))
mnmx = (/10.0 * mnmx/)

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

;*******************************************
; plot
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = .018
res@gsnXYBarChart = True
res@gsnXYBarChartBarWidth = 0.35
res@gsnYRefLineColor = "transparent"

res@vpWidthF = 0.8
res@vpHeightF = 0.2

res@trYMaxF = 7.0
res@trYMinF = -1.0
res@trXMaxF = nmod+1
res@trXMinF = -1

res@tiXAxisFontHeightF = .023
res@tiMainString = "Max Regression of Regional SSTA onto NDJ CTI"
res@tiMainFontHeightF = 0.025

res@tmXTOn = False
res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0, nmod+0, 1)
res@tmXBLabels = text4
res@tmXBLabelJust = "CenterCenter"
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.018
res@tmXBMajorLengthF = 0.008
res@tmXBMajorOutwardLengthF = 0.008

min_plot = new((/2,nmod+1/), graphic)
max_plot = new((/2,nmod+1/), graphic)

mnmx(:,1:nmod,:) = (/mnmx(:,3:nmod+2,:)/)

do i = 0, nmod+0
    res@gsnYRefLine = mnmx(0,i,0)
    res@gsnAboveYRefLineColor = colors(0)
    res@gsnBelowYRefLineColor = colors(1)
    res@tiYAxisString = text3(0)
    res@tiXAxisString = text3(1)
    if(i.eq.0)then
        res@gsnLeftString = text1
        res@gsnCenterString = text2
        plot = gsn_csm_xy(wks, i-0.175, mnmx(0,i,1), res)
        delete(res@gsnLeftString)
        delete(res@gsnCenterString)
        max_plot(0,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,i,2), res)
        overlay(plot, max_plot(0,i))
    else
        min_plot(0,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,i,1), res)
        max_plot(0,i) = gsn_csm_xy(wks, i-0.175, mnmx(0,i,2), res)
        overlay(plot, min_plot(0,i))
        overlay(plot, max_plot(0,i))
    end if
    res@gsnYRefLine = mnmx(1,i,0)
    res@gsnAboveYRefLineColor = colors(2)
    res@gsnBelowYRefLineColor = colors(3)
    min_plot(1,i) = gsn_csm_xy(wks, i+0.175, mnmx(1,i,1), res)
    max_plot(1,i) = gsn_csm_xy(wks, i+0.175, mnmx(1,i,2), res)
    overlay(plot, min_plot(1,i))
    overlay(plot, max_plot(1,i))
end do

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2
resl@gsLineColor = colors(1)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(0,0,0),mnmx(0,0,0)/), resl)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(0,0,1),mnmx(0,0,1)/), resl)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(0,0,2),mnmx(0,0,2)/), resl)
resl@gsLineDashPattern = 5
resl@gsLineColor = colors(3)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(1,0,0),mnmx(1,0,0)/), resl)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(1,0,1),mnmx(1,0,1)/), resl)
gsn_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/mnmx(1,0,2),mnmx(1,0,2)/), resl)

;--------------------------------------------------------------
;Manually creating a legend
xbox = (/0.39,0.45,0.45,0.39,0.39/)
ybox = (/0.46,0.46,0.48,0.48,0.46/)

txres = True
gsres = True
txres@txFontHeightF = 0.015

gsres@gsFillColor = colors(1)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = min(xbox)
ypos = (max(ybox) + min(ybox)) / 2.0
txres@txJust = "CenterRight"
gsn_text_ndc(wks, text5(0), xpos, ypos, txres)

xbox = xbox + 0.06
gsres@gsFillColor = colors(0)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = max(xbox)
txres@txJust = "CenterLeft"
gsn_text_ndc(wks, text5(1), xpos, ypos, txres)

xpos = min(xbox)
ypos = min(ybox)
txres@txJust = "TopCenter"
gsn_text_ndc(wks, text5(2), xpos, ypos, txres)

;--------------------------------------------------------------
xbox = xbox + 0.24
gsres@gsFillColor = colors(3)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = min(xbox)
ypos = (max(ybox) + min(ybox)) / 2.0
txres@txJust = "CenterRight"
gsn_text_ndc(wks, text5(0), xpos, ypos, txres)

xbox = xbox + 0.06
gsres@gsFillColor = colors(2)
gsn_polygon_ndc(wks, xbox, ybox, gsres)
xpos = max(xbox)
txres@txJust = "CenterLeft"
gsn_text_ndc(wks, text5(1), xpos, ypos, txres)

xpos = min(xbox)
ypos = min(ybox)
txres@txJust = "TopCenter"
gsn_text_ndc(wks, text5(3), xpos, ypos, txres)

draw(plot)
frame(wks)

end
