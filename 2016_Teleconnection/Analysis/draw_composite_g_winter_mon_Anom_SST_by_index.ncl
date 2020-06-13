;*************************************************************
;Aim: Draw composites of global sea surface temperature chosen by teleconnection index in the winter-half year
;Mission:
;
;   1. Read data from INDEX and sst datasets
;   2. Post-post process to deserved results
;   3. Draw the composites
;                       He Shan
;                       2017-02-27
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------INDEX
;   var2--------------sst
;================================================

;data
    in_path = "~/data/observation/SST/HadISST_sst_1870-2016.nc"

;time
    yS = 1979
    yE = 2015

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "comp_reg_winter_mon_Anom_SST_by_index"

;Map
    latN = 60
    latS = -30
    lonL = -80
    lonR = 170

;text
    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f        = addfile ("./PC_Index.nc", "r")
    SST_file = addfile (in_path,"r")

    index = f->INDEX
    SST_p = SST_file->sst
    time  = SST_file->time
    printVarSummary (index)
    printVarSummary (SST_p)

;----------------------------------------------------------
;get the time indexs
    TIME  = cd_calendar (time, 0)
    year1 = toint ( TIME(:,0) )
    iYYYY = ind (year1.ge.yS .and. year1.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    SST = SST_p(iYYYY,:,:)
    printVarSummary (SST)

;Calculate monthly means
    index_mon_p = calculate_monthly_values (index,"avg",0,False)
    index_mon   = conform_dims ((/dimsizes(index_mon_p),1,1/),index_mon_p,0)
    index_mon   = index_mon_p
    index_mon!1 = "lat"
    index_mon!2 = "lon"
    printVarSummary (index_mon)

;Monthly anomalies
    index_Clm  = clmMonTLL (index_mon)
    SST_Clm    = clmMonTLL (SST)
    index_Anom = calcMonAnomTLL (index_mon, index_Clm)
    SST_Anom   = calcMonAnomTLL (SST, SST_Clm)
    printVarSummary(index_Anom)
    printVarSummary(SST_Anom)

;----------------------------------------------------------
;Composite Analysis
    iMMp = ind(index_Anom(:,0,0).ge.2.3)
    iMMn = ind(index_Anom(:,0,0).le.-1.9)

    SSTp = dim_avg_n_Wrap (SST_Anom(iMMp,:,:),0)
    SSTn = dim_avg_n_Wrap (SST_Anom(iMMn,:,:),0)
    diff = SSTp
    diff = SSTp-SSTn
    printVarSummary(diff)

    YYYY   = cd_calendar (index_mon&time,0)
    year2  = toint (YYYY(:,0))
    month2 = toint (YYYY(:,1))
    yyyymm = year2*100+month2

    print(yyyymm(iMMp))
    print(yyyymm(iMMn))

; ==============================================================
; Mission 3. Draw the phase
; ==============================================================

 wks  = gsn_open_wks ("eps",out_path+out_name)   ; open a eps file
; plot = new(5,graphic)                          ;creat a plot array

;-----------------------------------------------------------------------------
res = True

;res@gsnDraw         = False      ;do not draw
;res@gsnFrame        = False      ;do not advance frame
res@gsnLeftString   = text1(0)
res@gsnCenterString = "Monthly Anom SST"

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnFillPalette  = "MPL_coolwarm"   ;choose a colormap
res@cnLineLabelsOn = False            ;turn off cn line labels

res@mpFillOn               = False      ;turn off map fill
res@mpCenterLonF           = -150.      ;get the correct map
;res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
;res@mpMinLonF              = lonL
;res@mpMaxLonF              = lonR

;res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.16   ;move Label Bar down

res@tmXBLabelFontHeightF = 0.012   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.012

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -.5      ;set min contour level
res@cnMaxLevelValF       = .5       ;set max contour level
res@cnLevelSpacingF      = 0.1      ;set contour spacing

plot = gsn_csm_contour_map_ce (wks,diff,res)

;*******************************************
;create panel resources
;*******************************************
;resP                    = True
;resP@txString           = "Spectrum of Teleconnection Index"   ;add common title
;resP@lbLabelFontHeightF = 0.015

;gsn_panel(wks,plot,(/2,2/),resP)

end
