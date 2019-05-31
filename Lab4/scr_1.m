R=[1,10,100];
for c=1:3
    BERs=[];
    SERs=[];
    for SNR=0:10
        upper_bound=[];
        lower_bound=[];
        M=16;
        bit_sequence=randi([0 1],1,100*R(c));
        symbol_sequence=symbol_mapper(bit_sequence, M, 1, 'QAM', 'Gray');
        ave_sym_power=(M-1)/6;
        ave_bit_power=ave_sym_power/4;
        noise_power=ave_bit_power*10^(-SNR/10)/2;
        for i=1:size(symbol_sequence,2)
            noisy_sequence(i)=symbol_sequence(i)+normrnd(0,sqrt(noise_power))+j*normrnd(0,sqrt(noise_power));
        end
        received=symbol_demapper(noisy_sequence, M, 1, 'QAM', 'Gray', 'MD');
        BER=sum(bit_sequence~=received(1:numel(bit_sequence)))/numel(bit_sequence);
        symbol_error_count=0;
        received_symbol_sequence=symbol_mapper(received(1:numel(bit_sequence)), M, 1, 'QAM', 'Gray');
        SER=sum(symbol_sequence~=received_symbol_sequence)/numel(symbol_sequence);
        BERs=[BERs, BER];
        SERs=[SERs, SER];
    end
    subplot(3,1,c);
    SNR=[0:10];
    k=10.^(SNR/10);
%     Q_exact=zeros(size(k,2));
    for p=1:size(k,2)
        Q_exact(p)=q(sqrt(4*k(p)/5));
    end
    Q_upper=0.5*exp(-2*k/5);
    Q_lower=(1-5./(4*k)).*(5./(8*k*pi).^0.5.*exp(-2*k./5));
    theoretical=3*Q_exact-9/4*Q_exact.^2;
    upper=3*Q_upper;
    lower=Q_lower;
    plot(SNR,SERs);
    hold on
    plot(SNR,BERs);
    plot(SNR,theoretical);
    plot(SNR,upper);
    plot(SNR,lower);
    hold off
    xlabel('E_b/N_0 (dB)');
    ylim([0 0.5])
    legend('SER','BER','SER theoretical','SER upper bound','SER lower bound');
%     legend('SER','BER','SER upper bound');
    title(sprintf('R=%d',R(c)));
end
