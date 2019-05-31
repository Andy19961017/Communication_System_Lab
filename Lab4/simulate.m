function BERs=simulate(numOfFilters,filter_length,message)
    for i=1:numOfFilters
        filters{i}=randi([0 1],1,filter_length);
    end
    BERs=[];
    for SNR=0:5
        encoded_data = convolutional_enc(message,filters);
        noise_power=0.25*10^(-SNR/10);
        noisy_sequence=encoded_data;
        for i=1:size(encoded_data,2)
            noisy_sequence(i)=encoded_data(i)+normrnd(0,sqrt(noise_power));
        end
        noisy_sequence=double([noisy_sequence>0.5]);
        decoded_data = convolutional_dec(noisy_sequence,filters);
        BER=sum(message~=decoded_data)/numel(decoded_data);
        BERs=[BERs, BER];
    end
end