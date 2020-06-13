;*************************************************************
;Aim: Calculate (normalize?) monthly March-August WPSH, IO, WNP, ENSO, and NAO indexes removed trend
;Mission:
;
;   1. Read data from dataset
;   2. Post-post process to deserved results
;   3. Output the results
;                       Shan He
;                       2019-06-25
;
;*************************************************************

begin

;================================================
;Variables List:
;   var1--------------hgt
;   var2--------------sst
;   var3--------------slp
;================================================

;NOAA ERSST 1981/01 - , 0.25x0.25
in_name2 = "~/data/observation/SST/OISST_daily/mean/sst.day.mean.*.v2.nc"
;NCEP-NCAR Reanalysis 1 1979/01 - , 2.5x2.5
in_path = "~/data-observation/NCEP_DOE/daily/"
in_name1 = "hgt/hgt.*.nc"
in_name3 = "mslp/mslp.*.nc"

yS = 1982
yE = 2018

opt = True
opt@segment_length = 5

;western Pacific subtropical high index
latN1 = 25
latS1 = 15
lonW1 = 115
lonE1 = 150

;Indian Ocean index
latN2 = 10
latS2 = -10
lonW2 = 50
lonE2 = 110

;western North Pacific index
latN3 = 15
latS3 = 0
lonW3 = 120
lonE3 = 160

;ENSO index
latN4 = 5
latS4 = -15
lonW4 = -170
lonE4 = -130

;North Atlantic Oscillation index
lat5 = 65
lonW5 = -80
lonE5 = 30

lat6 = 35
lonW6 = -80 
lonE6 = 30

;fig
out_data = "./WPSH_IO_WNP_ENSO_NAO_indexes.nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================
files1 = systemfunc("ls " + in_path + in_name1)
files2 = systemfunc("ls " + in_name2)
files3 = systemfunc("ls " + in_path + in_name3)
setfileoption("nc", "SuppressClose", False)   ;close too many files
in1 = addfiles(files1, "r")
in2 = addfiles(files2, "r")
in3 = addfiles(files3, "r")
ListSetType(in1, "cat")
ListSetType(in2, "cat")
ListSetType(in3, "cat")

time1 = in1[:]->time
time2 = in2[:]->time

;get the time indexs
TIME1 = cd_calendar(time1, 0)
year1 = toint(TIME1(:,0))
iYYYY1 = ind(year1.ge.yS .and. year1.le.yE)
month1 = toint(TIME1(:,1))
day1 = toint(TIME1(:,2)) 
ddd1 = day_of_year(year1, month1, day1)
yyyyddd1 = year1(iYYYY1) * 1000 + ddd1(iYYYY1)

TIME2 = cd_calendar(time2, 0)
year2 = toint(TIME2(:,0))
iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)
month2 = toint(TIME2(:,1))
day2 = toint(TIME2(:,2)) 
ddd2 = day_of_year(year2, month2, day2)
yyyyddd2 = year2(iYYYY2) * 1000 + ddd2(iYYYY2)
;year2 = cd_calendar(time2,-1) / 100
;iYYYY2 = ind(year2.ge.yS .and. year2.le.yE)

;creat weights: cos(lat)
rad = 4.0 * atan(1.0) / 180.0
gw1 = in1[0]->lat
gw2 = in2[0]->lat
;gw = in->latitude
gw1 = (/cos(rad * gw1)/)
gw2 = (/cos(rad * gw2)/)

;----------------------------------------------------------
hgt = short2flt(in1[:]->hgt(iYYYY1,2,:,:))
sst = lonFlip(in2[:]->sst(iYYYY2,:,:))
mslp = lonFlip(short2flt(in3[:]->mslp(iYYYY1,:,:)))
printVarSummary(hgt)
printVarSummary(sst)
printVarSummary(mslp)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================
;Monthly anomalies removed trend
clm1 = clmDayTLL(hgt, yyyyddd1)
clm2 = clmDayTLL(sst, yyyyddd2)
clm3 = clmDayTLL(mslp, yyyyddd1)
clm1_sm = smthClmDayTLL(clm1, 4)
clm2_sm = smthClmDayTLL(clm2, 4)
clm3_sm = smthClmDayTLL(clm3, 4)

