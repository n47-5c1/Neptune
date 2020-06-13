;*************************************************************
;Aim: Draw composites of hovmoller diagram (time vs. longitude ) of one-point cross correlation of geopotential height
;Mission:
;
;   1. Read data from daily hgt datasets
;   2. Post-post process to deserved results
;   3. Draw the hovmoller diagram
;                       He Shan
;                       2016-07-22
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
    a        = 6378388.
    omega    = 7.27*10.^(-5.)
    deg2rad  = 0.0174533      ;2*pi/360
    in_path1 = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_path2 = "~/data/observation/NCEP_NCAR/daily/hgt/"

;time
    mS     = 3
    mE     = 5
    yS     = 1979
    yE     = 2015
    maxlag = 8                   ;set lag
    days   = 92

;Averaged region
    latNK = 30
    latSK = 20
    lonLK = 30
    lonRK = 60

;Base point
    latP = 25
    lonP = 90

;Region
    latN = 35
    latS = 25
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_hovmoller_lon_one-point_corel_MAM_hgt"+latP+"N"+lonP+"E_Ks"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)","k)","l)","m)","n)","o)","p)","q)","r)"/)
    text2 = (/0.,4.,8.,12.,16./)
    text3 = (/"-8","-4","0","+4","+8"/)
    text4 = (/"March","April","May"/)
    text5 = (/"CLM","DIFF"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path1+in_name1,"r")

