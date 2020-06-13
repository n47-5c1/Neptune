;*************************************************************
;Aim: Draw scores for different mechanisms
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Draw the plot
;                       Shan He
;                       2018-03-01
;
;*************************************************************

;----------------------------------------------------------------------
; Procedure to attach a horizontal labelbar to the bottom of plot.
;----------------------------------------------------------------------
undef("add_labelbar")
procedure add_labelbar(wks,plot,colors,labels)
local vph, vpw, nboxes, lbres, lbid, amres, annoid
begin
  getvalues plot                      ; Get plot size for use in
    "vpHeightF" : vph                 ; creating labelbar.
    "vpWidthF"  : vpw
  end getvalues

  nboxes = dimsizes(colors)

  lbres                    = True
  lbres@lbAutoManage       = False         ; Necessary to control sizes
  lbres@vpWidthF           = 0.08 * vpw    ; labelbar width
  lbres@vpHeightF          = 1.05 * vph    ; labelbar height
  lbres@lbFillColors       = colors        ; labelbar colors
  lbres@lbMonoFillPattern  = True          ; Solid fill pattern
  lbres@lbLabelFontHeightF = 0.01          ; font height. default is small
  lbres@lbLabelAlignment   = "InteriorEdges"  ; center of box
  lbres@lbOrientation      = "Vertical"
  lbres@lbPerimOn          = False

  lbid = gsn_create_labelbar(wks,nboxes,labels,lbres)
   
;
; Now, create some annotation resources indicating how we want to
; attach the labelbar to the plot. Here, we are using the top right
; corner of the labelbar as the point which we are going to position
; it, and then we use amParallelPosF and amOrthogonalPosF to indicate
; where we want to place it.
;
; amParallelPosF/amOrthogonalPosF                                       ;
;    0.0/ 0.0  -  annotation in dead center of plot
;    0.5/ 0.5  -  annotation at bottom right of plot
;    0.5/-0.5  -  annotation at top right of plot
;   -0.5/-0.5  -  annotation at top left of plot
;   -0.5/ 0.5  -  annotation at bottom left of plot
;                                                                 
  amres                  = True
  amres@amJust           = "CenterLeft"
  amres@amParallelPosF   =  0.52
  amres@amOrthogonalPosF =  0.0
  plot@annoid = gsn_add_annotation(plot,lbid,amres)
end

begin

;================================================
;Variables List:
;   var--------------mnmx
;================================================
;data
    in_path  = "~/hes/ENSO/NCL/"
    in_name1 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_wspd.sfc_anom_remove_trend_CMIP.nc"
    in_name2 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_nrs_anom_remove_trend_CMIP.nc"
    in_name3 = "scatter_max_lag_regress_NDJ_CTI_and_areaave_TT_anom_remove_trend_CMIP.nc"
    in_name4 = "scatter_max_regress_areaave_SSTA_and_wspd.sfc_nrs_TT_anom_remove_trend_CMIP.nc"

    mnmn = new((/2,3,37+2/),float)
    std1 = new((/2,3/),float)
    r    = new((/2,3,37+2/),float)
    std2 = new((/2,3/),float)
    R1   = new((/2,3,37+1/),float)
    R2   = new((/2,3,37+1/),float)

;fig
    out_path = "~/hes/ENSO/Fig/"
    out_name = "score_SSTA_mechanism"

