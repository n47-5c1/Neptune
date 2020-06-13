;*************************************************************
;Aim: Draw climatologies of global zonal winds and correlation between monthly teleconnection index anomalies and the wind anomalies in the
;     winter-half year
;Mission:
;
;   1. Read data from U datasets
;   2. Post-post process to deserved results
;   3. Draw the climatologies
;                       He Shan
;                       2020-05-02
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------INDEX
;   var2--------------uwnd
;================================================

;data
    in_path1 = "~/data/observation/NCEP_DOE/daily/air/"
    in_path2 = "~/data/observation/NCEP_DOE/daily/uwnd/"
    in_path3 = "~/data/observation/NCEP_DOE/daily/hgt/"

;time
    mS = 7
    yS = 1979
    yE = 2015
    yS1 = (/1979,1982,1986,1987,1991,1994,1997,2002,2004,2006,2009/)   ;2015!
    yS2 = (/1983,1984,1988,1995,1998,1999,2000,2007,2010,2011/)   ;2016!
    ny1 = dimsizes (yS1)
    ny2 = dimsizes (yS2)

;arguments required by vertical mean
;    pnew       = (/850,700,600,500,400,300,250,200/)
    pnew       = (/850,700,600,500,400,300/)
    pver       = pnew*100
    pver@units = "Pa"
    dp         = dpres_plevel_Wrap (pver,85000,30000,0)   ;caculate dp
    sumdp      = sum(dp)

;region
    latN = 70
    latS = 0
    lonL = -90
    lonR = 10

;fig
    out_path = "~/hes/One_Belt_One_Road/Fig/"
    out_name = "clm_diff_winter_mon_EGR_anom"

;text
    text0 = (/"a) EGR;  El Nino","b) Ks"/)
    text1 = (/"Nov.(0) - Apr.(+1)","El Nino - La Nina"/)
if(False)
; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    files1 = systemfunc ("ls "+in_path1+"air.*.nc")
    files2 = systemfunc ("ls "+in_path2+"uwnd.*.nc")
    files3 = systemfunc ("ls "+in_path3+"hgt.*.nc")
    setfileoption("nc","SuppressClose",False)   ;close too many files
    in1 = addfiles(files1,"r")
    in2 = addfiles(files2,"r")
    in3 = addfiles(files3,"r")
    ListSetType (in1, "cat")   ;concatenate or "merge" (default)
    ListSetType (in2, "cat")
    ListSetType (in3, "cat")
    time = in1[:]->time

;get the time indexs
    TIME    = cd_calendar(time, 0)
    year_p  = toint (TIME(:,0) )
    month_p = toint (TIME(:,1) )
    iYYYY   = ind (year_p.ge.yS .and. year_p.le.yE)
    year  = year_p(iYYYY)
    month = month_p(iYYYY)

    El = (year.eq.yS1(0) .and. month.ge.mS .or. year.eq.yS1(0)+1 .and. month.lt.mS)
    do i=1,ny1-1
     El = El.or.(year.eq.yS1(i) .and. month.ge.mS .or. year.eq.yS1(i)+1 .and. month.lt.mS)
    end do

    La = (year.eq.yS2(0) .and. month.ge.mS .or. year.eq.yS2(0)+1 .and. month.lt.mS)
    do i=1,ny2-1
     La = La.or.(year.eq.yS2(i) .and. month.ge.mS .or. year.eq.yS2(i)+1 .and. month.lt.mS)
    end do

    iEl = ind ((month.ge.11 .or. month.le.4) .and. El)
    iLa = ind ((month.ge.11 .or. month.le.4) .and. La)

    printVarSummary (iEl)
    printVarSummary (iLa)
;----------------------------------------------------------

    air = short2flt(in1[:]->air(iYYYY,{950:250},{latN:latS},:))
    uwnd = short2flt(in2[:]->uwnd(iYYYY,{950:250},{latN:latS},:))
    hgt = short2flt(in3[:]->hgt(iYYYY,{950:250},{latN:latS},:))
    level = in1[0]->level({950:250})
    level = (/level * 100/)
    level@units = "Pa"
    lat = in1[0]->lat({latN:latS})
    xlat = conform(air, lat, 2)
    lon = in1[0]->lon

    printVarSummary(air)
    printVarSummary(level)
    printVarSummary(lat)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

   th = pot_temp(level, air, 1, False)
   EGR = eady_growth_rate(th, uwnd, hgt, xlat, 0, 0)
   EGR = (/where(EGR.lt.0, 0, EGR) * 86400/)
   EGR@units = "1/day"
   replace_ieeenan(EGR, EGR@_FillValue, 0)
   printVarSummary(EGR)
   U1_p = EGR(iEl,{850:300},:,:)
   U2_p = EGR(iLa,{850:300},:,:)
   dp1_cfm = conform_dims(dimsizes(U1_p), dp, 1)
   dp2_cfm = conform_dims(dimsizes(U2_p), dp, 1)
   U1 = dim_sum_n(dp1_cfm * U1_p / sumdp, 1)
   U2 = dim_sum_n(dp2_cfm * U2_p / sumdp, 1)
   copy_VarMeta(U1_p(:,0,:,:), U1)
   copy_VarMeta(U2_p(:,0,:,:), U2)

   ave1 = dim_avg_n_Wrap(U1, 0)
   ave2 = dim_avg_n_Wrap(U2, 0)
