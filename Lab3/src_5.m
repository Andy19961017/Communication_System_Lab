time_span=0.1;

% import data
[x, fs] = audioread('handel.ogg');
x=x';
x=x(1:time_span*fs);
numBits=4;
L=2^numBits;

% quantization
disp('quantization...')
x_=quantizer_L_level(x, 1, L);
[symbols, p]=signal_to_symbols(x_);

% eocoding to bit sequence
disp('eocoding to bit sequence...')
x_pcm_encoded=pcm_enc(x_, numBits);

% symbol mapping
disp('symbol mapping...')
M=16;
symbol_sequence=symbol_mapper(x_pcm_encoded, M, 1, 'QAM', 'Gray');

SNR_0=porcess(0,symbol_sequence,M,x_pcm_encoded,numBits);
SNR_10=porcess(10,symbol_sequence,M,x_pcm_encoded,numBits);
SNR_20=porcess(20,symbol_sequence,M,x_pcm_encoded,numBits);

subplot(4,1,1);
plot(linspace(0,time_span-1/fs, size(x_,2)),x_);
title('original quantized signal')
subplot(4,1,2);
plot(linspace(0,time_span-1/fs, size(SNR_0,2)),SNR_0);
title('SNR=0');
subplot(4,1,3);
plot(linspace(0,time_span-1/fs, size(SNR_10,2)),SNR_10);
title('SNR=10');
subplot(4,1,4);
plot(linspace(0,time_span-1/fs, size(SNR_20,2)),SNR_20);
title('SNR=20');
sound(SNR_20, fs)

function y=porcess(SNR,symbol_sequence,M,x_huff_encoded,numBits)
    % add Gaussian noise
    disp('add Gaussian noise...')
    noisy_sequence=symbol_sequence;
    ave_sym_power=(M-1)/6;
    noise_power=ave_sym_power*10^(-SNR/10);
    for i=1:size(symbol_sequence,2)
        noisy_sequence(i)=symbol_sequence(i)+normrnd(0,sqrt(noise_power))+j*normrnd(0,sqrt(noise_power));
    end

    % symbol demapping
    disp('symbol demapping...')
    received=symbol_demapper(noisy_sequence, M, 1, 'QAM', 'Gray', 'MD');
    received=received(1:numel(x_huff_encoded));

    % PCM decode
    disp('PCM decoding...')
    x_pcm_recover=pcm_dec(received,numBits);
    y=x_pcm_recover;
end