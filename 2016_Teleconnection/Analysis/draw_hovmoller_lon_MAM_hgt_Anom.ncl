;*************************************************************
;Aim: Draw hovmoller diagram (time vs. longitude ) of geopotential height disturbance
;Mission:
;
;   1. Read data from daily hgt datasets
;   2. Post-post process to deserved results
;   3. Draw the hovmoller diagram
;                       He Shan
;                       2016-07-25
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------hgt
;================================================

;datas
    in_path = "~/data/observation/NCEP_NCAR/daily/hgt/"

;time
    mS     = 3
    mE     = 5
    yS     = 2010
    season = "MAM"
    maxlag = 8                   ;set lag

;Region
    lat = 30

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "hovmoller_lon_"+season+"_hgt_Anom_"+lat+"N"

    text1 = (/0.,4.,8.,12.,16./)
    text2 = (/"-8","-4","0","+4","+8"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;
    hgt_files  = systemfunc ("ls "+in_path+"hgt.1979.nc "+in_path+"hgt.19[8-9]*.nc "+in_path+"hgt.2*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    hgt_in = addfiles (hgt_files, "r")   ;note the "s" of addfile
    ListSetType (hgt_in, "cat")   ;concatenate or "merge" (default)

;    hgt = hgt_in[:]->hgt(:,2,:,:)   ;850hPa
;    hgt = hgt_in[:]->hgt(:,5,:,:)   ;500hPa
    hgt = hgt_in[:]->hgt(:,8,{lat},:)   ;250hPa
    hgt = lonPivot (hgt, 290)                 ;reorder
    dim = dimsizes (hgt)
    printVarSummary (hgt)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time    = hgt_in[:]->time
    TIME    = cd_calendar (time, 0)
    year    = toint ( TIME(:,0) )
    month   = toint ( TIME(:,1) )
    day     = toint ( TIME(:,2) )
    ddd     = day_of_year (year,month,day)
    yyyyddd = year*1000 + ddd      ;needed for input
    printVarSummary (yyyyddd)

;get the time indexs
    iMM = ind (year.eq.yS .and. month.ge.mS .and. month.le.mE)

; create the filter weights
    nwt = 61
    fca = 1./30.
    fcb = 1./10.
    ihp = 2          
    nsigma = 1.
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)   ; 10-30 day

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;calculate deviation from zonal mean
   hgt_anom = dim_rmvmean_Wrap (hgt)
   printVarSummary (hgt_anom)

;band pass filters
   hAnom_BPF_p = wgt_runave_Wrap (hgt_anom(lon|:,time|:),wts,0)
   hAnom_BPF   = hAnom_BPF_p (time|iMM,lon|:)
   printVarSummary (hAnom_BPF)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks ("eps",out_path+out_name)  ;open a ps file
; plot = new(3,graphic)                          ;creat a plot array
 gsn_define_colormap (wks,"BlRe")               ;choose a colormap

;-----------------------------------------------------------------------------
res                = True

;res@gsnDraw        = False      ;don't draw
;res@gsnFrame       = False      ;don't advance frame

res@cnFillOn             = True
res@cnLinesOn            = False
res@cnLineLabelsOn       = False      ;turn off cn line labels
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -120
res@cnMaxLevelValF       = 120
res@cnLevelSpacingF      = 40

;res@tmYLMode             = "Explicit"                ; Define own tick mark labels.
;res@tmYLValues           = text1
;res@tmYLLabels           = text2
res@tmXBLabelFontHeightF = .02   ;font height of tick labels
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF     = 60.   ;label spacing

res@tiMainString = "Hovmoller Diagram of HGT Anomaly"

res@vpWidthF = 0.4        ;change aspect ratio of plot

;res@lbLabelBarOn = False

res@gsnLeftString   = lat+"N"
res@gsnRightString  = season
plot = gsn_csm_hov (wks,hAnom_BPF,res)

;---------------------------------------------------------------
;probability plots
;res2 = True

;res2@gsnDraw              = False            ;don't draw
;res2@gsnFrame             = False            ;don't advance frame
;res2@gsnLeftString        = " "
;res2@gsnRightString       = " "

;res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
;res2@cnMinLevelValF       = 0.00             ;set min contour level
;res2@cnMaxLevelValF       = 0.10             ;set max contour level
;res2@cnLevelSpacingF      = 0.01             ;set contour spacing
;res2@cnInfoLabelOn        = False
;res2@cnLinesOn            = False            ;do not draw contour lines
;res2@cnLineLabelsOn       = False            ;do not draw contour labels
;res2@cnFillDotSizeF       = 0.003            ;set a uniform dot size
;res2@cnFillScaleF         = 1.2              ;add extra density

;plot2 = gsn_csm_contour (wks,prob,res2)
;plot2 = ShadeLtContour (plot2,0.015,17)      ;shade all areas < 0.015 contour
;plot3 = gsn_csm_contour (wks,prob,res2)
;plot3 = ShadeLtContour (plot3,0.015,17)      ;shade all areas < 0.015 contour
;overlay (plot(0),plot2)
;overlay (plot(1),plot3)

;*******************************************
;create panel resources
;*******************************************
;resP                  = True
;resP@txString         = "Lag Correlation for "+season+" 250 hPa Height"   ;add common title
;resP@txFontHeightF    = 0.024           ;height of text
;resP@gsnPanelCenter   = False           ;the plots to be not centered
;resP@gsnPanelLabelBar = True            ;add common colorbar
;resP@pmLabelBarOrthogonalPosF = -0.02   ;move Label Bar down

;gsn_panel(wks,plot,(/2,2/),resP)          ; create panel

end
