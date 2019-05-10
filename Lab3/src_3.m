% (a)
W=50;
oversampling_factor = 1000;
T_os = 1/oversampling_factor;
bit_sequence=randi([0 1],1,20);
symbol_sequence = symbol_mapper(bit_sequence, 4, 2, 'PSK', 'Gray');
x=pulse_shaper(symbol_sequence, 'raised cosine', W);
t_axis=(0:size(sinc_modulation,2)-1)*T_os;

for i=1:size(t_axis,2)
    x(i)=x(i)*sqrt(2)*exp(j*2*pi*100*t_axis(i));
end

ctft=(1/size(x,2))*fftshift(fft(x,size(x,2)));
scale=size(x,2)/2;
w=linspace(-scale, scale, size(x,2));

% subplot(2,2,1);
% plot(t_axis,real(x));
% title('real, time domain');
% subplot(2,2,2);
% plot(t_axis,imag(x));
% title('imaginary, time domain');
% subplot(2,2,3);
% plot(w,real(ctft));
% title('real, frequency domain');
% subplot(2,2,4);
% plot(w,imag(ctft));
% title('imaginary, frequency domain');

% (b)
power=6.3*10^(-3);
for i=1:size(x,2)
    x_noise(i)=x(i)+normrnd(0,sqrt(power));
end
% subplot(2,1,1);
% plot(t_axis, real(x));
% title('original signal')
% subplot(2,1,2);
% plot(t_axis, real(x_noise));
% title('noisy signal');

% (c)
x=real(x_noise);
in_phase=x;
quadrature=x;
for i=1:size(x,2)
    in_phase(i)=in_phase(i)*sqrt(2)*cos(pi*100*t_axis(i));
    quadrature(i)=-quadrature(i)*sqrt(2)*sin(2*pi*100*t_axis(i));
end
in_phase=lowpass(in_phase, (W*1+0.25), oversampling_factor);
quadrature=lowpass(quadrature, (W*1+0.25), oversampling_factor);
y=in_phase+j*quadrature;

ctft=(1/size(y,2))*fftshift(fft(y,size(y,2)));
scale=size(y,2)/2;
w=linspace(-scale, scale, size(y,2));

subplot(2,2,1);
plot(t_axis, real(y));
title('time domain, real');
subplot(2,2,2);
plot(t_axis, imag(y));
title('time domain, imaginary');
subplot(2,2,3);
plot(w, real(ctft));
title('frequency domain, real');
subplot(2,2,4);
plot(w, imag(ctft));
title('frequency domain, imaginary');
