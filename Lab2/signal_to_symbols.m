function [symbols, p]=signal_to_symbols(x);
    symbols=[];
    p=[];
    for i=1:size(x,2);
        idx=find(symbols==x(i));
        if size(idx,2)>0;
            p(idx)=p(idx)+1;
        else
            symbols(size(symbols,2)+1)=x(i);
            p(size(symbols,2))=1;
        end
    end
    p=p/sum(p);
end