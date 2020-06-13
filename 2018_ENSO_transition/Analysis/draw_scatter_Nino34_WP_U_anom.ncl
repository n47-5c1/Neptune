;*************************************************************
;Aim: Draw a scatter plot of the Nino 3.4 index and western Pacific
;
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-09-11
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------uwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "SST/HadISST/HadISST_sst.nc"
    in_name2 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"

;time
    yS = 1958
    yE = 2017
    mS = 9
    mE = 8
    yENSO = (/1958,1963,1965,1968,1969,1972,1976,1977,1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009,2014,2015,\
                1964,1970,1971,1973,1974,1975,1983,1984,1988,1995,1998,1999,2000,2005,2007,2008,2010,2011/)
    ny = dimsizes(yENSO)
    season = (/"JFM","AMJ","JAS","OND"/)

;Nino 3.4
    latN1 = 5
    latS1 = -5
    lonW1 = 190
    lonE1 = 240

;central Pacific
    latN2 = 10
    latS2 = -10
    lonW2 = 160
    lonE2 = 240
/;
;western Pacific
    latN2 = 10
    latS2 = -5
    lonW2 = 120
    lonE2 = 160
;/
;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "scatter_Nino34_WP_U_anom"

;text
    text1 = (/"Nino 3.4 (~F35~J~F~C)","WP uwnd (m s~S~-1~N~)"/)
;    text1 = (/"Nino 3.4 (~F35~J~F~C)","CP uwnd (S - N; m s~S~-1~N~)"/)
    text2 = (/"58","63","64","65","68","69","70","71","72","73","74","75","76","77","79","82","83","84","86","87","88","91","94","95",\
                "97","98","99","00","02","04","05","06","07","08","09","10","11","14","15"/)

    size = 0.016
;    colors = (/"black","red","red","black","blue","red","blue","red","red","blue","blue","red","blue","black","black","red","blue",\
;                "black","blue","red","black","black","red","black","red","blue","blue","black","black","red","red","red","blue","red",\
;                "red","blue","black","blue","red"/)
;    colors = (/"black","red","red","black","black","red","black","red","red","black","black","red","black","black","black","red","black",\      ;Tran/Non
;                "black","black","red","black","black","red","black","red","black","black","black","black","red","red","red","black","red",\
;                "red","black","black","black","red"/)
;    colors = (/"blue","blue","red","blue","blue","red","blue","red","red","blue","blue","blue","red","blue","blue","red","blue","red",\      ;CP/EP
;                "red","blue","blue","blue","blue","red","red","blue","blue","blue","blue","blue","red","red","blue","blue","blue","blue",\
;                "blue","blue","red"/)
    colors = (/"deepskyblue","blue4","red4","deepskyblue","deepskyblue","red4","deepskyblue","red4","red4","deepskyblue","deepskyblue","blue4","orange","deepskyblue","deepskyblue","red4","deepskyblue","orange",\
                "orange","blue4","deepskyblue","deepskyblue","blue4","orange","red4","deepskyblue","deepskyblue","deepskyblue","deepskyblue","blue4","red4","red4","deepskyblue","blue4","blue4","deepskyblue",\
                "deepskyblue","deepskyblue","red4"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")

;get the time indexs
    time1 = in1->time
    time2 = in2->time

    TIME1 = cd_calendar(time1, 0)
    TIME2 = cd_calendar(time2, 0)
    year1 = toint(TIME1(:,0))
    year2 = toint(TIME2(:,0))
    iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)

    month_p = toint(TIME1(:,1))
    year = year1(iYYYY1)
    month = month_p(iYYYY1)

    ENSO = (year.eq.yENSO(0) .and. month.ge.mS .or. year.eq.yENSO(0)+1 .and. month.lt.mS)
    do i = 1, ny - 1
     ENSO = ENSO .or. (year.eq.yENSO(i) .and. month.ge.mS .or. year.eq.yENSO(i)+1 .and. month.lt.mS)
    end do

    iMM = ind(ENSO)

