fc=880;
fs=8192;
t=linspace(0,2,2*fs);
x=cos(2*pi*fc*t);
% plot(t,x)
sound(x, fs)