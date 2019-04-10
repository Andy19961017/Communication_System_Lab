[x, fs] = audioread('handel.ogg');
x=x';
[S, f, t] = STFT(x, 50, 40, 64, fs);
surf(t,f,abs(S));
colorbar
title('original')
xlabel('time');
ylabel('frequency');