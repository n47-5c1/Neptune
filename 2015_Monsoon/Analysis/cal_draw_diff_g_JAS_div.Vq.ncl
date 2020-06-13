;*************************************************************
;Aim: Draw detail of the difference of global JAS moisture convergence
;Mission:
;   1. Read data
;   2. Post-post process
;   4. Draw and differences
;                       He Shan
;                       2016-04-15
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;----------------------------------------------------------------------
; This function sets the gsnSpreadXXX resources necessary to correctly span a two-color colortable.
;
; lower  = cnMinLevelValF
; upper  = cnMaxLevelValF
; step   = cnLevelSpacingF
; center = The numerical value the colormap is centered on. For anomalies or trends, it's common to use 0.0, so blue means
;          cold or cooling and red means warm or warming.
; color_end = The number of colors in colormap (ex. 97 for BlRe, 253 for BlueRed)
; center_color = Color value on the left of the "center" value (see above).
;----------------------------------------------------------------------
undef("gsnColorRange")
function gsnColorRange(lower:numeric, upper:numeric, step:numeric, center:numeric, color_end:integer, center_color:integer)
local nboxes_left, nboxes_right, ncolors_left, ncolors_right, output, color_start

begin

 color_start = 2 ; All of the color maps begin with 2.
;Calculate the number of color bar boxes to the left and right of the "center" value.
 nboxes_left  = (center - (lower - step))/step
 nboxes_right = ((upper + step) - center)/step

;Calculate the number of colors in the map on the left and right hand sides.
 ncolors_left = (center_color - color_start + 1)
 ncolors_right = (color_end - center_color)

 output = True

;Either the lower or upper extent of the color map will be adjusted. If the magnitude of the lower limit is less than the magnitude of the
;upper limit, then the lower limit has to be "moved in" towards the center color. Oppositely, the upper limit will be moved. If both the
;lower and upper numerical values are the same, then pass back 2 as the lower extent and color_end (number of colors) as the upper extent (use
;the whole map in other words).

 if(abs(lower) .lt. abs(upper))then
  output@ColorStart = round(center_color - (ncolors_right/nboxes_right)*nboxes_left, 3)
  output@ColorEnd   = color_end
 else
