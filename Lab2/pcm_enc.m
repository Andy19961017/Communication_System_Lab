function y = pcm_enc(x, numBits);
    y=[];
    L=2^numBits;
    Delta = 2/L;
    min=-1+0.5*Delta;
    for i=1:size(x,2);
        k=dec2bin(int64((x(i)-min)/Delta));
        while(size(k,2)<numBits);
            k=['0',k];
        end
        for j=1:size(k,2);
            if k(j)=='1';
                y=[y,1];
            else
                y=[y,0];
            end
        end
    end
end