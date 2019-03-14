clear x fs
[x, fs] = audioread('handel.ogg');

y=x;
for i=1:length(x)
y(i)=quantizer_L_level(x(i),1,16);
end

sound(y, fs)
plot(y)
title('4-bit quantization')

function y = quantizer_L_level(x, x_max, L)
Delta = 2*x_max/L;
y=(floor(x/Delta)+0.5)*Delta;
end