;---no "else if" in NCL :(
  if(abs(lower) .gt. abs(upper))then
   output@ColorStart = 2
   output@ColorEnd   = round(center_color + (ncolors_left/nboxes_left)*nboxes_right, 3)
  else
   output@ColorStart = 2
   output@ColorEnd   = color_end
  end if
 end if

 return(output)

end


;*************************************************************
; Main code
;*************************************************************
begin

;================================================
;Variables List:
;	var1--------------uwnd
;	var2--------------vwnd
;	var3--------------shum
;================================================

;datas
    in_path = "~/data/observation/NCEP_NCAR/monthly/"

    g      = 9.8
    R      = 6378388.
    deg2pi = 0.0174533   ;2*pi/360
    unit   = 86400       ;60*60*24*10??????????????????
    nyear  = 15
    season = "JAS"

;time
    yS1 = 1950
    yE1 = 1965
    yS2 = 1966
    yE2 = 1981

;Region
    latN = 40
    latS = -20
    lonW = -40
    lonE = 65
        
    font = 0.025      ;font height of tick labels

    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    fig_name = "diff_g_" + season + "div.Vq"
    text_1   = (/"a)","b)","c)","d)","e)","f)","g)"/)

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================
;NCEP/NCAR Reanalysis 1948-01~2015-01
    file1 = addfile (in_path+"NC_uwnd.mon.mean.nc","r")
    file2 = addfile (in_path+"NC_vwnd.mon.mean.nc","r")
    file3 = addfile (in_path+"NC_shum.mon.mean.nc","r")
	
	U = file1->uwnd(:,0:7,:,:)
	V = file2->vwnd(:,0:7,:,:)
	Q = file3->shum
	Q = Q

    TIME = file1->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (Q)

    pver = Q&level
    dp   = dpres_plevel_Wrap (pver,1000,1,0)   ;caculate dp
    print (pver)
    printVarSummary (dp)

    lon  = U&lon
    lat  = U&lat
    nlat = dimsizes (lat)
    dlon = (lon(2)-lon(1))*deg2pi   ;convert to radians
    dlat = (lat(2)-lat(1))*deg2pi
    dy   = R*dlat                      ;convert to dist
    printVarSummary (lon)
    printVarSummary (lat)
    printVarSummary (nlat)

;get the time indexs
    YYYY     = cd_calendar (TIME,-1)/100          ;for original data
    iYYYY_S  = ind (YYYY.ge.yS1 .and. YYYY.le.yE1)
    iYYYY_E  = ind (YYYY.ge.yS2 .and. YYYY.le.yE2)

; ==============================================================
; Mission 2. post-post process data to deserved results
; ==============================================================

    u_CON = U(iYYYY_S,:,:,:)
    v_CON = V(iYYYY_S,:,:,:)
    q_CON = Q(iYYYY_S,:,:,:)
    u_SEN = U(iYYYY_E,:,:,:)
    v_SEN = V(iYYYY_E,:,:,:)
    q_SEN = Q(iYYYY_E,:,:,:)

    qu_CON = u_CON      ;copy metadata
    qv_CON = v_CON
    qu_SEN = u_SEN
    qv_SEN = v_SEN

    qu_CON = u_CON*q_CON
    qv_CON = v_CON*q_CON
    qu_SEN = u_SEN*q_SEN
    qv_SEN = v_SEN*q_SEN

    printVarSummary (qu_CON)
    printVarSummary (qv_CON)
    
;-----------------------------------------------------------------------------
;calculate div(Vq)
;calculate the vertical integral
    dp_cfm = conform_dims (dimsizes (qu_CON),dp,1)   ;conform dp to caculate sum(var*dp)
    printVarSummary (dp_cfm)
    sum_qu_CON = qu_CON(:,0,:,:)
    sum_qv_CON = qv_CON(:,0,:,:)
    sum_qu_CON = dim_sum_n (dp_cfm*qu_CON,1)
    sum_qv_CON = dim_sum_n (dp_cfm*qv_CON,1)    
    sum_qu_CON = unit*sum_qu_CON/g
    sum_qv_CON = unit*sum_qv_CON/g
    sum_qu_SEN = qu_SEN(:,0,:,:)
    sum_qv_SEN = qv_SEN(:,0,:,:)
    sum_qu_SEN = dim_sum_n (dp_cfm*qu_SEN,1)
    sum_qv_SEN = dim_sum_n (dp_cfm*qv_SEN,1)    
    sum_qu_SEN = unit*sum_qu_SEN/g
    sum_qv_SEN = unit*sum_qv_SEN/g
    printVarSummary (sum_qu_CON)
    printVarSummary (sum_qv_CON)
    
;dqu/dx
    dqudx_CON = sum_qu_CON      ;copy metadata
    dqudx_SEN = sum_qu_SEN
    do i = 0,nlat-1                   ;loop over each latitude
     dx = R*cos(deg2pi*lat(i))*dlon   ;constant at this latitude
     dqudx_CON(:,i,:) = dble2flt (center_finite_diff_n (sum_qu_CON(:,i,:), dx , True,0,1))   ;be careful with the dimison downscale
     dqudx_SEN(:,i,:) = dble2flt (center_finite_diff_n (sum_qu_SEN(:,i,:), dx , True,0,1))
    end do
    copy_VarMeta (sum_qu_CON,dqudx_CON)      ;copy metadata
    copy_VarMeta (sum_qu_SEN,dqudx_SEN)
    printVarSummary (dqudx_CON)

;dqv/dy
    dqvdy_CON = sum_qv_CON      ;copy metadata
    dqvdy_SEN = sum_qv_SEN
    dqvdy_CON = dble2flt (center_finite_diff_n (sum_qv_CON, dy , False,0,1))
    dqvdy_SEN = dble2flt (center_finite_diff_n (sum_qv_SEN, dy , False,0,1))
    copy_VarMeta (sum_qv_CON,dqvdy_CON)      ;copy metadata
    copy_VarMeta (sum_qv_SEN,dqvdy_SEN)
    printVarSummary (dqvdy_CON)

    divUq_CON = dqudx_CON   ;copy metadata
    divUq_SEN = dqudx_SEN
    divUq_CON = -(dqudx_CON + dqvdy_CON)
    divUq_SEN = -(dqudx_SEN + dqvdy_SEN)
    printVarSummary (divUq_CON)
    printVarSummary (divUq_SEN)

;seasonal mean
    divUq_JAS_CON    = month_to_season (divUq_CON,season)
    divUq_JAS_SEN    = month_to_season (divUq_SEN,season)
    divUq_clmJAS_CON = dim_avg_n_Wrap (divUq_JAS_CON,0)
    divUq_clmJAS_SEN = dim_avg_n_Wrap (divUq_JAS_SEN,0)
    printVarSummary (divUq_JAS_CON)
    printVarSummary (divUq_clmJAS_CON)

    diff_divUq = divUq_clmJAS_CON      ;copy metadata
    diff_divUq = divUq_clmJAS_SEN - divUq_clmJAS_CON
    printVarSummary (diff_divUq)

;=============================================================================
;calculate difference of V and q
    u_JAS_CON    = month_to_season (u_CON,season)
    v_JAS_CON    = month_to_season (v_CON,season)
    q_JAS_CON    = month_to_season (q_CON,season)
    u_JAS_SEN    = month_to_season (u_SEN,season)
    v_JAS_SEN    = month_to_season (v_SEN,season)
    q_JAS_SEN    = month_to_season (q_SEN,season)
    u_clmJAS_CON = dim_avg_n_Wrap (u_JAS_CON,0)
    v_clmJAS_CON = dim_avg_n_Wrap (v_JAS_CON,0)
    q_clmJAS_CON = dim_avg_n_Wrap (q_JAS_CON,0)
    u_clmJAS_SEN = dim_avg_n_Wrap (u_JAS_SEN,0)
    v_clmJAS_SEN = dim_avg_n_Wrap (v_JAS_SEN,0)
    q_clmJAS_SEN = dim_avg_n_Wrap (q_JAS_SEN,0)

    diff_u = u_clmJAS_CON      ;copy metadata
    diff_v = v_clmJAS_CON
    diff_q = q_clmJAS_CON
    diff_u = u_clmJAS_SEN - u_clmJAS_CON
    diff_v = v_clmJAS_SEN - v_clmJAS_CON
    diff_q = q_clmJAS_SEN - q_clmJAS_CON
    printVarSummary (diff_u)
    printVarSummary (diff_v)
    printVarSummary (diff_q)

;-----------------------------------------------------------------------------
;calculate q*div(V)  B1 B2

    du_CON_dx  = u_clmJAS_CON      ;copy metadata
    dv_CON_dy  = v_clmJAS_CON
    du_diff_dx = diff_u
    dv_diff_dy = diff_v
   
;du/dx
    do i = 0,nlat-1      ;loop over each latitude
     dx = R*cos(deg2pi*lat(i))*dlon      ;constant at this latitude
     du_CON_dx(:,i,:)  = dble2flt (center_finite_diff_n (u_clmJAS_CON(:,i,:), dx , True,0,1))   ;be careful with the dimison downscale
     du_diff_dx(:,i,:) = dble2flt (center_finite_diff_n (diff_u(:,i,:), dx , True,0,1))
    end do
    copy_VarMeta (u_clmJAS_CON,du_CON_dx)      ;copy metadata
    copy_VarMeta (diff_u,du_diff_dx)
    printVarSummary (du_CON_dx)

;dv/dy
    dv_CON_dy  = dble2flt (center_finite_diff_n (v_clmJAS_CON, dy , False,0,1))
    dv_diff_dy = dble2flt (center_finite_diff_n (diff_v, dy , False,0,1))
    copy_VarMeta (v_clmJAS_CON,dv_CON_dy)      ;copy metadata
    copy_VarMeta (diff_v,dv_diff_dy)
    printVarSummary (dv_CON_dy)
    printVarSummary (dv_diff_dy)

;sum(var*dp)/g
    B1_p = diff_q      ;copy metadata
    B2_p = q_clmJAS_CON
    B1_p = diff_q * ( du_CON_dx + dv_CON_dy )
    B2_p = q_clmJAS_CON * ( du_diff_dx + dv_diff_dy )
    B1   = B1_p(0,:,:)   ;copy metadata
    B2   = B2_p(0,:,:)
    B1   = dim_sum_n (dp_cfm(0,:,:,:) * B1_p,0)
    B2   = dim_sum_n (dp_cfm(0,:,:,:) * B2_p,0)
    B1   = -unit*B1/g
    B2   = -unit*B2/g
    printVarSummary (B1)

;-----------------------------------------------------------------------------
;calculate V*div(q)  A1 A2

    dq_CON_dx  = q_clmJAS_CON      ;copy metadata
    dq_CON_dy  = q_clmJAS_CON
    dq_diff_dx = diff_q
    dq_diff_dy = diff_q
   
;dq/dx
    do i = 0,nlat-1      ;loop over each latitude
     dx = R*cos(deg2pi*lat(i))*dlon      ;constant at this latitude
     dq_CON_dx(:,i,:)  = dble2flt (center_finite_diff_n (q_clmJAS_CON(:,i,:), dx , True,0,1))   ;be careful with the dimison downscale
     dq_diff_dx(:,i,:) = dble2flt (center_finite_diff_n (diff_q(:,i,:), dx , True,0,1))
    end do
    copy_VarMeta (q_clmJAS_CON,dq_CON_dx)      ;copy metadata
    copy_VarMeta (diff_q,dq_diff_dx)
    printVarSummary (dq_CON_dx)

;dq/dy
    dq_CON_dy  = dble2flt (center_finite_diff_n (q_clmJAS_CON, dy , False,0,2))
    dq_diff_dy = dble2flt (center_finite_diff_n (diff_q, dy , False,0,2))
    copy_VarMeta (q_clmJAS_CON,dq_CON_dy)      ;copy metadata
    copy_VarMeta (diff_q,dq_diff_dy)
    printVarSummary (dq_CON_dx)

;sum(var*dp)/g
    A1_p = diff_q
    A2_p = q_clmJAS_CON
    A1_p = u_clmJAS_CON*dq_diff_dx+v_clmJAS_CON*dq_diff_dy
    A2_p = diff_u*dq_CON_dx+diff_v*dq_CON_dy
    A1   = A1_p(0,:,:)
    A2   = A2_p(0,:,:)
    A1   = dim_sum_n (dp_cfm(0,:,:,:) * A1_p,0)
    A2   = dim_sum_n (dp_cfm(0,:,:,:) * A2_p,0)
    A1   = -unit*A1/g
    A2   = -unit*A2/g
    printVarSummary (A1)
    
; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

  wks  = gsn_open_wks ("eps",out_path+fig_name)   ;open a eps file
  plot = new((/6/),graphic)

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False       ;don't draw
res@gsnFrame       = False       ;don't advance frame
res@gsnRightString = " "
;res@gsnRightString = "mm/day"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off contour line labels
;res@cnFillPalette  = "BrownBlue12"      ;choose a colormap
res@cnFillPalette  = "rh_19lev"      ;choose a colormap

res@tmXBLabelFontHeightF = font   ;font height of tick labels
res@tmYLLabelFontHeightF = font
res@tmXBTickSpacingF     = 30.    ;label spacing

;gsn_range = gsnColorRange(-3.75,4.5,.75,-.75,19,11)
gsn_range = gsnColorRange(-37.5,45.,7.5,-7.5,19,11)
;symMinMaxPlt( diff_divUq,20,False,res)      ;to have a common label bar
;symMinMaxPlt( diff_divUq({latS:latN},{lonL:lonR}),20,False,res)      ;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -37.5
res@cnMaxLevelValF       = 45.
res@cnLevelSpacingF      = 7.5
res@lbLabelBarOn = False

res@gsnSpreadColorStart = gsn_range@ColorStart
res@gsnSpreadColorEnd   = gsn_range@ColorEnd

res@mpFillOn     = False      ;turn off gray continents
res@mpCenterLonF = 110.
;res@gsnAddCyclic = True

res@mpMaxLatF = latN
res@mpMinLatF = latS
res@mpMaxLonF = lonE
res@mpMinLonF = lonW
;res@mpGeophysicalLineThicknessF = 2
;res@mpGeophysicalLineColor      = "black";"white" 


res@gsnLeftString = text_1(0)
plot(0) = gsn_csm_contour_map_ce(wks,A1,res)
res@gsnLeftString = text_1(1)
plot(1) = gsn_csm_contour_map_ce(wks,A2,res)
;res@gsnLeftString = text_1(0)
res@gsnLeftString = text_1(2)
plot(2) = gsn_csm_contour_map_ce(wks,B1,res)
;res@tiMainString             = "Differences in JAS Moisture Convergence"   ;add title
;res@tiMainFontHeightF        = 0.035    ;change font heights
;res@lbLabelBarOn             = True
;res@pmLabelBarOrthogonalPosF = 0.2      ;move whole thing down
;res@gsnLeftString            = " "
;res@gsnLeftString = text_1(1)
res@gsnLeftString = text_1(3)
plot(3) = gsn_csm_contour_map_ce(wks,B2,res)
C = diff_divUq
C = A1+A2+B1+B2
res@gsnLeftString = text_1(4)
plot(4) = gsn_csm_contour_map_ce(wks,C,res)
;res@gsnLeftString = text_1(2)
res@gsnLeftString = text_1(5)
plot(5) = gsn_csm_contour_map_ce(wks,diff_divUq,res)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.035      ;height of text
resP@txString         = "Differences of JAS Moisture Convergence"   ;add common title
resP@gsnPanelLabelBar = True       ;add common colorbar

gsn_panel(wks,plot,(/3,2/),resP)          ; create panel
;gsn_panel(wks,plot((/2,3,5/)),(/3,1/),resP)          ; create panel

;draw(plot(3))
;frame(wks)

end 
