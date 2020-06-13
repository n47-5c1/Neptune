
begin

lonW = 40
lonE = 150
latS = -15
latN = 50

in_name = (/"CTRL","NOTP"/)
season = "JJA"

do i = 0, dimsizes(in_name) - 1
    in_path = "/home/yangsong3/data-model/wuyt/TP_" + in_name(i) + "_F2000_F19G16_CAM4/pro/"
    file1 = "F2000_" + in_name(i) + ".plevel.U.mon.0601-3012.nc"
    file2 = "F2000_" + in_name(i) + ".plevel.V.mon.0601-3012.nc"

    in1 = addfile(in_path + file1, "r")
    in2 = addfile(in_path + file2, "r")
    U_p = in1->U(:,:,{latS:latN},{lonW:lonE})
    V_p = in2->V(:,:,{latS:latN},{lonW:lonE})

;--------------------------------------------------------------
; Webster-Yang index (Asian Monsoon), U850 - U200 (0-20N, 40-110E)
    U = month_to_season(U_p, season)
    V = month_to_season(V_p, season)
    U_WY = dim_avg_n_Wrap(U(:,:,{0:20},{40:110}), (/2,3/))
    WYI = (/U_WY(:,{850}) - U_WY(:,{200})/)
    copy_VarCoords(U_WY(:,0), WYI)

;--------------------------------------------------------------
; East Asian - Western North Pacific monsoon index (Southeast monsoon), Wang et al. (2001)
; U850 (5N-15N, 90E-130E) - U850 (22.5-32.5N, 110-140E)
    U_WNP = U(:,{850},:,:)
    U1_WNP = dim_avg_n_Wrap(U_WNP(:,{5:15},{90:130}), (/1,2/))
    U2_WNP = dim_avg_n_Wrap(U_WNP(:,{22.5:32.5},{110:140}), (/1,2/))
    WNPI = (/U2_WNP - U1_WNP/)      ; -1?
    copy_VarCoords(U1_WNP, WNPI)

;--------------------------------------------------------------
; Dynamic Indian monsoon index, Wang et al. (2001), U850 (5-15N, 40-80E) - U850 (20-30N, 70-90E)
    U_SA = U(:,{850},:,:)
    U1_SA = dim_avg_n_Wrap(U_SA(:,{5:15},{40:80}), (/1,2/))
    U2_SA = dim_avg_n_Wrap(U_SA(:,{20:30},{70:90}), (/1,2/))
    SAI = (/U1_SA - U2_SA/)
    copy_VarCoords(U1_SA, SAI)

;--------------------------------------------------------------
; South Asian monsoon index (RM1), Lau et al. (2000), V850 - V200 (10-30N, 70-110E)
    V_RM1 = dim_avg_n_Wrap(V(:,:,{10:30},{70:110}), (/2,3/))
    RM1I = (/V_RM1(:,{850}) - V_RM1(:,{200})/)
    copy_VarCoords(V_RM1(:,0), RM1I)

;--------------------------------------------------------------
; LKY monsoon index (East Asian monsoon, RM2), U200 (40-50N, 110-150E) - U200 (25-35N, 110-150E)
    U_RM2 = U(:,{200},:,:)
    U1_RM2 = dim_avg_n_Wrap(U_RM2(:,{40:50},{110:150}), (/1,2/))
    U2_RM2 = dim_avg_n_Wrap(U_RM2(:,{25:35},{110:150}), (/1,2/))
    RM2I = (/U1_RM2 - U2_RM2/)
    copy_VarCoords(U1_RM2, RM2I)

;--------------------------------------------------------------
; Australian monsoon index 
; U850 (2.5-15S, 110-150E or 5-15S, 110-130E)
    US = month_to_season(U_p, season)
    AUSI = dim_avg_n_Wrap(US(:,{850},{-15:-5},{110:130}), (/1,2/))
    ndim = dimsizes(AUSI)

; ==============================================================
; Mission 3. Output ENSO pattern data
; ==============================================================
    out_data = "./WY_WNP_SA_RM_AUS_indexes_" + in_name(i) + ".nc"
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
    filevardef(fout, "time", typeof(U&time), getvardims(U&time))
    filevardef(fout, "WYI", typeof(WYI), getvardims(WYI))
    filevardef(fout, "WNPI", typeof(WNPI), getvardims(WNPI))
    filevardef(fout, "SAI", typeof(SAI), getvardims(SAI))
    filevardef(fout, "RM1I", typeof(RM1I), getvardims(RM1I))
    filevardef(fout, "RM2I", typeof(RM2I), getvardims(RM2I))
    filevardef(fout, "AUSI", typeof(AUSI), getvardims(AUSI))

;Copy attributes associated with each variable to the file
    filevarattdef(fout, "time", U&time)
    filevarattdef(fout, "WYI", WYI)
    filevarattdef(fout, "WNPI", WNPI)
    filevarattdef(fout, "SAI", SAI)
    filevarattdef(fout, "RM1I", RM1I)
    filevarattdef(fout, "RM2I", RM2I)
    filevarattdef(fout, "AUSI", AUSI)

;output only the data values
    fout->time = (/U&time/)
    fout->WYI = (/WYI/)
    fout->WNPI = (/WNPI/)
    fout->SAI = (/SAI/)
    fout->RM1I = (/RM1I/)
    fout->RM2I = (/RM2I/)
    fout->AUSI = (/AUSI/)

end do

print("Done!")

end
