;*************************************************************
;Aim: Draw hovmoller diagram (time vs. lag) of cross correlation between monthly cold tongue index and surface net flux anomalies removed trend
;     in the Tropical Indian Ocean
;Mission:
;
;   1. Read data from sst dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-03-19
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;================================================
;Variables List:
;   var1--------------sst
;   var2--------------lhtfl
;   var3--------------shtfl
;   var4--------------nlwrs
;   var5--------------nswrs
;================================================

;data
;HadISST1   1870/01 - , 1x1
    in_name1 = "~/hes/ENSO/Regrid/HadISST_sst_2x2.nc"
;NCEP/NCAR  1948/01 - , T64
    in_name2 = "~/data/observation/NCEP_NCAR/monthly/lhtfl.sfc.mon.mean.nc"
    in_name3 = "~/data/observation/NCEP_NCAR/monthly/shtfl.sfc.mon.mean.nc"
    in_name4 = "~/data/observation/NCEP_NCAR/monthly/nlwrs.sfc.mon.mean.nc"
    in_name5 = "~/data/observation/NCEP_NCAR/monthly/nswrs.sfc.mon.mean.nc"

;time
    yS = 1958
    yE = 2004
    maxlag = 6

;cold tongue
    latNI = 6
    latSI = -6
    lonWI = 180
    lonEI = 270
;Nino3
;    latNI = 5
;    latSI = -5
;    lonWI = 210
;    lonEI = 270
;Nino3.4
;    latNI = 5
;    latSI = -5
;    lonWI = 190
;    lonEI = 240

;tropical Indian Ocean
;    latN = 10
;    latS = -10
;    lonW = 50
;    lonE = 100

;tropical North Atlantic
    latN = 25
    latS = 5
    lonW = 305 
    lonE = 345

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_data = "./hovmoller_lag_corr_mon_CTI_and_TIO_nfs_anom_remove_trend.nc"
    out_name = "hovmoller_lag_corr_mon_CTI_and_TIO_nfs_anom_remove_trend"

;text
    text1 = (/"Jan.","Mar","May","July","Sept.","Nov.","Jan."/)
    text2 = (/"-6","-4","-2","0","2","4","6"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

     in1 = addfile (in_name1,"r")
     in2 = addfile (in_name2,"r")
     in3 = addfile (in_name3,"r")
     in4 = addfile (in_name4,"r")
     in5 = addfile (in_name5,"r")

     lat1 = in1->lat
     lat2 = in2->lat

;get the time indexs
     time1  = in1->time
     time2  = in2->time
     year1  = cd_calendar (time1,-1) /100
     year2  = cd_calendar (time2,-1) /100
     iYYYY1 = ind (year1.ge.yS .and. year1.le.yE)
     iYYYY2 = ind (year2.ge.yS .and. year2.le.yE)

     sst   = in1->sst(iYYYY1,:,:)
     lhtfl = in2->lhtfl(iYYYY2,:,:)
     shtfl = in3->shtfl(iYYYY2,:,:)
     nlwrs = in4->nlwrs(iYYYY2,:,:)
     nswrs = in5->nswrs(iYYYY2,:,:)
     nfs   = lhtfl+shtfl+nlwrs+nswrs
     copy_VarCoords (lhtfl,nfs)

;-------------------------------------------------------------
;creat weights: cos(lat)
     rad = 4.*atan(1.)/180.
;     gw  = in1->latitude({latN:latS})
     gw1 = cos (rad*lat1)
     gw2 = cos (rad*lat2)
     copy_VarCoords (lat1,gw1)
     copy_VarCoords (lat2,gw2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;monthly anomalies
   clm1 = clmMonTLL (sst)
   clm2 = clmMonTLL (nfs)
   sstA = calcMonAnomTLL (sst, clm1)
   nfsA = calcMonAnomTLL (nfs, clm2)
   sstA = (/dtrend_msg_n (sstA&time,sstA,False,False,0)/)
   nfsA = (/dtrend_msg_n (nfsA&time,nfsA,False,False,0)/)

;cold tongue index
   I = wgt_areaave_Wrap ( sstA(:,{latNI:latSI},{lonWI:lonEI}), gw1({latNI:latSI}), 1., 0)

;tropical Indian Ocean
   TIO_p = wgt_areaave_Wrap ( nfsA(:,{latN:latS},{lonW:lonE}), gw2({latN:latS}), 1., 0)

;--------------------------------------------------------------
   ccr = new ((/13,2*maxlag+1/), float)
   TIO = new (dimsizes(TIO_p), typeof(TIO_p))
   copy_VarMeta (TIO_p,TIO)

do i = 0,12

;get the deserved data
   TIO        = (/TIO_p@_FillValue/)
   TIO(i::12) = (/TIO_p(i::12)/)

;compute cross correlation
   x_lead_y = esccr (I,TIO,maxlag)
   y_lead_x = esccr (TIO,I,maxlag)

   ccr(i,:maxlag) = (/y_lead_x(::-1)/)
   ccr(i,maxlag:) = (/x_lead_y/)
   printVarSummary (ccr)

end do

;determine the statistical significance
;   prob = ccr      ;copy meta data
;   prob = rtest (ccr,dim(0),0)
;   prob = mask (prob,prob.eq.0.,False)      ;set prob that are equal to 0 to the _FillValue

; ==============================================================
; Mission 4. Draw the difference
; ==============================================================

wks  = gsn_open_wks ("svg",out_path + out_name)
plot = new (2,graphic)

res = True

;res@gsnDraw              = False
;res@gsnFrame             = False
;res@gsnAddCyclic         = True
res@gsnStringFontHeightF = .018

res@cnFillOn       = True
res@cnLinesOn      = False
res@cnLineLabelsOn = False
res@cnFillPalette  = "MPL_coolwarm"
res@cnInfoLabelOn  = False
;res@cnFillPalette  = "CBR_coldhot"
;to have a common label bar
res@cnLevelSelectionMode = "ExplicitLevels"
res@cnLevels             = (/-.4,-.3,-.2,-.1,.1,.2,.3,.4/)

;res@lbLabelBarOn = False

res@tmYLMode             = "Explicit"
res@tmYLValues           = ispan(0,12,2)
res@tmYLLabels           = text1
res@tmXBMode             = "Explicit"
res@tmXBValues           = ispan(0,12,2)
res@tmXBLabels           = text2
;res@tmYLMinorOn          = False
;res@tmYRMinorOn          = False
res@tmYLTickSpacingF     = 1
res@tmXBTickSpacingF     = 1
res@tmXBLabelFontHeightF = 0.018
res@tmYLLabelFontHeightF = 0.018

res@tiMainString  = "Correlation of NFS onto CTI"
;res@tiMainFontHeightF = 1
res@tiYAxisString = "NFS"
res@tiXAxisString = "CTI Lead (months)"

;res@vpHeightF = 0.25

;res@gsnLeftString   = text1(0)+text2(0)
res@gsnCenterString = lonW+"-"+lonE+"E, "+latS+"-"+latN+"N"
;res@gsnRightString  = text3(1)
plot(0) = gsn_csm_hov (wks,ccr,res)

end
