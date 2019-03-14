clear x fs
[x, fs] = audioread('handel.ogg');

x_up = upsample(x,2)
x_down = downsample(x,2)

sound(x_up, fs)
sound(x_down, fs)