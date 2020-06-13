;*************************************************************
;Aim: draw bars of the number of transitional and non-transitional EP/CP El Nino
;Mission:
;
;   1. Set data
;   2. Draw the bars
;                       Shan He
;                       2018-11-13
;
;*************************************************************

begin

;fig
    out_path = "~/hes/ENSO/Termination/Fig/"
    out_name = "bar_number_tran_EP_CP_ElNino"

    colors = (/"red","blue"/)

    text1 = (/"EP","CP"/)
    text2 = (/"Transitional","Non-transitional"/)
    text3 = (/"75","25","38","62"/)
    dim = dimsizes(text1)
    y = ispan(1,dim,1)
    xt = (/.75,6.75,.75,5.75/)
    yt = (/2,2,1,1/)

; ==============================================================
; Mission 1. Set the user specified data
; ==============================================================

    x = (/6,2+6,5,8+5/)

; ==============================================================
; Mission 3. Draw the timeseries
; ==============================================================

wks = gsn_open_wks("svg", out_path + out_name)

res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnXYBarChart = True
res@gsnXRefLine = 0
res@gsnXYBarChartBarWidth = 0.60

res@vpWidthF = 0.75
res@vpHeightF = 0.25

res@trXMinF = 0.0
res@trXMaxF = 14.
res@trYMinF = 0
res@trYMaxF = dim + 1

res@tiMainString = "The number of the Events"
res@tiMainFontHeightF = 0.028

res@tmYLMode = "Explicit"
res@tmYLValues = y
res@tmYLLabels = text1(::-1)
res@tmYLLabelFontHeightF = 0.021
res@tmXBLabelFontHeightF = 0.02
res@tmYLMajorLengthF = 0.
res@tmYLMajorOutwardLengthF = 0.
res@tmXTOn = False
res@tmXBMinorOn = False
res@tmXBMajorLengthF = 0.01
res@tmXBMajorOutwardLengthF = 0.01

base_plot = gsn_csm_xy(wks, x(1::-2), y, res)
delete([/res@tiMainString/])

res@gsnXYBarChartColors = colors(0)
plot1 = gsn_csm_xy(wks, x(0::-2), y, res)

res@gsnXYBarChartColors = colors(1)
plot2 = gsn_csm_xy(wks, x(1::-2), y, res)

overlay(base_plot, plot2)
overlay(base_plot, plot1)

;----------------------------------------------------------
; add labelbar to plot

nboxes =dimsizes(colors)

getvalues base_plot
    "vpXF"      : vpx
    "vpYF"      : vpy
    "vpHeightF" : vph
    "vpWidthF"  : vpw
end getvalues

lbres = True
lbres@vpWidthF = 0.16 * vpw
lbres@vpHeightF = 0.26 * vph

;lbres@lbPerimOn = True
lbres@lbBoxMajorExtentF = 0.8
lbres@lbFillColors = colors(::-1)
lbres@lbMonoFillPattern = True
lbres@lbLabelFontHeightF = 0.016
lbres@lbJustification = "TopLeft"
lbres@lbLabelJust = "CenterLeft"
                                    
gsn_labelbar_ndc(wks, nboxes, text2(::-1), 0.72, 0.78, lbres)

;Add some text to indicate the values
txres = True
txres@txFontColor = "white"
txres@txFontHeightF = 0.025
;txres@txPerimOn = True
;txres@txBackgroundFillColor = "white"

id = gsn_add_text(wks, base_plot, "~F22~"+text3+"%", xt, yt, txres)

;----------------------------------------------------------
draw(base_plot)
frame(wks)

end
