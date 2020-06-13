;*************************************************************
;Aim: Draw running climatology of global JJA anomalous precipitation and cloud cover 
;Mission:
;
;   1. Read data from daily PREC & Cloud  datasets
;   2. Post-post process to deserved results
;   3. Draw the climatology
;                       He Shan
;                       2017-04-03
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;	var1--------------precip
;	var2--------------prate
;	var3--------------lsp
;	var4--------------cp
;	var5--------------cldc
;================================================

;datas
;1948/01-
    file1 = "~/data/observation/PREC/precip.mon.anom.nc"
;1948/01-
    file2 = "~/data/observation/NCEP_NCAR/monthly/prate.sfc.mon.mean.nc"
;1871/01-2012/12
    file3 = "~/data/observation/20thCRV2/prate.mon.mean.nc"
;1957/09-2002/08
    file4 = "~/data/observation/ERA-40/monthly/lsp.cp.tcc.mon.mean.deg1.nc"
;1800/01-2014/12
    file5 = "~/data/observation/ICOADS2/Enhanced/cldc.mean.nc"
;1960/01-2014/12
;    file5 = "~/data/observation/ICOADS1/Enhanced/cldc.mean.nc"

;unit
    unit1 = 60.*60.*24.   ;Kg/m^2/s -> mm/day
    unit2 = 2000.         ;m -> mm/day

;time
    yS     = 1961
    yE     = 2000
    season = "JJA"
    nave   = 10      ;Number of points
    opt    = 0      ;set beginning and end points to x@_FillValue

;Region
    latN = 60
    latS = -20
    lonL = -60
    lonR = 180

;data
    out_path = "~/hes/Sahel_Rainfall/Revision/Animation/"
    out_name = "running_clm_g_JJA_Anom_PREC_Cloud_animation"

    text1 = (/"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16"/)
    text2 = (/"a)","b)","c)","d)","e)","f)","g)","h)"/)
    text3 = (/"60s","70s","80s","90s","00s"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (file1, "r")
    in2 = addfile (file2, "r")
    in3 = addfile (file3, "r")
    in4 = addfile (file4, "r")
    in5 = addfile (file5, "r")

    PREC1 = in1->precip
    PREC2 = in2->prate
    PREC2 = unit1*PREC2
    PREC3 = in3->prate
    PREC3 = unit1*PREC3
    PREC4 = short2flt (in4->lsp)
    PREC5 = short2flt (in4->cp)
    PREC4 = PREC4+PREC5
    PREC4 = unit2*PREC4
    Cloud = short2flt (in5->cldc)
    Cloud = 10*Cloud
    printVarSummary (PREC1)
    printVarSummary (PREC2)
    printVarSummary (PREC3)
    printVarSummary (PREC4)
    printVarSummary (Cloud)

;---------------------------------------------------------------
; Read time and create required yyyyddd                    
    time1  = in1->time
    time2  = in2->time
    time3  = in3->time
    time4  = in4->time
    time5  = in5->time
    TIME1  = cd_calendar (time1, 0)
    TIME2  = cd_calendar (time2, 0)
    TIME3  = cd_calendar (time3, 0)
    TIME4  = cd_calendar (time4, 0)
    TIME5  = cd_calendar (time5, 0)
    year1  = toint ( TIME1(:,0) )
    year2  = toint ( TIME2(:,0) )
    year3  = toint ( TIME3(:,0) )
    year4  = toint ( TIME4(:,0) )
    year5  = toint ( TIME5(:,0) )
    printVarSummary (year1)

;get the time indexs
    iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
    iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)
    iYYYY3 = ind (year3.ge.yS .and. year3.le.yE)
    iYYYY4 = ind (year4.ge.yS .and. year4.le.yE)
    iYYYY5 = ind (year5.ge.yS .and. year5.le.yE)
    printVarSummary (iYYYY1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;calculates seasonal means and running averages
    y1 = runave_n_Wrap ( month_to_season(PREC1(iYYYY1,:,:),season), nave, opt, 0)
    y2 = runave_n_Wrap ( month_to_season(PREC2(iYYYY2,:,:),season), nave, opt, 0)
    y3 = runave_n_Wrap ( month_to_season(PREC3(iYYYY3,:,:),season), nave, opt, 0)
    y4 = runave_n_Wrap ( month_to_season(PREC4(iYYYY4,:,:),season), nave, opt, 0)
    y5 = runave_n_Wrap ( month_to_season(Cloud(iYYYY5,:,:),season), nave, opt, 0)
    printVarSummary (y1)

;removes the mean
    y1 = dim_rmvmean_n_Wrap (y1,0)
    y2 = dim_rmvmean_n_Wrap (y2,0)
    y3 = dim_rmvmean_n_Wrap (y3,0)
    y4 = dim_rmvmean_n_Wrap (y4,0)
    y5 = dim_rmvmean_n_Wrap (y5,0)
    printVarSummary (y1)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
plot = new (5,graphic)      ;creat a plot array

;-----------------------------------------------------------------------------
res = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame
;res@gsnRightString  = " "

res@mpFillOn       = False      ;turn off map fill
res@mpCenterLonF   = 60.        ;get the correct map
res@mpMinLatF      = latS
res@mpMaxLatF      = latN
;res@mpMinLonF      = lonL
;res@mpMaxLonF      = lonR

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_RdBu"     ;choose a colormap

res@tmXBLabelFontHeightF = .018   ;font height of tick labels
res@tmYLLabelFontHeightF = .018
res@tmXBTickSpacingF     = 60.    ;label spacing

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -2.8
res@cnMaxLevelValF       = 2.8
res@cnLevelSpacingF      = 0.7

res@lbLabelBarOn = False

;*******************************************
;create panel resources
;*******************************************
 resP               = True
 resP@txString      = "Running Averages of "+season+" Precipitation and Cloudness"
 resP@txFontHeightF = 0.02      ;height of text

 resP@gsnPanelLabelBar         = True      ;add common colorbar
 resP@lbLabelFontHeightF       = 0.01      ;label heights of labelbars
 resP@pmLabelBarOrthogonalPosF = -0.008    ;move Label Bar down

do i=0,3
 wks = gsn_open_wks ("svg",out_path+out_name+text1(i))
 res@gsnLeftString   = text2(0)
 res@gsnCenterString = text3(i)
 plot(0) = gsn_csm_contour_map (wks,y1(4+i*nave,:,:),res)
 res@gsnLeftString   = text2(1)
 res@gsnCenterString = " "
 plot(1) = gsn_csm_contour_map (wks,y2(4+i*nave,:,:),res)
 res@gsnLeftString = text2(2)
 plot(2) = gsn_csm_contour_map (wks,y3(4+i*nave,:,:),res)
 res@gsnLeftString = text2(3)
 plot(3) = gsn_csm_contour_map (wks,y4(4+i*nave,:,:),res)
 res@gsnLeftString = text2(4)
 plot(4) = gsn_csm_contour_map (wks,y5(4+i*nave,:,:),res)
 gsn_panel(wks,plot,(/5,1/),resP)      ;create panel
 delete(wks)      ;Make sure file is closed
end do

end