;get the time indexs
    time1  = U_file->time
    TIME1  = cd_calendar (time1, 0)
    year1  = toint ( TIME1(:,0) )
    month1 = toint ( TIME1(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.mS .and. month1.le.mE)

    U = U_file->uwnd(iYYYY1,8,:,:)      ;250 hPa

    lat  = U&lat
    dlat = (lat(2)-lat(1))*deg2rad
    dy   = a*dlat                      ;convert to dist
    printVarSummary (U)
    printVarSummary (iYYYY1)
    print(dy)

;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw1 = U_file->lat({latSK:latNK})
    gw1 = cos(rad*gw1)
    printVarSummary(gw1)

;---------------------------------------------------------
    hgt_files = systemfunc ("ls "+in_path2+"hgt.1979.nc "+in_path2+"hgt.19[8-9]*.nc "+in_path2+"hgt.2*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    hgt_in = addfiles (hgt_files, "r")   ;note the "s" of addfile
    ListSetType (hgt_in, "cat")   ;concatenate or "merge" (default)

;    hgt = hgt_in[:]->hgt(:,2,:,:)   ;850 hPa
;    hgt = hgt_in[:]->hgt(:,5,:,:)   ;500 hPa
    hgt = hgt_in[:]->hgt(:,8,{latS:latN},:)   ;250 hPa
    hgt = lonPivot (hgt, 290)                 ;reorder
    dim = dimsizes (hgt)
    printVarSummary (hgt)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time2    = hgt_in[:]->time
    TIME2    = cd_calendar (time2, 0)
    year2    = toint ( TIME2(:,0) )
    month2   = toint ( TIME2(:,1) )

; create the filter weights
    nwt = 61
    fca = 1./30.
    fcb = 1./10.
    ihp = 2          
    nsigma = 1.
    wts = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)   ; 10-30 day

;creat weights: cos(lat)
    gw2 = hgt_in[0]->lat({latS:latN})
    gw2 = cos (rad*gw2)
    printVarSummary (gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute Ks
    beta  = conform (U, 2.*omega/a*cos(U&lat*deg2rad), 1)
    betaa = beta - center_finite_diff_n( center_finite_diff_n(U,dy,False,0,1) ,dy,False,0,1 )
    U   = mask (U,U.le.0.,False)
    Ks    = betaa/U/abs(betaa/U) * sqrt ( abs(betaa/U) )
    copy_VarCoords (U,Ks)
    printVarSummary (Ks)

;compute regional average
    Ks_reg = wgt_areaave_Wrap ( Ks(:,{latSK:latNK},{lonLK:lonRK}), gw1,1.,0)
   
    Ks_1 = Ks_reg(::3)
    Ks_2 = Ks_reg(1::3)
    Ks_3 = Ks_reg(2::3)
    ave1 = avg (Ks_1)
    ave2 = avg (Ks_2)
    ave3 = avg (Ks_3)
    std1 = .8*stddev (Ks_1)
    std2 = .8*stddev (Ks_2)
    std3 = .8*stddev (Ks_3)

    printVarSummary (Ks_1)

;---------------------------------------------------------
;Composite Analysis
    comp1p = ind (Ks_1.gt.ave1+std1)
    comp1n = ind (Ks_1.lt.ave1-std1)
    comp2p = ind (Ks_2.gt.ave2+std2)
    comp2n = ind (Ks_2.lt.ave2-std2)
    comp3p = ind (Ks_3.gt.ave3+std3)
    comp3n = ind (Ks_3.lt.ave3-std3)
    print (comp1p)

    year_p = year1(iYYYY1)
    year_c = year_p(::3)
    y1p    = year_c(comp1p)
    y1n    = year_c(comp1n)
    y2p    = year_c(comp2p)
    y2n    = year_c(comp2n)
    y3p    = year_c(comp2p)
    y3n    = year_c(comp2n)
    print (y1p)
    print (y1n)
    print (y2p)
    print (y2n)
    print (y3p)
    print (y3n)

;get the time indexs
    dim1p    = dimsizes(y1p)
    dim1n    = dimsizes(y1n)
    dim2p    = dimsizes(y2p)
    dim2n    = dimsizes(y2n)
    dim3p    = dimsizes(y3p)
    dim3n    = dimsizes(y3n)
    iYYYY_1p = new((/dim1p,days/),typeof(iYYYY1))
    iYYYY_1n = new((/dim1n,days/),typeof(iYYYY1))
    iYYYY_2p = new((/dim2p,days/),typeof(iYYYY1))
    iYYYY_2n = new((/dim2n,days/),typeof(iYYYY1))
    iYYYY_3p = new((/dim3p,days/),typeof(iYYYY1))
    iYYYY_3n = new((/dim3n,days/),typeof(iYYYY1))
    do i=0,dim1p-1
     iYYYY_1p(i,:) = ind (year2.eq.y1p(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    do i=0,dim1n-1
     iYYYY_1n(i,:) = ind (year2.eq.y1n(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    do i=0,dim2p-1
     iYYYY_2p(i,:) = ind (year2.eq.y2p(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    do i=0,dim2n-1
     iYYYY_2n(i,:) = ind (year2.eq.y2n(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    do i=0,dim3p-1
     iYYYY_3p(i,:) = ind (year2.eq.y3p(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    do i=0,dim3n-1
     iYYYY_3n(i,:) = ind (year2.eq.y3n(i) .and. month2.ge.mS .and. month2.le.mE)
    end do
    iYYYY1p = ndtooned (iYYYY_1p)
    iYYYY1n = ndtooned (iYYYY_1n)
    iYYYY2p = ndtooned (iYYYY_2p)
    iYYYY2n = ndtooned (iYYYY_2n)
    iYYYY3p = ndtooned (iYYYY_3p)
    iYYYY3n = ndtooned (iYYYY_3n)
    printVarSummary (iYYYY1p)

;calculate deviation from zonal mean
   hgt_anom = dim_rmvmean_Wrap (hgt)
   printVarSummary (hgt_anom)

;band pass filters
   hAnom_BPF_p = wgt_runave_Wrap (hgt_anom(lat|:,lon|:,time|:),wts,0)
   hAnom_BPF1p  = hAnom_BPF_p (time|iYYYY1p,lat|:,lon|:)
   hAnom_BPF1n  = hAnom_BPF_p (time|iYYYY1n,lat|:,lon|:)
   hAnom_BPF2p  = hAnom_BPF_p (time|iYYYY2p,lat|:,lon|:)
   hAnom_BPF2n  = hAnom_BPF_p (time|iYYYY2n,lat|:,lon|:)
   hAnom_BPF3p  = hAnom_BPF_p (time|iYYYY3p,lat|:,lon|:)
   hAnom_BPF3n  = hAnom_BPF_p (time|iYYYY3n,lat|:,lon|:)
   printVarSummary (hAnom_BPF1p)

;---------------------------------------------------------------
;get base point
   h_BPF_P1p = hAnom_BPF1p(:,{latP},{lonP})
   h_BPF_P1n = hAnom_BPF1n(:,{latP},{lonP})
   h_BPF_P2p = hAnom_BPF2p(:,{latP},{lonP})
   h_BPF_P2n = hAnom_BPF2n(:,{latP},{lonP})
   h_BPF_P3p = hAnom_BPF3p(:,{latP},{lonP})
   h_BPF_P3n = hAnom_BPF3n(:,{latP},{lonP})
   printVarSummary (h_BPF_P1p)

;---------------------------------------------------------------
;compute cross correlation
   hAnom_BPF_new1p = hAnom_BPF1p(lat|:,lon|:,time|:)
   hAnom_BPF_new1n = hAnom_BPF1n(lat|:,lon|:,time|:)
   hAnom_BPF_new2p = hAnom_BPF2p(lat|:,lon|:,time|:)
   hAnom_BPF_new2n = hAnom_BPF2n(lat|:,lon|:,time|:)
   hAnom_BPF_new3p = hAnom_BPF3p(lat|:,lon|:,time|:)
   hAnom_BPF_new3n = hAnom_BPF3n(lat|:,lon|:,time|:)

   ccr_n = new ((/6,dim(1),dim(2),maxlag+1/),"float")
   ccr_p = new ((/6,dim(1),dim(2),maxlag+1/),"float")
   ccr_n(0,:,:,:) = esccr (hAnom_BPF_new1p,h_BPF_P1p,maxlag)
   ccr_n(1,:,:,:) = esccr (hAnom_BPF_new1n,h_BPF_P1n,maxlag)
   ccr_n(2,:,:,:) = esccr (hAnom_BPF_new2p,h_BPF_P2p,maxlag)
   ccr_n(3,:,:,:) = esccr (hAnom_BPF_new2n,h_BPF_P2n,maxlag)
   ccr_n(4,:,:,:) = esccr (hAnom_BPF_new3p,h_BPF_P3p,maxlag)
   ccr_n(5,:,:,:) = esccr (hAnom_BPF_new3n,h_BPF_P3n,maxlag)
   ccr_n(:,:,:,:) = ccr_n(:,:,:,::-1)
   ccr_p(0,:,:,:) = esccr (h_BPF_P1p,hAnom_BPF_new1p,maxlag)
   ccr_p(1,:,:,:) = esccr (h_BPF_P1n,hAnom_BPF_new1n,maxlag)
   ccr_p(2,:,:,:) = esccr (h_BPF_P2p,hAnom_BPF_new2p,maxlag)
   ccr_p(3,:,:,:) = esccr (h_BPF_P2n,hAnom_BPF_new2n,maxlag)
   ccr_p(4,:,:,:) = esccr (h_BPF_P3p,hAnom_BPF_new3p,maxlag)
   ccr_p(5,:,:,:) = esccr (h_BPF_P3n,hAnom_BPF_new3n,maxlag)

   ccr = new ((/6,dim(1),dim(2),2*maxlag+1/),"float")
;copy coordinate variable
   ccr!0   = "comp"
   ccr!1   = "lat"
   ccr!2   = "lon"
   ccr!3   = "time"
   ccr&lat = hAnom_BPF_new1p&lat
   ccr&lon = hAnom_BPF_new1p&lon

   ccr(:,:,:,:maxlag-1) = (/ccr_n(:,:,:,:maxlag-1)/)
   ccr(:,:,:,maxlag:)   = (/ccr_p/)

   ccr_reg = dim_avg_wgt_n_Wrap ( ccr(comp|:,time|:,lat|:,lon|:) ,gw2,1,2)
   diff    = ccr_reg(0:2,:,:)
   diff    = ccr_reg(::2,:,:) - ccr_reg(1::2,:,:)

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (diff)
;   printVarSummary (prob_sm)


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
res@cnMinLevelValF       = -0.4
res@cnMaxLevelValF       = 0.4
res@cnLevelSpacingF      = 0.1

res@tmYLMode             = "Explicit"                ; Define own tick mark labels.
res@tmYLValues           = text2
res@tmYLLabels           = text3
res@tmXBLabelFontHeightF = .02   ;font height of tick labels
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF     = 60.   ;label spacing

res@tiMainString = "Composites of One-point Cross Correlation of HGT"

res@vpHeightF = 0.4        ;change aspect ratio of plot

;res@lbLabelBarOn = False

res@gsnLeftString   = lonP+"E "+latP+"N"
res@gsnCenterString = latS+"-"+latN+"N"
;res@gsnRightString  = season
plot = gsn_csm_hov (wks,diff(2,:,:),res)

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
