;*************************************************************
;Aim: Draw the climatology and difference of regional JJA ZM heating in model
;Mission:
;   1. Read data
;   2. Post-post process
;   4. Draw and overlap
;                       He Shan
;                       2017-04-20
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;*************************************************************
; Main code
;*************************************************************
begin

;================================================
;Variables List:
;	var1--------------EVAPTAM
;	var2--------------ZMDT
;	var3--------------ZMMTT
;	var4--------------PS
;	var5--------------hyam
;	var6--------------hybm
;================================================

;datas
    in_path1 = "~/data/model/CESM_CTRL/FC5PM_F19_1960_1969_SSTice_daily/"
    in_path2 = "~/data/model/CESM_CTRL/FC5PM_F19_1980_1989_SSTice_daily/"

    dayS   = 151
    dayE   = 241
;    dayE   = 272
    season = "JJA"

;arguments required by vinth2p
    P0mb   = 1000
    interp = 2
    pnew   = (/1000,925,850,775,700,600,500,400,300,250,200,150,100,70,50,30,20,10,7,5,3,2,1/)
    pnew@units = "mb"

    pver       = pnew*100
    pver@units = "Pa"

;Region
    latN = 45
    latS = -20
    lonW = 30
    lonE = 180
        
    font = 0.025      ;font height of tick labels

    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "clm_diff_reg_"+season+"_ZM_heating"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)"/)

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================
    ina1 = addfile (in_path1+"EVAPTZM.daily_clim60.nc", "r")
    inb1 = addfile (in_path1+"ZMDT.daily_clim60.nc",    "r")
    inc1 = addfile (in_path1+"ZMMTT.daily_clim60.nc",   "r")
    ind1 = addfile (in_path1+"PS.daily_clim60.nc",      "r")

    ina2 = addfile (in_path2+"EVAPTZM.daily_clim80.nc", "r")
    inb2 = addfile (in_path2+"ZMDT.daily_clim80.nc",    "r")
    inc2 = addfile (in_path2+"ZMMTT.daily_clim80.nc",   "r")
    ind2 = addfile (in_path2+"PS.daily_clim80.nc",      "r")

    ine = addfile (in_path1+"hym.nc", "r")
    
    H11_p = ina1->EVAPTZM
    H12_p = ina2->EVAPTZM
    H21_p = inb1->ZMDT
    H22_p = inb2->ZMDT
    H31_p = inc1->ZMMTT
    H32_p = inc2->ZMMTT

    PS1  = ind1->PS
    PS2  = ind2->PS
    hyam = ine->hyam
    hybm = ine->hybm

    printVarSummary (H11_p)
    printVarSummary (H21_p)
    printVarSummary (H31_p)
    printVarSummary (PS1)
    printVarSummary (hyam)
    printVarSummary (hybm)

;--------------------------------------------------------------
    dp = dpres_plevel_Wrap (pver,100000,1,0)   ;caculate dp
    print (pver)
    printVarSummary (dp)

; ==============================================================
; Mission 2. post-post process data to deserved results
; ==============================================================
    
    heat1_p = H11_p
    heat2_p = H12_p
    heat1_p = H11_p + H21_p + H31_p
    heat2_p = H12_p + H22_p + H32_p
    
;interpolate to pressure levels on pressure levels
    heat1 = vinth2p (heat1_p,hyam,hybm,pnew,PS1,interp,P0mb,1,False)
    heat2 = vinth2p (heat2_p,hyam,hybm,pnew,PS2,interp,P0mb,1,False)

    copy_VarAtts (heat1_p(:,0:22,:,:),heat1)
    copy_VarAtts (heat2_p(:,0:22,:,:),heat2)

    printVarSummary (heat1)
    printVarSummary (heat2)
    
;-----------------------------------------------------------------------------
;calculate the vertical integral
    dp_cfm = conform_dims (dimsizes (heat1),dp,1)   ;conform dp to caculate sum(var*dp)
    printVarSummary (dp_cfm)

    sum_heat1 = heat1(:,0,:,:)
    sum_heat2 = heat2(:,0,:,:)
    sum_heat1 = dim_sum_n (dp_cfm*heat1,1)
    sum_heat2 = dim_sum_n (dp_cfm*heat2,1)    
    printVarSummary (sum_heat1)
    printVarSummary (sum_heat2)
    
