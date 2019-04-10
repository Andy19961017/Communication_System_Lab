clear
fs=400;
T=1/fs;

%1(a)
t=linspace(0,1,1*fs+1);
x1=x(t);
ctft_x1=T*fftshift(fft(x1,1*fs));
scale=1/(T*2);
w=linspace(-scale, scale, 1*fs);
subplot(3,2,1);
plot(t,x1);
title('x_1(t)');
ylabel('magnitude');
xlabel('t(sec)');
subplot(3,2,2);
plot(w,ctft_x1);
title('CTFT of x_1(t)');
ylabel('magnitude');
xlabel('f(Hz)');

%1(b)
t=linspace(2.5,3.5,1*fs+1);
x2=x(t);
ctft_x2=T*fftshift(fft(x2,1*fs));
scale=1/(T*2);
w=linspace(-scale, scale, 1*fs);
subplot(3,2,3);
plot(t,x2);
title('x_2(t)');
ylabel('magnitude');
xlabel('t(sec)');
subplot(3,2,4);
plot(w,ctft_x2);
title('CTFT of x_2(t)');
ylabel('magnitude');
xlabel('f(Hz)');

%1(b) bonus
t=linspace(0,1,1*fs+1);
x3=0.5*cos(2*pi*50*t)+0.5*cos(2*pi*100*t);
ctft_x3=T*fftshift(fft(x3,1*fs));
scale=1/(T*2);
w=linspace(-scale, scale, 1*fs);
subplot(3,2,5);
plot(t,x3);
title('0.5*cos(2*pi*50*t)+0.5*cos(2*pi*100*t)');
ylabel('magnitude');
xlabel('t(sec)');
subplot(3,2,6);
plot(w,ctft_x3);
title('CTFT');
ylabel('magnitude');
xlabel('f(Hz)');

function y=x(t);
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