Anom1 = calcDayAnomTLL(hgt, yyyyddd1, clm1_sm)
delete([/hgt,clm1,clm1_sm/])
Anom2 = calcDayAnomTLL(sst, yyyyddd2, clm2_sm)
delete([/sst,clm2,clm2_sm/])
Anom3 = calcDayAnomTLL(mslp, yyyyddd1, clm3_sm)
delete([/mslp,clm3,clm3_sm/])
Anom1 = (/dtrend_msg_n(Anom1&time, Anom1, False, False, 0)/)
Anom2 = (/dtrend_msg_n(Anom2&time, Anom2, False, False, 0)/)
Anom3 = (/dtrend_msg_n(Anom3&time, Anom3, False, False, 0)/)
xSeg1 = calculate_segment_values(Anom1, "avg", 0, opt)
xSeg2 = calculate_segment_values(Anom2, "avg", 0, opt)
xSeg3 = calculate_segment_values(Anom3, "avg", 0, opt)
print("Segment DONE!")
printVarSummary(xSeg1)
printVarSummary(xSeg2)
printVarSummary(xSeg3)

WPSHI = wgt_areaave_Wrap(xSeg1(:,{latS1:latN1},{lonW1:lonE1}), gw1({latS1:latN1}), 1., 0)
IOI = wgt_areaave_Wrap(xSeg2(:,{latS2:latN2},{lonW2:lonE2}), gw2({latS2:latN2}), 1., 0)
WNPI = wgt_areaave_Wrap(xSeg2(:,{latS3:latN3},{lonW3:lonE3}), gw2({latS3:latN3}), 1., 0)
ENSOI = wgt_areaave_Wrap(xSeg2(:,{latS4:latN4},{lonW4:lonE4}), gw2({latS4:latN4}), 1., 0)
NAOIN = dim_avg_Wrap(xSeg3(:,{lat5},{lonW5:lonE5}))
NAOIS = dim_avg_Wrap(xSeg3(:,{lat6},{lonW6:lonE6}))
ndim = dimsizes(WPSHI)
/;
WPSHI = dim_standardize_Wrap(WPSHI, 0)
IOI = dim_standardize_Wrap(IOI, 0)
WNPI = dim_standardize_Wrap(WNPI, 0)
ENSOI = dim_standardize_Wrap(ENSOI,0)
NAOIN = dim_standardize_Wrap(NAOIN, 0)
;/

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
system("rm -f " + out_data)
fout = addfile(out_data, "c")
setfileoption(fout, "DefineMode", True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames = (/"time"/)
dimSizes = (/ndim/)
dimUnlim = (/False/)

filedimdef(fout, dimNames, dimSizes, dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef(fout, "time", typeof(time1), getvardims(WPSHI&time))
filevardef(fout, "WPSHI", typeof(WPSHI), getvardims(WPSHI))
filevardef(fout, "IOI", typeof(IOI), getvardims(IOI))
filevardef(fout, "WNPI", typeof(WNPI), getvardims(WNPI))
filevardef(fout, "ENSOI", typeof(ENSOI), getvardims(ENSOI))
filevardef(fout, "NAOIN", typeof(NAOIN), getvardims(NAOIN))
filevardef(fout, "NAOIS", typeof(NAOIS), getvardims(NAOIS))

;Copy attributes associated with each variable to the file
filevarattdef(fout, "time", time1)
filevarattdef(fout, "WPSHI", WPSHI)
filevarattdef(fout, "IOI", IOI)
filevarattdef(fout, "WNPI", WNPI)
filevarattdef(fout, "ENSOI", ENSOI)
filevarattdef(fout, "NAOIN", NAOIN)
filevarattdef(fout, "NAOIS", NAOIS)

;output only the data values
fout->time = (/WPSHI&time/)
fout->WPSHI = (/WPSHI/)
fout->IOI = (/IOI/)
fout->WNPI = (/WNPI/)
fout->ENSOI = (/ENSOI/)
fout->NAOIN = (/NAOIN/)
fout->NAOIS = (/NAOIS/)

print((/WPSHI(:9)/))
print((/IOI(:9)/))
print((/WNPI(:9)/))
print((/ENSOI(:9)/))
print((/NAOIN(:9)/))
print((/NAOIS(:9)/))

print("Done!")

end
