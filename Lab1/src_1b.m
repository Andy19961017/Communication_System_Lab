clear x fs
[x, fs] = audioread('handel.ogg');
% sound(x, fs);
y=single(x);
sound(y, fs);