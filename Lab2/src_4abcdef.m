symbols = 'abcdefgh'; % Alphabet vector
p = [.3 .2 .2 .1 .05 .05 .05 .05]; % Symbol probability vector

%(c)
n=100;
seq='';
for i=1:n;
    seq=[seq,getSymbol(symbols,p)];
end
dict = huffman_dict(symbols, p);
encoded_seq = huffman_enc(seq, dict);
fprintf('(c)\nlength of encoded binary data : %d\n\n',size(encoded_seq,2));

%(d)
R=1000;
n=100;
L=[];
dict = huffman_dict(symbols, p);
for i=1:R;
    seq='';
    for i=1:n;
        seq=[seq,getSymbol(symbols,p)];
    end
    L=[L, size(huffman_enc(seq, dict), 2)];
end
L_mean=mean(L);
fprintf('(d)\naverage length of the binary data : %d\n\n',L_mean);

%(e)
fprintf('(e)\naverage codeword length : %d\n\n',L_mean/n);

%(f)
R=10000;
n=1000;
L=[];
dict = huffman_dict(symbols, p);
for i=1:R;
    seq='';
    for i=1:n;
        seq=[seq,getSymbol(symbols,p)];
    end
    L=[L, size(huffman_enc(seq, dict), 2)];
end
L_mean=mean(L);
fprintf('(f)\naverage codeword length : %d\n\n',L_mean/n);