;text
    text1 = (/"MMM","ACCESS1-0","ACCESS1-3","bcc-csm1-1","CanESM2","CMCC-CESM","CMCC-CM","CMCC-CMS","CNRM-CM5","CNRM-CM5-2","CSIRO-Mk3-6-0","FGOALS-s2","GFDL-CM2p1","GFDL-CM3",\
              "GFDL-ESM2G","GFDL-ESM2M","GISS-E2-H","GISS-E2-H-CC","GISS-E2-R","GISS-E2-R-CC","HadCM3","HadGEM2-CC","HadGEM2-ES","inmcm4","IPSL-CM5A-LR","IPSL-CM5A-MR",\
              "IPSL-CM5B-LR","MIROC4h","MIROC5","MIROC-ESM","MIROC-ESM-CHEM","MPI-ESM-LR","MPI-ESM-MR","MPI-ESM-P","MRI-CGCM3","MRI-ESM1","NorESM1-M","NorESM1-ME"/)
    text2 = (/"WSPD","NRF","TTM"/)
    text3 = (/"a)","b)","c)","d)"/)
    text4 = (/"Tropical Indian Ocean","Tropical North Atlantic"/)
    text5 = (/"CTI-related","~F33~D~F~SSTA-related"/)

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in3 = addfile (in_path + in_name3,"r")
    in4 = addfile (in_path + in_name4,"r")

    mnmn(:,0,:) = -(in1->mnmx)
    mnmn(:,1,:) = -(in2->mnmx)
    mnmn(:,2,:) = in3->mnmx
    std1(:,0)   = in1->std
    std1(:,1)   = in2->std
    std1(:,2)   = in3->std
    r           = in4->r
    r(:,:1,:)   =(/-r(:,:1,:)/)
    std2        = in4->std

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    R1 = ( mnmn(:,:,1:) - conform_dims( dimsizes( mnmn(:,:,1:) ), mnmn(:,:,0), (/0,1/) ) ) / conform_dims( dimsizes( mnmn(:,:,1:) ), sqrt( (std1(0,:)^2+std1(1,:)^2)/2 ), 1 )
    R2 = ( r(:,:,1:) - conform_dims( dimsizes( r(:,:,1:) ), r(:,:,0), (/0,1/) ) ) / conform_dims( dimsizes( r(:,:,1:) ), sqrt( (std2(0,:)^2+std2(1,:)^2)/2 ), 1 )
    dim = dimsizes (R1)

; ==============================================================
; Mission 3. Draw the plots
; ==============================================================

wks  = gsn_open_wks ("svg",out_path+out_name)

;-------------------------------------------------------------
;Create a blank plot

res = True

res@gsnDraw       = False
res@gsnFrame      = False
res@gsnShape      = True
;res@gsnStringFontHeightF = .021

res@trXMinF = 0
res@trXMaxF = dim(2)
res@trYMinF = 0
res@trYMaxF = dim(1)

res@tmXBMode    = "Explicit"
res@tmXBValues  = fspan (.5,dim(2)-.5,dim(2))
res@tmXBLabels  = text1
res@tmXBLabelJust        = "CenterLeft"
res@tmXBLabelAngleF      = -60.
res@tmXBLabelFontHeightF = 0.008
;Remove tickmarks
res@tmXBMajorLengthF        = 0.
res@tmXBMajorOutwardLengthF = 0.

res@tmYLMode    = "Explicit"
res@tmYLValues  = fspan (.5,dim(1)-.5,dim(1))
res@tmYLLabels  = text2
res@tmYLLabelFontHeightF = 0.008

;res@tiYAxisString      = text3
;res@tiYAxisFontHeightF = .0

res@gsnLeftString   = text3(0)
res@gsnCenterString = text4(0)
res@gsnRightString  = text5(0)
res@tmXBLabelsOn    = False
plot1 = gsn_csm_blank_plot (wks,res)

res@gsnLeftString   = text3(2)
res@gsnCenterString = text4(1)
plot3 = gsn_csm_blank_plot (wks,res)

res@gsnLeftString   = text3(1)
res@gsnCenterString = " "
res@gsnRightString  = text5(1)
plot2 = gsn_csm_blank_plot (wks,res)

res@gsnLeftString   = text3(3)
res@tmXBLabelsOn    = True
plot4 = gsn_csm_blank_plot (wks,res)

/;
;-------------------------------------------------------------
;draw upper and lower triangles

;---Create array to hold colors for upper and lower triangles.
cols_for_tris = new(dims,string)

cols_for_tris = where(values.le.ranges(0),colors(0),cols_for_tris)
cols_for_tris = where(values.gt.ranges(nrng-1),colors(nrng),cols_for_tris)
do i=0,nrng-2
 rng_beg = ranges(i)
 rng_end = ranges(i+1)
 cols_for_tris = where(rng_beg.lt.values.and. values.le.rng_end,colors(i+1), cols_for_tris)
end do

