pro ACT_atmo_model

;Author: gully
;Date: February 21, 2014

cd, ''
dat = kp_atmo()

plot, dat[0, *], dat[1, *], yrange=[0, 1], xrange=[1.598, 1.659], xstyle=1

wl=dat[0, *]*1000.0
fl=dat[1, *]

lb=1598.0 ;nm
ub=1659.0 ;nm


gi=where((wl gt lb) and (wl lt ub))
n_gwls=n_elements(gi)

;Use the grating properties to get the background

;orders
nm=12
mms=findgen(nm)+8.0

pi=3.141592654
lam_nm=1628.0 ;nm
sigma1=11525.0 ;nm
alpha_deg=11.647 ;deg
beta_deg=24.15 ;deg
alpha=pi/180.0*alpha_deg
beta=pi/180.0*beta_deg

l_fsr=mms*0.0
l_lb=mms*0.0
l_ub=mms*0.0

backg=0.0
ind_back=fltarr(nm, n_gwls)

for i=0, nm-1 do begin

  this_n=sellmeier_si(lam_nm, 273.0)
  lam_blaze= this_n/mms[i]*sigma1*(sin(alpha)+sin(beta))
  revised_n=sellmeier_si(lam_blaze, 273.0)
  lam_blaze= revised_n/mms[i]*sigma1*(sin(alpha)+sin(beta))
  
  print, mms[i], lam_blaze
  
  l_fsr[i]=lam_blaze/15.0 ;should this be mms[i]??
  l_lb[i]=lam_blaze-l_fsr[i]/2.0
  l_ub[i]=lam_blaze+l_fsr[i]/2.0
  
  syn_i=where((wl gt l_lb[i]) and (wl lt l_ub[i]))
  
  ;congrid it
  
  x_interp=l_lb[i]+findgen(n_gwls)/n_gwls*l_fsr[i]
  fl_int=interpol(fl[syn_i], wl[syn_i], x_interp)
  
  const=0.001 ;30 dB suppression
  ind_back[i, *]=fl_int*const
  backg=backg+ind_back[i, *]

endfor

wl_g=wl[gi]
fl_g=fl[gi]
fl_b=(fl_g+backg)/(1.0+mean(backg))


device, set_character_size=[9, 12]


tot_back=0
gif_set=1
cd, '/Volumes/cambridge/Astronomy/silicon/ACT/spectrograph/atmo_background/'
device, decomposed=1
device, RETAIN=2
window, 0

for i=0, nm-1 do begin
  plot, wl_g, ind_back[i, *], yrange=[0, 0.025], ystyle=1, xrange=[1598, 1659], xstyle=1, background='FFFFFF'xL, color='000000'xL, $
    xtitle='wavelength (nm)', ytitle='relative intensity', title='Simulation of astmospheric background spectrum'
  if mms[i] ne 15 then tot_back=tot_back+ind_back[i, *]
  oplot, wl_g, tot_back, color='0000FF'xL
  out_1='background contribution from: '
  out_message=strcompress('order: '+string(fix(mms[i])))
  out_2= strcompress( number_formatter(l_lb[i], decimals=0) + '< wavelength < '  +  number_formatter(l_ub[i], decimals=0)   )
  xyouts, 1602.0, 0.020, out_1, /data, color='000000'xL, charsize=2.0
  xyouts, 1643.0, 0.020, out_message, /data, color='000000'xL, charsize=2.0
  xyouts, 1602.0, 0.015, out_2, /data, color='000000'xL, charsize=2.0 
  
    if gif_set then begin    
      WSET, 0
      image24=TVRD(true=1)
      image2d=color_quan(image24, 1, r, g, b)
      outfile=strcompress("ACT_model_"+string(i,FORMAT="(I03)"), /remove_all)
      write_gif, outfile+'.gif', image2d, r, g, b
    endif
  
  wait, 0.1
endfor  

spawn, 'gifsicle --delay=20 --loop ACT_model_* > '+ $
        strcompress('ACT_mod_anim.gif', /remove_all)
spawn, 'rm ACT_model_*'


window, 10
plot, wl_g, fl_g, yrange=[0, 1], xrange=[1608, 1652], xstyle=1, background='FFFFFF'xL, color='000000'xL, $
      xtitle='wavelength (nm)', ytitle='relative intensity', title='Simulation of astmospheric background spectrum'
oplot, wl_g, fl_b, color='FF0000'xL
xyouts, 1625.0, 0.8, '0.1% = off-band', /data, color='0000FF'xL, charsize=1.0

window, 11
plot, wl_g, fl_b/fl_g, yrange=[0.997, 1.01], xrange=[1608, 1652], xstyle=1, ystyle=1, background='FFFFFF'xL, color='000000'xL, $
      xtitle='wavelength (nm)', ytitle='Ratio: Synthetic/Real', title='Simulation of astmospheric background spectrum'
xyouts, 1608.3, 0.9975, '0.1% = off-band', /data, color='0000FF'xL, charsize=1.0

rat1=fl_b/fl_g
out_text=['#Predicted order overlap for ACT grating, assuming 0.1% off-band rejection.', $
           '#Model by Michael Gully-Santiago on 2/25/2014 using ACT_atmo_model.pro', $
           '#Custom source code available at: https://github.com/gully/orderOverlap', $
           '#',$
           '#wavelength (nm), Real atmos. trans., Ratio of (sythetic/real)']
forprint,  wl_g, fl_g, rat1,   textout='ACT_order_overlap_1630nm_30dB.dat', comment=out_text


 print, 1

end