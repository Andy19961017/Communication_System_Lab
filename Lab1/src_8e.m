fc=880;
fs=1200;
T=1/fs;
t=linspace(0,2,2*fs);
x=cos(2*pi*fc*t);

subplot(7,1,1)
plot(t,x)
title('x(t)')

subplot(7,1,2)
dft=fft(x);
dft_mag=abs(dft);
dft_phase=angle(dft);
plot(dft_mag);
title('DFT magnitude')
subplot(7,1,3)
plot(dft_phase)
title('DFT phase')


dtft=fftshift(fft(x,2*fs));
% dtft=fftshift(x);
w=linspace(-pi, pi, 2*fs);
subplot(7,1,4)
plot(w, abs(dtft));
title('DTFT magnitude')
subplot(7,1,5)
plot(w, angle(dtft))
title('DTFT phase')


ctft=T*fftshift(fft(x,2*fs));
scale=pi/(T*2*pi)
w=linspace(-scale, scale, 2*fs);
subplot(7,1,6)
plot(w, abs(ctft));
title('CTFT magnitude')
subplot(7,1,7)
plot(w, angle(ctft))
title('CTFT phase')
