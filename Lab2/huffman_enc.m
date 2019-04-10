function y = huffman_enc(x, dict);
    y=[];
    for i=1:size(x,2);
        for j=1:size(dict,1);
            if dict{j,1}==x(i);
                y=[y,dict{j,2}];
                break
            end
        end
    end
end
