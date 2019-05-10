function y=pcm_dec(code, numBits);
    y=[];
    L=2^numBits;
    Delta = 2/L;
    min=-1+0.5*Delta;
    len=size(code,2);
    ptr=1;
    while ptr<len;
        codeword=code(ptr:ptr+numBits-1);
        y=[y,min+Delta*bin2dec(num2str([codeword]))];
        ptr=ptr+numBits;
    end
end