%(a)
oversampling_factor = 1000;
T_os = 1/oversampling_factor;
pulse_duration = 1; % 1 sec
t_axis = (-pulse_duration/2 : T_os : pulse_duration/2 - T_os);
W=50; %Hz
T=1/(2*W);
x=zeros(size(t_axis));
for i=1:size(t_axis,2)
    if -T<t_axis(i) & t_axis(i)<T;
        x(i)=1;
    elseif t_axis(i)==T | t_axis(i)==-T;
        x(i)=0.5;
    end
end

ctft=(1/oversampling_factor)*fftshift(fft(x,oversampling_factor));
scale=oversampling_factor/2;
w=linspace(-scale, scale, oversampling_factor);
n=100;
ctft_sum=ctft;
% subplot(2,1,1);
% plot(t_axis,x);
% title('time domain');
% subplot(2,1,2);
% plot(w,ctft);
% title('frequency domain')

% subplot(10,1,1);
% plot(w,ctft_sum);
% title(sprintf('Iteration %d',0))
% for i=1:9;
%     subplot(10,1,i+1);
%     ctft_sum(1:end-i*n)=ctft_sum(1:end-i*n)+ctft(i*n+1:end);
%     ctft_sum(i*n+1:end)=ctft_sum(i*n+1:end)+ctft(1:end-i*n);
%     plot(w,ctft_sum);
%     title(sprintf('Iteration %d',i))
% end


%(b)
x=sinc(t_axis/T);
ctft=(1/oversampling_factor)*fftshift(fft(x,oversampling_factor));
scale=oversampling_factor/2;
w=linspace(-scale, scale, oversampling_factor);
ctft_sum=ctft;
% subplot(2,1,1);
% plot(t_axis,x);
% title('time domain');
% subplot(2,1,2);
% plot(w,ctft);
% title('frequency domain')

% subplot(10,1,1);
% plot(w,ctft_sum);
% title(sprintf('Iteration %d',0))
% for i=1:9;
%     subplot(10,1,i+1);
%     ctft_sum(1:end-i*n)=ctft_sum(1:end-i*n)+ctft(i*n+1:end);
%     ctft_sum(i*n+1:end)=ctft_sum(i*n+1:end)+ctft(1:end-i*n);
%     plot(w,ctft_sum);
%     title(sprintf('Iteration %d',i))
% end

%(c)
beta=0.25;
x=zeros(size(x));
for i=1:size(t_axis,2)
    if abs(t_axis)==T/(2*beta);
        x(i)=pi/4*sinc(1/(2*beta));
    else
        x(i)=sinc(t_axis(i)/T)*cos(pi*beta*t_axis(i)/T)/(1-4*beta^2*t_axis(i)^2/T^2);
    end
end
ctft=(1/oversampling_factor)*fftshift(fft(x,oversampling_factor));
ctft_sum=ctft;
% subplot(2,1,1);
% plot(t_axis,x);
% title('time domain, \beta=0.25');
% subplot(2,1,2);
% plot(w,ctft);
% title('frequency domain, \beta=0.25')

% subplot(10,1,1);
% plot(w,ctft_sum);
% title(sprintf('Iteration %d',0))
% for i=1:9;
%     subplot(10,1,i+1);
%     ctft_sum(1:end-i*n)=ctft_sum(1:end-i*n)+ctft(i*n+1:end);
%     ctft_sum(i*n+1:end)=ctft_sum(i*n+1:end)+ctft(1:end-i*n);
%     plot(w,ctft_sum);
%     title(sprintf('Iteration %d',i))
% end

% (f)
bit_sequence=randi([0 1],1,20);
symbol_sequence = symbol_mapper(bit_sequence, 4, 2, 'PSK', 'Gray');
sinc_modulation=pulse_shaper(symbol_sequence, 'sinc', 50);
r_cos_modulation=pulse_shaper(symbol_sequence, 'raised cosine', 50);
t_axis=(0:size(sinc_modulation,2)-1)*T_os;
subplot(2,2,1);
plot(t_axis, real(sinc_modulation));
title('sinc modulation, real part');
subplot(2,2,2);
plot(t_axis, imag(sinc_modulation));
title('sinc modulation, imaginary part');
subplot(2,2,3);
plot(t_axis, real(r_cos_modulation));
title('raise cosine modulation, real part');
subplot(2,2,4);
plot(t_axis, imag(r_cos_modulation));
title('raise cosine modulation, imaginary part');


