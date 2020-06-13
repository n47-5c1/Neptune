;*************************************************************
;Aim: Draw climatologies and differences of global JAS vectors for each levels
;Mission:
;
;   1. Read data from UV datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and differences
;                       He Shan
;                       2015-03-20
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;================================================

    level = (/"1000","925","850","700","600","500","400","300","250","200","150","100","70","50","30","20","10"/)
    nlev  = 3       ;number of the levels used
    nyear = 18      ;number of the years used

    season = "JAS"      ;choose seasonal mean

;time
    yEc = 2014
    yS1 = 1950
    yE1 = 1967
    yS2 = 1968
    yE2 = 1985

;fig
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "clm_diff_g_JAS_wind"

;text
    Text1 = (/"a)","b)","c)","d)","e)","f)"/)
    Text2 = (/"850hPa","500hPa","200hPa"/)
    Text3 = ": 6885-5067"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file = addfile("~/data/observation/NCEP_NCAR/monthly/NC_uwnd.mon.mean.nc","r")
    V_file = addfile("~/data/observation/NCEP_NCAR/monthly/NC_vwnd.mon.mean.nc","r")
    U      = U_file->uwnd(:,(/2,5,9/),:,:)
    V      = V_file->vwnd(:,(/2,5,9/),:,:)
    TIME   = V_file->time

    printVarSummary(U)
    printVarSummary(V)
    printVarSummary(TIME)

;get the time indexs
    YYYY     = cd_calendar(TIME,-1)/100          ;for original data
    YYYY_JAS = cd_calendar(TIME(8::12),-1)/100   ;for seasonal means data
    iYYYY_C  = ind(YYYY.le.yEc)
    iYYYY_1  = ind(YYYY_JAS.ge.yS1 .and. YYYY_JAS.le.yE1)
    iYYYY_2  = ind(YYYY_JAS.ge.yS2 .and. YYYY_JAS.le.yE2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means
   U_JAS = month_to_season( U(iYYYY_C,:,:,:) ,season)
   V_JAS = month_to_season( V(iYYYY_C,:,:,:) ,season)
   printVarSummary(U_JAS)
   printVarSummary(V_JAS)

;--------------------------------------------------------------
;compute annual climatologies
   U_clm = dim_avg_n_Wrap(U_JAS,0)
   V_clm = dim_avg_n_Wrap(V_JAS,0)
   printVarSummary(V_clm)
   printVarSummary(U_clm)

;--------------------------------------------------------------
;compute 3 monthly climatologies
   Uave50 = dim_avg_n_Wrap(U_JAS(iYYYY_1,:,:,:),0)
   Ustd50 = dim_stddev_n_Wrap(U_JAS(iYYYY_1,:,:,:),0)
   Uave80 = dim_avg_n_Wrap(U_JAS(iYYYY_2,:,:,:),0)
   Ustd80 = dim_stddev_n_Wrap(U_JAS(iYYYY_2,:,:,:),0)

   Vave50 = dim_avg_n_Wrap(V_JAS(iYYYY_1,:,:,:),0)
   Vstd50 = dim_stddev_n_Wrap(V_JAS(iYYYY_1,:,:,:),0)
   Vave80 = dim_avg_n_Wrap(V_JAS(iYYYY_2,:,:,:),0)
   Vstd80 = dim_stddev_n_Wrap(V_JAS(iYYYY_2,:,:,:),0)

   printVarSummary(Uave50)
   printVarSummary(Ustd50)
   printVarSummary(Vave50)
   printVarSummary(Vstd50)

;---------------------------------------------------------------
;copy meta data
   prob_U = Uave50
   diff_U = Uave50
   prob_V = Vave50
   diff_V = Vave50

;compute probabilities for means difference
   prob_U = ttest(Uave80,Ustd80^2,nyear,Uave50,Ustd50^2,nyear,False,False)
   prob_V = ttest(Vave80,Vstd80^2,nyear,Vave50,Vstd50^2,nyear,False,False)

;compute differences
   diff_U = Uave80-Uave50
   diff_V = Vave80-Vave50

   printVarSummary(prob_U)
   printVarSummary(diff_U)
   printVarSummary(prob_V)
   printVarSummary(diff_V)

; ==============================================================
; Mission 3. Draw the climatologies and differences
; ==============================================================

 wks = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(6,graphic)      ;creat a plot array

;*******************************************
;  plot climatologies
;*******************************************
res                 = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame

res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcRefAnnoOrthogonalPosF = -0.23           ;move ref vector
res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.01
res@vcLineArrowThicknessF   = 1.2
res@vcRefLengthF            = 0.05            ;the length of the reference magnitude
res@vcRefMagnitudeF         = 7               ;the magnitude used as the reference magnitude
res@vcMinDistanceF          = 0.04            ;the minimum distance of neighboring vectors

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@mpGeophysicalLineColor = "gray30"     ;change the colour of ontlines
res@mpCenterLonF           = 110          ;get the correct map
res@mpFillOn               = False        ;turn off map fill
;res@gsLineColor            = "Gray80"     ;change the colour of outlines

do i=0,nlev-1
 if(i.eq.nlev-1) then      ;turn on the buttom individual vector reference box
  res@vcRefAnnoOn = True
 else
  res@vcRefAnnoOn = False
 end if
 res@gsnLeftString   = Text1(2*i)
 res@gsnCenterString = Text2(i)
 plot(2*i) = gsn_csm_vector_map_ce(wks,U_clm(i,:,:),V_clm(i,:,:),res)
end do

;*******************************************
;  plot differences
;*******************************************
res@gsnRightString = "95%"

res@vcMinDistanceF  = 0.02      ;the minimum distance of neighboring vectors
res@vcRefMagnitudeF = 3         ;the magnitude used as the reference magnitude

diff_U = mask(diff_U,(prob_U.le.0.05).or.(prob_V.le.0.05),True)   ;draw all areas < 0.05 contour
diff_V = mask(diff_V,(prob_U.le.0.05).or.(prob_V.le.0.05),True)

do i=0,nlev-1
 if (i.eq.nlev-1) then      ;turn on the buttom individual vector reference box
  res@vcRefAnnoOn  = True
 else
  res@vcRefAnnoOn  = False
 end if
  res@gsnLeftString   = Text1(2*i+1)
  res@gsnCenterString = Text2(i)+Text3
  plot(2*i+1) = gsn_csm_vector_map_ce(wks,diff_U(i,:,:),diff_V(i,:,:),res)
 end do

;*******************************************
;create panel resources
;*******************************************
resP          = True
resP@txString = "Global "+season+" Climatologies and Differences of Wind Vectors"   ;add common title

gsn_panel(wks,plot,(/3,2/),resP)

end
