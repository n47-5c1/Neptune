;*************************************************************
;Aim: Draw the tropical surface zonal wind for transitional and non-transitional ENSO events
;
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-09-12
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;================================================

;data
in_path = "~/data/observation/"
in_name = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"

;time
yS = 1958
yE = 2017
mS = 9
mE = 8
yElT = (/1963,1972,1982,1987,1994,1997,2009,2015/)
yElN = (/1965,1968,1986,1991,2002/)
;yElT = (/1963,1969,1972,1982,1987,1994,1997,2004,2006,2009,2015/)
;yElN = (/1958,1965,1968,1976,1977,1979,1986,1991,2002,2014/)
;yLa = (/1964,1970,1971,1973,1974,1975,1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011/)
ny1 = dimsizes(yElT)
ny2 = dimsizes(yElN)
season = (/"MAM","JJA","SON"/)

;region
latN = 10
latS = -10
lonW = 90
lonE = 225

;fig
out_path = "~/hes/ENSO/Termination/Fig/"
out_name = "lon_tropic_U.surf_anom_tran_non-tran_ENSO"

;text
text1 = (/"a) NDJ","b)","c)FMA","d)","e)MJJ","f)"/)
text2 = (/"Transitional El Nino","Non-transitional El Nino","Transitional La Nina","Non-transitional La Nina"/)
text3 = "m s~S~-1~N~"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile(in_path + in_name, "r")

;get the time indexs
    time = in->time

    TIME = cd_calendar(time, 0)
    year_p = toint(TIME(:,0))
    iYYYY = ind(year_p.ge.yS .and. year_p.le.yE)

    month_p = toint(TIME(:,1))
    year = year_p(iYYYY)
    month = month_p(iYYYY)

    ElT = (year.eq.yElT(0) .and. month.ge.mS .or. year.eq.yElT(0)+1 .and. month.lt.mS)
    do i = 1, ny1 - 1
     ElT = ElT .or. (year.eq.yElT(i) .and. month.ge.mS .or. year.eq.yElT(i)+1 .and. month.lt.mS)
    end do

    ElN = (year.eq.yElN(0) .and. month.ge.mS .or. year.eq.yElN(0)+1 .and. month.lt.mS)
    do i = 1, ny2 - 1
     ElN = ElN .or. (year.eq.yElN(i) .and. month.ge.mS .or. year.eq.yElN(i)+1 .and. month.lt.mS)
    end do

    iMM1 = ind(ElT)
    iMM2 = ind(ElN)

;----------------------------------------------------------

    uwnd = in->uwnd(iYYYY,:,:)
    lat = in->lat
