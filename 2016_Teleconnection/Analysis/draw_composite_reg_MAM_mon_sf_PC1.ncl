;*************************************************************
;Aim: Draw composites of regional March, April and May stream function chosen by PC1 of 250 hPa wind
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2016-07-04
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
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"

;time
    mS    = 3
    mE    = 5
    yS    = 1979
    yE    = 2015
    month = (/"March","April","May"/)

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
    out_name = "comp_reg_"+month(1)+"_sf_PC1"            ;>>>>>>Change<<<<<<

;text
    text1 = (/"a)","b)","c)","d)","e)","f)"/)
    text2 = (/"CLM","POS","DIFF","NEG"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file   = addfile (in_path+in_name1,"r")
    V_file   = addfile (in_path+in_name2,"r")

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
;    U_p = U_file->uwnd(:,2,:,:)      ;850hPa
;    U_p = U_file->uwnd(:,5,:,:)      ;500hPa
    U_p = U_file->uwnd(iYYYY1,8,::-1,:)      ;250hPa
    V_p = V_file->vwnd(iYYYY2,8,::-1,:)      ;250hPa
    U_p = lonFlip (U_p)
    V_p = lonFlip (V_p)
    U   = U_p(:,{latS:latN},{lonL:lonR})
    V   = V_p(:,{latS:latN},{lonL:lonR})

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (iYYYY1)
    printVarSummary (iYYYY2)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = U_file->lat({latS:latN})      ;latitude order
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
    sfvp = uv2sfvpG (U_p,V_p)      ;MUST be in ascending latitude order, on a global grid
    sf   = sfvp(0,:,:,:)*10^(-7)
    copy_VarCoords (U_p,sf)
    printVarSummary (sf)

;EOF
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
    ave1    = avg (eof_ts1)
    ave2    = avg (eof_ts2)
    ave3    = avg (eof_ts3)
    std1    = .8*stddev (eof_ts1)
    std2    = .8*stddev (eof_ts2)
    std3    = .8*stddev (eof_ts3)

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
    print(year_c(comp2p))
    print(year_c(comp2n))
    print(year_c(comp3p))
    print(year_c(comp3n))

    sf_p1 = sf(::3,:,:)
    sf_p2 = sf(1::3,:,:)
    sf_p3 = sf(2::3,:,:)

    sf_c1p = dim_avg_n_Wrap (sf_p1(comp1p,:,:),0)
    sf_c1n = dim_avg_n_Wrap (sf_p1(comp1n,:,:),0)
    sf_c2p = dim_avg_n_Wrap (sf_p2(comp2p,:,:),0)
    sf_c2n = dim_avg_n_Wrap (sf_p2(comp2n,:,:),0)
    sf_c3p = dim_avg_n_Wrap (sf_p3(comp3p,:,:),0)
    sf_c3n = dim_avg_n_Wrap (sf_p3(comp3n,:,:),0)
    sfclm1 = dim_avg_n_Wrap (sf_p1,0)
    sfclm2 = dim_avg_n_Wrap (sf_p2,0)
    sfclm3 = dim_avg_n_Wrap (sf_p3,0)

    printVarSummary(sf_c1p)

    diff_1 = sf_c1p
    diff_2 = sf_c2p
    diff_3 = sf_c3p

    diff_1 = sf_c1p - sf_c1n
    diff_2 = sf_c2p - sf_c2n
    diff_3 = sf_c3p - sf_c3n

; ==============================================================
; Mission 3. Draw the composites
; ==============================================================

wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
plot = new (4,graphic)      ;creat a plot array

res = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame
res@gsnAddCyclic = False

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

res@lbLabelBarOn = False

res@pmLabelBarOrthogonalPosF = 0.2    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.021   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.021

res@cnFillPalette        = "WhiteYellowOrangeRed"   ;choose a colormap
;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -10.      ;set min contour level
res@cnMaxLevelValF       = 0.        ;set max contour level
res@cnLevelSpacingF      = 2.        ;set contour spacing

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString  = "10^7"
plot(0) = gsn_csm_contour_map_ce (wks,sfclm2,res)            ;>>>>>>Change<<<<<<
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString  = " "
plot(1) = gsn_csm_contour_map_ce (wks,sf_c2p,res)
res@lbLabelBarOn    = True
res@gsnLeftString   = text1(3)
res@gsnCenterString = text2(3)
plot(3) = gsn_csm_contour_map_ce (wks,sf_c2n,res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
res@cnFillPalette   = "CBR_coldhot"   ;choose a colormap
res@cnMinLevelValF  = -.9      ;set min contour level
res@cnMaxLevelValF  = .9       ;set max contour level
res@cnLevelSpacingF = .3       ;set contour spacing
plot(2) = gsn_csm_contour_map_ce (wks,diff_2,res)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Composites of 250 hPa "+month(1)+" Stream Function"   ;add common title            ;******Change******
resP@txFontHeightF            = 0.025      ;height of text

gsn_panel(wks,plot,(/2,2/),resP)

end
