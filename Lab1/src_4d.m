clear x fs
[x, fs] = audioread('handel.ogg');

y2=x;
for i=1:length(x)
y2(i)=quantizer_L_level(x(i),1,4);
end

y1=x;
for i=1:length(x)
y1(i)=quantizer_L_level(x(i),1,2);
end

subplot(2,1,1)
plot(y2)
title('2-bit quantization')

subplot(2,1,2)
plot(y1)
title('1-bit quantization')

sound(y2, fs)
sound(y1, fs)

function y = quantizer_L_level(x, x_max, L)
Delta = 2*x_max/L;
y=(floor(x/Delta)+0.5)*Delta;
end