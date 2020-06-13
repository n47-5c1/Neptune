;*************************************************************
;Aim: Draw composites of regional March, April and May winds chosen by PC1 of 250 hPa wind
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2016-05-11
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"

;time
    mS     = 3
    mE     = 5
    yS     = 1979
    yE     = 2015
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;regiion
    latN = 89
    latS = 0
    lonL = -80
    lonR = 170

    neof        = 1      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_reg_MAM_mon_wind_PC1"

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)
    text2 = (/"March","April","May"/)            ;<<<<<<Change>>>>>>
;    text2 = (/"CLM","POS","NEG"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path+in_name1,"r")
    V_file = addfile (in_path+in_name2,"r")

;get the time indexs
    time1  = U_file->time
    time2  = V_file->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    month1 = toint ( TIME1(:,1) )
    month2 = toint ( TIME2(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.mS .and. month1.le.mE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.ge.mS .and. month2.le.mE)

;---------------------------------------------------------
;    U_p    = U_file->uwnd(:,2,:,:)      ;850hPa
;    U_p    = U_file->uwnd(:,5,:,:)      ;500hPa
    U_p    = U_file->uwnd(iYYYY1,8,{latS:latN},:)      ;250hPa
    V_p    = V_file->vwnd(iYYYY2,8,{latS:latN},:)      ;250hPa
    U_p    = lonFlip (U_p)
    V_p    = lonFlip (V_p)
    U      = U_p(:,:,{lonL:lonR})
    V      = V_p(:,:,{lonL:lonR})

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME1)
    printVarSummary (TIME2)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = U_file->lat({latS:latN})
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
    wU           = U
    wV           = V
    wU           = U*conform (U,clat,1)
    wV           = V*conform (V,clat,1)
    wU@long_name = "Wgt: "+wU@long_name
    wV@long_name = "Wgt: "+wV@long_name

    x = (/wU(lat|:,lon|:,time|:),wV(lat|:,lon|:,time|:)/)   ;recorder the input data
    x!1   = "lat"
    x!2   = "lon"
    x&lat = U&lat
    x&lon = U&lon
    printVarSummary (x)

    eof    = eofunc_Wrap (x,neof,optEOF)
    eof_ts = eofunc_ts_Wrap (x,eof,optETS)
    speed  = eof(:,0,:,:)
    speed  = sqrt ( eof(:,0,:,:)^2.+eof(:,1,:,:)^2.)
    printVarSummary (eof)
    printVarSummary (speed)

;normalize time series: sum spatial weights over the area of used
    dimx   = dimsizes (x)
    sumWgt = dimx(1)*sum(clat)
    eof_ts = eof_ts/sumWgt
    printVarSummary (eof_ts)

    eof_ts1 = eof_ts(0,::3)
    eof_ts2 = eof_ts(0,1::3)
    eof_ts3 = eof_ts(0,2::3)

    ave1 = avg (eof_ts1)
    ave2 = avg (eof_ts2)
    ave3 = avg (eof_ts3)
    std1 = .8*stddev (eof_ts1)
    std2 = .8*stddev (eof_ts2)
    std3 = .8*stddev (eof_ts3)

    printVarSummary (eof_ts1)

