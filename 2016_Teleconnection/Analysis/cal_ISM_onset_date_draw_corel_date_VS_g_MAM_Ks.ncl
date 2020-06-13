;*************************************************************
;Aim: Draw correlation between Indian summer monsoon onset date and global spring seasonal stationary waves total wavenumber
;Mission:
;
;   1. Read uwnd (daily 850 hPa, monthly 250 hPa) dataset
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan 
;                       2016-09-02
                          
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;================================================

;datas
    in_path1 = "~/data/observation/NCEP_NCAR/daily/uwnd/"
    in_path2 = "~/data/observation/NCEP_NCAR/monthly/"
    in_name2 = "uwnd.mon.mean.nc"
    deg2rad  = 0.0174533      ;2*pi/360
    omega    = 7.27*10.^(-5.)
    a        = 6378388.

;time
    yS     = 1979
    yE     = 2015
    mS     = 5
    mE     = 7
    nyear  = yE-yS+1
    season = "MAM"

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "corel_ISM_onset_date_VS_g_MAM_Ks"

;index region
    latN = 15.
    latS = 5.
    lonL = 40.
    lonR = 80.

;map region
    latN_m = 60.
    latS_m = 0.
    lonL_m = -30.
    lonR_m = 150.

    text1 =(/"a)","b)","c)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in_files1 = systemfunc ("ls "+in_path1+"uwnd.1979.nc "+in_path1+"uwnd.19[8-9]*.nc "+in_path1+"uwnd.2*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in1 = addfiles (in_files1, "r")            ;note the "s" of addfile
    ListSetType (U_in1, "cat")                   ;concatenate or "merge" (default)

    U_in2 = addfile (in_path2+in_name2,"r")

;read time
    time1  = U_in1[:]->time
    TIME1  = cd_calendar (time1, 0)
    year1  = toint ( TIME1(:,0) )
    month1 = toint ( TIME1(:,1) )

;get the time indexs
    time2  = U_in2->time
    YYYY2  = cd_calendar (time2,-1)/100
    iYYYY2 = ind (YYYY2.ge.yS .and. YYYY2.le.yE)

    U850 = U_in1[:]->uwnd(:,2,{latS:latN},{lonL:lonR})   ;850 hPa
    U250 = U_in2->uwnd(iYYYY2,8,:,:)                     ;250 hPa
    printVarSummary (U850)
    printVarSummary (U250)

    lat  = U250&lat
    dlat = (lat(1)-lat(0))*deg2rad
    dy   = a*dlat                      ;convert to dist
    printVarSummary (dy)

;creat weights: cos(lat)
    rad = 4. * atan(1.) / 180.
    gw  = U_in1[0]->lat({latS:latN})          
    gw  = cos(rad*gw)
    printVarSummary (gw)

; ============================================================
; Mission 2. Post-post process data to deserved results
; ============================================================

;calculate onset circulation index
    OCI_p = wgt_areaave_Wrap (U850,gw,1.,0)
    printVarSummary (OCI_p)

;calculate onset date
    DATE = new (nyear,integer)
    do i=0,nyear-1
     DATE(i) = 1
     iYYYY1 = ind (year1.eq.(i+yS) .and. month1.ge.mS .and. month1.le.mE)   ;get the time indexs
     OCI    = OCI_p(iYYYY1)
     NTIME  = dimsizes (OCI)
     do while ( OCI(DATE(i)-1).le.6.2 .or. OCI(DATE(i)).le.6.2 .or. OCI(DATE(i)+1).le.6.2 .or. OCI(DATE(i)+2).le.6.2 .or. OCI(DATE(i)+3).le.6.2 .or. OCI(DATE(i)+4).le.6.2)
      DATE(i) = DATE(i) + 1
      if (DATE(i).eq.(NTIME-6))then
       DATE(i) = getFillValue(DATE)
       break
      end if
     end do
     delete (iYYYY1)
     delete (OCI)
     delete (NTIME)
    end do
    print(DATE)

;--------------------------------------------------------------
;compute Ks
    beta  = conform (U250, 2.*omega/a*cos(U250&lat*deg2rad), 1)
    betaa = beta - center_finite_diff_n( center_finite_diff_n(U250,dy,False,0,1) ,dy,False,0,1 )
    U250  = mask (U250,U250.le.0.,False)
    Ks    = betaa/U250/abs(betaa/U250) * sqrt ( abs(betaa/U250) )
    copy_VarCoords (U250,Ks)
    printVarSummary (Ks)

    ;compute seasonal means
    Ks_MAM_p = month_to_seasonN (Ks,season)
    Ks_MAM   = Ks_MAM_p(0,:,:,:)
;    Ks_MAM   = Ks(4::12,:,:)
    dim      = dimsizes (Ks_MAM)
    printVarSummary (Ks_MAM)

;--------------------------------------------------------------
;compute the correlation
    r = new ((/dim(1),dim(2)/),float)
    copy_VarCoords (Ks_MAM(0,:,:),r)          ;copy coordinate variable
    Ks_MAM_new = Ks_MAM(lat|:,lon|:,time|:)   ;reorder to get time as right most dimension
    r = escorc (Ks_MAM_new,DATE)
    printVarSummary (r)
                   
;determine the statistical significance
    prob = r      ;copy meta data
    prob = rtest (r,dim(0),0)
    prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
    printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================

 wks   = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
 plot  = new (2,graphic)                         ; creat a plot array

res = True

res@gsnDraw  = False         ;don't draw
res@gsnFrame = False         ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False         ;turn off cn line labels
res@cnFillPalette  = "MPL_RdBu"    ;choose a colormap

res@mpFillOn  = False         ;turn off map fill
;map outlines
res@mpMinLatF = latS_m
res@mpMaxLatF = latN_m
res@mpMinLonF = lonL_m
res@mpMaxLonF = lonR_m

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.4          ;set min contour level
res@cnMaxLevelValF       = 0.4           ;set max contour level
res@cnLevelSpacingF      = 0.1           ;set contour spacing

res@pmLabelBarOrthogonalPosF = 0.21   ;move Label Bar down

;res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.015   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.015

res@tiMainString      = "Correlation between ISM Onset Date and MAM Ks"   ;add title
res@tiMainFontHeightF = 0.025    ;change font heights

res@gsnLeftString   = " "
res@gsnCenterString = " "
res@gsnRightString  = "95% stippled"
plot(0) = gsn_csm_contour_map_ce (wks,r,res)

;---------------------------------------------------------------
;probability plots

res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00             ;set min contour level
res2@cnMaxLevelValF       = 0.1              ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.002   ;set a uniform dot size
res2@cnFillScaleF   = 0.8     ;add extra density

plot(1) = gsn_csm_contour (wks,prob,res2)
plot(1) = ShadeLtContour (plot(1),0.055,17)      ;shade all areas < 0.055 contour
overlay (plot(0),plot(1))

draw(plot(0))
frame(wks)

end
