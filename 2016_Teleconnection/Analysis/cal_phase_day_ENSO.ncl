;*************************************************************
;Aim: calculate days of each composite life cycles phase of Afro-Eurasian teleconnection derived by PC1 and PC2 for ENSO
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. output the days
;                       He Shan
;                       2017-06-27
;
;*************************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

;================================================
;Variables List:
;   var1--------------PC1
;   var2--------------PC2
;   var3--------------INDEX
;================================================

;data
    nPhase  = 4
    r2d     = 180./(4.*atan(1.0))

;time
    mS  = 7
    yS1 = (/1982,1997,2015/)
    yS2 = (/1988,1999/)   ;2016!
    ny1 = dimsizes (yS1)
    ny2 = dimsizes (yS2)

;fig
    out_path = "~/hes/One_Belt_One_Road/NCL/"

; ==============================================================
; Mission 1. Read only the user specified period
; ==============================================================

    f    = addfile ("./PC_Index.nc", "r")
    time = f->time

    pc1   = f->PC1
    pc2   = f->PC2
    index = f->INDEX

    printVarSummary (pc1)
    printVarSummary (pc2)
    printVarSummary (index)

;----------------------------------------------------------
    YYYY    = cd_calendar (time,0)
    year    = floattointeger (YYYY(:,0))
    month   = floattointeger (YYYY(:,1))

;get the time indexs
    El = (year.eq.yS1(0) .and. month.ge.mS .or. year.eq.yS1(0)+1 .and. month.lt.mS)
    do i=1,ny1-1
     El = El.or.(year.eq.yS1(i) .and. month.ge.mS .or. year.eq.yS1(i)+1 .and. month.lt.mS)
    end do

    La = (year.eq.yS2(0) .and. month.ge.mS .or. year.eq.yS2(0)+1 .and. month.lt.mS)
    do i=1,ny2-1
     La = La.or.(year.eq.yS2(i) .and. month.ge.mS .or. year.eq.yS2(i)+1 .and. month.lt.mS)
    end do

    printVarSummary (El)
    printVarSummary (La)

;----------------------------------------------------------
;Phase
    angBnd      = new ( (/2,nPhase/), "float")
    angBnd(0,:) = fspan (0,360-360/nPhase,nPhase)
    angBnd(1,:) = fspan (360/nPhase,360,nPhase)

    ang     = atan2(pc2,pc1)*r2d     ;phase space 
    nn      = ind(ang.lt.0)
    ang(nn) = ang(nn) + 360          ;make 0 to 360
    copy_VarCoords(pc1,ang)
    printVarSummary (ang)
;    print(pc1(:19)+"  "+pc2(:19)+"  "+ang(:19))

    nDaysE = new (nPhase, "integer")
    nDaysL = new (nPhase, "integer")
    pLabel = "P" + ispan(1,nPhase,1)

; ==============================================================
; Mission 2. Post-post process data to deserved results
; ==============================================================

    std_f = stddev (index)
    print (std_f)

do i = 0,nPhase-1
 na = i+nPhase/2             ;temporary adjustment for 0 <= ang < 360/nPhase represents phase nPhase/2+1 not MJO phase 1 
 if(na.gt.nPhase-1) then
  na = na - nPhase
 end if

 ntE        = ind (index.gt.1.2*std_f .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. El)
 ntL        = ind (index.gt.1.2*std_f .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i) .and. La)
 nDaysE(na) = dimsizes (ntE)
 nDaysL(na) = dimsizes (ntL)

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

 system ("rm -f "+out_path+"days_"+pLabel(na)+"_ElNino.nc")
 system ("rm -f "+out_path+"days_"+pLabel(na)+"_LaNina.nc")
 fout1 = addfile ( out_path+"days_"+pLabel(na)+"_ElNino.nc","c")
 fout2 = addfile ( out_path+"days_"+pLabel(na)+"_LaNina.nc","c")

 setfileoption (fout1,"DefineMode",True)
 setfileoption (fout2,"DefineMode",True)

;-----------------------------------------------------------
 ;predefine the coordinate variables and their dimensionality
 dimNames = "time"  
 dimSizes = nDaysE(na)
 dimUnlim = True
 filedimdef (fout1,dimNames,dimSizes,dimUnlim)
 dimSizes = nDaysL(na)
 filedimdef (fout2,dimNames,dimSizes,dimUnlim)

 ;predefine the the dimensionality of the variables to be written out
 filevardef (fout1,"time",typeof(time),getvardims(time))
 filevardef (fout1,"nt",  typeof(ntE), getvardims(time))
 filevardef (fout2,"time",typeof(time),getvardims(time))
 filevardef (fout2,"nt",  typeof(ntL), getvardims(time))

 ;Copy attributes associated with each variable to the file
 filevarattdef (fout1,"time",time)
 filevarattdef (fout1,"nt",  ntE)
 filevarattdef (fout2,"time",time)
 filevarattdef (fout2,"nt",  ntL)

 ;output only the data values
 fout1->time = (/time(ntE)/)
 fout1->nt   = (/ntE/)
 fout2->time = (/time(ntL)/)
 fout2->nt   = (/ntL/)

 delete([/ntE,ntL/])      ;will change next iteration

end do

print ((/nDaysE/)) 
print ((/nDaysL/)) 

end
