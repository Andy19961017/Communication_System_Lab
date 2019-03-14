clear x fs
[x, fs] = audioread('handel.ogg');
y=circshift(x, 100000)
sound(y, fs)
subplot(2,1,1)
plot(x)
title('original')

subplot(2,1,2)
plot(y)
title('circular shifted')
