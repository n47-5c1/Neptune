;*************************************************************
;Aim: Draw hovmoller diagram (time vs. latitude) of composite of tropical sea surface height and vorticity anomalies during El Nino for transisitonal and non-transistional events
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composite
;
;                       Shan He
;                       2019-11-05
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

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

;y1 = (/1969,1972,1976,1982,1986,1997,2006/)
;y2 = (/1958,1963,1965,1968,1977,1979,1987,1991,1994,2002,2004/)
;y3 = (/2004/)
;y4 = (/1965,1968,1991,2002/)
y1 = (/1969,1972,1982,1997,2006/)
y2 = (/1976,1986/)
y3 = (/1963,1987,1994,2004,2009/)
y4 = (/1958,1965,1968,1977,1979,1991,2002/)
ny1 = dimsizes(y1)
ny2 = dimsizes(y2)
ny3 = dimsizes(y3)
ny4 = dimsizes(y4)

;region
latN = 12
;latN = 8
latS = -6
;latS = -8
lonW = 160
;lonW = 240
lonE = 240
;lonE = 280

;Nino 3.4
latNI = 5
latSI = -5
lonWI = 190
lonEI = 240

;fig
out_path = "~/hes/ENSO/Termination/Fig/"
out_name = "hovmoller_lat_comp_tropic_tran_ElNino_SSH_vr_anom"

;text
text1 = (/"e) Transitional EP","j) Non-transitional EP","o) Transitional CP","d) Non-transitional CP"/)
;text1 = (/"a) Transitional EP","b) Non-transitional EP","c) Transitional CP","d) Non-transitional CP"/)
text2 = "~F33~D~F~SSHA (cm/mon)"
;text2 = "~F34~Q~F~SSHA (cm/deg)"
text3 = (/"6(0)","9(0)","12(0)","3(+1)"/)
text4 = "Hovmoller of Composite SSH & VR Anomalies during El Nino"

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
year1_p = toint(TIME1(:,0))
month_p = toint(TIME1(:,1))
dimX = dimsizes(year1_p)
year3_p = toint(TIME3(:,0))
year5_p = toint(TIME5(:,0))
iYYYY3 = ind(year3_p.ge.yS .and. year3_p.le.yE)
iYYYY5 = ind(year5_p.ge.yS .and. year5_p.le.yE)

year = new(dimX+24, typeof(year1_p))
month = new(dimX+24, typeof(month_p))
copy_VarMeta(year1_p, year(:dimX-1))
copy_VarMeta(month_p, month(:dimX-1))
year(:dimX-1) = (/year1_p/)
month(:dimX-1) = (/month_p/)
year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

E1 = (year.eq.y1(0) .and. month.ge.mS .or. year.eq.y1(0)+1 .and. month.lt.mS)
E2 = (year.eq.y2(0) .and. month.ge.mS .or. year.eq.y2(0)+1 .and. month.lt.mS)
E3 = (year.eq.y3(0) .and. month.ge.mS .or. year.eq.y3(0)+1 .and. month.lt.mS)
E4 = (year.eq.y4(0) .and. month.ge.mS .or. year.eq.y4(0)+1 .and. month.lt.mS)
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

iMM1 =ind(E1)
iMM2 =ind(E2)
iMM3 =ind(E3)
iMM4 =ind(E4)

;----------------------------------------------------------
ssh1 = in1->ssh(:,{latS:latN},{lonW:lonE})
SSH2 = in2[:]->SSH(:,{latN:latS},{lonW:lonE})
ssh1 = (/100 * ssh1/)
SSH2 = (/100 * SSH2/)
dimY = dimsizes(ssh1)
ssh = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(ssh1))
copy_VarMeta(ssh1, ssh(:dimY(0)-1,:,:))
ssh(:dimY(0)-1,:,:) = (/ssh1/)
ssh(dimY(0):,:,:) = (/SSH2/)
uwnd = in3->uwnd(iYYYY3,::-1,:)
vwnd = in4->vwnd(iYYYY3,::-1,:)
sst = lonFlip(in5->sst(iYYYY5,:,:))
printVarSummary(ssh)

;----------------------------------------------------------
;creat weights: cos(lat)
rad = 4. * atan(1.) / 180.
gw = in5->latitude({latSI:latNI})
gw = cos(rad * gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Compute vorticity
vr_p = uv2vrF_Wrap(uwnd, vwnd)
vr = vr_p(:,{latS:latN},{lonW:lonE})

;Calculate climatology
clm1 = clmMonTLL(ssh)
clm2 = clmMonTLL(sst)
clm3 = clmMonTLL(vr)

;Monthly anomalies
Anom1 = calcMonAnomTLL(ssh, clm1)
Anom2 = calcMonAnomTLL(sst, clm2)
Anom3 = calcMonAnomTLL(vr, clm3)

Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)

