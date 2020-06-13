;*************************************************************
;Aim: Draw hovmoller diagram (time vs. latitude) of climatology of wind anomalies over the western or central and eastern Pacific anomalies during EP- and CP-ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       Shan He
;                       2018-09-26
;
;*************************************************************

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SODA/2.2.4/soda2.2.4_mn_ocean_reg_taux_1957-2008.nc"
    in_name2 = "SODA/2.2.4/SODA_2.2.4_20*.cdf"
    in_name3 = "SST/HadISST/HadISST_sst.nc"

;time
    mS = 8
    mE = 3
    yS = 1958
    yE = 2010
    x = ispan(mS, mE+12, 1)


    y1 = (/1969,1972,1982,1997,2006/)
    y2 = (/1976,1986/)
    y3 = (/1963,1987,1994,2004,2009/)
    y4 = (/1958,1965,1968,1977,1979,1991,2002/)
;    y1 = (/1964,1971,2005/)
;    y2 = (/1984,1995/)
;    y3 = (/1975,2008/)
;    y4 = (/1970,1973,1974,1983,1988,1998,1999,2000,2007,2010,2011,2016/)

    ny1 = dimsizes(y1)
    ny2 = dimsizes(y2)
    ny3 = dimsizes(y3)
    ny4 = dimsizes(y4)

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;WPW
    latN2 = 10
    latS2 = -10
    lonW2 = 120
    lonE2 = 160

;CPW
    latN3 = 10
    latS3 = -0
    lonW3 = 160
    lonE3 = 240

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "timeseries_tran_ElNino_WPW_CPW_anom_SODA"

;text
    text1 = (/"c) EP","f) CP","i) EP","l) CP"/)
    text2 = (/"Zonal stress anomalies","Zero value latitude","10~S~-3~N~ N m~S~-2"/)
    text3 = (/"9(0)","11(0)","1(+1)","3(+1)"/)
    text4 = (/" Transitional"," Non-transitional"/)
    text5 = "Timeseries of TAUX Anomalies"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in3 = addfile(in_path + in_name3, "r")
    lat = in1->lat({latN3:latS3})
    
    files2 = systemfunc("ls " + in_path + in_name2)
    setfileoption("cdf", "SuppressClose", False)
    in2 = addfiles(files2, "r")
    ListSetType(in2, "join")

    time1 = in1->time
    time3 = in3->time

;get the time indexs
    TIME1 = cd_calendar(time1, 0)
    TIME3 = cd_calendar(time3, 0)
    year1 = toint(TIME1(12:,0))
    month1 = toint(TIME1(12:,1))
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

    iMM1 = ind(E1)
    iMM2 = ind(E2)
    iMM3 = ind(E3)
    iMM4 = ind(E4)

;----------------------------------------------------------
    taux1 = in1->taux(12:,{latN2:latS2},{lonW2:lonE3})
    TAUX2 = in2[:]->TAUX(:,{latN2:latS2},{lonW2:lonE3})
    dimY = dimsizes(taux1)
    taux = new((/dimY(0)+24,dimY(1),dimY(2)/),typeof(taux1))
    copy_VarMeta(taux1, taux(:dimY(0)-1,:,:))
    taux(:dimY(0)-1,:,:) = (/taux1/)
    taux(dimY(0):,:,:) = (/TAUX2/)
    sst = lonFlip(in3->sst(iYYYY3,:,:))

    printVarSummary(taux)

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = in1->lat
    gw3 = in3->latitude
    gw1 = cos(rad * gw1)
    gw3 = cos(rad * gw3)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(taux)
    clm3 = clmMonTLL(sst)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(taux, clm1)
    Anom3 = calcMonAnomTLL(sst, clm3)

;Nino 3.4 (DJF)
    Nino34 = wgt_areaave_Wrap(Anom3(:,{latN1:latS1},{lonW1:lonE1}), gw3({latN1:latS1}), 1., 0)
;    Nino34 = (/-Nino34/)
    dim1 = dimsizes(Nino34)
    Nino34(12::12) = (/(Nino34(11:dim1-13:12) + Nino34(12::12) + Nino34(13::12)) / 3./)
    do i = mS-1, mE+12-1
        if(i.ge.12)then
            Nino34(i::12) = (/Nino34(12::12)/)
        else
            Nino34(i:dim1-13:12) = (/Nino34(12::12)/)
        end if
    end do

;Normalize
    Anom1 = (/Anom1 / conform(Anom1, Nino34, 0)/)

