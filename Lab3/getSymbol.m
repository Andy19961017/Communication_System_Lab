function s=getSymbol(symbols, p);
    r=rand;
    for i=1:size(symbols,2);
        if r<p(i);
            s=symbols(i);
            break
        else
            r=r-p(i);
        end
    end
end