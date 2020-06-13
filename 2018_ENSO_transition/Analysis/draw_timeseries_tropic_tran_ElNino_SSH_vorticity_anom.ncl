;*************************************************************
;Aim: Draw timeseries of sea surface height and northern and southern edges of vorticity anomalies in the west-central equatorial Pacific
;     during El Nino for transisitonal and non-transistional events
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composite
;
;                       Shan He
;                       2019-11-18
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------ssh
;   var2--------------uwnd
;   var3--------------vwnd
;   var4--------------sst
;================================================

;data
in_path = "~/data/observation/"
in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"
in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"
in_name3 = "NCEP_NCAR/monthly/uwnd.sfc.mon.mean.nc"
in_name4 = "NCEP_NCAR/monthly/vwnd.sfc.mon.mean.nc"
in_name5 = "SST/HadISST/HadISST_sst.nc"

;time
mS = 6
mE = 5
yS = 1958
yE = 2010
x = ispan(0, 11, 1)

;y3 = (/2004/)
;y4 = (/1965,1968,1991,2002/)
y1 = (/1969,1972,1982,1997,2006/)
y2 = (/1963,1987,1994,2004,2009/)
y3 = (/1976,1986/)
y4 = (/1958,1965,1968,1977,1979,1991,2002/)
y5 = (/1969,1972,1976,1982,1986,1997,2006/)
y6 = (/1958,1963,1965,1968,1977,1979,1987,1991,1994,2002,2004,2009/)
ny1 = dimsizes(y1)
ny2 = dimsizes(y2)
ny3 = dimsizes(y3)
ny4 = dimsizes(y4)
ny5 = dimsizes(y5)
ny6 = dimsizes(y6)

;region
latN = 5
latS = -5
lonW = 155
;lonW = 130
;lonE = 220
lonE = 280

;Nino 3.4
latNI = 5
latSI = -5
lonWI = 190
lonEI = 240

;fig
out_path = "~/hes/ENSO/Termination/Fig/"
out_name = "timeseries_tropic_tran_ElNino_SSH_vr_anom"

;text
text1 = (/"a) EP - CP","b) EP, transitional - non-transitional","c) CP, transitional - non-transitional","d) Transitional EP","e) Transitional CP",\
          "f) Non-transitional EP","g) Non-transitional CP"/)
text2 = (/"SSHA tendency (cm/mon)","Curl anomaly (10~S~-6~N~ s~S~-1~N~)"/)
text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
text4 = (/"  dSSHA","  Curl"/)
text5 = "Timeseries of dSSH & VR Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_path + in_name1, "r")
in3 = addfile(in_path + in_name3, "r")
in4 = addfile(in_path + in_name4, "r")
in5 = addfile(in_path + in_name5, "r")

files2 = systemfunc("ls " + in_path + in_name2)
setfileoption("cdf", "SuppressClose", False)
in2 = addfiles(files2, "r")
ListSetType(in2, "join")

time1 = in1->time
time3 = in3->time
time5 = in5->time

;get the time indexs
TIME1 = cd_calendar(time1, 0)
TIME3 = cd_calendar(time3, 0)
TIME5 = cd_calendar(time5, 0)
year1 = toint(TIME1(:,0))
month1 = toint(TIME1(:,1))
dimX = dimsizes(year1)
year3 = toint(TIME3(:,0))
year5 = toint(TIME5(:,0))
iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)
iYYYY5 = ind(year5.ge.yS .and. year5.le.yE)

year = new(dimX+24, typeof(year1))
month = new(dimX+24, typeof(month1))
copy_VarMeta(year1, year(:dimX-1))
copy_VarMeta(month1, month(:dimX-1))
year(:dimX-1) = (/year1/)
month(:dimX-1) = (/month1/)
year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

E1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
E2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
E3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
E4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)
E5 = (year.eq.y5(0) .and. month.ge.mS .or. year.eq.y5(0)+1 .and. month.lt.mS)
E6 = (year.eq.y6(0) .and. month.ge.mS .or. year.eq.y6(0)+1 .and. month.lt.mS)
do i = 1, ny1 - 1
    E1 = E1 .or. (year.eq.y1(i) .and. month.ge.mS .or. year.eq.y1(i)+1 .and. month.lt.mS)
end do
do i = 1, ny2 - 1
    E2 = E2 .or. (year.eq.y2(i) .and. month.ge.mS .or. year.eq.y2(i)+1 .and. month.lt.mS)
end do
do i = 1, ny3 - 1
    E3 = E3 .or. (year.eq.y3(i) .and. month.ge.mS .or. year.eq.y3(i)+1 .and. month.lt.mS)
