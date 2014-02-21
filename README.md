This is an IDL script to calculate the background order overlap.  The key parameter is the off-band rejection that the filter can provide.  This script seeks to estimate the real specification.

The rough sketch of the code is:

1) Use the observed published Kitt Peak Observatory atmospheric spectrum.  It assumes Earth albedo is 100% everywhere, always.
2) I simulated the grating properties taken from the ACT annual report: 15th order, grating pitch = 11.525 um.
3) I assumed 0.05% off-band rejection.
4) I calculated the approximate wavelength range of the order overlap from the grating equation (in an admittedly half-assed way).
5) I wildly guessed we would pick up orders 8-20.
6) I summed the synthetic background.  For display purposes, I re-normalized the spectrum by (1+ the background mean). 
