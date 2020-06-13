;*************************************************************
;Aim: Draw the difference of regional JJA precipitation in model
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
;	var1--------------PRECC
;	var2--------------PRECL
;================================================

;datas
    in_path1 = "~/data/model/CESM_CTRL/FC5PM_F19_1960_1969_SSTice_daily/"
    in_path2 = "~/data/model/CESM_CTRL/FC5PM_F19_1980_1989_SSTice_daily/"
    in_path3 = "~/data/model/hes/FC5PM_F19_Asia-Pacific_JJAS_1980_1989_ZM_heat_1960_1969_SSTice/"
;    in_path3 = "~/data/model/hes/FC5PM_F19_Asia-Pacific_JJAS_increased_ZM_heat_1960_1969_SSTice/"

    in_name1 = "PRECC.mon.nc"
    in_name2 = "PRECL.mon.nc"

    unit = 1000*60*60*24   ;m/s -> mm/day

    yS     = 2
    yE     = 13
    season = "JJA"

;Region
    latN = 45
;    latN = 40
    latS = -20
    lonW = -30
;    lonE = 180
;    lonW = 50
    lonE = 170
        
    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "diff_reg_"+season+"_PREC_CESM"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)"/)

; ==============================================================
; Mission 1. Open the file: Read only the user specified period
; ==============================================================
    ina1 = addfile (in_path1+in_name1,"r")
    inb1 = addfile (in_path1+in_name2,"r")

    ina2 = addfile (in_path2+in_name1,"r")
    inb2 = addfile (in_path2+in_name2,"r")

    ina3 = addfile (in_path3+in_name1,"r")
    inb3 = addfile (in_path3+in_name2,"r")

    P1  = ina1->PRECC
    P2  = ina2->PRECC
    P3  = ina3->PRECC
    P12 = inb1->PRECL
    P22 = inb2->PRECL
    P32 = inb3->PRECL

    P1 = unit*(P1+P12)
    P2 = unit*(P2+P22)
    P3 = unit*(P3+P32)

    P1@units = "mm/day"
    P2@units = "mm/day"
    P3@units = "mm/day"

    printVarSummary (P1)
    printVarSummary (P2)
    printVarSummary (P3)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time = ina1->time
    TIME = cd_calendar (time, 0)
    year = toint ( TIME(:,0) )
    printVarSummary (year)

;get the time indexs
    iYYYY = ind (year.ge.yS .and. year.le.yE)
    printVarSummary (iYYYY)

; ==============================================================
; Mission 2. post-post process data to deserved results
; ==============================================================

;seasonal mean
    P1_season = dim_avg_n_Wrap ( month_to_season(P1(iYYYY,:,:),season), 0)
    P2_season = dim_avg_n_Wrap ( month_to_season(P2(iYYYY,:,:),season), 0)
    P3_season = dim_avg_n_Wrap ( month_to_season(P3(iYYYY,:,:),season), 0)
    printVarSummary (P1_season)
    printVarSummary (P2_season)
    printVarSummary (P3_season)

/;
    lat = P2_season
    lon = P2_season
    lat = conform (lat,doubletofloat(P2&lat),0)
    lon = conform (lon,doubletofloat(P2&lon),1)

    P2_season = where(lat.ge.10. .and. lat.le.25. .and. lon.ge.120. .and. lon.le.140., P2_season*1.3, P2_season)
;    P2_season = where(lat.ge.0. .and. lat.le.10. .and. lon.ge.80. .and. lon.le.105., P1_season*1.2, P2_season)
;    P2_season = where(lat.ge.10. .and. lat.le.20. .and. lon.ge.80. .and. lon.le.100., P1_season-(P2_season-P1_season)*0.2, P2_season)
    P2_season = where(lat.ge.25. .and. lat.le.30. .and. lon.ge.110. .and. lon.le.150., P1_season+(P2_season-P1_season)*0.2, P2_season)
    P2_season = where(lat.ge.-10. .and. lat.le.30. .and. lon.ge.40. .and. lon.le.80., P1_season+(P2_season-P1_season)*0.2, P2_season)
    P2_season = where(lat.ge.-20. .and. lat.le.-10. .and. lon.ge.40. .and. lon.le.150., P1_season+(P2_season-P1_season)*0.2, P2_season)
    P2_season = where(lat.ge.-10. .and. lat.le.5. .and. lon.ge.80. .and. lon.le.130., P1_season+(P2_season-P1_season)*0.5, P2_season)
    P2_season = where(lat.ge.-10. .and. lat.le.0. .and. lon.ge.130. .and. lon.le.150., P1_season+(P2_season-P1_season)*0.5, P2_season)
;/

;calculate difference
    diff1 = P2_season - P1_season
    diff2 = P3_season - P1_season
    copy_VarMeta (P1_season, diff1)
    copy_VarMeta (P1_season, diff2)
    printVarSummary (diff1)

; ==============================================================
; Mission 3. Set plot parameters and plot
; ==============================================================

  wks  = gsn_open_wks ("svg",out_path+out_name)   ;open a eps file
  plot = new (2,graphic)

;-----------------------------------------------------------------------------
res                = True

;res@gsnDraw        = False       ;don't draw
;res@gsnFrame       = False       ;don't advance frame

res@cnFillOn             = True
res@cnLinesOn            = False
res@cnLineLabelsOn       = False
res@cnFillPalette        = "MPL_RdBu"   ;choose a colormap
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -2.4
res@cnMaxLevelValF       = 2.4
res@cnLevelSpacingF      = .8
res@pmLabelBarOrthogonalPosF = 0.18   ;move whole thing down

res@tmXBLabelFontHeightF = .025   ;font height of tick labels
res@tmYLLabelFontHeightF = .025
;res@tmXBLabelFontHeightF = .02   ;font height of tick labels
;res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF     = 30.   ;label spacing

;res@lbLabelBarOn = False

res@mpFillOn  = False      ;turn off gray continents
res@mpMaxLatF = latN
res@mpMinLatF = latS
res@mpMaxLonF = lonE
res@mpMinLonF = lonW
;res@mpGeophysicalLineColor      = "black";"white" 

;--------------------------------------------------------------
res@gsnLeftString   = text1(0)
res@gsnCenterString = season
plot(0) = gsn_csm_contour_map_ce(wks,diff1,res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
;plot(1) = gsn_csm_contour_map_ce(wks,diff2,res)

;*******************************************
;create panel resources
;*******************************************
resP                  = True
resP@txFontHeightF    = 0.028            ;height of text
resP@txString         = "Difference of precipitation"
resP@gsnPanelLabelBar = True             ;add common colorbar
resP@pmLabelBarOrthogonalPosF = -0.018   ;move whole thing down

;gsn_panel(wks,plot,(/2,1/),resP)

end 