end do
do i = 1, ny4 - 1
    E4 = E4 .or. (year.eq.y4(i) .and. month.ge.mS .or. year.eq.y4(i)+1 .and. month.lt.mS)
end do
do i = 1, ny5 - 1
    E5 = E5 .or. (year.eq.y5(i) .and. month.ge.mS .or. year.eq.y5(i)+1 .and. month.lt.mS)
end do
do i = 1, ny6 - 1
    E6 = E6 .or. (year.eq.y6(i) .and. month.ge.mS .or. year.eq.y6(i)+1 .and. month.lt.mS)
end do

iMM1 =ind(E1)
iMM2 =ind(E2)
iMM3 =ind(E3)
iMM4 =ind(E4)
iMM5 =ind(E5)
iMM6 =ind(E6)

;----------------------------------------------------------
ssh1 = in1->ssh(:,{latS:latN},{lonW:lonE})
SSH2 = in2[:]->SSH(:,{latN:latS},{lonW:lonE})
ssh1 = (/100 * ssh1/)
SSH2 = (/100 * SSH2/)
dimY = dimsizes(ssh1)
ssh = new((/dimY(0)+24,dimY(1),dimY(2)/), typeof(ssh1))
copy_VarMeta(ssh1, ssh(:dimY(0)-1,:,:))
ssh(:dimY(0)-1,:,:) = (/ssh1/)
ssh(dimY(0):,:,:) = (/SSH2/)
uwnd = in3->uwnd(iYYYY3,::-1,:)
vwnd = in4->vwnd(iYYYY3,::-1,:)
sst = lonFlip(in5->sst(iYYYY5,:,:))
printVarSummary(uwnd)

;----------------------------------------------------------
;creat weights: cos(lat)
rad = 4. * atan(1.) / 180.
gw1 = in1->lat({latS:latN})
gw5 = in5->latitude({latSI:latNI})
gw1 = cos(rad * gw1)
gw5 = cos(rad * gw5)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Compute vorticity
vr_p = uv2vrF_Wrap(uwnd, vwnd)
vr = vr_p(:,:,{lonW:lonE})

;Calculate climatology
clm1 = clmMonTLL(ssh)
clm3 = clmMonTLL(vr)
clm5 = clmMonTLL(sst)

;Monthly anomalies
Anom1 = calcMonAnomTLL(ssh, clm1)
Anom3 = calcMonAnomTLL(vr, clm3)
Anom5 = calcMonAnomTLL(sst, clm5)

Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)
Anom5 = (/dtrend_msg_n(Anom5&time, Anom5, False, False, 0)/)

