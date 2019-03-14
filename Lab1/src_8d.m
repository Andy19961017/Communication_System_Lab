fc=880;
fs=8192;
T=1/fs;
t=linspace(0,2,2*fs);
x=cos(2*pi*fc*t);


ctft=T*fftshift(fft(x,2*fs));
% dtft=fftshift(x);
scale=pi/(T*2*pi)
w=linspace(-scale, scale, 2*fs);

subplot(2,1,1)
plot(w, abs(ctft));
title('magnitude')
subplot(2,1,2)
plot(w, angle(ctft))
title('phase')