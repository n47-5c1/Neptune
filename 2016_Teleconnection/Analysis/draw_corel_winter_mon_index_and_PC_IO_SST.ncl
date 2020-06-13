;*************************************************************
;Aim: Draw sample correlation between monthly teleconnection index and PCs of the Indian ocean SST in the winter half year
;Mission:
;
;   1. Read data from daily INDEX & sst datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2017-02-10
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------INDEX
;	var2--------------sst
;================================================

;datas
    in_path1 = "~/hes/One_Belt_One_Road/NCL/PC_Index.nc"
    in_path2 = "~/data/observation/SST/HadISST_sst_1870-2016.nc"

;time
    yS = 1979
    yE = 2015
    mS = 11
    mE = 4

;Region
    latN = 30
    latS = -10
    lonL = 30
    lonR = 120

;EOF
    neof        = 3      ;number of EOFs
    optEOF      = False
;    optEOF      = True
;    optEOF@jopt = 1      ;*only* if the correlation EOF is desired
    optETS      = False
;    optETS      = True
;    optETS@jopt = 1      ;*only* if the standardized ETF is desired

;data
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "corel_winter_mon_index_and_PC_IO_SST"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)","i)"/)
;    text2 = (/"-7","","-3","0","+3","+6"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    index_in = addfile (in_path1, "r")
    SST_in   = addfile (in_path2, "r")

    index = index_in->INDEX
    SST   = SST_in->sst
    printVarSummary (index)
    printVarSummary (SST)

;---------------------------------------------------------------
;get the time indexs
    time1  = index_in->time
    TIME1  = cd_calendar (time1, 0)
    day1   = toint ( TIME1(:,2) )
    iDD1   = ind (day1.eq.1)
    TIME11 = cd_calendar (time1(iDD1), 0)
    month1 = toint ( TIME11(:,1) )
    iMM1   = ind (month1.ge.mS .or. month1.le.mE)

    time2  = SST_in->time
    TIME2  = cd_calendar (time2, 0)
    year2  = toint ( TIME2(:,0) )
    month2 = toint ( TIME2(:,1) )
    iMM2   = ind (year2.ge.yS .and. year2.le.yE .and. (month2.ge.mS .or. month2.le.mE))

    printVarSummary (iMM1)
    printVarSummary (iMM2)

;creat weights: sqrt(cos(lat))
    rad  = 4.*atan(1.)/180.
    clat = SST_in->latitude({latS:latN})
    clat = sqrt(cos(rad*clat))
    printVarSummary(clat)

; create the filter weights
;    nwt    = 29
;    fca    = 1./14.
;    fcb    = 1./999.
;    ihp    = 0
;    nsigma = 1.
;    wts    = filwgts_lanczos (nwt, ihp, fca, fcb, nsigma)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;Filter
;    index_BP = wgt_runave_Wrap (index,wts,0)

;Calculate monthly means
    index_mon = calculate_monthly_values (index,"avg",0,False)
;    index_mon = calculate_monthly_values (index_BP,"avg",0,False)
    printVarSummary (index_mon)

;EOF
    x           = SST({latitude|latS:latN},{longitude|lonL:lonR},time|:)
    x           = x*conform (x,clat,0)
    x@long_name = "Wgt: "+x@long_name

    eof    = eofunc_Wrap (x,neof,optEOF)
    eof_ts = eofunc_ts (x,eof,optETS)
    printVarSummary (eof)

;normalize time series: sum spatial weights over the area of used
    dimx   = dimsizes (x)
    sumWgt = dimx(0)*sum(clat)
    eof_ts = eof_ts/sumWgt
    printVarSummary (eof_ts)

    index_r  = index_mon(iMM1)
    eof_ts_r = eof_ts(:,iMM2)
    printVarSummary (index_r)
    printVarSummary (eof_ts_r)

;---------------------------------------------------------------
;compute cross correlation
    r = escorc (index_r,eof_ts_r)
    copy_VarCoords_1 (eof_ts_r,r)   ;copy coordinate variable

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

   printVarSummary (r)
;   printVarSummary (prob)

; ==============================================================
; Mission 3. Draw the EOF
; ==============================================================

 wks     = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot    = new(neof*2,graphic)      ;creat a plot array

;*******************************************
;  plot EOF
;*******************************************
res = True

res@gsnDraw      = False      ;don't draw
res@gsnFrame     = False      ;don't advance frame
res@gsnAddCyclic = False

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False    ;turn off cn line labels
res@cnFillPalette  = "BlRe"   ;choose a colormap

;res@mpFillOn               = False      ;turn off map fill
res@mpGeophysicalLineColor = "gray40"   ;change the colour of ontlines
;map outlines
res@mpMinLatF              = latS
res@mpMaxLatF              = latN
res@mpMinLonF              = lonL
res@mpMaxLonF              = lonR

;to have a common label bar
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -0.04      ;set min contour level
res@cnMaxLevelValF       = 0.04       ;set max contour level
res@cnLevelSpacingF      = 0.01          ;set contour spacing

res@lbLabelBarOn = False
res@pmLabelBarOrthogonalPosF = 0.25    ;move Label Bar down

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02

do i=0,neof-1
 if(i.eq.neof-1) then
  res@lbLabelBarOn = True
 end if
 res@gsnLeftString   = text1(2*i)
 res@gsnCenterString = "EOF "+(i+1)
 res@gsnRightString  = sprintf("%5.1f",eof@pcvar(i))+"%"
 plot(2*i) = gsn_csm_contour_map_ce (wks,eof(i,:,:),res)
end do

;*******************************************
;  plot EOF time series
;*******************************************
rts = True

rts@gsnDraw       = False      ;don't draw
rts@gsnFrame      = False      ;don't advance frame
rts@gsnYRefLine   = 0.         ;reference line
rts@gsnStringFontHeightF  = 0.024

rts@tmXBLabelFontHeightF = 0.018   ;font height of tick labels
rts@tmYLLabelFontHeightF = 0.018

rts@vpWidthF  = 0.75        ;change aspect ratio of plot
rts@vpHeightF = 0.35

do i=0,neof-1
 rts@gsnLeftString  = text1(2*i+1)
 rts@gsnRightString = r(i)
 plot(2*i+1) = gsn_csm_y (wks,eof_ts(i,0:119),rts)
end do

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "EOF of Monthly 6-8-month bandpass SST"   ;add common title

gsn_panel(wks,plot,(/3,2/),resP)

end
