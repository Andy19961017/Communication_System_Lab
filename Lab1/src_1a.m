clear x fs
[x, fs] = audioread('handel.ogg');
sound(x, fs);
sound(x, fs/2);
sound(x, 2*fs);