function x_dec = huffman_dec(y, dict);
    code=y;
    x_dec=[];
    while size(code,2)>0;
        for ptr=1:size(code,2);
            seq=code(1:ptr);
            matched_seq=false;
            for i=1:size(dict,1);
                if size(dict{i,2},2)~=ptr;
                    continue
                end
                match=true;
                for j=1:ptr;
                    if seq(j)~=dict{i,2}(j);
                        match=false;
                        break
                    end
                end
                if match;
                    x_dec=[x_dec, dict{i,1}];
                    code(1:ptr)=[];
                    matched_seq=true;
                    break
                end
            end
            if matched_seq;
                break
            end
        end
    end                      
end