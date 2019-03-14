clear x fs
[x, fs] = audioread('handel.ogg');
Wp = [94, 142]/(fs/2);
h = fir1(50, Wp);
% freqz(h)
% impz(h)
title('frequency response')
y = filter(h,1,x);
subplot(2,1,1)
plot(x)
title('original')
subplot(2,1,2)
plot(y)
title('filtered')
% sound(x,fs)
sound(y,fs)


