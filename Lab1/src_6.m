clear x fs
[x, fs] = audioread('handel.ogg');

y=x;
for i=1:length(x)
    y(i)=x(i)+sqrt(0.01)*randn;
end

sound(y, fs)
subplot(2,1,1)
plot(x)
title('original')
subplot(2,1,2)
plot(y)
title('y[n] = x[n] + w[n]')