;---Retrieve range of axes so we can get width/heights of triangles
getvalues plot
 "trXMinF"   : xmin
 "trXMaxF"   : xmax
 "trYMinF"   : ymin
 "trYMaxF"   : ymax
end getvalues

xsize = (xmax-xmin)/ncols         ; width of triangle
ysize = (ymax-ymin)/nrows         ; height of triangle
xdelta = xsize/10000.
ydelta = ysize/10000.

gnres = True
lnres = True
/;
;-------------------------------------------------------------
;draw upper and lower triangles

;---Create array to hold colors for upper and lower triangles.
cols_for_tris = new(dims,string)

cols_for_tris = where(values.le.ranges(0),colors(0),cols_for_tris)
cols_for_tris = where(values.gt.ranges(nrng-1),colors(nrng),cols_for_tris)
do i=0,nrng-2
 rng_beg = ranges(i)
 rng_end = ranges(i+1)
 cols_for_tris = where(rng_beg.lt.values.and. values.le.rng_end,colors(i+1), cols_for_tris)
end do

;---Retrieve range of axes so we can get width/heights of triangles
getvalues plot
 "trXMinF"   : xmin
 "trXMaxF"   : xmax
 "trYMinF"   : ymin
 "trYMaxF"   : ymax
end getvalues

xsize = (xmax-xmin)/ncols         ; width of triangle
ysize = (ymax-ymin)/nrows         ; height of triangle
xdelta = xsize/10000.
ydelta = ysize/10000.

gnres = True
lnres = True
/;
;-------------------------------------------------------------
;draw upper and lower triangles

;---Create array to hold colors for upper and lower triangles.
cols_for_tris = new(dims,string)

cols_for_tris = where(values.le.ranges(0),colors(0),cols_for_tris)
cols_for_tris = where(values.gt.ranges(nrng-1),colors(nrng),cols_for_tris)
do i=0,nrng-2
 rng_beg = ranges(i)
 rng_end = ranges(i+1)
 cols_for_tris = where(rng_beg.lt.values.and. values.le.rng_end,colors(i+1), cols_for_tris)
end do

;---Retrieve range of axes so we can get width/heights of triangles
getvalues plot
 "trXMinF"   : xmin
 "trXMaxF"   : xmax
 "trYMinF"   : ymin
 "trYMaxF"   : ymax
end getvalues

xsize = (xmax-xmin)/ncols         ; width of triangle
ysize = (ymax-ymin)/nrows         ; height of triangle
xdelta = xsize/10000.
ydelta = ysize/10000.

gnres = True
lnres = True

;---Arrays to hold primitives.
tri  = new((/2,nrows,ncols/),graphic)
line = new((/nrows,ncols/),graphic)

;
; Loop through each row/column of data, and draw the 
; upper and lower triangle.
; 
lnres@gsLineThicknessF = 1.5
do nr = 0,nrows-1
;
; This test becomes necessary when the triangles reach the edge
; of the right axis. The coordinates for the triangles may not
; quite be inside the coordinates of the axes (xmin,xmax,ymin,ymax)
; so we have to subtract a small delta to make sure the coordinates
; are smaller.
;
 if(nr.eq.nrows-1) then
  ypos = ymax - ((nr+1) * (ysize-ydelta))
 else
  ypos = ymax - ((nr+1) * ysize)
 end if
 do nc = 0,ncols-1

;---Upper triangle
  gnres@gsFillColor = cols_for_tris(0,nr,nc)
  ii = nr*ncols+nc
  if(nc.eq.ncols-1) then
   xpos = xmin + (nc * (xsize-xdelta))
  else
   xpos = xmin + (nc * xsize)
  end if
  tri(0,nr,nc) = gsn_add_polygon(wks,plot,(/xpos,xpos+xsize,xpos,xpos/), (/ypos,ypos+ysize,ypos+ysize,ypos/),gnres)
;---Lower triangle
  gnres@gsFillColor = cols_for_tris(1,nr,nc)
  ii = nr*ncols+nc
  if(nc.eq.ncols-1) then
   xpos = xmin + (nc * (xsize-xdelta))
  else
   xpos = xmin + (nc * xsize)
  end if
  tri(1,nr,nc) = gsn_add_polygon(wks,plot, (/xpos,xpos+xsize,xpos+xsize,xpos/), (/ypos,ypos+ysize,ypos,ypos/),gnres)
