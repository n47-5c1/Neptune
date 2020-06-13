;*************************************************************
;Aim: Draw one-point lagged correlation of stream function for animations
;Mission:
;
;   1. Read data from daily U & V datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2016-08-19
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
    in_path1 = "~/data/observation/NCEP_NCAR/daily/uwnd/"
    in_path2 = "~/data/observation/NCEP_NCAR/daily/vwnd/"

;time
    mS     = 3
    mE     = 5
    season = "MAM"
    maxlag = 8                   ;set lag

;Base point
;    lat = 35
;    lon = 130
    lat = 40
    lon = 355

;Region
    latN = 85
    latS = -15
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/Animation/"
    out_name = "one-point_corel_"+season+"_sf_"+lat+"N"+lon+"E_"

    text1 = (/"-8","-7","-6","-5","-4","-3","-2","-1","0","+1","+2","+3","+4","+5","+6","+7","+8"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    U_files  = systemfunc ("ls "+in_path1+"uwnd.1979.nc "+in_path1+"uwnd.19[8-9]* "+in_path1+"uwnd.2*")
    V_files  = systemfunc ("ls "+in_path2+"vwnd.1979.nc "+in_path2+"vwnd.19[8-9]* "+in_path2+"vwnd.2*")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files, "r")   ;note the "s" of addfile
    V_in = addfiles (V_files, "r")
    ListSetType (U_in, "cat")   ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")

;    hgt = hgt_in[:]->hgt(:,2,:,:)   ;850hPa
;    hgt = hgt_in[:]->hgt(:,5,:,:)   ;500hPa
    U = U_in[:]->uwnd(:,8,::-1,:)   ;250hPa
    V = V_in[:]->vwnd(:,8,::-1,:)   ;250hPa
    printVarSummary (U)
    printVarSummary (V)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time    = U_in[:]->time
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

;stream function
   sfvp = uv2sfvpG (U,V)
   sf   = sfvp(0,:,:,:)
   copy_VarCoords (U,sf)
   dim = dimsizes (sf)
   printVarSummary (sf)   

;band pass filters
   sf_BP_pp = wgt_runave_Wrap (sf(lat|:,lon|:,time|:),wts,0)
   sf_BP    = sf_BP_pp (time|iMM,lat|:,lon|:)
   printVarSummary (sf_BP)

;---------------------------------------------------------------
;get base point
   sf_BP_P = sf_BP(:,{lat},{lon})
   printVarSummary (sf_BP_P)

;---------------------------------------------------------------
;compute cross correlation
   sf_BP_new = sf_BP(lat|:,lon|:,time|:)

   ccr_BP_n = esccr (sf_BP_new,sf_BP_P,maxlag)
   ccr_BP_p = esccr (sf_BP_P,sf_BP_new,maxlag)
   copy_VarCoords_1 (sf_BP_new,ccr_BP_n)   ;copy coordinate variable
   copy_VarCoords_1 (sf_BP_new,ccr_BP_p)   ;copy coordinate variable

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

res@gsnRightString  = lat+" N "+(360-lon)+" W"
;res@gsnRightString  = lat+" N"+lon+" E"
;res@gsnPolar        = "NH"       ;specify the hemisphere
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
res@cnFillPalette  = "BlRe"     ;choose a colormap

res@tmXBLabelFontHeightF = .018   ;font height of tick labels
res@tmYLLabelFontHeightF = .018
res@tmXBTickSpacingF     = 60.   ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.4
res@cnMaxLevelValF       = 0.4
res@cnLevelSpacingF      = 0.08

res@tiMainString      = "Cross Correlation for "+season+" 250 hPa Stream Function"   ;add title
res@tiMainFontHeightF = 0.026

;res@lbLabelBarOn = False

res@pmLabelBarOrthogonalPosF = 0.24   ;move Label Bar down

do i=0,7
 wks  = gsn_open_wks ("eps",out_path+out_name+text1(i))
 res@gsnCenterString = "LAG: "+text1(i)
 plot = gsn_csm_contour_map (wks,ccr_BP_n(:,:,maxlag-i),res)
 delete(wks)      ;Make sure file is closed
end do

do i=0,8
 wks  = gsn_open_wks ("eps",out_path+out_name+text1(i+8))
 res@gsnCenterString = "LAG: "+text1(i+8)
 plot = gsn_csm_contour_map (wks,ccr_BP_p(:,:,i),res)
 delete(wks)      ;Make sure file is closed
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
