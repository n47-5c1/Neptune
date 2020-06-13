;*************************************************************
;Aim: Draw daily climatologies of stream function deviations from the zonal mean at different locations and sample anomalies using smooth and raw climatologies
;Mission:
;
;   1. Read data from U & V datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies and anomalies
;                       He Shan
;                       2016-09-09
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------uwnd
;   var2--------------vwnd
;================================================

;data
    in_path = "~/data/observation/NCEP_NCAR/daily/"
    nhar    = 4      ;number of fourier comp

;point
    LAT = (/40,30,25/)
    LON = (/355,65,90/)

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "timeseries_clm_annual_cycle_anom_sf"

;text
    text1 = (/"a)","b)","c)","d)"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

;NCEP/NCAR Reanalysis
    U_files  = systemfunc ("ls "+in_path+"uwnd/uwnd.1979.nc "+in_path+"uwnd/uwnd.19[8-9]*.nc "+in_path+"uwnd/uwnd.2*.nc")
    V_files  = systemfunc ("ls "+in_path+"vwnd/vwnd.1979.nc "+in_path+"vwnd/vwnd.19[8-9]*.nc "+in_path+"vwnd/vwnd.2*.nc")
    setfileoption ("nc","SuppressClose",False)   ;close too many files
    U_in = addfiles (U_files,"r")                ;note the "s" of addfile
    V_in = addfiles (V_files,"r")
    ListSetType (U_in, "cat")                    ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")
;    U      = V_file->hgt(:,2,:,:)                ;850hPa
;    U      = V_file->hgt(:,5,:,:)                ;500hPa
    U      = U_in[:]->uwnd(:,8,::-1,:)           ;250hPa
    V      = V_in[:]->vwnd(:,8,::-1,:)           ;250hPa
    TIME   = U_in[:]->time

    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME)

;create required yyyyddd
    YYYY    = cd_calendar (TIME,0)       ;for original data
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))
    day     = floattointeger (YYYY(:,2))
    ddd     = day_of_year(year, month, day) 
    yyyyddd = year*1000 + ddd            ;needed for input

    printVarSummary (yyyyddd)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;stream function
   sfvp = uv2sfvpG (U,V)
   sf   = sfvp(0,:,:,:)
   sf   = sf * 10^(-6.)
   copy_VarCoords (U,sf)
   printVarSummary (sf)

;calculate deviation from zonal mean
   sf_xAnom = dim_rmvmean_Wrap (sf)
   printVarSummary (sf_xAnom)

;-------------------------------------------------------------
;Compute daily climatology: raw and then 'smoothed'
   sfClmDay    = clmDayTLL (sf_xAnom, yyyyddd)
   sfClmDay_sm = smthClmDayTLL (sfClmDay, nhar)
   printVarSummary(sfClmDay)
   printVarSummary(sfClmDay_sm)

;***********************************************************
; Compute daily anomalies using raw and smoothed climatologies
;***********************************************************
   sf_tAnom              = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay)
   sf_tAnom_sm           = calcDayAnomTLL (sf_xAnom, yyyyddd, sfClmDay_sm)     
   sf_tAnom_sm@long_name = "Anomalies from Smooth Daily Climatology"
   printVarSummary(sf_tAnom)
   printVarSummary(sf_tAnom_sm)

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks  = gsn_open_wks("eps",out_path+out_name)   ; open a eps file
 plot = new(5,graphic)      ;creat a plot array

;---------------------------------------------------------------
;plot daily climatologies
data = new ( (/2,366/), typeof(sfClmDay), getFillValue(sfClmDay))

res = True

res@gsnDraw        = False      ;don't draw
res@gsnFrame       = False      ;don't advance frame
res@gsnRightString = "10^6"

res@trXMinF = 1
res@trXMaxF = 366

res@xyLineThicknesses = (/1.0, 2.0/)              ;make 2nd lines thicker
res@xyLineColors      = (/"blue","red"/)          ;change line color
;res@xyMonoDashPattern = True                      ;all solid

res@vpHeightF = 0.4
res@vpWidthF  = 0.8

res@tmXBLabelFontHeightF = 0.02   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.02
res@tmXBTickSpacingF     = 60.     ;label spacing

do i=0,2
 res@gsnLeftString   = text1(i)
 res@gsnCenterString = "lat="+LAT(i)+"  lon="+LON(i)
 if(i.eq.1) then
  res@gsnRightString = " "
 end if
 data(0,:) = sfClmDay(:,{LAT(i)},{LON(i)})
 data(1,:) = sfClmDay_sm(:,{LAT(i)},{LON(i)})
 plot(i)   = gsn_csm_y (wks,data,res)      ;create plot
end do

;---------------------------------------------------------------
;plot anomalies

dimx = dimsizes(sf_tAnom)
ntim = dimx(0)

sf_tAnom@long_name    = "Anomalies from Raw"      ;short labels for plot
sf_tAnom_sm@long_name = "Anomalies from Smooth"

yyyymmdd = cd_calendar (TIME, -2)
;yrfrac   = yyyymmdd_to_yyyyfrac (yyyymmdd, 0)
;delete(yrfrac@long_name)

ntS = ind(yyyymmdd.eq.19961001)
ntE = ind(yyyymmdd.eq.19970401)
       
monthLabels = (/1,4,7,10/)
monNam      = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec" /)
xVal        = new(ntim, typeof(sf_tAnom&time) , "No_FillValue")   ;bigger than needed
xLab        = new(ntim, "string", "No_FillValue")
xValm       = new(ntim, typeof(sf_tAnom&time) , "No_FillValue")

ntm = -1
cr  = inttochar(10)                     ; carriage return

do nt=ntS,ntE
 if (day(nt).eq.1) then
  ntm       = ntm + 1
  xVal(ntm) = sf_tAnom&time(nt)
  xLab(ntm) = monNam(month(nt)-1)
  if (month(nt).eq.1) then
   xLab(ntm) = xLab(ntm) + cr +sprinti("%0.4i", year(nt))
  end if
 end if
end do

res2 = True

res2@gsnDraw               = False
res2@gsnFrame              = False
res2@gsnYRefLine           = 0.0          ;create a reference line   
;res2@gsnCenterString       = " "
;res2@gsnRightString        = " "
res2@gsnAboveYRefLineColor = "red"        ;above ref line fill red
res2@gsnBelowYRefLineColor = "blue"       ;below ref line fill blue

;res2@xyLineThicknessF  = 2.0

res2@vpHeightF  = 0.4
res2@vpWidthF   = 0.8

res2@tmXBMode   = "Explicit"
res2@tmXBValues = xVal(0:ntm)
res2@tmXBLabels = xLab(0:ntm)

res2@gsnLeftString         = " "
plot(3)  = gsn_csm_xy (wks,TIME(ntS:ntE),sf_tAnom(ntS:ntE,{LAT(2)},{LON(2)}),res2) 
plot(4)  = gsn_csm_xy (wks,TIME(ntS:ntE),sf_tAnom_sm(ntS:ntE,{LAT(2)},{LON(2)}),res2)

;*******************************************
;create panel resources
;*******************************************
resP                          = True
resP@txString                 = "Climatologies of 250 hPa SF Deviations from Zonal Mean"   ;add common title
resP@txFontHeightF            = 0.025      ;height of text

gsn_panel(wks,plot,(/2,3/),resP)

end
