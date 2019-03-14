fc=880;
fs=8192;
t=linspace(0,2,2*fs);
x=cos(2*pi*fc*t);
% plot(t,x)

dft=fft(x);
dft_mag=abs(dft);
dft_phase=angle(dft);
subplot(2,1,1);
plot(dft_mag);
title('magnitude')
subplot(2,1,2)
plot(dft_phase)
title('phase')