;*************************************************************
;Aim: Draw climatology of the global monthly sea surface height in C_NORMAL_YEAR and in observation
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-11-24
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var1--------------SSH
;   var2--------------ssh
;================================================


    in_name1 = "~/data/observation/SODA/2.2.4/soda2.2.4_mn_ocean_reg_ssh_1958-2008.nc"
    in_name2 = "~/data/model/hes/C_NORMAL_YEAR_1958-2009_T62g16_spin-up/C_NORMAL_YEAR_1958-2009_T62g16_spin-up.pop.h.SSH.001-150.nc"

;time
    yS = 121
    yE = 150

;map
    latN = 60
    latS = -60
    lonW = 180
    lonE = 270
/;
;Set up options for regridding
    Opt = True

    Opt@SrcTitle = "POP Grid"
;    Opt@SrcRegional = True
    Opt@SrcFileName = "POP_gx1v6_SCRIP.nc"
    Opt@WgtFileName = "gx1v6_2_T62.nc"

;    Opt@DstRegional = True
    Opt@DstGridLat = latGau(94, "lat", "latitude", "degrees_north")
    Opt@DstGridLon = lonGlobeF(192, "lon", "longitude", "degrees_east")
    Opt@DstFileName = "T62_SCRIP.nc"

    Opt@InterpMethod   = "bilinear"
;    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True
;/
;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "clm_g_SSH_C"

;text
    text1 = (/"a) SODA","b) POP"/)
    text2 = (/"58-08","58-09"/)
    text3 = "cm"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_name1, "r")
    in2 = addfile(in_name2, "r")

;get the time indexs
    time = in2->time
    YYYY = cd_calendar(time, -1) / 100
    iYYYY = ind(YYYY.ge.yS .and. YYYY.le.yE)

    ssh = in1->ssh
    ssh = (/100 * ssh/)
    SSH = in2->SSH(iYYYY,:,:)
    SSH@lat2d = in2->TLAT
    SSH@lon2d = in2->TLONG

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Calculate climatology
   clm1 = dim_avg_n_Wrap(ssh, 0)
   clm2 = dim_avg_n_Wrap(SSH, 0)

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)
plot = new(2, graphic)

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnStringFontHeightF = 0.021

res@cnFillOn = True
res@cnFillPalette = "MPL_coolwarm"
res@cnLinesOn = False
res@cnLineLabelsOn = False
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels = (/-120,-90,-60,-30,0,30,60,90,120/)

res@lbLabelBarOn = False

res@mpFillOn = True
res@mpCenterLonF = 160.
;map outlines
;res@mpMinLatF = latS
;res@mpMaxLatF = latN
;res@mpMinLonF = lonL
;res@mpMaxLonF = lonR

res@tmXBLabelFontHeightF = .02
res@tmYLLabelFontHeightF = .02
res@tmXBTickSpacingF = 45.

res@gsnLeftString = text1(0)
res@gsnCenterString = text2(0)
res@gsnRightString = text3
plot(0) = gsn_csm_contour_map_ce(wks, clm1, res)

res@gsnLeftString = text1(1)
res@gsnCenterString = text2(1)
res@gsnRightString = " "
plot(1) = gsn_csm_contour_map_ce(wks, clm2, res)

;*******************************************
;create panel resources
;*******************************************
resP = True
;resP@txString = text3
resP@gsnPanelBottom = 0.06
resP@gsnPanelLabelBar = True
resP@lbLabelFontHeightF = 0.014
resP@pmLabelBarOrthogonalPosF = -0.008

gsn_panel(wks, plot, (/2,1/), resP)

end