;   var1 = dim_variance_n_Wrap(U1, 0)
;   var2 = dim_variance_n_Wrap(U2, 0)

;---------------------------------------------------------------
;compute probabilities for means difference
   diff = ave1 - ave2
;   prob = ttest(ave2, var2, dimsizes(U2(:,0,0)), ave1, var1, dimsizes(U1(:,0,0)), False, False)
   copy_VarMeta (ave1,diff)
;   copy_VarCoords (ave1,prob)
   printVarSummary (diff)
   printMinMax(diff,1)

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

system ("rm -f "+out_path+out_name+".nc")      ;remove if exists
fout = addfile (out_path+out_name+".nc","c")   ;open output file

setfileoption (fout,"DefineMode",True)   ;declare file definition mode

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"lat","lon"/)  
dimSizes = dimsizes(diff)
dimUnlim = (/False,False/)   
filedimdef (fout,dimNames,dimSizes,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout,"lat",typeof(lat),getvardims(lat))                          
filevardef (fout,"lon",typeof(lon),getvardims(lon))                          
filevardef (fout,"diff",typeof(diff),getvardims(diff))    

;Copy attributes associated with each variable to the file
filevarattdef (fout,"lat",lat)
filevarattdef (fout,"lon",lon)
filevarattdef (fout,"diff",diff)

;output only the data values
fout->lat  = (/lat/)
fout->lon  = (/lon/) 
fout->diff = (/diff/)

else

in = addfile(out_path+out_name+".nc","r")
diff = in->diff

end if

; ==============================================================
; Mission 3. Draw the climatologies
; ==============================================================

 wks   = gsn_open_wks("svg",out_path+out_name)

;*******************************************
;  plot correlation
;*******************************************
res = True

res@gsnDraw         = False
res@gsnFrame        = False
res@gsnAddCyclic    = True
res@gsnLeftString   = text0(0)
res@gsnCenterString = text1(0)
res@gsnRightString  = text1(1)
res@gsnStringFontHeightF    = 0.02

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-1.2,-.8,-.4,.4,.8,1.2/)

res@mpFillOn               = False
;res@mpCenterLonF           = 60.
res@mpGeophysicalLineColor = "gray40"
;map outlines
res@mpMinLatF    = latS
res@mpMaxLatF    = latN
res@mpMinLonF    = lonL
res@mpMaxLonF    = lonR
    
;res@lbOrientation = "vertical"
;res@lbLabelFontHeightF       = .022
;res@pmLabelBarOrthogonalPosF = -.01
res@pmLabelBarOrthogonalPosF = .26

res@tiMainString      = "EGR and its Difference"
res@tiMainFontHeightF = 0.023

res@tmXBLabelFontHeightF = .018
res@tmYLLabelFontHeightF = .018
;res@tmXBTickSpacingF     = 45.
plot0 = gsn_csm_contour_map (wks,diff,res)

;---------------------------------------------------------------
;plot climatology

res2 = True

res2@gsnDraw         = False
res2@gsnFrame        = False
res2@gsnAddCyclic    = True
res2@gsnLeftString   = " "
res2@gsnCenterString = " "
res2@gsnRightString  = " "
;res2@gsnContourNegLineDashPattern   = 1
res2@gsnContourLineThicknessesScale = 1.8

;res2@cnInfoLabelOn   = False
;res2@cnLineLabelsOn = False
res2@cnLabelDrawOrder = "PostDraw"
res2@cnLineLabelInterval = 1
res2@cnLineLabelDensityF = 0.2
res2@cnLineLabelFontHeightF = 0.013
res2@cnLineLabelPlacementMode = "Computed"
res2@cnInfoLabelFontHeightF = 0.013
res2@cnInfoLabelOrthogonalPosF = 0.32
;res2@cnLevelSelectionMode = "ManualLevels"
;res2@cnMinLevelValF       = 10.
;res2@cnMaxLevelValF       = 55.
;res2@cnLevelSpacingF      = 15.

;plot1 = gsn_csm_contour (wks,ave1,res2)

;---------------------------------------------------------------
;probability plots
res3 = True
res3@gsnDraw = False
res3@gsnFrame = False
res3@gsnLeftString = " "
res3@gsnRightString = " "

res3@cnLevelSelectionMode = "ManualLevels"
res3@cnMinLevelValF = 0.00
res3@cnMaxLevelValF = 0.10
res3@cnLevelSpacingF = 0.01
res3@cnInfoLabelOn = False
res3@cnLinesOn = False
res3@cnLineLabelsOn = False
res3@cnFillDotSizeF = 0.004
res3@cnFillScaleF = 2.

;plot2 = gsn_csm_contour (wks, prob, res3)
;plot2 = ShadeLtContour (plot2, 0.055, 17)

;overlay (plot0,plot2)
;overlay (plot0,plot1)

draw (plot0)
frame (wks)

end
