clear x fs
[x, fs] = audioread('handel.ogg');
% sound(x, fs);

x_clip=x;
x_clip(x_clip>0.05)=0.05;
x_clip(x_clip<-0.05)=-0.05;
sound(x_clip, fs);

x_square = x.^2;
% sound(x_square, fs);

x_neg = -x;
% sound(x_neg, fs);

subplot(4,1,1);
plot(x)
title('original')

subplot(4,1,2);
plot(x_clip)
title('hard limit 0.05')

subplot(4,1,3);
plot(x_square)
title('squaring')

subplot(4,1,4);
plot(x_neg)
title('negation')