clear x fs
[x, fs] = audioread('handel.ogg');

y=x;
for i=1:length(x)
y(i) = x(i) * exp(1i*2*pi*100*(i/fs));
end

y_real=arrayfun(@real, y);
y_mag=arrayfun(@abs, y);
y_phase=arrayfun(@angle, y);

sound(y_real, fs)
% sound(y_mag)
% sound(y_phase)
subplot(3,1,1)
plot(y_real)
title('real part')
subplot(3,1,2)
plot(y_mag)
title('magnitude')
subplot(3,1,3)
plot(y_phase)
title('phase')