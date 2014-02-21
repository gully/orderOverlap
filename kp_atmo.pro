function kp_atmo
;Date: April 25, 2012
;Author: gully
;Desc: returns the atmospheric transmission over kitt peak, from 1-5 um.
;Data is from:  ftp://ftp.noao.edu/catalogs/atmospheric_transmission/
;Hinkle, Wallace, Livingston

;dirKP='/Users/gully/Astronomy/Silicon/Immersion/kittpeak_atmospheric_trans/'
dirKP='/Volumes/cambridge/Astronomy/instruments/kittpeak_atmospheric_trans/'
fnKP='transdata_1_5_mic'
get_lun, lun
OPENR,lun,dirKP+fnKP 
H=DBLARR(2,757760) 
READF,lun,H 
CLOSE,lun

wn=h[0, *]
t=h[1,*]
vacw = 1.0d8 / wn
airw = vacw / (1d0 + 2.735182d-4 + (11.46377774d0/vacw)^2 + (128.9214492d0/vacw)^4) / 1d4 ;in um

outarr=h
outarr[0, *]=airw

free_lun, lun
return, outarr

end