% (a)
d=2;
% bit_sequence=randi([0 1],1,20);
% symbol_sequence = symbol_mapper(bit_sequence, 4, d, 'PSK', 'Gray');
% 
% SNR=[0,10,20];
% for k=1:3
%     noisy_sequence=symbol_sequence;
%     power=2*10^(-SNR(k)/10);
%     for i=1:size(symbol_sequence,2)
%         noisy_sequence(i)=symbol_sequence(i)+normrnd(0,sqrt(power))+j*normrnd(0,sqrt(power));
%     end
%     subplot(1,3,k);
%     scatter(real(noisy_sequence), imag(noisy_sequence));
%     hold on
%     scatter(real(symbol_sequence), imag(symbol_sequence));
%     hold off
%     axh = gca; % use current axes
%     color = 'k'; % black, or [0 0 0]
%     linestyle = '-'; % dotted
%     line([-4,4], [0 0], 'Color', color, 'LineStyle', linestyle);
%     line([0 0], [-4,4], 'Color', color, 'LineStyle', linestyle);
%     title(sprintf('SNR: %d', SNR(k)));
% end

% (c)
bit_sequence=randi([0 1],1,1000);
QPSK_b=[];
QPSK_g=[];
PAM2_g=[];
PAM4_g=[];
PSK8_g=[];
QAM4_g=[];
QAM16_g=[];
PAM16_g=[];
PSK16_g=[];
QAM16_b=[];
for SNR=0:25
    disp('SNR');
    disp(SNR);
%     QPSK_b=[QPSK_b, simulation(bit_sequence, 4, 'PSK', 'Binary', 'MD', SNR)];
%     QPSK_g=[QPSK_g, simulation(bit_sequence, 4, 'PSK', 'Gray', 'MD', SNR)];
%     PAM2_g=[PAM2_g, simulation(bit_sequence, 2, 'PAM', 'Gray', 'MD', SNR)];
%     PAM4_g=[PAM4_g, simulation(bit_sequence, 4, 'PAM', 'Gray', 'MD', SNR)];
%     PSK8_g=[PSK8_g, simulation(bit_sequence, 8, 'PSK', 'Gray', 'MD', SNR)];
%     QAM4_g=[QAM4_g, simulation(bit_sequence, 4, 'QAM', 'Gray', 'MD', SNR)];
    QAM16_g=[QAM16_g, simulation(bit_sequence, 16, 'PSK', 'Gray', 'MD', SNR)];
    QAM16_b=[QAM16_b, simulation(bit_sequence, 16, 'PSK', 'Binary', 'MD', SNR)];
%     PAM16_g=[PAM16_g, simulation(bit_sequence, 16, 'PAM', 'Gray', 'MD', SNR)];
%     PSK16_g=[PSK16_g, simulation(bit_sequence, 16, 'PSK', 'Gray', 'MD', SNR)];  
end
subplot(1,1,1);
plot_error_rate(QAM16_b, '16-PSK + Binary', QAM16_g, '16-PSK + Gray', '', '');
subplot(5,1,1);
plot_error_rate(QPSK_b, 'QPSK + Binary', QPSK_g, 'QPSK + Gray', '', '');
subplot(5,1,2);
plot_error_rate(PAM2_g, '2-PAM + Gray', PAM4_g, '4-PAM + Gray', '', '');
subplot(5,1,3);
plot_error_rate(QPSK_g, 'QPSK + Gray', PSK8_g, '8-PSK + Gray', '', '');
subplot(5,1,4);
plot_error_rate(QAM4_g, '4-QAM + Gray', QAM16_g, '16-QAM + Gray', '', '');
subplot(5,1,5);
plot_error_rate(PAM16_g, '16-PAM + Gray', PSK16_g, '16-PSK + Gray', QAM16_g, '16-QAM + Gray');
% plot_error_rate(PSK16_g, '16-PSK + Gray', QAM16_g, '16-QAM + Gray', '', '');

function error_rate=simulation(bit_sequence, M, constellation, mapping, decision_rule, SNR)
    symbol_sequence=symbol_mapper(bit_sequence, M, 1, constellation, mapping);
    noisy_sequence=symbol_sequence;
    if strcmp(constellation, 'PAM')
        ave_sym_power=(M^2-1)/12;
    elseif strcmp(constellation, 'PSK')
        ave_sym_power=1/(2-cos(2*pi/M));
    elseif strcmp(constellation, 'QAM')
        ave_sym_power=(M-1)/6;
    end
    noise_power=ave_sym_power*10^(-SNR/10);
    for i=1:size(symbol_sequence,2)
        noisy_sequence(i)=symbol_sequence(i)+normrnd(0,sqrt(noise_power))+j*normrnd(0,sqrt(noise_power));
    end
    received=symbol_demapper(noisy_sequence, M, 1, constellation, mapping, decision_rule);
    diffelements=sum(bit_sequence~=received(1:numel(bit_sequence)));
    error_rate=diffelements/numel(bit_sequence);
end

function plot_error_rate(data1, title1, data2, title2, data3, title3)
    plot([0:25],data1);
    hold on
    plot([0:25],data2);
    hold off
    if ~strcmp(title3, '')
        hold on
        plot([0:25],data3);
        hold off  
        legend(title1,title2,title3);
        title([title1,' vs ',title2, ' vs ', title3])
    else
        legend(title1,title2);
        title([title1,' vs ',title2])
    end
end