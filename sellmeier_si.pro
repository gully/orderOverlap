function sellmeier_si, lam_nm, t_K

;author: gully
;date: 5/4/2012
;desc: Returns the index of refraction of Si, 
; given a wavelength and temperature in the range:
; 20<T<300
; 1.1< wl <5.6
;t_K should be a scalar
;lam can be a vector or scalar
lam_um=lam_nm/1000.0
l=lam_um

if lam_um lt 1.0 or lam_um gt 5.6 then stop
if t_K lt 20 or t_K gt 400 then stop

s1j=[10.4907,-2.08020E-04,4.21694E-06,-5.82298E-09,3.44688E-12]
s2j=[-1346.61,29.1664,-0.278724,1.05939E-03,-1.35089E-06]
s3j=[4.42827E+07,-1.76213E+06,-7.61575E+04,678.414,103.243]

s1=poly(t_K, s1j)
s2=poly(t_K, s2j)
s3=poly(t_K, s3j)

l1j=[0.299713,-1.14234E-05,1.67134E-07,-2.51049E-10,2.32484E-14]
l2j=[-3.51710E+03,42.3892,-0.357957,1.17504E-03,-1.13212E-06]
l3j=[1.71400E+06,-1.44984E+05,-6.90744E+03,-39.3699,23.5770]

l1=poly(t_K, l1j)
l2=poly(t_K, l2j)
l3=poly(t_K, l3j)

l_2=l^2
n2=1.0 + (s1*l_2/(l_2-l1^2)) + (s2*l_2/(l_2-l2^2)) + (s3*l_2/(l_2-l3^2))
n=sqrt(n2)

return, n

end