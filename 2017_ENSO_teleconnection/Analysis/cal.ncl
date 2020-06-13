;====================UNFINISHED===============================
;*************************************************************
;Aim: Draw detail of the difference of global JAS moisture convergence between CON and SEN(E)
;Mission:
;   1. Read data
;   2. Post-post process
;   4. Draw and overlap
;                       He Shan
;                       2015-10-20
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;	var1--------------U
;	var2--------------V
;	var3--------------Q
;================================================

;datas
    in_path_CON = "~/WORKSPACE/hes/1950_2013_SSTice_FC5/run/"
    in_path_SEN = "~/WORKSPACE/hes/E_SAM_JJAS_LH_1950_2013_SSTice_FC5PM/run/"

    g      = 9.8
    R      = 6378388.
    deg2pi = 0.0174533   ;2*pi/360
    unit   = 864000      ;60*60*24*10??????????????????
    nyear  = 30
    season = "JAS"

;arguments required by vinth2p
    P0mb   = 1000
    interp = 2
    pnew   = (/1000,925,850,775,700,600,500,400,300,250,200,150,100,70,50,30,20,10,7,5,3,2,1/)
    pnew@units = "mb"

    pver       = pnew*100
    pver@units = "Pa"

;Region
    latN = 60
    latS = -30
    lonW = -40
    lonE = 180
        
    font = 0.025      ;font height of tick labels

    fig_name  = "../Fig/diff_g_" + season + "div.Vq_CON_SEN_E"
    text_1    = (/"a)","b)","c)","d)","e)","f)","g)"/)

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================
    files_CON = systemfunc ("ls "+in_path_CON+"*cam.h0.000[6-9]* "+in_path_CON+"*cam.h0.00[1-3]*")   ;F_2000_CAM5
    files_SEN = systemfunc ("ls "+in_path_SEN+"*cam.h0.000[6-9]* "+in_path_SEN+"*cam.h0.00[1-3]*")
    setfileoption ("nc","SuppressClose",False)      ;close too many files
	
    in_CON = addfiles (files_CON, "r")   ;note the "s" of addfile
    in_SEN = addfiles (files_SEN, "r")
    ListSetType (in_CON, "cat")          ;concatenate or "merge" (default)
    ListSetType (in_SEN, "cat")

    hyam   = in_CON[:]->hyam(0:29)      ;must have the same dimension size as the level dimension of datai
    hybm   = in_CON[:]->hybm(0:29)
    PS_CON = in_CON[:]->PS
    PS_SEN = in_SEN[:]->PS
    printVarSummary (hyam)
    printVarSummary (hybm)
    printVarSummary (PS_CON)

;--------------------------------------------------------------
	u_CON_p = in_CON[:]->U
	v_CON_p = in_CON[:]->V
	q_CON_p = in_CON[:]->Q
	u_SEN_p = in_SEN[:]->U
	v_SEN_p = in_SEN[:]->V
	q_SEN_p = in_SEN[:]->Q

    printVarSummary (u_CON_p)
    printVarSummary (v_CON_p)
    printVarSummary (q_CON_p)

    dp         = dpres_plevel_Wrap (pver,100000,1,0)   ;caculate dp
    print (pver)
    printVarSummary (dp)

    lon  = u_CON_p&lon
    lat  = u_CON_p&lat
    nlat = dimsizes (lat)
    dlon = (lon(2)-lon(1))*deg2pi   ;convert to radians
    dlat = (lat(2)-lat(1))*deg2pi
    dy   = R*dlat                      ;convert to dist
    printVarSummary (lon)
    printVarSummary (lat)
    printVarSummary (nlat)

; ==============================================================
; Mission 2. post-post process data to deserved results
; ==============================================================

