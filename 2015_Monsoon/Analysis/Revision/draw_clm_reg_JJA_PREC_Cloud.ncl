;*************************************************************
;Aim: Draw climatology of regional JJA precipitation and cloud cover 
;Mission:
;
;   1. Read data from PREC & Cloud  datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       He Shan
;                       2017-04-21
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------prate
;	var2--------------lsp
;	var3--------------cp
;	var4--------------cldc
;================================================

;datas
;1948/01-
    file1 = "~/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;1957/09-2002/08
    file2 = "~/data/observation/ERA-40/monthly/lsp.cp.tcc.mon.mean.deg1.nc"
;1800/01-2014/12
    file3 = "~/data/observation/ICOADS2/Enhanced/cldc.mean.nc"

;unit
    unit1 = 60.*60.*24.   ;Kg/m^2/s -> mm/day
    unit2 = 4000.         ;m -> mm/day

;time
    yS     = 1958
    yE     = 2001
    season = "JJA"

;Region
    latN = 45
    latS = -20
    lonL = 30
    lonR = 180

;data
    out_path = "~/hes/Sahel_Rainfall/Revision/"
    out_name = "clm_reg_JJA_PREC_Cloud"

    text1 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (file1, "r")
    in2 = addfile (file2, "r")
    in3 = addfile (file3, "r")

    PREC1 = in1->prate
    PREC1 = unit1*PREC1
    PREC2 = short2flt (in2->lsp)
    PREC3 = short2flt (in2->cp)
    PREC2 = PREC2+PREC3
    PREC2 = unit2*PREC2
    Cloud = short2flt (in3->cldc)
    Cloud = 2*Cloud
    PREC1@units = "mm/day"
    PREC2@units = "mm/day"
    printVarSummary (PREC1)
    printVarSummary (PREC2)
    printVarSummary (Cloud)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time1  = in1->time
    time2  = in2->time
    time3  = in3->time

    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    TIME3  = cd_calendar (time3, 0)

    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    year3  = toint ( TIME3(:,0) )

    printVarSummary (year1)

;get the time indexs
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    printVarSummary (iYYYY1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;calculates seasonal means and running averages
    y1 = dim_avg_n_Wrap ( month_to_season(PREC1(iYYYY1,:,:),season), 0)
    y2 = dim_avg_n_Wrap ( month_to_season(PREC2(iYYYY2,:,:),season), 0)
    y3 = dim_avg_n_Wrap ( month_to_season(Cloud(iYYYY3,:,:),season), 0)
    printVarSummary (y1)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
plot = new (3,graphic)      ;creat a plot array
wks  = gsn_open_wks ("svg",out_path+out_name)

;-----------------------------------------------------------------------------
res = True

res@gsnDraw  = False      ;don't draw
res@gsnFrame = False      ;don't advance frame

;res@mpFillOn       = False      ;turn off map fill
;res@mpCenterLonF   = 60.        ;get the correct map
res@mpMinLatF      = latS
res@mpMaxLatF      = latN
res@mpMinLonF      = lonL
res@mpMaxLonF      = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "WhiteBlue"     ;choose a colormap

res@tmXBLabelFontHeightF = .025   ;font height of tick labels
res@tmYLLabelFontHeightF = .025
res@tmXBTickSpacingF     = 30.    ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = 3
res@cnMaxLevelValF       = 15
res@cnLevelSpacingF      = 3

res@lbLabelBarOn = False

res@gsnLeftString   = text1(0)
res@gsnCenterString = season
plot(0) = gsn_csm_contour_map (wks,y1,res)
res@gsnLeftString   = text1(1)
res@gsnCenterString = " "
res@gsnRightString  = " "
plot(1) = gsn_csm_contour_map (wks,y2,res)
res@gsnLeftString  = text1(2)
res@gsnRightString = y3@units
plot(2) = gsn_csm_contour_map (wks,y3,res)

;*******************************************
;create panel resources
;*******************************************
resP               = True
resP@txString      = "Climatology of Precipitation and Cloudness"
resP@txFontHeightF = 0.026      ;height of text

resP@gsnPanelLabelBar         = True      ;add common colorbar
resP@lbLabelFontHeightF       = 0.018     ;label heights of labelbars
resP@pmLabelBarOrthogonalPosF = -0.008    ;move Label Bar down

gsn_panel(wks,plot,(/3,1/),resP)      ;create panel

end