;----------------------------------------------------------

    sst = lonFlip(in1->sst(iYYYY1,:,:))
    uwnd = in2->uwnd(iYYYY2,:,:)
    lat1 = in1->latitude
    lat2 = in2->lat
;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw1 = cos(rad * lat1)
    gw2 = cos(rad * lat2)
    copy_VarCoords(lat1, gw1)
    copy_VarCoords(lat2, gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate climatology
    clm1 = clmMonTLL(sst)
    clm2 = clmMonTLL(uwnd)

;Monthly anomalies
    Anom1 = calcMonAnomTLL(sst, clm1)
    Anom2 = calcMonAnomTLL(uwnd, clm2)

;----------------------------------------------------------
    season1 = month_to_season(Anom1(iMM,:,:), season(1))
;    season2 = dim_avg_n_Wrap(month_to_seasonN(Anom2(iMM,:,:), season),0)
    season2 = month_to_seasonN(Anom2(iMM,:,:), season)

    ave1 = wgt_areaave_Wrap(season1(:,{latN1:latS1},{lonW1:lonE1}), gw1({latN1:latS1}), 1., 0)
    dim = dimsizes(ave1)
;    ave2 = wgt_areaave_Wrap(season2(1,:,{latN2:latS2},{lonW2:lonE2}), gw2({latN2:latS2}), 1., 0)
    ave2 = wgt_areaave_Wrap(season2(1,:,{0:latS2},{lonW2:lonE2}), gw2({0:latS2}), 1., 0)
    ave2 = (/ave2 - wgt_areaave_Wrap(season2(1,:,{latN2:0},{lonW2:lonE2}), gw2({latN2:0}), 1., 0)/)
    ave3 = wgt_areaave_Wrap(season2(0,:,{0:latS2},{lonW2:lonE2}), gw2({0:latS2}), 1., 0)
    ave3 = (/ave3 - wgt_areaave_Wrap(season2(0,:,{latN2:0},{lonW2:lonE2}), gw2({latN2:0}), 1., 0)/)
    ave2 = (/ave2 - ave3/)

    x = new((/2,dim/), float)
    x(0,:) = (/ave1/)
    x(1,:) = (/ave2/)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
member = new(dim, graphic)
dum = new(2, graphic)

;*******************************************
; plot timeseries
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = .024

res@tiXAxisFontHeightF = .023

res@tmXBLabelFontHeightF = .023
res@tmYLLabelFontHeightF = .023

;res@trYMaxF = 4.5
;res@trYMinF = -2.5
res@trYMaxF = 4.
res@trYMinF = -2.
res@trXMaxF = 3.
res@trXMinF = -2.5

res@tiXAxisString = text1(0)
res@tiYAxisString = text1(1)
plot = gsn_csm_xy (wks, (/0,0/), (/0,0/), res)

/;
res@gsnLeftString = text1(2)
res@trYMaxF = 1.7
res@trYMinF = .0
res@trXMaxF = 1.6
res@trXMinF = -.1
res@tiYAxisString = text2(4)
res@tiXAxisString = text2(5)
plot(2) = gsn_csm_xy (wks, transpose((/A(4,:1),A(4,:1)/)), transpose((/A(3,:1),A(3,:1)/)) ,res)
;/

;--------------------------------------------------------------
;each year
reso = True
reso@txFontHeightF = size
reso@txFontColor = colors(0)
do i = 0, dim-1
    reso@txFontColor = colors(i)
    member(i) = gsn_add_text(wks, plot, text2(i), x(0,i), x(1,i), reso)
end do

;--------------------------------------------------------------
;add the line
resl = True
resl@gsLineThicknessF = 2.
resl@gsLineDashPattern = 1
dum(0) = gsn_add_polyline(wks, plot, (/0.,0./), (/res@trYMinF,res@trYMaxF/), resl)
dum(1) = gsn_add_polyline(wks, plot, (/res@trXMinF,res@trXMaxF/), (/0.,0./), resl)

draw(plot)
frame(wks)

end
