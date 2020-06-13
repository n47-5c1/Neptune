;*************************************************************
;Aim: Draw sample correlation between global lowpass teleconnection index and storm tracks in the winter half year
;Mission:
;
;   1. Read data from daily INDEX & hgt datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2017-02-14
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------INDEX
;	var2--------------hgt
;================================================

;datas
    in_path1 = "~/hes/One_Belt_One_Road/NCL/PC_Index.nc"
    in_path2 = "~/data/observation/NCEP_DOE/daily/hgt/"

;time
    yS     = 1979
    yE     = 2015
    mS     = 11
    mE     = 4

;Region
    latN = 50
    latS = 0
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "corel_g_winter_LP_index_and_storm_track"

;    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
;    text2 = (/"-7","","-3","0","+3","+6"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    index_in  = addfile (in_path1, "r")
    hgt_files = systemfunc ("ls "+in_path2+"hgt.*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    hgt_in = addfiles (hgt_files, "r")   ;note the "s" of addfile
    ListSetType (hgt_in, "cat")   ;concatenate or "merge" (default)

    index = index_in->INDEX
    hgt   = short2flt (hgt_in[:]->hgt(:,8,{latS:latN},:))   ;250hPa
    printVarSummary (index)
    printVarSummary (hgt)

;---------------------------------------------------------------
;get the time indexs
    time1  = index_in->time
    TIME1  = cd_calendar (time1, 0)
    month1 = toint ( TIME1(:,1) )
    iMM1   = ind (month1.ge.mS .or. month1.le.mE)

    time2  = hgt_in[:]->time
    TIME2  = cd_calendar (time2, 0)
    year2  = toint ( TIME2(:,0) )
    month2 = toint ( TIME2(:,1) )
    iMM2   = ind (year2.ge.yS .and. year2.le.yE .and. (month2.ge.mS .or. month2.le.mE))

    printVarSummary (iMM1)
    printVarSummary (iMM2)

; create the filter weights
    nwt    = 43
    fca    = 1./21.
    fcb    = 1./999.
    ihp    = 0
    nsigma = 1.
    wts1   = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

    nwt  = 15
    fca  = 1./7.
    fcb  = 1./2.
    ihp  = 2
    wts2 = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;filters
    index_F = wgt_runave_Wrap (index,wts1,0)
    hgt_F   = wgt_runave_Wrap (hgt(lat|:,lon|:,time|:),wts2,0)
    dim     = dimsizes (hgt_F)
    printVarSummary (index_F)
    printVarSummary (hgt_F)
    printVarSummary (dim)

;compute runing standard deviation
    hgt_std = new (dim,double)
    copy_VarCoords(hgt_F,hgt_std)
    do i=14,dim(2)-5
     hgt_std(:,:,i) = dim_stddev (hgt_F(:,:,i-14:i+4))
     if( mod(i,500).eq.0)then
      print(i*100./dim(2)+"% DONE")
     end if
    end do
    printVarSummary (hgt_std)

;Calculate monthly means
;    index_mon = calculate_monthly_values (index,"avg",0,False)
;    hgt_mon   = calculate_monthly_values (hgt_std(time|:,lat|:,lon|:),"avg",0,False)
;    printVarSummary (index_mon)
;    printVarSummary (hgt_mon)

    index_r = index_F(iMM1)
    hgt_r   = hgt_std(:,:,iMM2)
    printVarSummary (index_r)
    printVarSummary (hgt_r)

;---------------------------------------------------------------
;compute cross correlation
    r = escorc (index_r,hgt_r)
    copy_VarCoords_1 (hgt_r,r)   ;copy coordinate variable

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (r)
;   printVarSummary (prob_sm)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks ("eps",out_path+out_name)  ;open a eps file
; plot = new(15,graphic)                          ;creat a plot array

;-----------------------------------------------------------------------------
res          = True

;res@gsnDraw         = False      ;don't draw
;res@gsnFrame        = False      ;don't advance frame
;res@gsnLeftString   = text1(i)
;res@gsnCenterString = "LAG: "+text2(i+1)
;res@gsnRightString  = "99% stippled"

res@mpFillOn     = False      ;turn off map fill
res@mpCenterLonF = 60.       ;get the correct map
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
;res@mpMinLonF    = lonL
;res@mpMaxLonF    = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False          ;turn off cn line labels
res@cnFillPalette  = "temp_19lev"   ;choose a colormap

res@tmXBLabelFontHeightF = .005   ;font height of tick labels
res@tmYLLabelFontHeightF = .005
;res@tmXBTickSpacingF     = 60.     ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.21
res@cnMaxLevelValF       = 0.21
res@cnLevelSpacingF      = 0.07

res@pmLabelBarOrthogonalPosF = -0.02   ;move Label Bar down
;res@lbLabelBarOn = False

plot = gsn_csm_contour_map (wks,r,res)

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
;resP@txString         = "Cross Correlation"   ;add common title
;resP@txFontHeightF    = 0.024           ;height of text
;resP@gsnPanelCenter   = False           ;the plots to be not centered
;resP@gsnPanelLabelBar = True            ;add common colorbar
;resP@pmLabelBarOrthogonalPosF = -0.02   ;move Label Bar down

;gsn_panel(wks,plot,(/5,3/),resP)          ; create panel

end
