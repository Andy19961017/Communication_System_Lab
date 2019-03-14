clear x fs
[x, fs] = audioread('handel.ogg');

sound(0.2*x+1, fs)