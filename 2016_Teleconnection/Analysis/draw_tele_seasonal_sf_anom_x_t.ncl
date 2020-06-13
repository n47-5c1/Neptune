;*************************************************************
;Aim: Draw seasonal teleconnectivity of daily anomalous stream function deviations from zonal mean
;Mission:
;
;   1. Read data from teleconnectivity datasets
;   2. Post-post process to deserved results
;   3. Draw the teleconnectivity
;                       He Shan
;                       2016-07-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------tele
;	var2--------------uwnd
;================================================

;time
    yS     = 1979
    yE     = 2015
    season = (/"MAM","JJA","SON","DJF"/)

;datas
    in_path1 = "~/hes/One_Belt_One_Road/NCL/"
    in_path2 = "~/data/observation/NCEP_NCAR/monthly/"
    in_name1 = "tele_"+season+"_sf_anom_x_t_10_30_BP.nc "      ;<<<<<<change>>>>>>
    in_name2 = "uwnd.mon.mean.nc"
;    in_name = "tele_"+season+"_sf.nc "

;Region
    latN = 75
    latS = 0
;    lonL = -60
;    lonR = 180

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "tele_seasonal_sf_anom_x_t_10_30_BP"      ;<<<<<<change>>>>>>
;    out_name = "tele_seasonal_BP_sf"

    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
    tele_files  = systemfunc("ls " + in_path1 + in_name1(0) + in_path1 + in_name1(1) + in_path1 + in_name1(2) + in_path1 + in_name1(3))
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    tele_in     = addfiles (tele_files, "r")     ;note the "s" of addfile
    ListSetType (tele_in, "join")   ;concatenate or joined

    tele_p      = tele_in[:]->tele(:,{latN:latS},:)
    tele        = tele_p
    tele(0,:,:) = tele_p(2,:,:)
    tele(1,:,:) = tele_p(1,:,:)
    tele(2,:,:) = tele_p(3,:,:)
    tele(3,:,:) = tele_p(0,:,:)
    tele        = -100.*tele

    print (tele_files)
    printVarSummary (tele)

;---------------------------------------------------------------
;NCEP/NCAR Reanalysis
    U_file = addfile (in_path2 + in_name2, "r")
;get the time indexs
    TIME   = U_file->time
    YYYY  = cd_calendar (TIME,-1)/100
    iYYYY = ind (YYYY.ge.yS .and. YYYY.le.yE)

;    U      = U_file->uwnd(:,2,:,:)      ;850hPa
;    U      = U_file->uwnd(:,5,:,:)      ;500hPa
    U      = U_file->uwnd(iYYYY,8,:,:)      ;250hPa

    printVarSummary (U)
    printVarSummary (TIME)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;compute seasonal means
   U_season = month_to_seasonN(U, season)
   printVarSummary(U_season)

;compute seasonal climatologies
   U_clm = dim_avg_n_Wrap(U_season,1)
   printVarSummary(U_clm)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks = gsn_open_wks("svg", out_path + out_name)
 plot = new(4, graphic)
 plot2 = new(4, graphic)
 gsn_define_colormap(wks, "gsltod")

;-----------------------------------------------------------------------------
res = True

res@gsnDraw  = False      ;don't draw
res@gsnFrame = False      ;don't advance frame
;res@gsnPolar = "NH"       ;specify the hemisphere
;res@gsnPolarLabelFontHeightF = .025

res@mpFillOn       = False      ;turn off map fill
res@mpCenterLonF   = 60.        ;get the correct map
res@mpMinLatF      = latS
res@mpMaxLatF      = latN
;res@mpMinLonF      = lonLm
;res@mpMaxLonF      = lonRm

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False      ;turn off cn line labels

res@tmXBLabelFontHeightF = .016   ;font height of tick labels
res@tmYLLabelFontHeightF = .016
res@tmXBTickSpacingF     = 60.    ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 38
res@cnMaxLevelValF       = 58
res@cnLevelSpacingF      = 5

res@lbLabelBarOn = False

do i=0,3
 res@gsnLeftString  = text1(i)
 res@gsnRightString = season(i)
 if (i.eq.3) then
  res@tmXBLabelsOn = True    ;draw lon labels
 else
  res@tmXBLabelsOn = False   ;do not draw lon labels
 end if
 if (i.eq.0) then
  res@gsnCenterString = "250 hPa"
 else
  res@gsnCenterString = " "
 end if
 plot(i) = gsn_csm_contour_map (wks,tele(i,:,:),res)
end do

;---------------------------------------------------------------
;plot climatologies
res2 = True

res2@gsnDraw = False
res2@gsnFrame = False
res2@gsnAddCyclic = True
res2@gsnLeftString = " "
res2@gsnCenterString = " "
res2@gsnRightString = " "
res2@gsnContourLineThicknessesScale = 1.8

res2@cnLevelSelectionMode = "ExplicitLevels"
res2@cnLevels = (/20,35,50/)
res2@cnLineColor = "red"
res2@cnLabelDrawOrder = "PostDraw"
res2@cnLineLabelInterval = 1
res2@cnLineLabelFontColor = "red"
res2@cnLineLabelFontHeightF = 0.011
res2@cnLineLabelPlacementMode = "Computed"
res2@cnInfoLabelFontHeightF = 0.012
res2@cnInfoLabelOrthogonalPosF = 0.32

do i = 0, 3
    if(i .eq. 3)then
        res2@cnInfoLabelOn = True
    else
        res2@cnInfoLabelOn = False
    end if
    plot2(i) = gsn_csm_contour (wks,U_clm(i,:,:),res2)
    overlay (plot(i),plot2(i))
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Teleconnectivity of 10-30 day BPF daily Stream Function"   ;<<<<<<change>>>>>>
;resP@txString                 = "Teleconnectivity of seasonal 250 hPa Stream Function"
resP@txFontHeightF            = 0.023
resP@gsnPanelBottom           = 0.08
resP@gsnPanelLabelBar         = True      ;add common colorbar
;resP@lbLabelFontHeightF       = 0.015
resP@pmLabelBarOrthogonalPosF = -0.013

gsn_panel(wks,plot,(/4,1/),resP)

end
