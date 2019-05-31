impulse_response{1} = [1 1 1 1];
impulse_response{2} = [1 1 0 1]; 
% impulse_response{3} = [1 1 0 1 0 0 0 0 1]; 
message=[1 0 1 1 1];

encoded_data = convolutional_enc(message,impulse_response);
decoded_data = convolutional_dec(encoded_data,impulse_response);
% received_data=[1 0 0 0 1 0 1 1 0 1 0 1 1 0 0 0];
% decoded_data = convolutional_dec(received_data,impulse_response);