;seasonal mean
    heat1_clm = dim_avg_n_Wrap ( sum_heat1(dayS:dayE,:,:), 0)
    heat2_clm = dim_avg_n_Wrap ( sum_heat2(dayS:dayE,:,:), 0)
    printVarSummary (heat1_clm)
    printVarSummary (heat2_clm)

    lat = heat2_clm
    lon = heat2_clm
    lat = conform (lat,doubletofloat(heat2_clm&lat),0)
    lon = conform (lon,doubletofloat(heat2_clm&lon),1)
/;
    heat2_clm = where(lat.ge.10. .and. lat.le.25. .and. lon.ge.120. .and. lon.le.140., heat2_clm*1.5, heat2_clm)
;    heat2_clm = where(lat.ge.0. .and. lat.le.10. .and. lon.ge.80. .and. lon.le.105., heat1_clm*1.1, heat2_clm)
;    heat2_clm = where(lat.ge.10. .and. lat.le.20. .and. lon.ge.80. .and. lon.le.100., heat1_clm-(heat2_clm-heat1_clm)*0.1, heat2_clm)
    heat2_clm = where(lat.ge.25. .and. lat.le.30. .and. lon.ge.110. .and. lon.le.150., heat1_clm+(heat2_clm-heat1_clm)*0.1, heat2_clm)
    heat2_clm = where(lat.ge.-10. .and. lat.le.30. .and. lon.ge.70. .and. lon.le.80., heat1_clm+(heat2_clm-heat1_clm)*0.1, heat2_clm)
;    heat2_clm = where(lat.ge.-20. .and. lat.le.-10. .and. lon.ge.80. .and. lon.le.150., heat1_clm+(heat2_clm-heat1_clm)*0.1, heat2_clm)
    heat2_clm = where(lat.ge.-10. .and. lat.le.5. .and. lon.ge.80. .and. lon.le.130., heat1_clm+(heat2_clm-heat1_clm)*0.5, heat2_clm)
    heat2_clm = where(lat.ge.-10. .and. lat.le.0. .and. lon.ge.130. .and. lon.le.150., heat1_clm+(heat2_clm-heat1_clm)*0.5, heat2_clm)
;/


;    heat2_clm = where(lat.ge.5. .and. lat.le.20. .and. lon.ge.115. .and. lon.le.140., ((1.-abs(lat-12.5)/7.5)*(1.-abs(lon-127.5)/12.5))^0.5*heat1_clm*0.65+heat1_clm, heat1_clm)
;    heat2_clm = where(lat.ge.0. .and. lat.le.10. .and. lon.ge.85. .and. lon.le.105., ((1.-abs(lat-5.)/5.)*(1.-abs(lon-100.)/15.))^0.5*heat1_clm*0.3+heat1_clm, heat2_clm)


;calculate difference
    diff = heat1_clm
    diff = heat2_clm - heat1_clm
    printVarSummary (diff)

; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

  wks  = gsn_open_wks ("svg",out_path+out_name)   ;open a eps file
  plot = new (2,graphic)

;-----------------------------------------------------------------------------
res                = True

res@gsnDraw        = False       ;don't draw
res@gsnFrame       = False       ;don't advance frame

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False       ;turn off contour line labels

res@tmXBLabelFontHeightF = font   ;font height of tick labels
res@tmYLLabelFontHeightF = font
res@tmXBTickSpacingF     = 30.    ;label spacing

;res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.24      ;move whole thing down

res@mpFillOn  = False      ;turn off gray continents
res@mpMaxLatF = latN
res@mpMinLatF = latS
res@mpMaxLonF = lonE
res@mpMinLonF = lonW
;res@mpGeophysicalLineColor      = "black";"white" 

;--------------------------------------------------------------
res@cnFillPalette = "sunshine_9lev"      ;choose a colormap

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 0.8
res@cnMaxLevelValF       = 3.2
res@cnLevelSpacingF      = .4

res@gsnLeftString   = text1(0)
res@gsnCenterString = season
plot(0) = gsn_csm_contour_map_ce(wks,heat1_clm,res)

res@cnFillPalette = "MPL_coolwarm"

res@cnMinLevelValF  = -.4
res@cnMaxLevelValF  = .4
res@cnLevelSpacingF = .1

res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(1) = gsn_csm_contour_map_ce(wks,diff,res)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.035      ;height of text
resP@txString         = "Climatology and Difference of ZM heating"   ;add common title
;resP@gsnPanelLabelBar = True       ;add common colorbar

gsn_panel(wks,plot,(/2,1/),resP)          ; create panel

end 
