;*************************************************************
;Aim: Draw sample correlation between monthly teleconnection index and global SST in the winter half year for each month
;Mission:
;
;   1. Read data from daily INDEX & sst datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2017-02-10
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
;	var2--------------sst
;================================================

;datas
    in_path1 = "~/hes/One_Belt_One_Road/NCL/PC_Index.nc"
    in_path2 = "~/data/observation/SST/HadISST_sst_1870-2016.nc"

;time
    yS = 1979
    yE = 2015
    mS = 11
    mE = 4

;Region
    latN = 85
    latS = -10
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "mon_corel_g_winter_mon_index_and_SST"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
    text2 = (/"Nov.","Dec.","Jan.","Feb.","Mar.","Apr."/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    index_in = addfile (in_path1, "r")
    SST_in   = addfile (in_path2, "r")

    index = index_in->INDEX
    SST   = SST_in->sst
    printVarSummary (index)
    printVarSummary (SST)

;---------------------------------------------------------------
;get the time indexs
    time1  = index_in->time
    TIME1  = cd_calendar (time1, 0)
    day1   = toint ( TIME1(:,2) )
    iDD1   = ind (day1.eq.1)
    TIME11 = cd_calendar (time1(iDD1), 0)
    month1 = toint ( TIME11(:,1) )
    iMM1   = ind (month1.ge.mS .or. month1.le.mE)

    time2  = SST_in->time
    TIME2  = cd_calendar (time2, 0)
    year2  = toint ( TIME2(:,0) )
    month2 = toint ( TIME2(:,1) )
    iMM2   = ind (year2.ge.yS .and. year2.le.yE .and. (month2.ge.mS .or. month2.le.mE))

    printVarSummary (iMM1)
    printVarSummary (iMM2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Calculate monthly means
    index_mon = calculate_monthly_values (index,"avg",0,False)
    printVarSummary (index_mon)

    index_p = index_mon(iMM1)
    SST_p   = SST(iMM2,:,:)
    printVarSummary (index_p)
    printVarSummary (SST_p)

    dim1      = dimsizes (index_p)
    dim2      = dimsizes (SST_p)
    index_r   = new ((/6,dim1/6/),"float")
    SST_r     = new ((/6,dim2(0)/6,dim2(1),dim2(2)/),"float")
;    index_r!0 = "month"
;    SST_r!0   = "month"
;    SST_r!1    = "time"
;    SST_r&time = SST_p&time(::6)
;    SST_r!2    = "lat"
;    SST_r&lat  = SST_p&latitude
;    SST_r!3    = "lon"
;    SST_r&lon  = SST_p&longitude

    do i=0,5
     if (i.le.1) then
      index_r(i,:)   = index_p(i+4::6)
      SST_r(i,:,:,:) = SST_p(i+4::6,:,:)
     else
      index_r(i,:)   = index_p(i-2::6)
      SST_r(i,:,:,:) = SST_p(i-2::6,:,:)
     end if
    end do
    printVarSummary (index_r)
    printVarSummary (SST_r)

;---------------------------------------------------------------
;compute cross correlation
    r     = new ((/6,dim2(1),dim2(2)/),"float")
    r!1   = "lat"
    r&lat = SST_p&latitude
    r!2   = "lon"
    r&lon = SST_p&longitude

    do i=0,5
     r(i,:,:) = escorc_n (index_r(i,:),SST_r(i,:,:,:),0,0)
    end do

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (r)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks ("eps",out_path+out_name)  ;open a eps file
 plot = new(6,graphic)                          ;creat a plot array

;-----------------------------------------------------------------------------
res          = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
;res@gsnRightString  = "99% stippled"

;res@mpFillOn     = False      ;turn off map fill
res@mpCenterLonF = 60.       ;get the correct map
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
;res@mpMinLonF    = lonL
;res@mpMaxLonF    = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False          ;turn off cn line labels
res@cnFillPalette  = "temp_19lev"   ;choose a colormap

res@tmXBLabelFontHeightF = .025   ;font height of tick labels
res@tmYLLabelFontHeightF = .025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.6
res@cnMaxLevelValF       = 0.6
res@cnLevelSpacingF      = 0.2

res@lbLabelBarOn = False

do i=0,5
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = text2(i)
 plot(i) = gsn_csm_contour_map (wks,r(i,:,:),res)
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
resP@txString         = "Cross Correlation"   ;add common title
resP@txFontHeightF    = 0.024           ;height of text
;resP@gsnPanelCenter   = False           ;the plots to be not centered
resP@gsnPanelLabelBar = True            ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.02   ;move Label Bar down

gsn_panel(wks,plot,(/3,2/),resP)          ; create panel

end
