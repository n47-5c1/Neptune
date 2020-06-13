;*************************************************************
;Aim: Draw correlation between global JAS wind vectors and Sahel JAS region mean rainfall
;Mission:
;
;   1. Read data from UV and PREC datasets
;   2. Post-post process to deserved results
;   3. Draw the correlation
;                       He Shan
;                       2015-03-22
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;     var1--------------precip
;     var2--------------uwnd
;     var3--------------vwnd
;     var4--------------UGRD_GDS0_ISBL_S123
;     var5--------------VGRD_GDS0_ISBL_S123
;================================================

;    level1 = (/"1000","925","850","700","600","500","400","300","250","200","150","100","70","50","30","20","10"/)
;    level2 = (/"1000","975","950","925","900","875","850","825","800","775","750","700","650","600","550","500","450","400","350","300","250","225","200","175","150","125","100","70","50","30","20","10","7","5","3","2","1"/)
    nlev  = 3       ;number of the levels used

    season = "JAS"      ;choose seasonal mean

;time
    yS = 1958
    yE = 2011

;Sahel
    latN=20
    latS=10
    lonL=-20
    lonR=40

;Fig name
    out_path = "~/hes/Sahel_Rainfall/fig/observation/"
    out_name = "corel_g_JAS_wind_VS_Sahel_JAS_reg_PREC" 

;text
    Text1 = (/"a)","b)","c)","e)","f)","g)"/)
    Text2 = (/"850hPa","500hPa","200hPa"/)
    Text3 = (/"NCEP/NCAR","JRA-55"/)

; ==============================================================
; Mission 1. Read only the user specified period

; ==============================================================

;PREC 1948-01~2012-01
    PREC_file = addfile ("~/data/observation/PRECPT/precip-land.mon.mean.0.5x0.5.nc","r")
;NCEP/NCAR Reanalysis 1948-01~2015-01
    U_file = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_uwnd.mon.mean.nc","r")
    V_file = addfile ("~/data/observation/NCEP_NCAR/monthly/NC_vwnd.mon.mean.nc","r")
;JRA-55 1958-01~2012-12
    U_files = systemfunc ("ls ~/data/observation/JRA/JRA-55/*033_ugrd*")
    V_files = systemfunc ("ls ~/data/observation/JRA/JRA-55/*034_vgrd*")
	
    U_in = addfiles (U_files, "r")   ;note the "s" of addfile
    V_in = addfiles (V_files, "r")
    ListSetType (U_in, "cat")   ;concatenate or "merge" (default)
    ListSetType (V_in, "cat")

    PREC_p = PREC_file->precip(:,{latS:latN},:)
    PREC_p = lonFlip (PREC_p)      ;Sahel rainfall
    PREC   = PREC_p(:,:,{lonL:lonR})
    U      = U_file->uwnd(:,(/2,5,9/),:,:)
    V      = V_file->vwnd(:,(/2,5,9/),:,:)
    TIME   = PREC_file->time
    u      = U_in[:]->UGRD_GDS0_ISBL_S123(:,(/6,15,22/),:,:)
    v      = V_in[:]->VGRD_GDS0_ISBL_S123(:,(/6,15,22/),:,:)
    time   = U_in[:]->initial_time0_hours

    printVarSummary (PREC)
    printVarSummary (U)
    printVarSummary (V)
    printVarSummary (TIME)
    printVarSummary (u)
    printVarSummary (v)
    printVarSummary (time)

;---------------------------------------------------------------
;creat weights: cos(lat)
    rad  = 4.*atan(1.)/180.
    gw = PREC_file->lat({latS:latN})
    gw = cos (rad*gw)
    printVarSummary (gw)

;get the time indexs
    YYYY   = cd_calendar (TIME,-1)/100
    iYYYY1 = ind (YYYY.le.yE)
    iYYYY2 = ind (YYYY.ge.yS .and. YYYY.le.yE)
    yyyy   = cd_calendar (time,-1)/100
    iYYYY3 = ind (yyyy.ge.yS .and. yyyy.le.yE)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

