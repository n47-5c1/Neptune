;*************************************************************
;Aim: Draw a scatter plot of the maximum cross regression coefficients of 3-month means of area average of monthly SSTAs removed trend in the tropical
;     Indian Ocean as well as in the tropical North Atlantic onto the NDJ cold tongue index
;
;Mission:
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output data
;   4. Draw the scatter plot
;                       Shan He
;                       2017-12-13
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------ts
;================================================

process = False      ;Statistics? Plot?

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

rTIO = new((/maxlag,nmod/),float)
rTNA = new((/maxlag,nmod/),float)

;Fig
out_path = "~/hes/ENSO/Asymmetry/Fig/"
out_data = "./scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP.nc"
out_name = "scatter_max_lag_regress_NDJ_CTI_and_areaave_SSTA_remove_trend_CMIP"

;text
text1 = "a)"
text2 = "max[~F14~R~BF~CTI~F18~o~F~SSTA(~F8~t~F~)~N~]"
;text1 = "~F35~J~F~C/~F35~J~F~C"
text3 = (/"TNA","TIO"/)
text4 = (/"HadISST","ERSST","COBE","CMIP5"/)

x = (/0.25,0.25,0.25,0.25/)
y = (/0.75,0.7,0.65,0.6/)
color = "grey"
sizes = (/.028,.028,.028,.022/)
indexes = (/4,8,7,0/)
thicknesses = (/3,3,3,1/)

if(process)then

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

            a = regline_stats(CTI1(:dim-2), TIO1(2,1:))
            printVarSummary(a)
        end if

        delete([/time,year/])

    end do

    mnmx = new((/2,nmod+4/), float)
    mnmx(:,0) = dim_max((/rTIO1,rTNA1/))
    mnmx(:,1) = dim_max((/rTIO2,rTNA2/))
    mnmx(:,2) = dim_max((/rTIO3,rTNA3/))
    mnmx(:,4:) = dim_max_n((/rTIO,rTNA/), 1)
    mnmx(:,3) = dim_avg(mnmx(:,4:))

    std = dim_stddev_Wrap(mnmx(:,4:))

    mnmx!0 = "region"
    mnmx!1 = "member"
    std!0  = "region"

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================

    ndim = dimsizes(mnmx)

    system("rm -f " + out_data)
    fout = addfile(out_data, "c")
    setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
    dimNames = (/"region","member"/)
    dimSizes = (/ndim/)
    dimUnlim = (/False,False/)   

    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
    filevardef(fout, "region", "integer", "region")
    filevardef(fout, "member", "integer", "member")
    filevardef(fout, "mnmx", typeof(mnmx), getvardims(mnmx))
    filevardef(fout, "std", typeof(std), getvardims(std))

;Copy attributes associated with each variable to the file
    filevarattdef(fout, "std", std)

;output only the data values
    fout->region = ispan(1, 2, 1)
    fout->member = ispan(1, nmod+4, 1)
    fout->mnmx = (/mnmx/)
    fout->std = (/std/)
else
    in   = addfile (out_data,"r")
    mnmx = in->mnmx
    std  = in->std
end if

printVarSummary(mnmx)
printVarSummary(std)
print((/mnmx(:,(/0,3/))/))
print(ind(abs(mnmx(0,4:) - mnmx(0,0)) .lt. 2.0*std(0) .and. abs(mnmx(1,4:) - mnmx(1,0)) .lt. 2.0*std(1)))
;print((/mnmx(1,ind(mnmx(1,:).lt.0.1))/))

; ==============================================================
; Mission 4. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

;*******************************************
; plot timeseries
;*******************************************
res = True

res@gsnFrame = False
res@gsnLeftString = text1
res@gsnCenterString = text2
res@gsnStringFontHeightF = .024

res@tiYAxisString = text3(0)
res@tiXAxisString = text3(1)
res@tiXAxisFontHeightF = .023
res@tiMainString = "Max Regression of Regional SSTA onto NDJ CTI"
res@tiMainFontHeightF = 0.028

res@trYMaxF = .4
res@trYMinF = .1
res@trXMaxF = .4
res@trXMinF = .1

res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

indexes(3) = NhlNewMarker(wks, "y", 35, 0.0, 0.0, 1.0, 1.0, 0.0)
res@xyMarkLineMode = "Markers"
res@xyMarkers = indexes
res@xyMarkerSizes = sizes
res@xyMarkerColor = color
res@xyMarkerThicknesses = thicknesses
plot = gsn_csm_xy(wks, transpose((/mnmx(0,0:3),mnmx(0,0:3)/)), transpose((/mnmx(1,0:3),mnmx(1,0:3)/)), res)

;--------------------------------------------------------------
; add the line
resl = True
resl@gsLineThicknessF = 2
resl@gsLineDashPattern = 1
gsn_polyline(wks, plot, (/0,.55/), (/0,.55/), resl)
resl@gsLineColor = color
resl@gsLineThicknessF = 3
resl@gsLineDashPattern = 0
a = (res@trYMaxF - res@trYMinF) / 50.0
gsn_polyline(wks, plot, (/mnmx(0,3)-std(0),mnmx(0,3)+std(0)/), (/mnmx(1,3),mnmx(1,3)/), resl)
gsn_polyline(wks, plot, (/mnmx(0,3),mnmx(0,3)/), (/mnmx(1,3)-std(1),mnmx(1,3)+std(1)/), resl)
gsn_polyline(wks, plot, (/mnmx(0,3)-std(0),mnmx(0,3)-std(0)/), (/mnmx(1,3)-a,mnmx(1,3)+a/), resl)
gsn_polyline(wks, plot, (/mnmx(0,3)+std(0),mnmx(0,3)+std(0)/), (/mnmx(1,3)-a,mnmx(1,3)+a/), resl)
gsn_polyline(wks, plot, (/mnmx(0,3)-a,mnmx(0,3)+a/), (/mnmx(1,3)-std(1),mnmx(1,3)-std(1)/), resl)
gsn_polyline(wks, plot, (/mnmx(0,3)-a,mnmx(0,3)+a/), (/mnmx(1,3)+std(1),mnmx(1,3)+std(1)/), resl)

;--------------------------------------------------------------
;Manually creating a legend
gsres = True
do i = 0, 3
    gsres@gsMarkerSizeF = sizes(i)
    gsres@gsMarkerIndex = indexes(i)
    gsres@gsMarkerThicknessF = thicknesses(i)
    gsn_polymarker_ndc(wks, x(i), y(i), gsres)
end do

txres = True
txres@txJust = "CenterLeft"
txres@txFontHeightF = 0.02
gsn_text_ndc(wks, text4, x+0.028, y, txres)

frame(wks)

end
