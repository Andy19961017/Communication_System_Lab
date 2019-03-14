clear x fs
[x, fs] = audioread('handel.ogg');
subplot(2,1,1)
plot(x);
title('data type: double')
subplot(2,1,2)
plot(single(x))
title('data type: single')