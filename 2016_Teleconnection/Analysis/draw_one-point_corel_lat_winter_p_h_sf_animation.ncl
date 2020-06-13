;*************************************************************
;Aim: Draw one-point lagged correlation of stream function for animations
;Mission:
;
;   1. Read data from daily U & V datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2017-03-22
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------uwnd
;	var2--------------vwnd
;================================================

;datas
    in_path1 = "~/data/observation/NCEP_DOE/daily/uwnd/"
    in_path2 = "~/data/observation/NCEP_DOE/daily/vwnd/"

;time
    mS     = 11
    mE     = 4
    maxlag = 8                   ;set lag

;Region
    levT = 11   ;
    levB = 2    ;850 hPa
    latN = 35
    latS = 25

;Base point
;    lev = 2      ;850 hPa
;    lev = 5      ;500 hPa
    lev = 8-levB      ;250 hPa
    lat = 36
    lon = -2

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/Animation/"
    out_name = "one-point_corel_lat_winter_p_h_sf_"+lat+"N"+abs(lon)+"W_"

    text1 = (/"-8","-7","-6","-5","-4","-3","-2","-1","0","+1","+2","+3","+4","+5","+6","+7","+8"/)
    text2 = (/"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    U_files  = systemfunc ("ls "+in_path1+"uwnd.*.nc")
    V_files  = systemfunc ("ls "+in_path2+"vwnd.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files, "r")   ;note the "s" of addfile
    V_in = addfiles (V_files, "r")
    ListSetType (U_in, "cat")   ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")

    U = short2flt (U_in[:]->uwnd(:,levB:levT,::-1,:))
    V = short2flt (V_in[:]->vwnd(:,levB:levT,::-1,:))

    printVarSummary (U)
    printVarSummary (V)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time    = U_in[:]->time
    TIME    = cd_calendar (time, 0)
    month   = toint ( TIME(:,1) )
    printVarSummary (month)

;get the time indexs
    iMM = ind (month.lt.mS .and. month.gt.mE)   ;get summer-half year
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

;stream function
   sfvp = uv2sfvpG (U,V)
   sf_p = sfvp(0,:,:,:,:)
   dim  = dimsizes (sf_p)
   copy_VarCoords (U,sf_p)
   sf  = lonPivot (sf_p(:,:,{latS:(latN+5)},:), 240)   ;reorder
   printVarSummary (sf)

;band pass filters
   sf_BP = wgt_runave_Wrap (sf(level|:,lat|:,lon|:,time|:),wts,0)
   printVarSummary (sf_BP)

;---------------------------------------------------------------
;compute meridional means
   sf_lat = dim_avg_n_Wrap( sf_BP(:,{latS:latN},:,:) ,1)
   printVarSummary (sf_lat)

;get base point
   sf_BP_P      = sf_BP(lev,{lat},{lon},:)
   sf_BP_P(iMM) = sf_BP_P@_FillValue      ;leave winter-half year alone
   printVarSummary (sf_BP_P)

;---------------------------------------------------------------
;compute cross correlation
   ccr_BP_n = esccr (sf_lat,sf_BP_P,maxlag)
   ccr_BP_p = esccr (sf_BP_P,sf_lat,maxlag)
   copy_VarCoords_1 (sf_lat,ccr_BP_n)   ;copy coordinate variable
   copy_VarCoords_1 (sf_lat,ccr_BP_p)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (ccr_BP_p)
;   printVarSummary (prob_sm)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================

res                = True

res@gsnLeftString = latS+" - "+latN+" N"
res@gsnRightString  = sf_BP&level(lev)+" hPa, "+lat+" N "+abs(lon)+" W"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels
res@cnFillPalette  = "BlRe"     ;choose a colormap

res@tmXBLabelFontHeightF = .02   ;font height of tick labels
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF     = 60.   ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.6
res@cnMaxLevelValF       = 0.6
res@cnLevelSpacingF      = 0.15

res@vpHeightF = 0.3        ;change aspect ratio of plot

res@tiMainString      = "Cross Correlation for winter Stream Function"   ;add title
res@tiMainFontHeightF = 0.026

;res@lbLabelBarOn = False

;res@pmLabelBarOrthogonalPosF = 0.24   ;move Label Bar down

do i=0,7
 wks  = gsn_open_wks ("svg",out_path+out_name+text2(i))
 res@gsnCenterString = "LAG: "+text1(i)
 plot = gsn_csm_pres_hgt (wks,ccr_BP_n(:,:,maxlag-i),res)
 delete(wks)      ;Make sure file is closed
end do

do i=0,8
 wks  = gsn_open_wks ("svg",out_path+out_name+text2(i+8))
 res@gsnCenterString = "LAG: "+text1(i+8)
 plot = gsn_csm_pres_hgt (wks,ccr_BP_p(:,:,i),res)
 delete(wks)
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

end
