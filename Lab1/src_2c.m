clear x fs
[x, fs] = audioread('handel.ogg');
y = flipud(x);
size(x)
z = [x;y]
sound(z, fs)
audiowrite('output_file.wav', z, fs)