;*************************************************************
;Aim: Draw the evolution of tropical sea surface height and geostrophic current anomalies during El Nino for transisitonal and non-transistional events in certain years
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

begin

;================================================
;Variables List:
;   var1--------------ssh
;================================================

;data
in_path = "~/data/observation/"
in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"
in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"

;time
mS = 10
mE = 9
yS = 1958
yE = 2010

y1 = 1972
y2 = 1986
y3 = 1987
y4 = 1991

;region
latN = 20
latS = -20
lonW = 120
lonE = 285

;fig
out_path = "~/hes/ENSO/Termination/Case/"
out_name = "case_tropic_tran_ElNino_SSH_UgVg_anom"

;text
text1 = (/"a) Feb(+1)","b)","d) Oct(0)","d)","b) Mar(+1)","f)","e) Nov(0)","h)","c) Apr(+1)","j)","f) Dec(0)","l)","m) Feb(+1)","n)","o)","p)","q) Mar(+1)","r)","s)","t)","u) Apr(+1)","v)","w)","X)"/)
text2 = (/"Transitional EP, "+y1,"Non-transitional EP, "+y2,"Transitional CP, "+y3,"Non-transitional CP, "+y4,"SSHA (cm)"/)
text3 = "Composite SSH Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_path + in_name1, "r")
time1 = in1->time

files2 = systemfunc("ls " + in_path + in_name2)
setfileoption("cdf", "SuppressClose", False)
in2 = addfiles(files2, "r")
ListSetType(in2, "join")

;get the time indexs
TIME1 = cd_calendar(time1, 0)
year1 = toint(TIME1(:,0))
month1 = toint(TIME1(:,1))
dimX = dimsizes(year1)

year = new(dimX+24, typeof(year1))
month = new(dimX+24, typeof(month1))
copy_VarMeta(year1, year(:dimX-1))
copy_VarMeta(month1, month(:dimX-1))
year(:dimX-1) = (/year1/)
month(:dimX-1) = (/month1/)
year(dimX:) = (/2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,2009,\
                2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010,2010/)
month(dimX:) = (/1,2,3,4,5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11,12/)

