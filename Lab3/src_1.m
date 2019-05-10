figure('Name','QAM','NumberTitle','off');
plot(2,2,1,4,'QAM','Binary')
plot(2,2,2,16,'QAM','Binary')
plot(2,2,3,4,'QAM','Gray')
plot(2,2,4,16,'QAM','Gray')

figure('Name','PAM','NumberTitle','off');
plot(2,4,1,2,'PAM','Binary')
plot(2,4,2,4,'PAM','Binary')
plot(2,4,3,8,'PAM','Binary')
plot(2,4,4,16,'PAM','Binary')
plot(2,4,5,2,'PAM','Gray')
plot(2,4,6,4,'PAM','Gray')
plot(2,4,7,8,'PAM','Gray')
plot(2,4,8,16,'PAM','Gray')

figure('Name','PSK','NumberTitle','off');
plot(2,4,1,2,'PSK','Binary')
plot(2,4,2,4,'PSK','Binary')
plot(2,4,3,8,'PSK','Binary')
plot(2,4,4,16,'PSK','Binary')
plot(2,4,5,2,'PSK','Gray')
plot(2,4,6,4,'PSK','Gray')
plot(2,4,7,8,'PSK','Gray')
plot(2,4,8,16,'PSK','Gray')

function plot(a,b,c,M,constellation,mapping)
    subplot(a,b,c)
    [symbol_sequence, code_sequence] = plot_scatter(M, constellation, mapping);
    scatter(real(symbol_sequence), imag(symbol_sequence),'b.');
    for i=1:size(symbol_sequence,2)
        text(real(symbol_sequence(i)),imag(symbol_sequence(i)),num2str(dec2bin(i-1,int8(log2(M)))),'FontSize',8,'VerticalAlignment','bottom','HorizontalAlignment','center');
    end
    boundary=max(real(symbol_sequence))+0.5;
    axis([-boundary boundary -boundary boundary]);
    title([num2str(M),' ',constellation,',  ',mapping])
    xlabel('In-Phase');
    ylabel('Quadrature');
end

function [symbol_sequence, code_sequence] = plot_scatter(M, constellation, mapping)
    symbol_sequence=[];
    code_sequence=[];
    for i=0:M-1;
        code=num2str(dec2bin(i,int8(log2(M))));
        bin_seq=code-'0';
        symbol = symbol_mapper(bin_seq, M, 1, constellation, mapping);
        symbol_sequence=[symbol_sequence,symbol];
        code_sequence=[code_sequence,code];
    end
end