;interpolate to pressure levels on pressure levels
    u_CON = vinth2p (u_CON_p,hyam,hybm,pnew,PS_CON,interp,P0mb,1,False)
    v_CON = vinth2p (v_CON_p,hyam,hybm,pnew,PS_CON,interp,P0mb,1,False)
    q_CON = vinth2p (q_CON_p,hyam,hybm,pnew,PS_CON,interp,P0mb,1,False)
    u_SEN = vinth2p (u_SEN_p,hyam,hybm,pnew,PS_SEN,interp,P0mb,1,False)
    v_SEN = vinth2p (v_SEN_p,hyam,hybm,pnew,PS_SEN,interp,P0mb,1,False)
    q_SEN = vinth2p (q_SEN_p,hyam,hybm,pnew,PS_SEN,interp,P0mb,1,False)

    qu_CON = u_CON      ;copy metadata
    qv_CON = v_CON
    qu_SEN = u_SEN
    qv_SEN = v_SEN

    qu_CON = u_CON*q_CON
    qv_CON = v_CON*q_CON
    qu_SEN = u_SEN*q_SEN
    qv_SEN = v_SEN*q_SEN

    copy_VarCoords (u_CON_p(:,0:23,:,:),u_CON)
    copy_VarCoords (v_CON_p(:,0:23,:,:),v_CON)
    copy_VarCoords (q_CON_p(:,0:23,:,:),q_CON)
    copy_VarCoords (u_SEN_p(:,0:23,:,:),u_SEN)
    copy_VarCoords (v_SEN_p(:,0:23,:,:),v_SEN)
    copy_VarCoords (q_SEN_p(:,0:23,:,:),q_SEN)

    copy_VarCoords (u_CON_p(:,0:23,:,:),qu_CON)
    copy_VarCoords (v_CON_p(:,0:23,:,:),qv_CON)
    copy_VarCoords (u_CON_p(:,0:23,:,:),qu_SEN)
    copy_VarCoords (v_SEN_p(:,0:23,:,:),qv_SEN)

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

  wks  = gsn_open_wks ("eps",fig_name)   ;open a eps file
  plot = new((/6/),graphic)

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False       ;don't draw
res@gsnFrame       = False       ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off contour line labels
res@cnFillPalette  = "BrownBlue12"      ;choose a colormap

res@tmXBLabelFontHeightF = font   ;font height of tick labels
res@tmYLLabelFontHeightF = font
res@tmXBTickSpacingF     = 40.    ;label spacing

;symMinMaxPlt( diff_divUq,20,False,res)      ;to have a common label bar
;symMinMaxPlt( diff_divUq({latS:latN},{lonL:lonR}),20,False,res)      ;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -15
res@cnMaxLevelValF       = 15
res@cnLevelSpacingF      = 3
res@lbLabelBarOn = False

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
;res@gsnCenterString = g_fig_title(0)
res@gsnRightString = ""
plot(0) = gsn_csm_contour_map_ce(wks,A1,res)
res@gsnLeftString = text_1(1)
plot(1) = gsn_csm_contour_map_ce(wks,A2,res)
res@gsnLeftString = text_1(0)
;res@gsnLeftString = text_1(2)
plot(2) = gsn_csm_contour_map_ce(wks,B1,res)
res@gsnLeftString = text_1(1)
;res@gsnLeftString = text_1(3)
plot(3) = gsn_csm_contour_map_ce(wks,B2,res)
C = diff_divUq
C = A1+A2+B1+B2
res@gsnLeftString = text_1(4)
plot(4) = gsn_csm_contour_map_ce(wks,C,res)
res@gsnLeftString = text_1(2)
;res@gsnLeftString = text_1(5)
plot(5) = gsn_csm_contour_map_ce(wks,diff_divUq,res)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.04       ;height of text
resP@txString         = "Difference of JAS Moisture Convergence"   ;add common title
resP@gsnPanelLabelBar = True       ;add common colorbar

gsn_panel(wks,plot((/2,3,5/)),(/3,1/),resP)          ; create panel

end 
