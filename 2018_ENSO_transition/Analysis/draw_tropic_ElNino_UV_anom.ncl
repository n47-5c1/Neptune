;*************************************************************
;Aim: Draw (partial?) correlation between tropical seasonal surface wind anomalies during positive phase and DJF EP index as well as CP index
;     calculated by two methods
;
;Mission:
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;
;                       Shan He
;                       2018-11-09
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;   var5--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.surf.mon.mean.nc"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 6
    mE = 5
    yS = 1958
    yE = 2017

    season = (/"AMJ","JAS"/)

;    y1 = (/1969,1972,1982,1997,2006,2015/)
;    y2 = (/1976,1986/)
;    y3 = (/1963,1987,1994,2004,2009/)
;    y4 = (/1958,1965,1968,1977,1979,1991,2002,2014/)
    y1 = 2006
    y2 = 2015
    y3 = 1976
    y4 = 1986

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;map region
    latN2 = 30
    latS2 = -30
    lonW2 = 90
    lonE2 = 270

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "tropic_ElNino_UV_anom"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)"/)
    text2 = (/"SON","DJF"/)
    text3 = "Wind Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    in3 = addfile(in_path + in_name3, "r")
    time1 = in1->time
    time3 = in3->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    year1 = toint(TIME1(:,0))
    year3 = toint(TIME3(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY3 = ind(year3.ge.yS .and. year3.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    E1 = (year.eq.y1 .and. month.ge.mS .or. year.eq.y1+1 .and. month.lt.mS)
    E2 = (year.eq.y2 .and. month.ge.mS .or. year.eq.y2+1 .and. month.lt.mS)
    E3 = (year.eq.y3 .and. month.ge.mS .or. year.eq.y3+1 .and. month.lt.mS)
    E4 = (year.eq.y4 .and. month.ge.mS .or. year.eq.y4+1 .and. month.lt.mS)

    iMM1 = ind(E1)
    iMM2 = ind(E2)
    iMM3 = ind(E3)
    iMM4 = ind(E4)

;----------------------------------------------------------
    uwnd = in1->uwnd(iYYYY1,:,:)
    vwnd = in2->vwnd(iYYYY1,:,:)
    sst_p = lonFlip(in3->sst)
    sst = sst_p(iYYYY3,:,:)

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad = 4. * atan(1.) / 180.
    gw = in3->latitude
    gw = cos(rad * gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
    clm1 = clmMonTLL(uwnd)
    clm2 = clmMonTLL(vwnd)
    clm3 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(uwnd, clm1)
    Anom2 = calcMonAnomTLL(vwnd, clm2)
    SSTA = calcMonAnomTLL(sst, clm3)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(SSTA(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
    dim = dimsizes(Nino34)
    Nino34(12::12) =  (/(Nino34(11:dim-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            Nino34(i::12) = (/Nino34(12::12)/)
        else
            Nino34(i:dim-13:12) = (/Nino34(12::12)/)
        end if
    end do

;Normalize
    Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)
    Anom2 = (/Anom2 / conform(Anom2, Nino34, 0)/)

    u1 = month_to_seasonN(Anom1(iMM1,:,:), season)
    u2 = month_to_seasonN(Anom1(iMM2,:,:), season)
    u3 = month_to_seasonN(Anom1(iMM3,:,:), season)
    u4 = month_to_seasonN(Anom1(iMM4,:,:), season)

    v1 = month_to_seasonN(Anom2(iMM1,:,:), season)
    v2 = month_to_seasonN(Anom2(iMM2,:,:), season)
    v3 = month_to_seasonN(Anom2(iMM3,:,:), season)
    v4 = month_to_seasonN(Anom2(iMM4,:,:), season)

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(8, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = " "
res@gsnScalarContour = True       ;contours desired
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-4.,-2.,-1.,0.,1.,2.,4./)

res@lbLabelBarOn = False

res@vcGlyphStyle = "CurlyVector"
res@vcRefAnnoOn = False
res@vcRefLengthF = 0.06
res@vcRefMagnitudeF = 5
res@vcRefAnnoOrthogonalPosF = -0.27
res@vcMinDistanceF = 0.03
res@vcLineArrowThicknessF = 1.6
res@vcLineArrowHeadMaxSizeF = 0.018
res@vcLineArrowHeadMinSizeF = 0.009

res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
res@mpMinLatF = latS2
res@mpMaxLatF = latN2
res@mpMinLonF = lonW2
res@mpMaxLonF = lonE2

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

do i = 0, 1
    if(i .eq. 0)then
        res@gsnLeftString = text1(i) + " " + y1
    else
        res@gsnLeftString = text1(i)
    end if
    res@gsnCenterString = text2(i)
    plot(i) = gsn_csm_vector_scalar_map_ce(wks, u1(i,0,:,:), v1(i,0,:,:), u1(i,0,:,:), res)

    if(i .eq. 0)then
    res@gsnLeftString = text1(i+2) + " " + y2
    else
        res@gsnLeftString = text1(i+2)
    end if
    res@gsnCenterString = " "
    plot(i+2) = gsn_csm_vector_scalar_map_ce(wks, u2(i,0,:,:), v2(i,0,:,:), u2(i,0,:,:), res)

    if(i .eq. 0)then
    res@gsnLeftString = text1(i+2*2) + " " + y3
    else
        res@gsnLeftString = text1(i+2*2)
    end if
    plot(i+2*2) = gsn_csm_vector_scalar_map_ce(wks, u3(i,0,:,:), v3(i,0,:,:), u3(i,0,:,:), res)

    if(i .eq. 0)then
    res@gsnLeftString = text1(i+3*2) + " " + y4
    else
        res@gsnLeftString = text1(i+3*2)
    end if
    if(i .eq. 1)then
        res@vcRefAnnoOn = True
    end if
    plot(i+3*2) = gsn_csm_vector_scalar_map_ce(wks, u4(i,0,:,:), v4(i,0,:,:), u4(i,0,:,:), res)
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008
resP@txString = text3
gsn_panel(wks, plot, (/4,2/), resP)

end
