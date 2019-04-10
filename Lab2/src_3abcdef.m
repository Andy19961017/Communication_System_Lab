[x, fs] = audioread('handel.ogg');
x=x';
numBits=4;
L=2^numBits;

%(a)
x_=quantizer_L_level(x, 1, L);
[symbols, p]=signal_to_symbols(x_);

%(b)
dict=huffman_dict(symbols,p);
x_huff_encoded=huffman_enc(x_, dict);

%(c)
x_pcm_encoded=pcm_enc(x_, numBits);

%(d)
fprintf('Data size of Huffman code of original signal (quantized): %d\n', size(x_huff_encoded,2))
fprintf('Data size of PCM code of original signal (quantized): %d\n', size(x_pcm_encoded,2))

%(e)
% x_huff_recover=huffman_dec(x_huff_encoded, dict);
% x_pcm_recover=pcm_dec(x_pcm_encoded,numBits);
% sound(x_,fs);
% sound(x_huff_recover,fs);
% sound(x_pcm_recover,fs);

%(f)
%hard-limiting
x_hard_limiting=x;
x_hard_limiting(x_hard_limiting>0.1)=0.1;
x_hard_limiting(x_hard_limiting<-0.1)=-0.1;
x_hard_limiting=quantizer_L_level(x_hard_limiting, 1, L);
[symbols, p]=signal_to_symbols(x_hard_limiting);
dict=huffman_dict(symbols,p);
x_huff_encoded=huffman_enc(x_hard_limiting, dict);
x_pcm_encoded=pcm_enc(x_hard_limiting, numBits);
fprintf('Data size of Huffman code of hard limiting signal (quantized): %d\n', size(x_huff_encoded,2))
fprintf('Data size of PCM code of hard limiting signal (quantized): %d\n', size(x_pcm_encoded,2))

%squaring
x_squaring = x.^2;
x_squaring=quantizer_L_level(x_squaring, 1, L);
[symbols, p]=signal_to_symbols(x_squaring);
dict=huffman_dict(symbols,p);
x_huff_encoded=huffman_enc(x_squaring, dict);
x_pcm_encoded=pcm_enc(x_squaring, numBits);
fprintf('Data size of Huffman code of squaring signal (quantized): %d\n', size(x_huff_encoded,2))
fprintf('Data size of PCM code of squaring signal (quantized): %d\n', size(x_pcm_encoded,2))

%modulation
x_modulation=x;
for i=1:length(x)
x_modulation(i) = x(i) * exp(1i*2*pi*100*(i/fs));
end
x_modulation=quantizer_L_level(real(x_modulation), 1, L);
[symbols, p]=signal_to_symbols(x_modulation);
dict=huffman_dict(symbols,p);
x_huff_encoded=huffman_enc(x_modulation, dict);
x_pcm_encoded=pcm_enc(x_modulation, numBits);
fprintf('Data size of Huffman code of modulation signal (quantized): %d\n', size(x_huff_encoded,2))
fprintf('Data size of PCM code of modulation signal (quantized): %d\n', size(x_pcm_encoded,2))
