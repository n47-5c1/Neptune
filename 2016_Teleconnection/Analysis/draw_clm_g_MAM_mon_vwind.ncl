;*************************************************************
;Aim: Draw climatologies of global March, April, and May meridional winds
;Mission:
;
;   1. Read data from V datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2016-05-20
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name = "vwnd.mon.mean.nc"

;time
    yS     = 1979
    yE     = 2014
    text2 = (/"March","April","May"/)      ;choose seasonal mean

;region
    latN = 40
    latS = 0
    lonL = -40
    lonR = 65

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_g_MAM_mon_V"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    V_file = addfile (in_path+in_name,"r")
;    V      = V_file->vwnd(:,2,:,:)      ;850hPa
;    V      = V_file->vwnd(:,5,:,:)      ;500hPa
    V      = V_file->vwnd(:,8,:,:)      ;250hPa

    printVarSummary (V)

;get the time indexs
    time  = V_file->time
    TIME  = cd_calendar (time, 0)
    year  = toint ( TIME(:,0) )
    month = toint ( TIME(:,1) )
    iYYYY = ind (year.ge.yS .and. year.le.yE .and. month.ge.3 .and. month.le.5)

    printVarSummary (iYYYY)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

   V_p = V(iYYYY,:,:)

;compute monthly climatologies
   V_clm1 = dim_avg_n_Wrap (V_p(::3,:,:),0)
   V_clm2 = dim_avg_n_Wrap (V_p(1::3,:,:),0)
   V_clm3 = dim_avg_n_Wrap (V_p(2::3,:,:),0)
   printVarSummary (V_clm1)

;compute seasonal standard deviations
   Vstd1 = dim_stddev_n_Wrap (V_p(::3,:,:),0)
   Vstd2 = dim_stddev_n_Wrap (V_p(1::3,:,:),0)
   Vstd3 = dim_stddev_n_Wrap (V_p(2::3,:,:),0)
   printVarSummary (Vstd1)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(3,graphic)      ;creat a plot array
 plot2 = new(3,graphic)

;plot standard deviations
res = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame
res@gsnAddCyclic = True

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False                    ;turn off cn line labels
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.       ;get the correct map
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
;res@mpMinLonF              = lonL
;res@mpMaxLonF              = lonR

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 1.      ;set min contour level
res@cnMaxLevelValF       = 7.      ;set max contour level
res@cnLevelSpacingF      = 1.      ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.018
res@tmXBTickSpacingF     = 60.     ;label spacing

res@gsnLeftString   = text1(0)
res@gsnCenterString = text2(0)
plot(0) = gsn_csm_contour_map_ce (wks,Vstd1,res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = " "
plot(1) = gsn_csm_contour_map_ce (wks,Vstd2,res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = text2(2)
plot(2) = gsn_csm_contour_map_ce (wks,Vstd3,res)

;---------------------------------------------------------------
;  plot climatologies

res2 = True

res2@gsnDraw                      = False   ;don't draw
res2@gsnFrame                     = False   ;don't advance frame
res2@gsnAddCyclic                 = True
res2@gsnLeftString                = " "
res2@gsnCenterString              = " "
res2@gsnRightString               = " "
res2@gsnContourZeroLineThicknessF = 3       ;sets thickness of zero contour
res2@gsnContourNegLineDashPattern = 1       ;sets negative contours to dash lines

res2@cnLevelSelectionMode = "ManualLevels"   ;set manual contour levels
res2@cnMinLevelValF       = -12.             ;set min contour level
res2@cnMaxLevelValF       = 12.              ;set max contour level
res2@cnLevelSpacingF      = 1.5              ;set contour spacing
res2@cnInfoLabelOn        = False
res2@cnLineDrawOrder      = "PostDraw"
res2@cnLabelDrawOrder     = "PostDraw"

;res2@cnLineLabelsOn = False   ;do not draw contour labels

plot2(0) = gsn_csm_contour (wks,V_clm1,res2)
plot2(1) = gsn_csm_contour (wks,V_clm2,res2)
plot2(2) = gsn_csm_contour (wks,V_clm3,res2)

do i=0,2
 overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa Meridional Wind"   ;add common title
resP@txFontHeightF            = 0.028    ;height of text
resP@gsnPanelLabelBar         = True     ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002   ;move Label Bar down

gsn_panel(wks,plot,(/3,1/),resP)

end
