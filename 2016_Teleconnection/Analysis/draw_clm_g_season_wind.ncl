;*************************************************************
;Aim: Draw climatologies of global seasonal winds
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2016-04-27
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var--------------uwnd
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"

;time
    yS     = 1979
    yE     = 2014
    season = (/"MAM","JJA","SON","DJF"/)      ;choose seasonal mean

;region
    latN = 40
    latS = 0
    lonL = -40
    lonR = 65

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_g_season_wind"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_file = addfile (in_path+in_name1,"r")
    V_file = addfile (in_path+in_name2,"r")
;    U      = U_file->uwnd(:,2,:,:)      ;850hPa
;    U      = U_file->uwnd(:,5,:,:)      ;500hPa
    U      = U_file->uwnd(:,8,:,:)      ;250hPa
    V      = V_file->vwnd(:,8,:,:)      ;250hPa
    TIME1  = U_file->time
    TIME2  = V_file->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME1)
    printVarSummary (TIME2)

;get the time indexs
    YYYY1  = cd_calendar (TIME1,-1)/100          ;for original data
    YYYY2  = cd_calendar (TIME2,-1)/100          ;for original data
    iYYYY1 = ind (YYYY1.ge.yS .and. YYYY1.le.yE)
    iYYYY2 = ind (YYYY2.ge.yS .and. YYYY2.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   U_season = month_to_seasonN (U(iYYYY1,:,:),season)
   V_season = month_to_seasonN (V(iYYYY2,:,:),season)
   printVarSummary (U_season)

;compute seasonal climatologies
   U_clm = dim_avg_n_Wrap (U_season,1)
   V_clm = dim_avg_n_Wrap (V_season,1)
   wind  = U_clm
   wind  = sqrt (U_clm^2.+V_clm^2.)
   printVarSummary (U_clm)
   printVarSummary (wind)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(4,graphic)      ;creat a plot array

;*******************************************
;  plot climatologies
;*******************************************
res = True

res@gsnDraw           = False      ;don't draw
res@gsnFrame          = False      ;don't advance frame
res@gsnAddCyclic      = True
res@gsnSpreadColorEnd = 250        ; end at color 200

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off cn line labels
res@cnFillPalette  = "WhiteYellowOrangeRed"   ;choose a colormap

res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;res@mpCenterLonF           = 110.       ;get the correct map
;map outlines
res@mpMinLatF              = latS
;res@mpMaxLatF              = latN
;res@mpMinLonF              = lonL
;res@mpMaxLonF              = lonR

;res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
;res@vcRefLengthF            = 0.075           ;the length of the reference magnitude
;res@vcMinDistanceF          = 0.04            ;the minimum distance of neighboring vectors
;res@vcRefMagnitudeF         = 50              ;the magnitude used as the reference magnitude
;res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
;res@vcLineArrowThicknessF   = 1.4
;res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
;res@vcLineArrowHeadMinSizeF = 0.005
;res@vcRefAnnoOrthogonalPosF = -0.168          ;move ref vector
res@stArrowLengthF     = 0.008      ;size of the arrows.
res@stMinArrowSpacingF = 0.08       ;arrow spacing.
res@stLineThicknessF   = 1.1        ;changes the line thickness
res@stMinDistanceF     = 0.05       ;distance between streamlines
res@stMinLineSpacingF  = 0.004

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 4       ;set min contour level
res@cnMaxLevelValF       = 48      ;set max contour level
res@cnLevelSpacingF      = 4       ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.     ;label spacing

do i=0,3
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = season(i)
 if(i.eq.1) then
  res@gsnRightString = " "
 end if
 plot(i) = gsn_csm_streamline_contour_map_ce (wks,U_clm(i,:,:),V_clm(i,:,:),wind(i,:,:),res)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa Streamline"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text
resP@gsnPanelLabelBar         = True   ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002    ;move Label Bar down

gsn_panel(wks,plot,(/4,1/),resP)

end