;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw = cos(rad * lat)
    copy_VarCoords(lat, gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm = clmMonTLL(uwnd)

;Monthly anomalies
    Anom = calcMonAnomTLL(uwnd, clm)

;----------------------------------------------------------
    ave1N = dim_avg_wgt_n_Wrap(month_to_seasonN(Anom(iMM1,{latN:0},{lonW:lonE}), season), gw({latN:0}), 1, 2)
    ave1S = dim_avg_wgt_n_Wrap(month_to_seasonN(Anom(iMM1,{0:latS},{lonW:lonE}), season), gw({0:latS}), 1, 2)
    ave2N = dim_avg_wgt_n_Wrap(month_to_seasonN(Anom(iMM2,{latN:0},{lonW:lonE}), season), gw({latN:0}), 1, 2)
    ave2S = dim_avg_wgt_n_Wrap(month_to_seasonN(Anom(iMM2,{0:latS},{lonW:lonE}), season), gw({0:latS}), 1, 2)
    dim = dimsizes(ave1N)
/;
    x = new((/2,dim(0),dim(1),dim(2)/), float)
    x(0,:) = (/ave1/)
    x(1,:) = (/ave2/)
;/
; ==============================================================
; Mission 3. Draw the difference
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(6, graphic)
plot2 = new(6, graphic)
O1 = new(6, graphic)
O2 = new(6, graphic)

res = True
res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.019

res@tmXBOn = False
;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

;res@tiYAxisFontHeightF = 0.019
res@tiYAxisString = " "

res@trYMaxF = 6.
res@trYMinF = -4.
res@trXMaxF = lonE
res@trXMinF = lonW

res@vpWidthF = 0.45
res@vpHeightF = 0.2

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
plot1(0) = gsn_csm_xy(wks, ave1N&lon, ave1N(0,:,:), res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = text3
plot1(1) = gsn_csm_xy(wks, ave2N&lon, ave2N(0,:,:), res)

res@gsnLeftString = text1(2)
res@gsnCenterString = " "
res@gsnRightString = " "
plot1(2) = gsn_csm_xy(wks, ave1N&lon, ave1N(1,:,:), res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_xy(wks, ave2N&lon, ave2N(1,:,:), res)

res@gsnLeftString = text1(4)
plot1(4) = gsn_csm_xy(wks, ave1N&lon, ave1N(2,:,:), res)

res@gsnLeftString = text1(5)
plot1(5) = gsn_csm_xy(wks, ave2N&lon, ave2N(2,:,:), res)

;--------------------------------------------------------------
res@tmXBOn = True
res@tmXTOn = False
res@tmYLLabelsOn = False
res@tmYRLabelsOn = True
res@tmYRLabelJust = "CenterRight"

res@gsnLeftString = " "

plot2(0) = gsn_csm_xy(wks, ave1S&lon, ave1S(0,:,:), res)
plot2(1) = gsn_csm_xy(wks, ave2S&lon, ave2S(0,:,:), res)
plot2(2) = gsn_csm_xy(wks, ave1S&lon, ave1S(1,:,:), res)
plot2(3) = gsn_csm_xy(wks, ave2S&lon, ave2S(1,:,:), res)
plot2(4) = gsn_csm_xy(wks, ave1S&lon, ave1S(2,:,:), res)
plot2(5) = gsn_csm_xy(wks, ave2S&lon, ave2S(2,:,:), res)

;--------------------------------------------------------------
res1 = True
res1@gsnDraw = False
res1@gsnFrame = False
res1@xyLineColor = "red"
res1@xyLineThicknessF = 2

O1(0) = gsn_csm_xy(wks, ave1N&lon, dim_avg_n(ave1N(0,:,:), 0), res1)
O1(1) = gsn_csm_xy(wks, ave2N&lon, dim_avg_n(ave2N(0,:,:), 0), res1)
O1(2) = gsn_csm_xy(wks, ave1N&lon, dim_avg_n(ave1N(1,:,:), 0), res1)
O1(3) = gsn_csm_xy(wks, ave2N&lon, dim_avg_n(ave2N(1,:,:), 0), res1)
O1(4) = gsn_csm_xy(wks, ave1N&lon, dim_avg_n(ave1N(2,:,:), 0), res1)
O1(5) = gsn_csm_xy(wks, ave2N&lon, dim_avg_n(ave2N(2,:,:), 0), res1)
do i = 0, 5
    overlay(plot1(i), O1(i))
end do

O2(0) = gsn_csm_xy(wks, ave1S&lon, dim_avg_n(ave1S(0,:,:), 0), res1)
O2(1) = gsn_csm_xy(wks, ave2S&lon, dim_avg_n(ave2S(0,:,:), 0), res1)
O2(2) = gsn_csm_xy(wks, ave1S&lon, dim_avg_n(ave1S(1,:,:), 0), res1)
O2(3) = gsn_csm_xy(wks, ave2S&lon, dim_avg_n(ave2S(1,:,:), 0), res1)
O2(4) = gsn_csm_xy(wks, ave1S&lon, dim_avg_n(ave1S(2,:,:), 0), res1)
O2(5) = gsn_csm_xy(wks, ave2S&lon, dim_avg_n(ave2S(2,:,:), 0), res1)
do i = 0, 5
    overlay(plot2(i), O2(i))
end do
/;
;--------------------------------------------------------------
; add the line
resl                   = True
;resl@gsLineColor       = "grey60"
resl@gsLineThicknessF  = 2
;resl@gsLineDashPattern = 1
dum1(0) = gsn_add_polyline(wks, plot(1), (/0,360/), (/0,0/), resl)
dum1(1) = gsn_add_polyline(wks, plot(2), (/0,360/), (/0,0/), resl)
dum1(2) = gsn_add_polyline(wks, plot(3), (/0,360/), (/0,0/), resl)
dum1(3) = gsn_add_polyline(wks, plot(4), (/0,360/), (/0,0/), resl)
dum1(4) = gsn_add_polyline(wks, plot(5), (/0,360/), (/0,0/), resl)
resl@gsLineDashPattern = 1
dum2(0) = gsn_add_polyline(wks, plot(0), (/lonW1,lonW1/), (/20,35/), resl)
dum2(1) = gsn_add_polyline(wks, plot(1), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(2) = gsn_add_polyline(wks, plot(2), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(3) = gsn_add_polyline(wks, plot(3), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(4) = gsn_add_polyline(wks, plot(4), (/lonW1,lonW1/), (/-20,20/), resl)
dum2(5) = gsn_add_polyline(wks, plot(5), (/lonW1,lonW1/), (/-20,20/), resl)
dum3(0) = gsn_add_polyline(wks, plot(0), (/lonE1,lonE1/), (/20,35/), resl)
dum3(1) = gsn_add_polyline(wks, plot(1), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(2) = gsn_add_polyline(wks, plot(2), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(3) = gsn_add_polyline(wks, plot(3), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(4) = gsn_add_polyline(wks, plot(4), (/lonE1,lonE1/), (/-20,20/), resl)
dum3(5) = gsn_add_polyline(wks, plot(5), (/lonE1,lonE1/), (/-20,20/), resl)
;/
;*******************************************
;create panel resources
;*******************************************
; attaching the plot
res2 = True
res2@gsnAttachPlotsXAxis = True
do i = 0, 5
    amid = gsn_attach_plots(plot1(i), plot2(i), False, res2)
end do

resP = True
;resP@gsnPanelBottom = 0.04
;resP@txFontHeightF = 0.021
;resP@txString = "CLM SST, U, and RC of P onto CTI"

gsn_panel(wks, plot1, (/3,2/), resP)

end
