;*************************************************************
;Aim: Draw composite of the evolution of tropical sea surface height and geostrophic current anomalies during El Nino for transisitonal and non-transistional events
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
;   var2--------------sst
;================================================

;data
in_path = "~/data/observation/"
in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"
in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"
in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
mS = 10
mE = 9
yS = 1958
yE = 2010

;y1 = (/1969,2006/)
;y2 = (/1986/)
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
latN = 20
latS = -20
lonW = 120
lonE = 285

;Nino 3.4
latNI = 5
latSI = -5
lonWI = 190
lonEI = 240

;fig
out_path = "~/hes/ENSO/Termination/Fig/"
out_name = "comp_tropic_tran_ElNino_SSH_UgVg_anom"

;text
text1 = (/"a) Dec(0)","f)","k)","d)","b) Jan(+1)","g)","l)","h)","c) Feb(+1)","h)","m)","l)","d) Mar(+1)","i)","n)","p)","q) Mar(+1)","r)","s)","t)","u) Apr(+1)","v)","w)","X)"/)
text2 = (/"Transitional EP","Non-transitional EP","Transitional CP","Non-transitional CP","SSHA (cm)"/)
text3 = "Composite SSH Anomalies during El Nino"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

in1 = addfile(in_path + in_name1, "r")
in3 = addfile(in_path + in_name3, "r")

files2 = systemfunc("ls " + in_path + in_name2)
setfileoption("cdf", "SuppressClose", False)
in2 = addfiles(files2, "r")
ListSetType(in2, "join")

time1 = in1->time
time3 = in3->time

;get the time indexs
TIME1 = cd_calendar(time1, 0)
TIME3 = cd_calendar(time3, 0)
year1 = toint(TIME1(:,0))
month1 = toint(TIME1(:,1))
dimX = dimsizes(year1)
year3 = toint(TIME3(:,0))
iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)

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
sst = lonFlip(in3->sst(iYYYY3,:,:))
printVarSummary(ssh)

;----------------------------------------------------------
;creat weights: cos(lat)
rad = 4. * atan(1.) / 180.
gw = in3->latitude({latSI:latNI})
gw = cos(rad * gw)

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
clm2 = clmMonTLL(sst)
clm3 = clmMonTLL(u)
clm4 = clmMonTLL(v)

;Monthly anomalies
Anom1 = calcMonAnomTLL(ssh, clm1)
Anom2 = calcMonAnomTLL(sst, clm2)
Anom3 = calcMonAnomTLL(u, clm3)
Anom4 = calcMonAnomTLL(v, clm4)

Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)
Anom4 = (/dtrend_msg_n(Anom4&time, Anom4, False, False, 0)/)

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
Anom4 = (/Anom4 / conform(Anom4, Nino34, 0)/)

ave11 = clmMonTLL(Anom1(iMM1,:,:))
ave12 = clmMonTLL(Anom1(iMM2,:,:))
ave13 = clmMonTLL(Anom1(iMM3,:,:))
ave14 = clmMonTLL(Anom1(iMM4,:,:))
ave31 = clmMonTLL(Anom3(iMM1,:,:))
ave32 = clmMonTLL(Anom3(iMM2,:,:))
ave33 = clmMonTLL(Anom3(iMM3,:,:))
ave34 = clmMonTLL(Anom3(iMM4,:,:))
ave41 = clmMonTLL(Anom4(iMM1,:,:))
ave42 = clmMonTLL(Anom4(iMM2,:,:))
ave43 = clmMonTLL(Anom4(iMM3,:,:))
ave44 = clmMonTLL(Anom4(iMM4,:,:))

;----------------------------------------------------------
;Calculate difference
diff1 = (/ave11 - ave12/)
diff2 = (/ave13 - ave14/)
copy_VarCoords(ave11, diff1)
copy_VarCoords(ave13, diff2)

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
res@cnLevels = (/-8.,-4.,-2.,2.,4.,8./)

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

;ave11 = (/ave11 + ave12/)/2
;ave12 = (/ave13 - ave14/)

do i = 0, 5
    res@gsnLeftString = text1(4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(0)
    else
        res@gsnCenterString = " "
        res@gsnRightString = " "
    end if
    plot1(4*i) = gsn_csm_contour_map_ce(wks, ave11(2+i,:,:), res)

    res@gsnLeftString = text1(1+4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(1)
    end if
    plot1(1+4*i) = gsn_csm_contour_map_ce(wks, ave12(2+i,:,:), res)

    res@gsnLeftString = text1(2+4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(2)
        res@gsnRightString = text2(4)
    end if
    plot1(2+4*i) = gsn_csm_contour_map_ce(wks, ave13(2+i,:,:), res)

    res@gsnLeftString = text1(3+4*i)
    if(i.eq.0)then
        res@gsnCenterString = text2(3)
        res@gsnRightString = text2(4)
    end if
    plot1(3+4*i) = gsn_csm_contour_map_ce(wks, ave14(2+i,:,:), res)
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
res2@vcRefMagnitudeF = 40
res2@vcRefAnnoString2On = False
res2@vcRefAnnoOrthogonalPosF = 0.28
res2@vcMinDistanceF = 0.03
;res2@vcLineArrowThicknessF = 1.6
res2@vcLineArrowHeadMaxSizeF = 0.02
res2@vcLineArrowHeadMinSizeF = 0.01

v0 = (/ave41(0,:,:)*0/)
copy_VarCoords(ave41(0,:,:), v0)

do i = 0, 5
    plot2(4*i) = gsn_csm_vector(wks, ave31(1+i,:,:), ave41(1+i,:,:), res2)
    plot2(1+4*i) = gsn_csm_vector(wks, ave32(1+i,:,:), ave42(1+i,:,:), res2)
    plot2(2+4*i) = gsn_csm_vector(wks, ave33(1+i,:,:), ave43(1+i,:,:), res2)

    if(i .eq. 5)then
        res2@vcRefAnnoOn = True
    end if
    plot2(3+4*i) = gsn_csm_vector(wks, ave34(1+i,:,:), ave44(1+i,:,:), res2)
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
    plot2(4*i) = gsn_csm_contour(wks, ave11(2+i,:,:), res2)
    plot2(1+4*i) = gsn_csm_contour(wks, ave12(2+i,:,:), res2)
    plot2(2+4*i) = gsn_csm_contour(wks, ave13(2+i,:,:), res2)
    plot2(3+4*i) = gsn_csm_contour(wks, ave14(2+i,:,:), res2)
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
resP@lbLabelFontHeightF = 0.01
resP@pmLabelBarWidthF = 0.3
resP@pmLabelBarOrthogonalPosF = -0.01
gsn_panel(wks, plot1((/0,1,2,4,5,6,8,9,10,12,13,14/)), (/4,3/), resP)

end
