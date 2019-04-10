%(e)
t=linspace(0,1,20);
x=cos(t);
% length of x is 20
numBits=5;
L=2^numBits;
x_max=1;
y = quantizer_L_level(x, x_max, L);
% length of y is 20, y is quantized
z = pcm_enc(y, numBits);
% length of z is 20*numBits=100
disp(z);

%(f)(g)(h)
symbols = 'abcde'; % Alphabet vector
p = [.3 .1 .2 .3 .1]; % Symbol probability vector
dict = huffman_dict(symbols, p);
y = huffman_enc('bca', dict);
% encode 'bca' into y
x_dec = huffman_dec(y, dict);
% decode y back to 'bca'
disp(x_dec);
