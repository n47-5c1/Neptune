;*************************************************************
;Aim: Output and draw the climatology of global SST and sea ice in certain period
;Mission:
;
;   1. Read data from SST and sea ice datasets
;   2. Post-post process to deserved results
;   3. Output and draw the SST and sea ice
;                       He Shan
;                       2015-08-28
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1---------------ice_cov
;   var2---------------ice_cov_prediddle
;   var3---------------SST_cpl
;   var4---------------SST_cpl_prediddle
;================================================

    year1 = 1979
    year2 = 2016

;datas
    path = "~/hes/input/SST/"
    in_name = "sst_HadOIBl_bc_1.9x2.5_1850_2017_c180507.nc"
    out_name = "g_"+year1+"_"+year2+"_clim_SST_ice"

;time
    yEl = (/1982,1987,1991,1997,2015/)
    yLa = (/1988,1998,1999,2007,2010/)
    ny1 = dimsizes(yEl)
    ny2 = dimsizes(yLa)

;Map
    latN = 60
    latS = -60
    lonL = 30
    lonR = 300

;text
    text1 = (/"a) SON(0)","b)","c) DJF(0)","d)","e)MAM(+1)","f)","g)JJA(+1)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in_file = addfile(path + in_name, "r")

    time = in_file->time
;get the time indexs
    TIME = cd_calendar(time, 0)
    year0 = toint(TIME(:,0))
    iYYYY = ind(year0.ge.year1 .and. year0.le.year2)

    year = year0(iYYYY)

    El = year.eq.yEl(0)
    do i = 1, ny1 - 1
     El = El .or. year.eq.yEl(i)
    end do

    La = year.eq.yLa(0)
    do i = 1, ny2 - 1
     La = La .or. year.eq.yLa(i)
    end do

    iEl = ind(El)
    iLa = ind(La)

    SST = in_file->SST_cpl(iYYYY,:,:)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute monthly climatologies
    SST_clm = clmMonTLL(SST)

    SST1 = clmMonTLL(SST(iEl,:,:))
    SST2 = clmMonTLL(SST(iEl+12,:,:))
    SST3 = clmMonTLL(SST(iLa,:,:))
    SST4 = clmMonTLL(SST(iLa+12,:,:))

;Monthly anomalies
    Anom1 = calcMonAnomTLL(SST1, SST_clm)
    Anom2 = calcMonAnomTLL(SST2, SST_clm)
    Anom3 = calcMonAnomTLL(SST3, SST_clm)
    Anom4 = calcMonAnomTLL(SST4, SST_clm)
    dim = dimsizes(Anom1)

;---------------------------------------------------------------
    AnomEl = new((/24,dim(1),dim(2)/), float)
    AnomLa = new((/24,dim(1),dim(2)/), float)
    AnomEl(:11,:,:) = Anom1
    AnomEl(12:,:,:) = Anom2
    AnomLa(:11,:,:) = Anom3
    AnomLa(12:,:,:) = Anom4
    copy_VarMeta(Anom1, AnomEl(:11,:,:))
    copy_VarMeta(Anom1, AnomLa(:11,:,:))

    printVarSummary(AnomEl)

; ==============================================================
; Mission 3. Draw the SST
; ==============================================================

wks = gsn_open_wks("svg", path + out_name)
plot = new(8, graphic)

;---------------------------------------------------------------
;plot climatology
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-.8,-.4,-.2,.2,.4,.8/)

res@lbLabelBarOn = False

res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonL
res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

do i = 0, 7
    res@gsnLeftString = text1(i)
    plot(i) = gsn_csm_contour_map_ce(wks, AnomEl(i*3,:,:), res)
end do

;*******************************************
;create panel resources
;*******************************************
resP = True
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008

resP@txString = " "
gsn_panel(wks, plot, (/4,2/), resP)

end
