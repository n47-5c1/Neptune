;*************************************************************
;Aim: Draw climatologies of global March, April, and May winds
;Mission:
;
;   1. Read data from UV datasets
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
;   var--------------uwnd
;   var--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "uwnd.mon.mean.nc"
    in_name2 = "vwnd.mon.mean.nc"

;time
    yS    = 1979
    yE    = 2014
    month = (/"March","April","May"/)      ;choose seasonal mean

;region
    latN = 40
    latS = 0
    lonL = -40
    lonR = 65

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_g_MAM_mon_wind"

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

    printVarSummary (U)
    printVarSummary (V)

;get the time indexs
    time1  = U_file->time
    time2  = V_file->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    month1 = toint ( TIME1(:,1) )
    month2 = toint ( TIME2(:,1) )
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE .and. month1.ge.3 .and. month1.le.5)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE .and. month2.ge.3 .and. month2.le.5)

    printVarSummary (iYYYY1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
  
  U_p = U(iYYYY1,:,:)
  V_p = V(iYYYY2,:,:)

;compute monthly climatologies
   U_clm1 = dim_avg_n_Wrap (U_p(::3,:,:),0)
   V_clm1 = dim_avg_n_Wrap (V_p(::3,:,:),0)
   U_clm2 = dim_avg_n_Wrap (U_p(1::3,:,:),0)
   V_clm2 = dim_avg_n_Wrap (V_p(1::3,:,:),0)
   U_clm3 = dim_avg_n_Wrap (U_p(2::3,:,:),0)
   V_clm3 = dim_avg_n_Wrap (V_p(2::3,:,:),0)
   wind1  = U_clm1
   wind1  = sqrt (U_clm1^2.+V_clm1^2.)
   wind2  = U_clm2
   wind2  = sqrt (U_clm2^2.+V_clm2^2.)
   wind3  = U_clm3
   wind3  = sqrt (U_clm3^2.+V_clm3^2.)
   printVarSummary (U_clm1)
   printVarSummary (wind1)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot  = new(3,graphic)      ;creat a plot array

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
res@cnMinLevelValF       = 5       ;set min contour level
res@cnMaxLevelValF       = 45      ;set max contour level
res@cnLevelSpacingF      = 5       ;set contour spacing

res@lbLabelBarOn = False

res@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.018
res@tmXBTickSpacingF     = 60.     ;label spacing

res@gsnLeftString   = text1(0)
res@gsnCenterString = month(0)
plot(0) = gsn_csm_streamline_contour_map_ce (wks,U_clm1,V_clm1,wind1,res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = month(1)
res@gsnRightString = " "
plot(1) = gsn_csm_streamline_contour_map_ce (wks,U_clm2,V_clm2,wind2,res)
res@gsnLeftString   = text1(2)
res@gsnCenterString = month(2)
plot(2) = gsn_csm_streamline_contour_map_ce (wks,U_clm3,V_clm3,wind3,res)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa Streamline"   ;add common title
resP@txFontHeightF            = 0.028    ;height of text
resP@gsnPanelLabelBar         = True     ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.002   ;move Label Bar down

gsn_panel(wks,plot,(/3,1/),resP)

end
