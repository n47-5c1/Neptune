;*************************************************************
;Aim: Draw one-point lagged correlation of geopotential height
;Mission:
;
;   1. Read data from daily hgt datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2016-04-24
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
    season = "MAM"
    maxlag = 4                   ;set lag

;Base point
;    lat = 35
;    lon = 130
    lat = 40
    lon = 355

;Region
    latN = 85
    latS = 0
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "one-point_corel_"+season+"_hgt"+lat+"N"+lon+"E"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
    text2 = (/"-6","-3","0","+3","+6"/)

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
    hgt = hgt_in[:]->hgt(:,8,:,:)   ;250hPa
    dim = dimsizes (hgt)
    printVarSummary (hgt)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time    = hgt_in[:]->time
    TIME    = cd_calendar (time, 0)
    month   = toint ( TIME(:,1) )
    printVarSummary (month)

;get the time indexs
    iMM = ind (month.ge.mS .and. month.le.mE)
    printVarSummary (iMM)

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

   hAnom_BP_p = wgt_runave_Wrap (hgt_anom(lat|:,lon|:,time|:),wts,0)
   hAnom_BP   = hAnom_BP_p (time|iMM,lat|:,lon|:)
   printVarSummary (hAnom_BP)

;---------------------------------------------------------------
;get base point
   h_BP_P = hAnom_BP(:,{lat},{lon})
   printVarSummary (h_BP_P)

;---------------------------------------------------------------
;compute cross correlation
   hAnom_BP_new = hAnom_BP(lat|:,lon|:,time|:)

   ccr_BP_n = esccr (hAnom_BP_new,h_BP_P,maxlag)
   ccr_BP_p = esccr (h_BP_P,hAnom_BP_new,maxlag)
   copy_VarCoords_1 (hAnom_BP_new,ccr_BP_n)   ;copy coordinate variable
   copy_VarCoords_1 (hAnom_BP_new,ccr_BP_p)   ;copy coordinate variable

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (ccr_BP_p)
;   printVarSummary (prob_sm)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks ("eps",out_path+out_name)  ;open a ps file
 plot = new(4,graphic)                          ;creat a plot array
 gsn_define_colormap (wks,"BlRe")               ;choose a colormap

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame
;res@gsnPolar       = "NH"       ;specify the hemisphere
;res@gsnPolarLabelFontHeightF = .025

res@mpFillOn       = False      ;turn off map fill
res@mpCenterLonF   = 60.       ;get the correct map
res@mpMinLatF      = latS
res@mpMaxLatF      = latN
;res@mpMinLonF      = lonL
;res@mpMaxLonF      = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels

res@tmXBLabelFontHeightF = .025   ;font height of tick labels
res@tmYLLabelFontHeightF = .025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.4
res@cnMaxLevelValF       = 0.4
res@cnLevelSpacingF      = 0.08

res@lbLabelBarOn = False

do i=0,1
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = "LAG: "+text2(i+1)
; res@gsnRightString  = "99% stippled"
 if(i.eq.1) then
  res@gsnRightString  = lat+" N "+(360-lon)+" W"
;  res@gsnRightString  = lat+" N"+lon+" E"
 end if
 plot(i) = gsn_csm_contour_map (wks,ccr_BP_n(:,:,maxlag-2*(i+1)),res)
end do

res@gsnRightString  = " "
do i=2,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = "LAG: "+text2(i+1)
 plot(i) = gsn_csm_contour_map (wks,ccr_BP_p(:,:,2*(i+1)-maxlag),res)
end do

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
resP                  = True
resP@txString         = "Lag Correlation for "+season+" 250 hPa Height"   ;add common title
resP@txFontHeightF    = 0.024           ;height of text
resP@gsnPanelCenter   = False           ;the plots to be not centered
resP@gsnPanelLabelBar = True            ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.02   ;move Label Bar down

gsn_panel(wks,plot,(/2,2/),resP)          ; create panel

end
