;*************************************************************
;Aim: Draw correlation between JAS global OLR and Sahel region mean rainfall
;Mission:
;
;   1. Read data from PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2016-01-09
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;     var1--------------olr
;     var2--------------precip
;================================================

;time
    yS = 1950
    yE = 2012
    season = "JAS"      ;choose seasonal mean

;Sahel
    latN = 20
    latS = 10
    lonL = -20
    lonR = 35

;map
    latSm = -15.
    latNm = 35.
    lonLm = -70.
    lonRm = 200

;data
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "corel_JAS_g_PREC_VS_Sahel_reg_PREC"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;PREC 1979-01~2014-12
    PREC_file = addfile ("~/data/observation/PRECPT/GPCP_precip.197901-201412.nc","r")
;OLR 1979-01~2012-12
    OLR_file  =  addfile ("~/data/observation/NOAA-OLR/olr1979-2012.nc","r")

;get the time indexs
    TIME = OLR_file->time

    YYYY  = cd_calendar (TIME,-1)/100
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

;---------------------------------------------------------------
    PRECg  = OLR_file->olr
    PREC_p = PREC_file->precip(iYYYY,{latS:latN},:)
    PREC_p = lonFlip (PREC_p)      ;Sahel rainfall
    PREC   = PREC_p(:,:,{lonL:lonR})
    printVarSummary (PRECg)
    printVarSummary (PREC)

;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.
    gw = PREC_file->lat({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   PREC_JAS_reg = month_to_season ( wgt_areaave_Wrap ( PREC ,gw,1.,0) ,season)
   printVarSummary (PREC_JAS_reg)

;compute seasonal means
   PRECg_JAS = month_to_season (PRECg,season)
   dim     = dimsizes (PRECg_JAS)
   printVarSummary (PRECg_JAS)

;compute the correlation
   r = new ((/dim(1),dim(2)/),float)
   copy_VarCoords (PRECg(0,:,:),r)      ;copy coordinate variable
   PRECg_JAS_new = PRECg_JAS(lat|:,lon|:,time|:)   ;reorder to get time as right most dimension
   r = escorc (PRECg_JAS_new,PREC_JAS_reg)
   printVarSummary (r)

   rc = new ((/dim(1),dim(2)/),float)
   copy_VarCoords (PRECg(0,:,:),rc)      ;copy coordinate variable
   do i=0,dim(1)-1
    do j=0,dim(2)-1
     rc(i,j) = regline (PRECg_JAS(:,i,j),PREC_JAS_reg)
    end do
   end do
   printVarSummary (rc)

;determine the statistical significance
   prob = r      ;copy meta data
   prob = rtest (r,dim(0),0)
   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue
   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks  = gsn_open_wks("eps",out_path+out_name)  ; open a ps file
 plot = new(2,graphic)       ;creat a plot array

 gsn_define_colormap(wks,"MPL_RdBu") ; choose a colormap

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame

;res@mpGridAndLimbOn = True        ;turn on grid lines
;res@mpGridLineColor = "Gray30"
res@mpCenterLonF    = 110         ;get the correct map

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels

;res@tiMainString      = "Correlations between SST and Sahel Rainfall Index"   ;add title
;res@tiMainFontHeightF = 0.03    ;change font heights

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@pmLabelBarOrthogonalPosF = 0.15   ;move Label Bar down

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.7
res@cnMaxLevelValF       = 0.7
res@cnLevelSpacingF      = 0.1

res@gsnLeftString   = "a)"
res@gsnCenterString = "99% stippled"
res@gsnRightString  = " "
plot(0) = gsn_csm_contour_map (wks,r,res)

symMinMaxPlt(r,20,False,res)
res@gsnLeftString   = "b)"
res@gsnCenterString = " "
res@gsnRightString  = "mm/(day* C)"
plot(1) = gsn_csm_contour_map (wks,rc,res)

;---------------------------------------------------------------
res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

if(False)then
 res2@cnLineLabelsOn       = False   ;turn off cn line labels
 res2@cnInfoLabelOn        = False   ;turn off cn info labels
 res2@cnLevelSelectionMode = "ExplicitLevels"
 res2@cnLevels             = (/0/)      ;Use a value that's between the two values
 plot1 = gsn_csm_contour(wks,r,res2)
 overlay (plot(0),plot1)
 overlay (plot(1),plot1)
end if

;---------------------------------------------------------------
;probability plots

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = 0.00             ;set min contour level
res2@cnMaxLevelValF       = 0.10             ;set max contour level
res2@cnLevelSpacingF      = 0.01             ;set contour spacing
res2@cnInfoLabelOn        = False

res2@cnLinesOn      = False   ;do not draw contour lines
res2@cnLineLabelsOn = False   ;do not draw contour labels
res2@cnFillDotSizeF = 0.003   ;set a uniform dot size
res2@cnFillScaleF   = 1.2     ;add extra density

plot2 = gsn_csm_contour (wks,prob,res2)
plot2 = ShadeLtContour (plot2,0.015,17)      ;shade all areas < 0.015 contour
plot3 = gsn_csm_contour (wks,prob,res2)
plot3 = ShadeLtContour (plot3,0.015,17)      ;shade all areas < 0.015 contour
overlay (plot(0),plot2)
overlay (plot(1),plot3)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.02      ;height of text
resP@txString         = "Correlations and Regression between JAS OLR and Sahel Rainfall"   ;add common title
resP@gsnPanelCenter   = False      ;the plots to be not centered

gsn_panel(wks,plot,(/1,2/),resP)          ; create panel

end
