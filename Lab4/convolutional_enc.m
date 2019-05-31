function encoded_data = convolutional_enc(binary_data, impulse_response)
%Function:  Encodes a Rate 1/3 Convolution Code
%m = message to encode
%g = n generators corresponding to the n outputs
%n = 1/n Convolution Encoder -- # of generators

%First Perform Convolution of Input Message for Each Generator.  This
%produces n outputs... [y{1},y{2},...,y{n}]
n=length(impulse_response)
for i = 1:n
    y{i} = mod(conv(binary_data,impulse_response{i}),2);
end

%Initialize code word to all zeros
encoded_data = zeros(1,n*length(y{1}));

%Assemble code word from n outputs
for i = 0:n-1
    encoded_data(1+i:n:end) = y{i+1};
end

