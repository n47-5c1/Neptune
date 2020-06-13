;*************************************************************
;Aim: Interpolating deserved data from one grid to a 2x2 degree global grid
;Mission:
;
;   1. Read data from sst datasets
;   2. Post-post process to deserved results
;   3. Writing data to a file
;                       He Shan
;                       2017-08-28
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

;================================================
;Variables List:
;   var--------------sst
;================================================

;data
    in_path  = "~/data/observation/SST/"
;HadISST1   1870/01 - , 1x1
;    in_name1 = "HadISST/HadISST_sst.nc"
;COBE SST   1891/01 - , 1x1
    in_name1 = "COBE/sst.mon.mean.2.nc"
;NOAA OISST 1981/12 - , 1x1
    in_name2 = "NOAA_OISST/sst.mnmean.nc"
    in_name3 = "NOAA_OISST/lsmask.nc"

;output
    out_path  = "~/hes/ENSO/Regrid/"
    out_name1 = "HadISST_sst_2x2.nc"
    out_name1 = "COBE2_sst_2x2.nc"
    out_name2 = "NOAA_OISST_sst.mnmean_2x2.nc"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    in1 = addfile (in_path + in_name1,"r")
    in2 = addfile (in_path + in_name2,"r")
    in  = addfile (in_path + in_name3,"r")

;    sst1 = lonFlip (in1->sst)
    sst1 = in1->sst
    sst2 = short2flt (in2->sst)

    time1 = in1->time
    time2 = in2->time
    lmask = in->mask(0,:,:)
    printVarSummary (time1)
    printVarSummary (time2)

;masking of data
    sst1 = where (sst1.lt.-1.8,-1.8,sst1)
;    sst2 = mask (sst2, conform(sst2,lmask,(/1,2/)) ,1)

    printVarSummary (sst1)
    printVarSummary (sst2)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    print ("pre-regrid...")

;Set up options for regridding
    Opt = True

;    Opt@SrcRegional = True
    Opt@WgtFileName = "1x1_2_2x2.nc"
    Opt@SrcFileName = "src_SCRIP_1x1.nc"

;    Opt@DstRegional = True
    Opt@DstGridType = "2x2"
    Opt@DstLLCorner = (/ -88,   0/)
    Opt@DstURCorner = (/  88, 358/)

;    Opt@InterpMethod   = "bilinear"
    Opt@InterpMethod   = "patch"
    Opt@ForceOverwrite = True

;Different destination grid options

    Opt1 = Opt
    Opt2 = Opt

    Opt1@SrcTitle          = "HadISST Grid"
    Opt1@SrcInputFileName  = in_path + in_name1
    Opt1@SrcMask2D         = where ( ismissing (sst1(0,:,:)) ,0,1)

    Opt2@SrcTitle          = "NOAA OISST Grid"
    Opt2@SrcInputFileName  = in_path + in_name2
    Opt2@SrcMask2D         = lmask

;Regrid the data
    sst1_regrid = ESMF_regrid (sst1,Opt1)
    sst1_regrid= where (sst1_regrid.lt.-1.8,-1.8,sst1_regrid)
    printVarSummary (sst1_regrid)
    print (min(sst1_regrid))

    Opt2@SkipSrcGrid = True
    Opt2@SkipDstGrid = True
    Opt2@SkipWgtGen  = True

    sst2_regrid = ESMF_regrid (sst2,Opt2)
    sst2_regrid= where (sst2_regrid.lt.-1.8,-1.8,sst2_regrid)
    printVarSummary (sst2_regrid)
    print (min(sst2_regrid))

; ==============================================================
; Mission 3. Output regridded data
; ==============================================================

dim1 = dimsizes (sst1_regrid)
dim2 = dimsizes (sst2_regrid)
lat  = sst1_regrid&lat
lon  = sst1_regrid&lon

system ("rm -f "+out_path+out_name1)
system ("rm -f "+out_path+out_name2)

fout1 = addfile (out_path+out_name1,"c")
fout2 = addfile (out_path+out_name2,"c")

setfileoption (fout1,"DefineMode",True)
setfileoption (fout2,"DefineMode",True)

;--------------------------------------------------------------
;predefine the coordinate variables and their dimensionality
dimNames  = (/"time","lat","lon"/)  
dimSizes1 = (/dim1(0),dim1(1),dim1(2)/) 
dimSizes2 = (/dim2(0),dim2(1),dim2(2)/) 
dimUnlim  = (/True,False,False/)   

filedimdef (fout1,dimNames,dimSizes1,dimUnlim)
filedimdef (fout2,dimNames,dimSizes2,dimUnlim)

;predefine the the dimensionality of the variables to be written out
filevardef (fout1,"time",typeof(time1),getvardims(time1))
filevardef (fout2,"time",typeof(time2),getvardims(time2))

filevardef (fout1,"lat",typeof(lat),getvardims(lat))
filevardef (fout2,"lat",typeof(lat),getvardims(lat))

filevardef (fout1,"lon",typeof(lon),getvardims(lon))
filevardef (fout2,"lon",typeof(lon),getvardims(lon))

filevardef (fout1,"sst",typeof(sst1_regrid),getvardims(sst1_regrid))
filevardef (fout2,"sst",typeof(sst2_regrid),getvardims(sst2_regrid))

;Copy attributes associated with each variable to the file
filevarattdef (fout1,"time",time1)
filevarattdef (fout2,"time",time2)

filevarattdef (fout1,"lat",lat)
filevarattdef (fout2,"lat",lat)

filevarattdef (fout1,"lon",lon)
filevarattdef (fout2,"lon",lon)

filevarattdef (fout1,"sst",sst1_regrid)
filevarattdef (fout2,"sst",sst2_regrid)

;output only the data values
fout1->time = (/time1/)
fout2->time = (/time2/)

fout1->lat = (/lat/)
fout2->lat = (/lat/)

fout1->lon = (/lon/) 
fout2->lon = (/lon/) 

fout1->sst = (/sst1_regrid/)
fout2->sst = (/sst2_regrid/)

end
