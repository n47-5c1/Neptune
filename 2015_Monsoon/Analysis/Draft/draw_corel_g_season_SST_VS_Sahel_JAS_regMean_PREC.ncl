;*************************************************************
;Aim: Draw correlation between JAS global SST and Sahel region mean rainfall
;Mission:
;
;   1. Read data from SST and PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2015-04-28
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------sst
;     var2--------------precip
;================================================

;    GRAY = True      ;colour?
    GRAY = False      ;colour?

;time
    yS = 1950
    yE = 2011
    season = "JAS"      ;choose seasonal mean

;Sahel
    latN=20
    latS=10
    lonL=-20
    lonR=40

;data
    out_path = "~/hes/Sahel_Rainfall/final/"
    if(GRAY)then
     out_name = "corel_JAS_g_SST_VS_Sahel_reg_PREC_gray"
    else
     out_name = "corel_JAS_g_SST_VS_Sahel_reg_PREC"
    end if

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;HadISST 1870-01~2014-09
    SST_file  = addfile ("~/data/observation/SST/HadISST_sst.nc","r")
;PREC 1948-01~2012-01
    PREC_file = addfile ("~/data/observation/PRECPT/precip-land.mon.mean.0.5x0.5.nc","r")

    SST     = SST_file->sst
    PREC_p  = PREC_file->precip(:,{latS:latN},:)
    PREC_p = lonFlip (PREC_p)      ;Sahel rainfall
    PREC   = PREC_p(:,:,{lonL:lonR})
    printVarSummary (SST)
    printVarSummary (PREC)

;---------------------------------------------------------------
;get the time indexs
    TIME1 = PREC_file->time
    TIME2 = SST_file->time

    YYYY_1     = cd_calendar (TIME1,-1)/100
    iYYYY_PREC = ind (YYYY_1.ge.yS .and. YYYY_1.le.yE)
    YYYY_2     = cd_calendar (TIME2,-1)/100
    iYYYY_SST  = ind (YYYY_2.ge.yS .and. YYYY_2.le.yE)

;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.
    gw = PREC_file->lat({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   PREC_JAS_reg = month_to_season ( wgt_areaave_Wrap ( PREC(iYYYY_PREC,:,:) ,gw,1.,0) ,season)
   printVarSummary (PREC_JAS_reg)

;compute seasonal means
   SST     = mask (SST,SST.le.0,False)      ;set SST that are less than 0 to the _FillValue
   SST_JAS = month_to_season ( SST(iYYYY_SST,:,:) ,season)
   dim     = dimsizes (SST_JAS)
   printVarSummary (SST_JAS)

;compute the correlation
   r = new ((/dim(1),dim(2)/),float)
   copy_VarCoords (SST(0,:,:),r)      ;copy coordinate variable
   SST_JAS_new = SST_JAS(latitude|:,longitude|:,time|:)   ;reorder to get time as right most dimension
   r = escorc (SST_JAS_new,PREC_JAS_reg)
   printVarSummary (r)

   rc = new ((/dim(1),dim(2)/),float)
   copy_VarCoords (SST(0,:,:),rc)      ;copy coordinate variable
   do i=0,dim(1)-1
    do j=0,dim(2)-1
     rc(i,j) = regline (SST_JAS(:,i,j),PREC_JAS_reg)
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

 if(GRAY)then
  gsn_define_colormap(wks,"MPL_Greys")      ; choose a colormap
 else
  gsn_define_colormap(wks,"MPL_RdBu") ; choose a colormap
 end if

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame

;res@mpGridAndLimbOn       = True        ;turn on grid lines
;res@mpGridLineColor       = "Gray30"
res@mpCenterLonF          = 110         ;get the correct map

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
res@gsnCenterString = "JAS"
res@gsnRightString  = "99% stippled"
plot(0) = gsn_csm_contour_map (wks,r,res)

symMinMaxPlt(r,20,False,res)
res@gsnLeftString   = "b)"
res@gsnCenterString = "99% stippled"
res@gsnRightString  = "mm/(day* C)"
plot(1) = gsn_csm_contour_map (wks,rc,res)

;---------------------------------------------------------------
;plot zero line

res2 = True

res2@gsnDraw        = False   ;don't draw
res2@gsnFrame       = False   ;don't advance frame
res2@gsnLeftString  = " "
res2@gsnRightString = " "

if(GRAY)then
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
resP@txFontHeightF    = 0.024      ;height of text
resP@txString         = "Correlations and Regression between SST and Sahel Rainfall Index"   ;add common title
resP@gsnPanelCenter   = False      ;the plots to be not centered

gsn_panel(wks,plot,(/1,2/),resP)          ; create panel

end