iMM1 = ind(year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
iMM2 = ind(year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
iMM3 = ind(year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
iMM4 = ind(year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

;----------------------------------------------------------
ssh1 = in1->ssh(:,{latS:latN},{lonW:lonE})
SSH2 = in2[:]->SSH(:,{latS:latN},{lonW:lonE})
ssh1 = (/100 * ssh1/)
SSH2 = (/100 * SSH2/)
dimY = dimsizes(ssh1)
ssh = new((/dimY(0)+24,dimY(1),dimY(2)/), typeof(ssh1))
copy_VarMeta(ssh1, ssh(:dimY(0)-1,:,:))
ssh(:dimY(0)-1,:,:) = (/ssh1/)
ssh(dimY(0):,:,:) = (/SSH2/)
printVarSummary(ssh)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Compute the geostrophic currents
uv = z2geouv(ssh,ssh&lat,ssh&lon,0)
u = uv(0,:,:,:)
v = uv(1,:,:,:)
copy_VarCoords(ssh, u)
copy_VarCoords(ssh, v)

;Calculate climatology
clm1 = clmMonTLL(ssh)
clm2 = clmMonTLL(u)
clm3 = clmMonTLL(v)

;Monthly anomalies
Anom1 = calcMonAnomTLL(ssh, clm1)
Anom2 = calcMonAnomTLL(u, clm2)
Anom3 = calcMonAnomTLL(v, clm3)

Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)

ave11 = clmMonTLL(Anom1(iMM1,:,:))
ave12 = clmMonTLL(Anom1(iMM2,:,:))
ave13 = clmMonTLL(Anom1(iMM3,:,:))
ave14 = clmMonTLL(Anom1(iMM4,:,:))
ave21 = clmMonTLL(Anom2(iMM1,:,:))
ave22 = clmMonTLL(Anom2(iMM2,:,:))
ave23 = clmMonTLL(Anom2(iMM3,:,:))
ave24 = clmMonTLL(Anom2(iMM4,:,:))
ave31 = clmMonTLL(Anom3(iMM1,:,:))
ave32 = clmMonTLL(Anom3(iMM2,:,:))
ave33 = clmMonTLL(Anom3(iMM3,:,:))
ave34 = clmMonTLL(Anom3(iMM4,:,:))

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================
wks = gsn_open_wks("svg", out_path + out_name)
plot1 = new(24, graphic)
plot2 = new(24, graphic)

;---------------------------------------------------------------
;plot shading
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.024

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnInfoLabelOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-9.,-6.,-3.,3.,6.,9./)

res@lbLabelBarOn = False

res@mpLandFillColor = "gray75"
res@mpOutlineOn = False
res@mpCenterLonF = 202.5
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@tmYLMinorOn = False
res@tmYRMinorOn = False
res@tmXBLabelFontHeightF = 0.023
res@tmYLLabelFontHeightF = 0.023

do i = 0, 5
    res@gsnLeftString = text1(4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(0)
    else
        res@gsnCenterString = " "
        res@gsnRightString = " "
    end if
    plot1(4*i) = gsn_csm_contour_map_ce(wks, ave11(i+4,:,:), res)

    res@gsnLeftString = text1(1+4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(1)
        res@gsnRightString = text2(4)
    end if
    plot1(1+4*i) = gsn_csm_contour_map_ce(wks, ave12(i,:,:), res)

    res@gsnLeftString = text1(2+4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(2)
    end if
    plot1(2+4*i) = gsn_csm_contour_map_ce(wks, ave13(i,:,:), res)

    res@gsnLeftString = text1(3)
    if(i.eq.0)then
        res@gsnCenterString = text2(3)
    end if
    plot1(3+4*i) = gsn_csm_contour_map_ce(wks, ave14(i,:,:), res)
end do
/;
;---------------------------------------------------------------
;plot vector
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "

res2@vcRefAnnoOn = False
res2@vcRefLengthF = 0.05
res2@vcRefMagnitudeF = 50
res2@vcRefAnnoString2On = False
res2@vcRefAnnoOrthogonalPosF = 0.28
res2@vcMinDistanceF = 0.03
;res2@vcLineArrowThicknessF = 1.6
res2@vcLineArrowHeadMaxSizeF = 0.02
res2@vcLineArrowHeadMinSizeF = 0.01

do i = 0, 5
    plot2(4*i) = gsn_csm_vector(wks, ave21(i,:,:), ave31(i,:,:), res2)
    plot2(1+4*i) = gsn_csm_vector(wks, ave22(i,:,:), ave32(i,:,:), res2)
    plot2(2+4*i) = gsn_csm_vector(wks, ave23(i,:,:), ave33(i,:,:), res2)

    if(i .eq. 5)then
        res2@vcRefAnnoOn = True
    end if
    plot2(3+4*i) = gsn_csm_vector(wks, ave24(1+i,:,:), ave34(1+i,:,:), res2)
end do

do i = 0, 23
    overlay(plot1(i), plot2(i))
end do

;---------------------------------------------------------------
;plot zero contour
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
;res2@gsnContourZeroLineThicknessF = 2

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/0/)
res2@cnLineLabelsOn = False
res2@cnInfoLabelOn = False

do i = 0, 5
    plot2(4*i) = gsn_csm_contour(wks, ave11(i,:,:), res2)
    plot2(1+4*i) = gsn_csm_contour(wks, ave12(i,:,:), res2)
    plot2(2+4*i) = gsn_csm_contour(wks, ave13(i,:,:), res2)
    plot2(3+4*i) = gsn_csm_contour(wks, ave14(i,:,:), res2)
end do

do i = 0, 23
    overlay(plot1(i), plot2(i))
end do
;/
;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text3
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
;resP@pmLabelBarWidthF = 0.3
resP@pmLabelBarOrthogonalPosF = -0.01
gsn_panel(wks, plot1((/0,2,4,6,8,10/)), (/3,2/), resP)

end
