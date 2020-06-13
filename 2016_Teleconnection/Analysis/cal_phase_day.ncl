;*************************************************************
;Aim: calculate days of each composite life cycles phase of extreme Afro-Eurasian teleconnection derived by PC1 and PC2
;Mission:
;
;   1. Read data from datasets
;   2. Post-post process to deserved results
;   3. output the days
;                       He Shan
;                       2017-06-24
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

    nDays  = new (nPhase, "integer")
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

 nt        = ind (index.gt.4*std_f .and. ang.ge.angBnd(0,i) .and. ang.lt.angBnd(1,i))
 nDays(na) = dimsizes (nt)

; ==============================================================
; Mission 3. Output the teleconnectivity
; ==============================================================

 system ("rm -f "+out_path+"days_"+pLabel(na)+".nc")
 fout = addfile ( out_path+"days_"+pLabel(na)+".nc","c")

 setfileoption (fout,"DefineMode",True)

;-----------------------------------------------------------
 ;predefine the coordinate variables and their dimensionality
 dimNames = "time"  
 dimSizes = nDays(na)
 dimUnlim = True
 filedimdef (fout,dimNames,dimSizes,dimUnlim)

 ;predefine the the dimensionality of the variables to be written out
 filevardef (fout,"time",typeof(time),getvardims(time))
 filevardef (fout,"nt",typeof(nt),getvardims(time))

 ;Copy attributes associated with each variable to the file
 filevarattdef (fout,"time",time)
 filevarattdef (fout,"nt",nt)

 ;output only the data values
 fout->time = (/time(nt)/)
 fout->nt   = (/nt/)

 delete([/nt,fout/])      ;will change next iteration

end do

print (nDays) 

end
