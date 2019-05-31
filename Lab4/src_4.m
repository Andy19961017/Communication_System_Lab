SNR=[0:5];
message=randi([0 1],1,1000);
subplot(2,1,1);
filter_2_3=simulate(2,3,message);
filter_5_3=simulate(5,3,message);
plot(SNR,filter_2_3);
hold on
plot(SNR,filter_5_3);
hold off
xlabel('E_b/N_0 (dB)');
legend('num of filters:2, filter length:3','num of filters:5, filter length:3');
subplot(2,1,2);
filter_2_6=simulate(2,6,message);
plot(SNR,filter_2_3);
hold on
plot(SNR,filter_2_6);
hold off
xlabel('E_b/N_0 (dB)');
legend('num of filters:2, filter length:3','num of filters:2, filter length:6');