;----------------------------------------------------------
   ave1_p = clmMonTLL(Anom1(iMM1,:,:))
   ave2_p = clmMonTLL(Anom1(iMM2,:,:))
   ave3_p = clmMonTLL(Anom1(iMM3,:,:))
   ave4_p = clmMonTLL(Anom1(iMM4,:,:))

   ave1 = wgt_areaave_Wrap(ave1_p(:mE+12-mS,:,{:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave2 = wgt_areaave_Wrap(ave2_p(:mE+12-mS,:,{:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave3 = wgt_areaave_Wrap(ave3_p(:mE+12-mS,:,{:lonE2}), gw1({latN2:latS2}), 1., 0)
   ave4 = wgt_areaave_Wrap(ave4_p(:mE+12-mS,:,{:lonE2}), gw1({latN2:latS2}), 1., 0)

   dim2 = dimsizes(ave1)

   data = new((/4,dim2/), typeof(ave1))
   data(0,:) = (/ave1/)
   data(1,:) = (/ave2/)
   data(2,:) = (/ave3/)
   data(3,:) = (/ave4/)
   data = (/data * 1000/)
   copy_VarAtts(ave1, data)

   ave1y = dim_avg_n_Wrap(ave1_p({lat|latN3:latS3},{lon|lonW3:},month|:mE+12-mS), 1)
   ave2y = dim_avg_n_Wrap(ave2_p({lat|latN3:latS3},{lon|lonW3:},month|:mE+12-mS), 1)
   ave3y = dim_avg_n_Wrap(ave3_p({lat|latN3:latS3},{lon|lonW3:},month|:mE+12-mS), 1)
   ave4y = dim_avg_n_Wrap(ave4_p({lat|latN3:latS3},{lon|lonW3:},month|:mE+12-mS), 1)

   nlat = new((/4,dim2/), typeof(ave1))
   copy_VarAtts(lat, nlat(0,:))

   a = where(ave1y.le.0, True, False)
   a(0,:) = True
   b = where(ave2y.le.0, True, False)
   b(0,:) = True
   c = where(ave3y.le.0, True, False)
   c(0,:) = True
   d = where(ave4y.le.0, True, False)
   d(0,:) = True

   do i = 0, dim2-1
       nlat(0,i) = (/min(lat(ind(a(:,i))))/)
       nlat(1,i) = (/min(lat(ind(b(:,i))))/)
       nlat(2,i) = (/min(lat(ind(c(:,i))))/)
       nlat(3,i) = (/min(lat(ind(d(:,i))))/)
   end do

; ==============================================================
; Mission 3. Draw the climatology
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(4, graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnYRefLine = .0
res@gsnStringFontHeightF = 0.023
res@gsnYRefLineThicknessF = 2
res@gsnYRefLineDashPattern = 1

;Manually creating a legend
res@pmLegendWidthF = 0.06
res@pmLegendHeightF = 0.07
res@pmLegendSide = "Top"
res@pmLegendParallelPosF = 0.81
res@pmLegendOrthogonalPosF = -0.47

res@lgPerimOn = False
res@lgLabelFontHeightF = 0.019

res@tiXAxisFontHeightF = 0.021
res@tiYAxisFontHeightF = 0.021

res@tmXBMode = "Explicit"
res@tmXBValues = ispan(9,15,2)
res@tmXBLabels = text3
res@tmXBLabelFontHeightF = 0.021
res@tmYLLabelFontHeightF = 0.021

res@vpHeightF = 0.3
res@vpWidthF = 0.75

res@xyLineColors = (/"red","black"/)
;res@xyLineColors = (/"red4","orange","blue4","deepskyblue"/)
res@xyDashPattern = 0
res@xyLineThicknessF = 4.
res@xyExplicitLegendLabels = text4

res@gsnLeftString = text1(0)
res@gsnRightString = text2(2)
res@tiYAxisString = text2(0)
res@trYMaxF = 20.
res@trYMinF = -15.
res@pmLegendDisplayMode = "Always"
plot(0) = gsn_csm_xy(wks, x, data(:1,:), res)

res@gsnLeftString = text1(1)
res@gsnRightString = " "
res@pmLegendDisplayMode = "NoCreate"
plot(1) = gsn_csm_xy(wks, x, data(2:,:), res)

res@gsnLeftString = text1(2)
res@tiYAxisString = text2(1)
res@trYMaxF = 11.
res@trYMinF = -1.
plot(2) = gsn_csm_xy(wks, x, nlat(:1,:), res)

res@gsnLeftString = text1(3)
plot(3) = gsn_csm_xy(wks, x, nlat(2:,:), res)

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@txString = text5
resP@txFontHeightF = 0.026
gsn_panel(wks, plot, (/4,1/), resP)

end
