;*************************************************************
;Aim: Draw the EOF of Pacific wind anomalies
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. Draw the EOF
;                       Shan He
;                       2018-11-14
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var1--------------vwnd
;================================================

;data
    in_path = "~/data/observation/"
    in_name1 = "NCEP_NCAR/monthly/uwnd.surf.mon.mean.nc"
    in_name2 = "NCEP_NCAR/monthly/vwnd.surf.mon.mean.nc"

;time
    yS = 1958
    yE = 2017

;EOF
    latN = 20
    latS = -20
    lonW = 100
    lonE = 260

    neof = 3
    optEOF = False
    optETS = False

;outcome
    out_path  = "~/hes/ENSO/Termination/Fig/"
    out_name = "EOF_Pac_UV_anom"
    out_data  = "~/hes/ENSO/Termination/NCL/EOF_ts_Pac_UV_anom.nc"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile(in_path + in_name1, "r")
    in2 = addfile(in_path + in_name2, "r")
    time = in1->time

;get the time indexs
    year = cd_calendar(time,-1) / 100
    iYYYY = ind(year.ge.yS .and. year.le.yE)

;-------------------------------------------------------------
;    sst_p = lonFlip(in->sst)
    uwnd = in1->uwnd(iYYYY,{latN:latS},{lonW:lonE})
    vwnd = in2->vwnd(iYYYY,{latN:latS},{lonW:lonE})

;-------------------------------------------------------------
;creat weights: sqrt(cos(lat))
    rad = 4. * atan(1.) / 180.
;    clat = in->latitude({latN:latS})
    clat = in1->lat({latN:latS})
    clat = sqrt(cos(rad * clat))

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm1 = clmMonTLL(uwnd)
   clm2 = clmMonTLL(vwnd)
   UA = calcMonAnomTLL(uwnd, clm1)
   VA = calcMonAnomTLL(vwnd, clm2)

;-------------------------------------------------------------
;EOF
    wUA = UA * conform(UA, clat, 1)
    wVA = VA * conform(VA, clat, 1)
    copy_VarMeta(UA, wUA)
    copy_VarMeta(VA, wVA)

    x1 = wUA(lat|:,lon|:,time|:)
    x2 = wVA(lat|:,lon|:,time|:)

    x_p1 = (/x1,x2/)
    copy_VarMeta(x1, x_p1(0,:,:,:))
    x_p1!0 = "var"
    x_p2 = month_to_season(x_p1(time|:,var|:,lat|:,lon|:), "DJF")
    x = x_p2(var|:,lat|:,lon|:,time|:)

    eof = eofunc_Wrap(x, neof, optEOF)
    eof(0,:,:,:) = (/-eof(0,:,:,:)/)
    eof_ts = eofunc_ts_Wrap(x, eof, optETS)
    printVarSummary(eof)

;normalize time series
    eof_ts = (/dim_standardize_n(eof_ts, 0, 1)/)
    dim = dimsizes(eof_ts)

;North significance test
    sig_pcv = eofunc_north(eof@pcvar, dim(1), True)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
system("rm -f " + out_data)
fout = addfile(out_data, "c")
setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"evn","time"/)  
dimSizes = dim
dimUnlim = (/False,False/)

filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef(fout, "evn", "integer", "evn")
filevardef(fout, "time", typeof(time), "time")
filevardef(fout, "eof_ts", typeof(eof_ts), getvardims(eof_ts))

;Copy attributes associated with each variable to the file
;filevarattdef(fout, "env", env)
filevarattdef(fout, "time", time(iYYYY))
filevarattdef(fout, "eof_ts", eof_ts)

;output only the data values
fout->evn = (/eof_ts&evn/)
fout->time = (/eof_ts&time/)
fout->eof_ts = (/eof_ts/)

; ==============================================================
; Mission 4. Draw the EOF
; ==============================================================

 wks  = gsn_open_wks("svg", out_path + out_name)
 plot = new(neof * 2, graphic)

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw = False
res@gsnFrame = False
res@gsnAddCyclic = False
res@gsnRightString = " "
res@gsnStringFontHeightF = 0.023

;res@mpFillOn = False
;res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF = latS
res@mpMaxLatF = latN
res@mpMinLonF = lonW
res@mpMaxLonF = lonE

res@tmXBTickSpacingF = 45.
res@tmXBLabelFontHeightF = 0.022
res@tmYLLabelFontHeightF = 0.022

res@vcGlyphStyle = "CurlyVector"
res@vcRefAnnoOn = False
res@vcRefLengthF = 0.07
res@vcRefMagnitudeF = 0.15
res@vcRefAnnoOrthogonalPosF = -0.4
res@vcMinDistanceF = 0.02
res@vcLineArrowThicknessF = 1.2
res@vcLineArrowHeadMaxSizeF = 0.012
res@vcLineArrowHeadMinSizeF = 0.006

do i=0,neof-1
    if(i .eq. neof-1)then
        res@vcRefAnnoOn = True
    end if
    res@gsnLeftString = text1(2 * i)
    res@gsnCenterString = "EOF " + (i + 1)
    res@gsnRightString = sprintf("%5.1f", eof@pcvar(i)) + "%"
    plot(2*i) = gsn_csm_vector_map_ce(wks, eof(i,0,:,:), eof(i,1,:,:), res)
end do

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw = False
rts@gsnFrame = False
rts@gsnYRefLine = 0.
rts@gsnStringFontHeightF = 0.023

rts@tiYAxisString = " "

rts@tmXBLabelFontHeightF = 0.022
rts@tmYLLabelFontHeightF = 0.018

rts@vpWidthF = 0.75
rts@vpHeightF = 0.19

do i=0,neof-1
    rts@gsnLeftString = text1(2 * i + 1)
    rts@gsnCenterString = "PC " + (i + 1)
    plot(2*i+1) = gsn_csm_xy(wks, fspan(yS, yE+1, yE+1-yS), eof_ts(i,:), rts)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "EOFs of Surface Wind Anomalies"

gsn_panel(wks,plot,(/neof,2/),resP)

end
