fc=880;
fs=8192;
t=linspace(0,2,2*fs);
x=cos(2*pi*fc*t);


dtft=fftshift(fft(x,2*fs));
% dtft=fftshift(x);
w=linspace(-pi, pi, 2*fs);

subplot(2,1,1)
plot(w, abs(dtft));
title('magnitude')
subplot(2,1,2)
plot(w, angle(dtft))
title('phase')