;---------------------------------------------------------
;Composite Analysis
    comp1p = ind (eof_ts1.gt.ave1+std1)
    comp1n = ind (eof_ts1.lt.ave1-std1)
    comp2p = ind (eof_ts2.gt.ave2+std2)
    comp2n = ind (eof_ts2.lt.ave2-std2)
    comp3p = ind (eof_ts3.gt.ave3+std3)
    comp3n = ind (eof_ts3.lt.ave3-std3)
    
    year_p = year1(iYYYY1)
    year_c = year_p(::3)
    print(year_c(comp1p))
    print(year_c(comp1n))

    U_p1 = U(::3,:,:)
    V_p1 = V(::3,:,:)
    U_p2 = U(1::3,:,:)
    V_p2 = V(1::3,:,:)
    U_p3 = U(2::3,:,:)
    V_p3 = V(2::3,:,:)

    U_c1p = dim_avg_n_Wrap (U_p1(comp1p,:,:),0)
    V_c1p = dim_avg_n_Wrap (V_p1(comp1p,:,:),0)
    U_c1n = dim_avg_n_Wrap (U_p1(comp1n,:,:),0)
    V_c1n = dim_avg_n_Wrap (V_p1(comp1n,:,:),0)
    U_c2p = dim_avg_n_Wrap (U_p2(comp2p,:,:),0)
    V_c2p = dim_avg_n_Wrap (V_p2(comp2p,:,:),0)
    U_c2n = dim_avg_n_Wrap (U_p2(comp2n,:,:),0)
    V_c2n = dim_avg_n_Wrap (V_p2(comp2n,:,:),0)
    U_c3p = dim_avg_n_Wrap (U_p3(comp3p,:,:),0)
    V_c3p = dim_avg_n_Wrap (V_p3(comp3p,:,:),0)
    U_c3n = dim_avg_n_Wrap (U_p3(comp3n,:,:),0)
    V_c3n = dim_avg_n_Wrap (V_p3(comp3n,:,:),0)
    U_clm = dim_avg_n_Wrap (U_p2,0)
    V_clm = dim_avg_n_Wrap (V_p2,0)

    printVarSummary(U_c1p)

    diff_U1 = U_c1p
    diff_V1 = V_c1p
    diff_U2 = U_c2p
    diff_V2 = V_c2p
    diff_U3 = U_c3p
    diff_V3 = V_c3p

    diff_U1 = U_c1p-U_c1n
    diff_V1 = V_c1p-V_c1n
    diff_U2 = U_c2p-U_c2n
    diff_V2 = V_c2p-V_c2n
    diff_U3 = U_c3p-U_c3n
    diff_V3 = V_c3p-V_c3n

    speed1 = sqrt (diff_U1^2.+diff_V1^2)            ;<<<<<<Change>>>>>>
    speed2 = sqrt (diff_U2^2.+diff_V2^2)
    speed3 = sqrt (diff_U3^2.+diff_V3^2)
;    speed1 = sqrt (U_clm^2.+V_clm^2.)
;    speed2 = sqrt (U_c2p^2.+V_c2p^2.)
;    speed3 = sqrt (U_c2n^2.+V_c2n^2.)

    copy_VarCoords (diff_U1,speed1)
    copy_VarCoords (diff_U2,speed2)
    copy_VarCoords (diff_U3,speed3)

; ==============================================================
; Mission 3. Draw the composites
; ==============================================================

wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
plot = new (3,graphic)      ;creat a plot array

res = True

res@gsnDraw           = False      ;don't draw
res@gsnFrame          = False      ;don't advance frame
res@gsnAddCyclic      = False
res@gsnSpreadColorEnd = 250        ; end at color 200

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

res@stArrowLengthF     = 0.008      ;size of the arrows
res@stMinArrowSpacingF = 0.08       ;arrow spacing
res@stLineThicknessF   = 1.1        ;changes the line thickness
res@stMinDistanceF     = 0.05       ;distance between streamlines
res@stMinLineSpacingF  = 0.004

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 2       ;set min contour level            ;<<<<<<Change>>>>>>
res@cnMaxLevelValF       = 14      ;set max contour level
res@cnLevelSpacingF      = 2       ;set contour spacing
;res@cnMinLevelValF       = 3
;res@cnMaxLevelValF       = 45
;res@cnLevelSpacingF      = 3

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
plot(0) = gsn_csm_streamline_contour_map_ce (wks,diff_U1,diff_V1,speed1,res)            ;<<<<<<Change>>>>>>
;plot(0) = gsn_csm_streamline_contour_map_ce (wks,U_clm,V_clm,speed1,res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
plot(1) = gsn_csm_streamline_contour_map_ce (wks,diff_U2,diff_V2,speed2,res)
;plot(1) = gsn_csm_streamline_contour_map_ce (wks,U_c2p,V_c2p,speed2,res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
plot(2) = gsn_csm_streamline_contour_map_ce (wks,diff_U3,diff_V3,speed3,res)
;plot(2) = gsn_csm_streamline_contour_map_ce (wks,U_c2n,V_c2n,speed3,res)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Difference of 250 hPa wind between POS & NEG"   ;add common title            ;<<<<<<Change>>>>>>
;resP@txString                 = "Composites of 250 hPa April wind"
resP@txFontHeightF            = 0.025    ;height of text
resP@gsnPanelLabelBar         = True     ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002   ;move Label Bar down

gsn_panel(wks,plot,(/3,1/),resP)

end
