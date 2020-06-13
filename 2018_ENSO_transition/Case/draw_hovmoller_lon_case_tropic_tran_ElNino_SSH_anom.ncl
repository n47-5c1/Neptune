;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude) of tropical sea surface height anomalies during El Nino for transisitonal and non-transistional events in certain years
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the composite
;
;                       Shan He
;                       2019-11-14
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------ssh
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"

;time
    mS = 9
    mE = 8
    yS = 1958
    yE = 2008

    y1 = 1972
    y2 = 1986
    y3 = 1987
    y4 = 1991

;region
    latN = 5
    latS = -5
    lonW = 120
    lonE = 285

;fig
    out_path = "~/hes/ENSO/Termination/Case/"
    out_name = "hovmoller_lon_case_tropic_tran_ElNino_SSH_anom"

;text
    text1 = (/"c) Transitional EP, "+y1,"d) Non-transitional EP, "+y2,"g) Transitional CP, "+y3,"h) Non-transitional CP, "+y4/)
    text2 = "cm"
    text3 = (/"9(0)","12(0)","3(+1)","6(+1)"/)
    text4 = "Hovmoller of SSH Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    time1 = in1->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    year1_p = toint(TIME1(:,0))
    iYYYY1 = ind(year1_p.ge.yS .and. year1_p.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1_p(iYYYY1)
    month = month_p(iYYYY1)

    iMM1 = ind(year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
    iMM2 = ind(year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
    iMM3 = ind(year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
    iMM4 = ind(year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

;----------------------------------------------------------
    ssh = in1->ssh(:,{latN:latS},{lonW:lonE})
    ssh = (/100 * ssh/)
    printVarSummary(ssh)

;----------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat({latN:latS})
    gw1 = cos(rad * gw1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
clm1 = clmMonTLL(ssh)

;Monthly anomalies
Anom1 = calcMonAnomTLL(ssh, clm1)

;----------------------------------------------------------
Anom1(:,0,:) = dim_avg_wgt_n_Wrap(Anom1, gw1, 1, 1)

ave1_p = clmMonTLL(Anom1(iMM1,0:0,:))
ave2_p = clmMonTLL(Anom1(iMM2,0:0,:))
ave3_p = clmMonTLL(Anom1(iMM3,0:0,:))
ave4_p = clmMonTLL(Anom1(iMM4,0:0,:))

ave1 = ave1_p(:,0,:) 
ave2 = ave2_p(:,0,:) 
ave3 = ave3_p(:,0,:) 
ave4 = ave4_p(:,0,:) 

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(4, graphic)
plot2 = new(4, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnCenterString = " "
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.028

res@cnFillOn = True
res@cnFillPalette = "MPL_RdYlBu"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-12.,-8.,-4.,4.,8.,12./)

res@lbLabelBarOn = False

res@tmYLMode = "Explicit"
res@tmYLValues = ispan(0,11,3)
res@tmYLLabels = text3
;res@tmXBTickSpacingF = 15.
res@tmXBLabelFontHeightF = 0.026
res@tmYLLabelFontHeightF = 0.026

res@vpWidthF = 0.93
res@vpHeightF = 0.4

res@gsnLeftString = text1(0)
plot1(0) = gsn_csm_hov(wks, ave1, res)

res@gsnLeftString = text1(1)
res@gsnRightString = text2
plot1(1) = gsn_csm_hov(wks, ave2, res)

res@gsnLeftString = text1(2)
res@gsnRightString = " "
plot1(2) = gsn_csm_hov(wks, ave3, res)

res@gsnLeftString = text1(3)
plot1(3) = gsn_csm_hov(wks, ave4, res)

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

plot2(0) = gsn_csm_hov(wks, ave1, res2)
plot2(1) = gsn_csm_hov(wks, ave2, res2)
plot2(2) = gsn_csm_hov(wks, ave3, res2)
plot2(3) = gsn_csm_hov(wks, ave4, res2)

do i = 0, 3
    overlay(plot1(i), plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text4
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008
gsn_panel(wks, plot1, (/2,2/), resP)

end