;Nino 3.4 (DJF)
Nino34 = wgt_areaave_Wrap(Anom2(:,{latSI:latNI},{lonWI:lonEI}), gw, 1., 0)
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
Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)
Anom3 = (/Anom3 / conform(Anom3, Nino34, 0)/)

;----------------------------------------------------------
Anom1(:,:,0) = dim_avg_n_Wrap(Anom1, 2)
Anom3(:,:,0) = dim_avg_n_Wrap(Anom3, 2)

ave11_p = clmMonTLL(Anom1(iMM1,:,0:0))
ave12_p = clmMonTLL(Anom1(iMM2,:,0:0))
ave13_p = clmMonTLL(Anom1(iMM3,:,0:0))
ave14_p = clmMonTLL(Anom1(iMM4,:,0:0))
ave31_p = clmMonTLL(Anom3(iMM1,:,0:0))
ave32_p = clmMonTLL(Anom3(iMM2,:,0:0))
ave33_p = clmMonTLL(Anom3(iMM3,:,0:0))
ave34_p = clmMonTLL(Anom3(iMM4,:,0:0))

;ave11_p = (/center_finite_diff_n(ave11_p, 0.5, False, 0, 1)/)
;ave12_p = (/center_finite_diff_n(ave12_p, 0.5, False, 0, 1)/)
;ave13_p = (/center_finite_diff_n(ave13_p, 0.5, False, 0, 1)/)
;ave14_p = (/center_finite_diff_n(ave14_p, 0.5, False, 0, 1)/)
ave11_p = (/center_finite_diff_n(ave11_p, 1, False, 0, 0)/)
ave12_p = (/center_finite_diff_n(ave12_p, 1, False, 0, 0)/)
ave13_p = (/center_finite_diff_n(ave13_p, 1, False, 0, 0)/)
ave14_p = (/center_finite_diff_n(ave14_p, 1, False, 0, 0)/)

ave11 = ave11_p(lat|:,lon|0,month|:)
ave12 = ave12_p(lat|:,lon|0,month|:)
ave13 = ave13_p(lat|:,lon|0,month|:)
ave14 = ave14_p(lat|:,lon|0,month|:)
ave31 = ave31_p(lat|:,lon|0,month|:)
ave32 = ave32_p(lat|:,lon|0,month|:)
ave33 = ave33_p(lat|:,lon|0,month|:)
ave34 = ave34_p(lat|:,lon|0,month|:)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)
plot3 = new(4, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
;res@cnLevels = (/-6.,-4.,-2.,2.,4.,6./)
;res@cnLevels = (/-4.5,-3.,-1.5,1.5,3.,4.5/)
res@cnLevels = (/-1.8,-1.2,-0.6,0.6,1.2,1.8/)

res@lbLabelBarOn = False

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(0,11,3)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@vpWidthF = 0.93
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
plot1(0) = gsn_csm_hov(wks, ave11, res)

res@gsnLeftString = text1(1)
plot1(1) = gsn_csm_lat_time(wks, ave12, res)

res@gsnLeftString = text1(2)
res@gsnRightString = text2
plot1(2) = gsn_csm_lat_time(wks, ave13, res)

res@gsnLeftString = text1(3)
res@gsnRightString = " "
plot1(3) = gsn_csm_lat_time(wks, ave14, res)

;---------------------------------------------------------------
;plot zero contour
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourZeroLineThicknessF = 2

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0/)
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False

plot2(0) = gsn_csm_lat_time(wks, ave11, res2)
plot2(1) = gsn_csm_lat_time(wks, ave12, res2)
plot2(2) = gsn_csm_lat_time(wks, ave13, res2)
plot2(3) = gsn_csm_lat_time(wks, ave14, res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do
/;
;---------------------------------------------------------------
;plot contour
res3 = True

res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnCenterString = " "
res3@gsnRightString = " "
res3@gsnContourZeroLineThicknessF = 3
res3@gsnContourNegLineDashPattern = 1

res3@cnLevelSelectionMode = "ManualLevels"
res3@cnMinLevelValF = -2. * 10^-6
res3@cnMaxLevelValF = 2.5 * 10^-6
res3@cnLevelSpacingF = 0.5 * 10^-6
;res3@cnLineColor = "green"
res3@cnLineLabelsOn = False
res3@cnInfoLabelOn = False

plot3(0) = gsn_csm_lat_time(wks, ave31, res3)
plot3(1) = gsn_csm_lat_time(wks, ave32, res3)
plot3(2) = gsn_csm_lat_time(wks, ave33, res3)
res3@cnInfoLabelOn = True
plot3(3) = gsn_csm_lat_time(wks, ave34, res3)

do i = 0, 3
    overlay(plot1(i), plot3(i))
end do
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text4
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.01
resP@pmLabelBarWidthF = 0.3
resP@pmLabelBarOrthogonalPosF = 0.012
gsn_panel(wks, plot1(:2), (/1,3/), resP)
;gsn_panel(wks, plot1, (/2,2/), resP)

end
