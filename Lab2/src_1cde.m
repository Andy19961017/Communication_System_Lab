% (c) (d)
fs=400;
time=linspace(0,4,4*fs+1);
x1=xx(time);

[S, f, t] = STFT(x1, 50, 40, 64, fs);
subplot(2,2,1);
surf(t,f,abs(S));
colorbar
title('window=50, Noverlap=40')
xlabel('time');
ylabel('frequency');

[S, f, t] = STFT(x1, 50, 20, 64, fs);
subplot(2,2,2);
surf(t,f,abs(S));
colorbar
title('window=50, Noverlap=20')
xlabel('time');
ylabel('frequency');

[S, f, t] = STFT(x1, 100, 80, 64, fs);
subplot(2,2,3);
surf(t,f,abs(S));
colorbar
title('window=100, Noverlap=80')
xlabel('time');
ylabel('frequency');

[S, f, t] = STFT(x1, 100, 40, 64, fs);
subplot(2,2,4);
surf(t,f,abs(S));
colorbar
title('window=100, Noverlap=40')
xlabel('time');
ylabel('frequency');

% spectrogram(x1,50, 40, 64, 400)


% (e)
clear
[x, fs] = audioread('handel.ogg');

x_hard_limiting=x;
x_hard_limiting(x_hard_limiting>0.05)=0.05;
x_hard_limiting(x_hard_limiting<-0.05)=-0.05;

x_squaring = x.^2;

x_modulation=x;
for i=1:length(x)
x_modulation(i) = x(i) * exp(1i*2*pi*100*(i/fs));
end

x_quantization = quantizer_L_level(x, 1, 8);

figure;
[S, f, t] = STFT(x, 2048, 1024, 2048, fs);
surf(t,f(1024-100:1025+100),abs(S(1024-100:1025+100,:)));
colorbar
title('original')
xlabel('time');
ylabel('frequency');


figure;
[S, f, t] = STFT(x_hard_limiting, 2048, 1024, 2048, fs);
surf(t,f(1024-100:1025+100),abs(S(1024-100:1025+100,:)));
colorbar
title('hard limiting')
xlabel('time');
ylabel('frequency');

figure;
[S, f, t] = STFT(x_squaring, 2048, 1024, 2048, fs);
surf(t,f(1024-100:1025+100),abs(S(1024-100:1025+100,:)));
colorbar
title('squaring')
xlabel('time');
ylabel('frequency');

figure;
[S, f, t] = STFT(x_modulation, 2048, 1024, 2048, fs);
surf(t,f(1024-100:1025+100),abs(S(1024-100:1025+100,:)));
colorbar
title('modulation')
xlabel('time');
ylabel('frequency');

figure;
[S, f, t] = STFT(x_quantization, 2048, 1024, 2048, fs);
surf(t,f(1024-100:1025+100),abs(S(1024-100:1025+100,:)));
colorbar
title('quantization')
xlabel('time');
ylabel('frequency');


function y=xx(t);
    y=t;
    for i=1:size(t,2);
        if 0<=t(i) & t(i)<1;
            y(i)=cos(2*pi*10*t(i));
        elseif 1<=t(i) & t(i)<2;
            y(i)=cos(2*pi*25*t(i));
        elseif 2<=t(i) & t(i)<3;
            y(i)=cos(2*pi*50*t(i));
        elseif 3<=t(i) & t(i)<4;
            y(i)=cos(2*pi*100*t(i));
        else
            y(i)=0;
        end
    end
end