;---Diagonal line plus box
  line(nr,nc) = gsn_add_polyline(wks,plot, (/xpos,xpos+xsize,xpos+xsize,xpos,xpos,xpos+xsize/), (/ypos,ypos,ypos+ysize,ypos+ysize,ypos,ypos+ysize/),lnres)
 end do
end do

;---Attach primitives to plot id so the "live" outside this function.
plot@triangles = tri
plot@lines     = line
return(plot)
;/
;-------------------------------------------------------------
;Fill each grid box

levels = fspan(-2.65,2.45,18)
;levels = fspan(-.45,.45,10)
;rgba   = read_colormap_file ("WhiteYellowOrangeRed")
rgba   = read_colormap_file ("MPL_coolwarm")
colors = span_color_rgba (rgba, dimsizes(levels))

gnid1 = new((/2,dim(1),dim(2)/),"graphic")
line1 = new((/2,dim(1),dim(2)/),"graphic")

gnres = True
lnres = True

lnres@gsLineThicknessF = 1.5

;gnres@gsFillIndex = 4
gnres@gsFillDotSizeF       = 0.8
gnres@gsFillLineThicknessF = 1.5

do jj = 0,dim(1)-1
 do ii = 0,dim(2)-1
  boxx   = (/ii,ii,ii+1,ii+1,ii/)
  boxy   = (/jj,jj+1,jj+1,jj,jj/)
  index1 = closest_val( R1(0,jj,ii),levels)
  index3 = closest_val( R1(1,jj,ii),levels)
  gnres@gsFillColor = colors(index1,:)
  gnid1(0,jj,ii) = gsn_add_polygon (wks,plot1,boxx,boxy,gnres)
  line1(0,jj,ii) = gsn_add_polyline(wks,plot1,boxx,boxy,lnres)
  gnres@gsFillColor = colors(index3,:)
  gnid1(1,jj,ii) = gsn_add_polygon (wks,plot3,boxx,boxy,gnres)
  line1(1,jj,ii) = gsn_add_polyline(wks,plot3,boxx,boxy,lnres)
 end do
end do

plot1@gnid = gnid1(0,:,:)
plot1@line = line1(0,:,:)
plot3@gnid = gnid1(1,:,:)
plot3@line = line1(1,:,:)

;-------------------------------------------------------------
gnid2 = new((/2,dim(1),dim(2)/),"graphic")
line2 = new((/2,dim(1),dim(2)/),"graphic")

do jj = 0,dim(1)-1
 do ii = 0,dim(2)-1
  boxx   = (/ii,ii,ii+1,ii+1,ii/)
  boxy   = (/jj,jj+1,jj+1,jj,jj/)
  index2 = closest_val( R2(0,jj,ii),levels)
  index4 = closest_val( R2(1,jj,ii),levels)
  gnres@gsFillColor = colors(index2,:)
  gnid2(0,jj,ii) = gsn_add_polygon (wks,plot2,boxx,boxy,gnres)
  line2(0,jj,ii) = gsn_add_polyline(wks,plot2,boxx,boxy,lnres)
  gnres@gsFillColor = colors(index4,:)
  gnid2(1,jj,ii) = gsn_add_polygon (wks,plot4,boxx,boxy,gnres)
  line2(1,jj,ii) = gsn_add_polyline(wks,plot4,boxx,boxy,lnres)
 end do
end do

plot2@gnid = gnid2(0,:,:)
plot2@line = line2(0,:,:)
plot4@gnid = gnid2(1,:,:)
plot4@line = line2(1,:,:)

add_labelbar (wks,plot4,colors,levels(1:)-.05)

;*******************************************
;create panel resources
;*******************************************
resP = True

resP@txString       = "Standard Score of Regression"
resP@txFontHeightF  = .025      ;height of text
resP@gsnPanelRight  = .93

gsn_panel(wks,(/plot1,plot2,plot3,plot4/),(/4,1/),resP)          ; create panel

end