;Nino 3.4 (DJF)
Nino34 = wgt_areaave_Wrap(Anom5(:,{latSI:latNI},{lonWI:lonEI}), gw5, 1., 0)
dim = dimsizes(Nino34)
Nino34(12::12) = (/(Nino34(11:dim-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
do i = mS-1, mE+12-1
    if(i.ge.12)then
        Nino34(i::12) = (/Nino34(12::12)/)
    else
        Nino34(i:dim-13:12) = (/Nino34(12::12)/)
    end if
end do

;Normalize
;Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)
;Anom3 = (/Anom3 / conform(Anom3, Nino34, 0)/)

Anom3 = (/Anom3*10^6/)

;----------------------------------------------------------
Anom1(:,0,0) = wgt_areaave_Wrap(Anom1, gw1, 1., 0)
Anom1(:,0,0) = (/center_finite_diff_n(Anom1(:,0,0), 1, False, 0, 0)/)
Anom3(:,0,0) = dim_avg_n_Wrap(Anom3(:,{latS},:), 1) - dim_avg_n_Wrap(Anom3(:,{latN},:), 1)

ave11 = clmMonTLL(Anom1(iMM1,0:0,0:0))
ave12 = clmMonTLL(Anom1(iMM2,0:0,0:0))
ave13 = clmMonTLL(Anom1(iMM3,0:0,0:0))
ave14 = clmMonTLL(Anom1(iMM4,0:0,0:0))
ave15 = clmMonTLL(Anom1(iMM5,0:0,0:0))
ave16 = clmMonTLL(Anom1(iMM6,0:0,0:0))
ave21 = clmMonTLL(Anom3(iMM1,0:0,0:0))
ave22 = clmMonTLL(Anom3(iMM2,0:0,0:0))
ave23 = clmMonTLL(Anom3(iMM3,0:0,0:0))
ave24 = clmMonTLL(Anom3(iMM4,0:0,0:0))
ave25 = clmMonTLL(Anom3(iMM5,0:0,0:0))
ave26 = clmMonTLL(Anom3(iMM6,0:0,0:0))

data = new((/7,2,12/), typeof(ave11))
copy_VarMeta(ave11(:,0,0), data(0,0,:))
data(0,0,:) = (/ave15(:,0,0) - ave16(:,0,0)/)
data(1,0,:) = (/ave11(:,0,0) - ave13(:,0,0)/)
data(2,0,:) = (/ave12(:,0,0) - ave14(:,0,0)/)
data(3,0,:) = (/ave11(:,0,0)/)
data(4,0,:) = (/ave12(:,0,0)/)
data(5,0,:) = (/ave13(:,0,0)/)
data(6,0,:) = (/ave14(:,0,0)/)
data(0,1,:) = (/ave25(:,0,0) - ave26(:,0,0)/)
data(1,1,:) = (/ave21(:,0,0) - ave23(:,0,0)/)
data(2,1,:) = (/ave22(:,0,0) - ave24(:,0,0)/)
data(3,1,:) = (/ave21(:,0,0)/)
data(4,1,:) = (/ave22(:,0,0)/)
data(5,1,:) = (/ave23(:,0,0)/)
data(6,1,:) = (/ave24(:,0,0)/)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot = new(7, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnYRefLine = .0
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.023
res@gsnYRefLineThicknessF = 2
res@gsnYRefLineDashPattern = 1

;Manually creating a legend
res@pmLegendWidthF = 0.06
res@pmLegendHeightF = 0.04
res@pmLegendSide = "Top"
res@pmLegendParallelPosF = 0.85
res@pmLegendOrthogonalPosF = -0.85

res@lgPerimOn = False
res@lgLabelFontHeightF = 0.019

res@tiXAxisOn = False
res@tiYAxisString = text2(0)
;res@tiYAxisFontColor = "red"
res@tiYAxisFontHeightF = 0.021

res@trYMaxF = 1.5
res@trYMinF = -2.5

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0,11,3)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.021
res@tmYLLabelFontHeightF = 0.021

res@vpWidthF = 0.85
res@vpHeightF = 0.3

;res@xyLineColor = res@tiYAxisFontColor
res@xyDashPattern = 0
res@xyLineThicknessF = 4.
res@xyExplicitLegendLabels = text4(0)

resR = res
delete(resR@gsnYRefLine)
resR@trYMaxF = 4.5
resR@trYMinF = -7.5
resR@tiYAxisString = text2(1)
resR@tiYAxisFontColor = "blue"
resR@xyLineColor = resR@tiYAxisFontColor
resR@xyExplicitLegendLabels = text4(1)
resR@pmLegendParallelPosF = 0.827
resR@pmLegendOrthogonalPosF = -1.05

res@gsnLeftString = text1(0)
;res@pmLegendDisplayMode = "Always"
resR@pmLegendDisplayMode = "Always"
;plot(0) = gsn_csm_xy2(wks, x, data(0,0,:), data(0,1,:), res, resR)
plot(0) = gsn_csm_xy(wks, x, data(0,0,:), res)

res@gsnLeftString = text1(1)
res@pmLegendDisplayMode = "NoCreate"
resR@pmLegendDisplayMode = "NoCreate"
;plot(1) = gsn_csm_xy2(wks, x, data(1,0,:), data(1,1,:), res, resR)
plot(1) = gsn_csm_xy(wks, x, data(1,0,:), res)

res@gsnLeftString = text1(2)
;plot(2) = gsn_csm_xy2(wks, x, data(2,0,:), data(2,1,:), res, resR)
plot(2) = gsn_csm_xy(wks, x, data(2,0,:), res)
/;
res@gsnLeftString = text1(3)
plot(3) = gsn_csm_xy2(wks, x, data(3,0,:), data(3,1,:), res, resR)

res@gsnLeftString = text1(4)
plot(4) = gsn_csm_xy2(wks, x, data(4,0,:), data(4,1,:), res, resR)

res@gsnLeftString = text1(5)
plot(5) = gsn_csm_xy2(wks, x, data(5,0,:), data(5,1,:), res, resR)

res@gsnLeftString = text1(6)
plot(6) = gsn_csm_xy2(wks, x, data(6,0,:), data(6,1,:), res, resR)
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text5
resP@txFontHeightF = 0.026
;resP@gsnPanelRowSpec = True
;gsn_panel(wks, plot, (/1,2,2,2/), resP)
gsn_panel(wks, plot(:2), (/3,1/), resP)

end
