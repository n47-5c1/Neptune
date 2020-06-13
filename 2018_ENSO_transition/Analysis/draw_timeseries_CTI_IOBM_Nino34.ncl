;*************************************************************
;Aim: Draw time series of the monthly cold tongue index, Indian Ocean basin mode index, and Nino 3.4 index
;
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-08-15
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================


;HadISST1   1870/01 - , 1x1
    in_name1 = "~/data/observation/SST/HadISST/HadISST_sst.nc"
;NOAA ERSST 1854/01 - , 2x2
    in_name2 = "~/data/observation/SST/NOAA_ERSST/sst.mnmean.v4.nc"

;time
    yS = 1958
    yE = 2017
    x = fspan(yS, yE, 720)

;cold tongue
    latN1 = 6
    latS1 = -6
    lonW1 = 180
    lonE1 = 270

;Indian Ocean basin mode
    latN2 = 20
    latS2 = -20
    lonW2 = 40
    lonE2 = 120

;Nino 3.4
    latN3 = 5
    latS3 = -5
    lonW3 = 190
    lonE3 = 240

;Lanczos Filter
    nWgt = 97
;the low-pass filter: ihp = 0; high-pass ihp = 1; band-pass ihp = 2
    ihp = 0
    fca = 1. / 48.
    fcb = -999.
    nsigma = 1.0
    wgt = filwgts_lanczos(nWgt, ihp, fca, fcb, nsigma)

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "timeseries_CTI_IOBM_Nino34"

;text
    text1 = yS+"-"+yE
    text2 = "~F35~J~F~C"
    text3 = (/"CT","IOBM","N34"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in = addfile (in_name1,"r")

;get the time indexs
    time  = in->time
    year  = cd_calendar (time,-1) /100
    iYYYY = ind (year.ge.yS .and. year.le.yE)

;    sst = in->sst(iYYYY,:,:)
    sst = lonFlip(in->sst(iYYYY,:,:))

;-------------------------------------------------------------
;creat weights: cos(lat)
    rad = 4.*atan(1.)/180.
    gw  = in->latitude
    gw  = cos (rad*gw)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm  = clmMonTLL(sst)
   SSTA = calcMonAnomTLL(sst, clm)
   SSTA = (/dtrend_msg_n(SSTA&time, SSTA, False, False, 0)/)

;--------------------------------------------------------------
;CT
   CT = wgt_areaave_Wrap(sst(:,{latN1:latS1},{lonW1:lonE1}), gw({latN1:latS1}), 1., 0)
   CT = wgt_runave_Wrap(CT, wgt, 0)
   CT = (/CT - avg(CT)/)
   dim = dimsizes (CT)
;IOBM
   IOBM = wgt_areaave_Wrap(SSTA(:,{latN2:latS2},{lonW2:lonE2}), gw({latN2:latS2}), 1., 0)
;N34
   N34 = wgt_areaave_Wrap(SSTA(:,{latN3:latS3},{lonW3:lonE3}), gw({latN3:latS3}), 1., 0)

   printVarSummary(CT)

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

data = new((/3,dim/), typeof(CT))
data(0,:) = (/CT/)
data(1,:) = (/IOBM/)
data(2,:) = (/N34/)
copy_VarAtts (CT,data)
printVarSummary (data)

wks = gsn_open_wks("svg", out_path + out_name)
;plot = new(2, graphic)        

res = True

;res@gsnFrame = False
res@gsnYRefLine = .0
res@gsnCenterString = text1
res@gsnRightString = text2
res@gsnStringFontHeightF = 0.021
;res@gsnYRefLineColor = "black"
;res@gsnYRefLineThicknessF = 2
;res@gsnYRefLineDashPattern = 1

;res@tiYAxisString = text4(0)
;res@tiXAxisFontHeightF = 0.021
;res@tiYAxisFontHeightF = 0.021

res@tmXBLabelFontHeightF = 0.02
res@tmYLLabelFontHeightF = 0.02

;res@trYMinF = 0
;res@trYMaxF = 15

res@txString = "Time series"
res@txFontHeightF = 0.028

res@vpHeightF = 0.25

res@xyLineColors = (/"blue","black","orangered"/)
res@xyDashPattern = 0
res@xyLineThicknessF = 2.

plot = gsn_csm_xy(wks, x, data, res)

end