;compute seasonal means and regional means
   PREC_JAS_reg = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY1,:,:) ,season) ,gw,1.,0)
   prec_JAS_reg = wgt_areaave_Wrap ( month_to_season ( PREC(iYYYY2,:,:) ,season) ,gw,1.,0)
   U_JAS        = month_to_season ( U(iYYYY1,:,:,:) ,season)
   V_JAS        = month_to_season ( V(iYYYY1,:,:,:) ,season)
   u_JAS        = month_to_season ( u(iYYYY3,:,:,:) ,season)
   v_JAS        = month_to_season ( v(iYYYY3,:,:,:) ,season)
   printVarSummary (PREC_JAS_reg)
   printVarSummary (prec_JAS_reg)
   printVarSummary (U_JAS)
   printVarSummary (V_JAS)
   printVarSummary (u_JAS)
   printVarSummary (v_JAS)

   DIM = dimsizes (U_JAS)
   r_U   = new ((/DIM(1),DIM(2),DIM(3)/),float)
   r_V   = new ((/DIM(1),DIM(2),DIM(3)/),float)
   copy_VarCoords(U_JAS(0,:,:,:),r_U)      ;copy coordinate variable
   copy_VarCoords(U_JAS(0,:,:,:),r_V)
   U_JAS_r = U_JAS(level|:,lat|:,lon|:,time|:)   ;reorder to get time as right most dimension
   V_JAS_r = V_JAS(level|:,lat|:,lon|:,time|:)

   dim = dimsizes (u_JAS)
   r_u   = new ((/dim(1),dim(2),dim(3)/),float)
   r_v   = new ((/dim(1),dim(2),dim(3)/),float)
   copy_VarCoords(u_JAS(0,:,:,:),r_u)      ;copy coordinate variable
   copy_VarCoords(u_JAS(0,:,:,:),r_v)
   v_JAS_r = u_JAS(lv_ISBL1|:,g0_lat_2|:,g0_lon_3|:,initial_time0_hours|:)   ;reorder to get time as right most dimension
   u_JAS_r = v_JAS(lv_ISBL1|:,g0_lat_2|:,g0_lon_3|:,initial_time0_hours|:)

do i=0,nlev-1 
   r_U(i,:,:) = escorc(U_JAS_r(i,:,:,:),PREC_JAS_reg)
   r_V(i,:,:) = escorc(V_JAS_r(i,:,:,:),PREC_JAS_reg)
   r_u(i,:,:) = escorc(u_JAS_r(i,:,:,:),prec_JAS_reg)
   r_v(i,:,:) = escorc(v_JAS_r(i,:,:,:),prec_JAS_reg)
end do
   printVarSummary(r_U)
   printVarSummary(r_V)
   printVarSummary(r_u)
   printVarSummary(r_v)

; ==============================================================
; Mission 3. Draw the correlation
; ==============================================================
 wks = gsn_open_wks("eps",out_path+out_name)  ;open a ps file
 plot = new(6,graphic)                        ;creat a plot array

;-----------------------------------------------------------------------------
res                 = True

res@gsnDraw         = False      ;don't draw
res@gsnFrame        = False      ;don't advance frame

res@vcGlyphStyle            = "CurlyVector"   ;the style of vector
res@vcVectorDrawOrder       = "PostDraw"      ;draw vectors last
res@vcRefAnnoOrthogonalPosF = -0.23           ;move ref vector
res@vcLineArrowHeadMaxSizeF = 0.024           ;change the vector line arrows
res@vcLineArrowHeadMinSizeF = 0.01
res@vcLineArrowThicknessF   = 1.2
res@vcRefLengthF            = 0.05            ;the length of the reference magnitude
res@vcRefMagnitudeF         = 0.5             ;the magnitude used as the reference magnitude
res@vcMinDistanceF          = 0.04            ;the minimum distance of neighboring vectors

res@tmXBLabelFontHeightF = 0.025   ;font height of tick labels
res@tmYLLabelFontHeightF = 0.025
res@tmXBTickSpacingF     = 60.     ;label spacing

res@mpGeophysicalLineColor = "gray30"     ;change the colour of ontlines
res@mpCenterLonF           = 110          ;get the correct map
res@mpFillOn               = False        ;turn off map fill

do i=0,nlev-1
 if(i.eq.nlev-1) then      ;turn on the buttom individual vector reference box
  res@vcRefAnnoOn = True
 else
  res@vcRefAnnoOn = False
 end if
 res@gsnLeftString   = Text1(2*i)
 res@gsnCenterString = Text2(i)
 res@gsnRightString  = Text3(0)
 plot(2*i)   = gsn_csm_vector_map_ce(wks,r_U(i,:,:),r_V(i,:,:),res)
 res@gsnLeftString  = Text1(2*i+1)
 res@gsnRightString = Text3(1)
 plot(2*i+1) = gsn_csm_vector_map_ce(wks,r_u(i,:,:),r_v(i,:,:),res)
end do

;---------------------------------------------------------------
resP          = True
resP@txString = "Global "+season+" Wind Vectors V.S. Sahel "+season+" Region Mean PREC"   ;add common title

gsn_panel(wks,plot,(/3,2/),resP)

end
