;*************************************************************
;Aim: Draw sample correlation between daily teleconnection index and global bandpass SST in the winter half year
;Mission:
;
;   1. Read data from daily INDEX & sst datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2017-02-23
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
    in_path2 = "~/data/observation/SST/OISST_daily/"

;time
    yS = 1982
    mS = 11
    mE = 4
    fS = 180.
    fE = 270.

;Region
    latN = 85
    latS = 0
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "corel_g_winter_daily_LP_index_and_"+fS+"-"+fE+"day_SST"

;    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
;    text2 = (/"-7","","-3","0","+3","+6"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    index_in  = addfile (in_path1, "r")
    SST_files = systemfunc ("ls "+in_path2+"sst.day.mean.*.v2.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    SST_in = addfiles (SST_files, "r")   ;note the "s" of addfile
    ListSetType (SST_in, "cat")   ;concatenate or "merge" (default)

    index = index_in->INDEX
    SST   = SST_in[:]->sst(:,::8,::8)
    printVarSummary (index)
    printVarSummary (SST)

;---------------------------------------------------------------
;get the time indexs
    time1  = index_in->time
    TIME1  = cd_calendar (time1, 0)
    year1  = toint ( TIME1(:,0) )
    iYYYY  = ind (year1.ge.yS)
    TIME11 = cd_calendar (time1(iYYYY), 0)
    month1 = toint ( TIME11(:,1) )
    iMM1   = ind (month1.ge.mS .or. month1.le.mE)

    time2  = SST_in[:]->time
    TIME2  = cd_calendar (time2, 0)
    month2 = toint ( TIME2(:,1) )
    iMM2   = ind (month2.ge.mS .or. month2.le.mE)

    printVarSummary (iMM1)
    printVarSummary (iMM2)

; create the filter weights
    nwt    = 29.
    fca    = 1./14
    fcb    = 1./999
    ihp    = 0
    nsigma = 1.
    wts1   = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

    nwt  = fE*2+1
    fca  = 1./fE
    fcb  = 1./fS
    ihp  = 2
    wts2 = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;band pass filters
    index_F = wgt_runave_Wrap (index,wts1,0)
    SST_F   = wgt_runave_Wrap (SST(lat|:,lon|:,time|iYYYY),wts,0)
    printVarSummary (index_F)
    printVarSummary (SST_F)

    index_r = index_F(iMM1)
    SST_r   = SST_F(:,:,iMM2)

;---------------------------------------------------------------
;compute cross correlation
    r = escorc (index_r,SST_r)
    copy_VarCoords_1 (SST_r,r)   ;copy coordinate variable

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

;res@mpFillOn     = False      ;turn off map fill
res@mpCenterLonF = 60.       ;get the correct map
;res@mpMinLatF    = latS
;res@mpMaxLatF    = latN
;res@mpMinLonF    = lonL
;res@mpMaxLonF    = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False          ;turn off cn line labels
res@cnFillPalette  = "temp_19lev"   ;choose a colormap

;res@tmXBLabelFontHeightF = .025   ;font height of tick labels
;res@tmYLLabelFontHeightF = .025
;res@tmXBTickSpacingF     = 60.     ;label spacing

;res@cnLevelSelectionMode = "ManualLevels"
;res@cnMinLevelValF       = -0.6
;res@cnMaxLevelValF       = 0.6
;res@cnLevelSpacingF      = 0.2

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
