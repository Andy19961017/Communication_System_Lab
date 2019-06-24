function [HDCY, HDCCb, HDCCr, HACY, HACCb, HACCr] = compression4(x)
x = double(x);
Y = zeros(size(x,1),'int16');
Cb = zeros(size(x,1),'int16');
Cr = zeros(size(x,1),'int16');
for a = 1:size(x,1)
    for b = 1:size(x,1)
        Y(a,b) = 0.299*x(a,b,1) + 0.587*x(a,b,2) + 0.114*x(a,b,3);
    end
end
for a = 1:size(x,1)
    for b = 1:size(x,1)
        Cb(a,b) = -0.169*x(a,b,1) - 0.331*x(a,b,2) + 0.5*x(a,b,3) + 128;
    end
end
for a = 1:size(x,1)
    for b = 1:size(x,1)
        Cr(a,b) = 0.5*x(a,b,1) - 0.419*x(a,b,2) - 0.081*x(a,b,3) + 128;
    end
end

Cb2 = zeros(size(x,1)/2,'int16');
Cr2 = zeros(size(x,1)/2,'int16');
for a = 1:size(x,1)/2
    for b = 1:size(x,1)/2
        Cb2(a,b) = (Cb(2*a-1, 2*b) + Cb(2*a, 2*b))/2;
    end
end
for a = 1:size(x,1)/2
    for b = 1:size(x,1)/2
        Cr2(a,b) = (Cr(2*a-1, 2*b) + Cr(2*a, 2*b))/2;
    end
end

for a = 1:4
    for b = 1:4
        if a == 1
            C1(a,b) = 0.5* cos((2*b-1)*(a-1)*pi/8);
        else
            C1(a,b) = 0.5* sqrt(2)* cos((2*b-1)*(a-1)*pi/8);
        end
    end
end
for a = 1:4
    for b = 1:4
            if b == 1
                C2(a,b) = 0.5* cos((2*a-1)*(b-1)*pi/8);
            else
                C2(a,b) = 0.5* sqrt(2)* cos((2*a-1)*(b-1)*pi/8);
            end
    end
end
for a = 1:size(x,1)/4
    for b = 1:size(x,1)/4
        FY((4*a-3):4*a, (4*b-3):4*b) = C1* double(Y((4*a-3):4*a, (4*b-3):4*b))* C2;
    end
end
for a = 1:size(x,1)/8
    for b = 1:size(x,1)/8
        FCb((4*a-3):4*a, (4*b-3):4*b) = C1* double(Cb2((4*a-3):4*a, (4*b-3):4*b))* C2;
    end
end
for a = 1:size(x,1)/8
    for b = 1:size(x,1)/8
        FCr((4*a-3):4*a, (4*b-3):4*b) = C1* double(Cr2((4*a-3):4*a, (4*b-3):4*b))* C2;
    end
end

QY = [16,11,10,16,24,40,51,61;
12,12,14,19,26,58,60,55;
14,13,16,24,40,57,69,56;
14,17,22,29,51,87,80,62;
18,22,37,56,68,109,103,77;
24,35,55,64,81,104,113,92;
49,64,78,87,103,121,120,101;
72,92,95,98,112,103,100,99];
QC = [17,18,24,47,99,99,99,99;
18,21,26,66,99,99,99,99;
24,26,56,99,99,99,99,99;
47,66,99,99,99,99,99,99;
99,99,99,99,99,99,99,99;
99,99,99,99,99,99,99,99;
99,99,99,99,99,99,99,99;
99,99,99,99,99,99,99,99];
for a = 1:4
    for b = 1:4
        QY2(a,b) = (QY(2*a-1,2*b-1)+QY(2*a-1,2*b)+QY(2*a,2*b-1)+QY(2*a,2*b))/4;
        QC2(a,b) = (QC(2*a-1,2*b-1)+QC(2*a-1,2*b)+QC(2*a,2*b-1)+QC(2*a,2*b))/4;
    end
end

for a = 1:size(x,1)/4
    for b = 1:size(x,1)/4
        FY2(4*a-3:4*a, 4*b-3:4*b) = round(FY(4*a-3:4*a, 4*b-3:4*b) ./ QY2);
    end
end
for a = 1:size(x,1)/8
    for b = 1:size(x,1)/8
        FCb2(4*a-3:4*a, 4*b-3:4*b) = round(FCb(4*a-3:4*a, 4*b-3:4*b) ./ QC2);
        FCr2(4*a-3:4*a, 4*b-3:4*b) = round(FCr(4*a-3:4*a, 4*b-3:4*b) ./ QC2);
    end
end

DCY(1,1) = FY2(1,1);
for a = 2:size(x,1)/4
    DCY(a,1) = FY2(4*a-3,1) - FY2(4*a-7,1);
end
for a = 1:size(x,1)/4
    for b = 2:size(x,1)/4
        DCY(a,b) = FY2(4*a-3,4*b-3) - FY2(4*a-3,4*b-7);
    end
end
DCCb(1,1) = FCb2(1,1);
for a = 2:size(x,1)/8
    DCCb(a,1) = FCb2(4*a-3,1) - FCb2(4*a-7,1);
end
for a = 1:size(x,1)/8
    for b = 2:size(x,1)/8
            DCCb(a,b) = FCb2(4*a-3,4*b-3) - FCb2(4*a-3,4*b-7);
    end
end
DCCr(1,1) = FCr2(1,1);
for a = 2:size(x,1)/8
    DCCr(a,1) = FCr2(4*a-3,1) - FCr2(4*a-7,1);
end
for a = 1:size(x,1)/8
    for b = 2:size(x,1)/8
            DCCr(a,b) = FCr2(4*a-3,4*b-3) - FCr2(4*a-3,4*b-7);
    end
end

ACY = cell(size(x,1)/4);
for a = 1:size(x,1)/4
for b = 1:size(x,1)/4
AC(1) = FY2(4*a-3,4*b-2);
AC(2) = FY2(4*a-2,4*b-3);
AC(3) = FY2(4*a-1,4*b-3);
AC(4) = FY2(4*a-2,4*b-2);
AC(5) = FY2(4*a-3,4*b-1);
AC(6) = FY2(4*a-3,4*b);
AC(7) = FY2(4*a-2,4*b-1);
AC(8) = FY2(4*a-1,4*b-2);
AC(9) = FY2(4*a,4*b-3);
AC(10) = FY2(4*a,4*b-2);
AC(11) = FY2(4*a-1,4*b-1);
AC(12) = FY2(4*a-2,4*b);
AC(13) = FY2(4*a-1,4*b);
AC(14) = FY2(4*a,4*b-1);
AC(15) = FY2(4*a,4*b);
count = 0;
for c = 1:15
    if AC(c) == 0
        count = count+1;
    end
    if AC(c) ~= 0
        ACY{a,b} = [ACY{a,b}, count];
        ACY{a,b} = [ACY{a,b}, AC(c)];
        count = 0;
    end
end
end
end

ACCb = cell(size(x,1)/8);
for a = 1:size(x,1)/8
for b = 1:size(x,1)/8
AC(1) = FCb2(4*a-3,4*b-2);
AC(2) = FCb2(4*a-2,4*b-3);
AC(3) = FCb2(4*a-1,4*b-3);
AC(4) = FCb2(4*a-2,4*b-2);
AC(5) = FCb2(4*a-3,4*b-1);
AC(6) = FCb2(4*a-3,4*b);
AC(7) = FCb2(4*a-2,4*b-1);
AC(8) = FCb2(4*a-1,4*b-2);
AC(9) = FCb2(4*a,4*b-3);
AC(10) = FCb2(4*a,4*b-2);
AC(11) = FCb2(4*a-1,4*b-1);
AC(12) = FCb2(4*a-2,4*b);
AC(13) = FCb2(4*a-1,4*b);
AC(14) = FCb2(4*a,4*b-1);
AC(15) = FCb2(4*a,4*b);
count = 0;
for c = 1:15
if AC(c) == 0
count = count+1;
end
if AC(c) ~= 0
ACCb{a,b} = [ACCb{a,b}, count];
ACCb{a,b} = [ACCb{a,b}, AC(c)];
count = 0;
end
end
end
end

ACCr = cell(size(x,1)/8);
for a = 1:size(x,1)/8
for b = 1:size(x,1)/8
AC(1) = FCr2(4*a-3,4*b-2);
AC(2) = FCr2(4*a-2,4*b-3);
AC(3) = FCr2(4*a-1,4*b-3);
AC(4) = FCr2(4*a-2,4*b-2);
AC(5) = FCr2(4*a-3,4*b-1);
AC(6) = FCr2(4*a-3,4*b);
AC(7) = FCr2(4*a-2,4*b-1);
AC(8) = FCr2(4*a-1,4*b-2);
AC(9) = FCr2(4*a,4*b-3);
AC(10) = FCr2(4*a,4*b-2);
AC(11) = FCr2(4*a-1,4*b-1);
AC(12) = FCr2(4*a-2,4*b);
AC(13) = FCr2(4*a-1,4*b);
AC(14) = FCr2(4*a,4*b-1);
AC(15) = FCr2(4*a,4*b);
count = 0;
for c = 1:15
if AC(c) == 0
count = count+1;
end
if AC(c) ~= 0
ACCr{a,b} = [ACCr{a,b}, count];
ACCr{a,b} = [ACCr{a,b}, AC(c)];
count = 0;
end
end
end
end

HDCY = [];
HDCCb = [];
HDCCr = [];
for i = 1:size(DCY,1)
    for j = 1:size(DCY,2)
        if DCY(i,j) == 0
            HDCY = [HDCY,0,0];
        elseif DCY(i,j) == 1
            HDCY = [HDCY,0,1,0,1];
        elseif DCY(i,j) == -1
            HDCY = [HDCY,0,1,0,0];
        elseif abs(DCY(i,j)) < 4
            HDCY = [HDCY,0,1,1];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 0;
                DC2 = DCY(i,j)-2;
                for k = 1:1
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 0;
                DC2 = DCY(i,j)-(-3);
                for k = 1:1
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
        elseif abs(DCY(i,j)) < 8
            HDCY = [HDCY,1,0,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 1;
                DC2 = DCY(i,j)-4;
                for k = 1:2
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 1;
                DC2 = DCY(i,j)-(-7);
                for k = 1:2
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
          elseif abs(DCY(i,j)) < 16
            HDCY = [HDCY,1,0,1];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 2;
                DC2 = DCY(i,j)-8;
                for k = 1:3
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 2;
                DC2 = DCY(i,j)-(-15);
                for k = 1:3
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 32
            HDCY = [HDCY,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 3;
                DC2 = DCY(i,j)-16;
                for k = 1:4
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 3;
                DC2 = DCY(i,j)-(-31);
                for k = 1:4
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 64
            HDCY = [HDCY,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 4;
                DC2 = DCY(i,j)-32;
                for k = 1:5
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 4;
                DC2 = DCY(i,j)-(-63);
                for k = 1:5
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 128
            HDCY = [HDCY,1,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 5;
                DC2 = DCY(i,j)-64;
                for k = 1:6
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 5;
                DC2 = DCY(i,j)-(-127);
                for k = 1:6
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 256
            HDCY = [HDCY,1,1,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 6;
                DC2 = DCY(i,j)-128;
                for k = 1:7
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 6;
                DC2 = DCY(i,j)-(-255);
                for k = 1:7
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 512
            HDCY = [HDCY,1,1,1,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 7;
                DC2 = DCY(i,j)-256;
                for k = 1:8
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 7;
                DC2 = DCY(i,j)-(-511);
                for k = 1:8
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 1024
            HDCY = [HDCY,1,1,1,1,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 8;
                DC2 = DCY(i,j)-512;
                for k = 1:9
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 8;
                DC2 = DCY(i,j)-(-1023);
                for k = 1:9
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCY(i,j)) < 2048
            HDCY = [HDCY,1,1,1,1,1,1,1,1,0];
            if DCY(i,j) > 0
                HDCY = [HDCY,1];
                c = 9;
                DC2 = DCY(i,j)-1024;
                for k = 1:10
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCY = [HDCY,0];
                c = 9;
                DC2 = DCY(i,j)-(-2047);
                for k = 1:10
                    HDCY = [HDCY, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
        end
    end
end

for i = 1:size(DCCb,1)
    for j = 1:size(DCCb,2)
        if DCCb(i,j) == 0
            HDCCb = [HDCCb,0,0];
        elseif DCCb(i,j) == 1
            HDCCb = [HDCCb,0,1,1];
        elseif DCCb(i,j) == -1
            HDCCb = [HDCCb,0,1,0];
        elseif abs(DCCb(i,j)) < 4
            HDCCb = [HDCCb,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 0;
                DC2 = DCCb(i,j)-2;
                for k = 1:1
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 0;
                DC2 = DCCb(i,j)-(-3);
                for k = 1:1
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
        elseif abs(DCCb(i,j)) < 8
            HDCCb = [HDCCb,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 1;
                DC2 = DCCb(i,j)-4;
                for k = 1:2
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 1;
                DC2 = DCCb(i,j)-(-7);
                for k = 1:2
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
          elseif abs(DCCb(i,j)) < 16
            HDCCb = [HDCCb,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 2;
                DC2 = DCCb(i,j)-8;
                for k = 1:3
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 2;
                DC2 = DCCb(i,j)-(-15);
                for k = 1:3
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 32
            HDCCb = [HDCCb,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 3;
                DC2 = DCCb(i,j)-16;
                for k = 1:4
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 3;
                DC2 = DCCb(i,j)-(-31);
                for k = 1:4
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 64
            HDCCb = [HDCCb,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 4;
                DC2 = DCCb(i,j)-32;
                for k = 1:5
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 4;
                DC2 = DCCb(i,j)-(-63);
                for k = 1:5
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 128
            HDCCb = [HDCCb,1,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 5;
                DC2 = DCCb(i,j)-64;
                for k = 1:6
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 5;
                DC2 = DCCb(i,j)-(-127);
                for k = 1:6
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 256
            HDCCb = [HDCCb,1,1,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 6;
                DC2 = DCCb(i,j)-128;
                for k = 1:7
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 6;
                DC2 = DCCb(i,j)-(-255);
                for k = 1:7
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 512
            HDCCb = [HDCCb,1,1,1,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 7;
                DC2 = DCCb(i,j)-256;
                for k = 1:8
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 7;
                DC2 = DCCb(i,j)-(-511);
                for k = 1:8
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 1024
            HDCCb = [HDCCb,1,1,1,1,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 8;
                DC2 = DCCb(i,j)-512;
                for k = 1:9
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 8;
                DC2 = DCCb(i,j)-(-1023);
                for k = 1:9
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCb(i,j)) < 2048
            HDCCb = [HDCCb,1,1,1,1,1,1,1,1,1,1,0];
            if DCCb(i,j) > 0
                HDCCb = [HDCCb,1];
                c = 9;
                DC2 = DCCb(i,j)-1024;
                for k = 1:10
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCb = [HDCCb,0];
                c = 9;
                DC2 = DCCb(i,j)-(-2047);
                for k = 1:10
                    HDCCb = [HDCCb, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
        end
    end
end

for i = 1:size(DCCr,1)
    for j = 1:size(DCCr,2)
        if DCCr(i,j) == 0
            HDCCr = [HDCCr,0,0];
        elseif DCCr(i,j) == 1
            HDCCr = [HDCCr,0,1,1];
        elseif DCCr(i,j) == -1
            HDCCr = [HDCCr,0,1,0];
        elseif abs(DCCr(i,j)) < 4
            HDCCr = [HDCCr,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 0;
                DC2 = DCCr(i,j)-2;
                for k = 1:1
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 0;
                DC2 = DCCr(i,j)-(-3);
                for k = 1:1
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
        elseif abs(DCCr(i,j)) < 8
            HDCCr = [HDCCr,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 1;
                DC2 = DCCr(i,j)-4;
                for k = 1:2
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 1;
                DC2 = DCCr(i,j)-(-7);
                for k = 1:2
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
          elseif abs(DCCr(i,j)) < 16
            HDCCr = [HDCCr,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 2;
                DC2 = DCCr(i,j)-8;
                for k = 1:3
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 2;
                DC2 = DCCr(i,j)-(-15);
                for k = 1:3
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 32
            HDCCr = [HDCCr,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 3;
                DC2 = DCCr(i,j)-16;
                for k = 1:4
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 3;
                DC2 = DCCr(i,j)-(-31);
                for k = 1:4
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 64
            HDCCr = [HDCCr,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 4;
                DC2 = DCCr(i,j)-32;
                for k = 1:5
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 4;
                DC2 = DCCr(i,j)-(-63);
                for k = 1:5
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 128
            HDCCr = [HDCCr,1,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 5;
                DC2 = DCCr(i,j)-64;
                for k = 1:6
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 5;
                DC2 = DCCr(i,j)-(-127);
                for k = 1:6
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 256
            HDCCr = [HDCCr,1,1,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 6;
                DC2 = DCCr(i,j)-128;
                for k = 1:7
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 6;
                DC2 = DCCr(i,j)-(-255);
                for k = 1:7
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 512
            HDCCr = [HDCCr,1,1,1,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 7;
                DC2 = DCCr(i,j)-256;
                for k = 1:8
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 7;
                DC2 = DCCr(i,j)-(-511);
                for k = 1:8
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 1024
            HDCCr = [HDCCr,1,1,1,1,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 8;
                DC2 = DCCr(i,j)-512;
                for k = 1:9
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 8;
                DC2 = DCCr(i,j)-(-1023);
                for k = 1:9
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
            
            elseif abs(DCCr(i,j)) < 2048
            HDCCr = [HDCCr,1,1,1,1,1,1,1,1,1,1,0];
            if DCCr(i,j) > 0
                HDCCr = [HDCCr,1];
                c = 9;
                DC2 = DCCr(i,j)-1024;
                for k = 1:10
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            else
                HDCCr = [HDCCr,0];
                c = 9;
                DC2 = DCCr(i,j)-(-2047);
                for k = 1:10
                    HDCCr = [HDCCr, floor(DC2/2^c)];
                    DC2 = DC2 - 2^c * floor(DC2/2^c);
                    c = c-1;
                end
            end
        end
    end
end

HACY = [];
HACCb = [];
HACCr = [];
for i = 1:size(ACY,1)
    for j = 1:size(ACY,2)
        for k = 1:length(ACY{i,j})/2
            if ACY{i,j}(2*k-1) >= 16
                ACY{i,j}(2*k+2:length(ACY{i,j})+2) = ACY{i,j}(2*k:length(ACY{i,j}));
                ACY{i,j}(2*k+1) = ACY{i,j}(2*k-1)-16;
                ACY{i,j}(2*k) = 0;
                ACY{i,j}(2*k-1) = 15;
            end
        end
    end
end
for i = 1:size(ACCb,1)
    for j = 1:size(ACCb,2)
        for k = 1:length(ACCb{i,j})/2
            if ACCb{i,j}(2*k-1) >= 16
                ACCb{i,j}(2*k+2:length(ACCb{i,j})+2) = ACCb{i,j}(2*k:length(ACCb{i,j}));
                ACCb{i,j}(2*k+1) = ACCb{i,j}(2*k-1)-16;
                ACCb{i,j}(2*k) = 0;
                ACCb{i,j}(2*k-1) = 15;
            end
        end
    end
end
for i = 1:size(ACCr,1)
    for j = 1:size(ACCr,2)
        for k = 1:length(ACCr{i,j})/2
            if ACCr{i,j}(2*k-1) >= 16
                ACCr{i,j}(2*k+2:length(ACCr{i,j})+2) = ACCr{i,j}(2*k:length(ACCr{i,j}));
                ACCr{i,j}(2*k+1) = ACCr{i,j}(2*k-1)-16;
                ACCr{i,j}(2*k) = 0;
                ACCr{i,j}(2*k-1) = 15;
            end
        end
    end
end

for i = 1:size(ACY,1)
    for j = 1:size(ACY,2)
        if length(ACY{i,j}) == 0
            HACY = [HACY,1,0,1,0];
        end
        for k = 1:length(ACY{i,j})/2
            if ACY{i,j}(2*k-1) == 0
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,0,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,0,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 1
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,0,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,0,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 2
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,0,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,0,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 3
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,0,1,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,0,1,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 4
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,0,1,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,0,1,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 5
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,0,1,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,0,1,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 6
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,0,1,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,0,1,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 7
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,0,1,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,0,1,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 8
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,0,0,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,0,0,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 9
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,0,0,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 10
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,0,1,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,0,1,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 11
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,1,0,0,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 12
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,1,0,1,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,1,0,1,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 13
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,0,0,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,0,0,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 14
                if ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACY{i,j}(2*k-1) == 15
                if ACY{i,j}(2*k) == 0
                    HACY = [HACY,1,1,1,1,1,1,1,1,0,0,1];
                elseif ACY{i,j}(2*k) == 1
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1];
                elseif ACY{i,j}(2*k) == -1
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0];
                elseif abs(ACY{i,j}(2*k)) < 4
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-2;
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 0;
                        AC2 = ACY{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 8
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-4;
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 1;
                        AC2 = ACY{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 16
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-8;
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 2;
                        AC2 = ACY{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 32
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-16;
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 3;
                        AC2 = ACY{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 64
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-32;
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 4;
                        AC2 = ACY{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 128
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-64;
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 5;
                        AC2 = ACY{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 256
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-128;
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 6;
                        AC2 = ACY{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 512
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-256;
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 7;
                        AC2 = ACY{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACY{i,j}(2*k)) < 1024
                    HACY = [HACY,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0];
                    if ACY{i,j}(2*k) > 0
                        HACY = [HACY,1];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-512;
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACY = [HACY,0];
                        c = 8;
                        AC2 = ACY{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACY = [HACY, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            if k == length(ACY{i,j})/2
                HACY = [HACY,1,0,1,0];
            end
        end
    end
end

for i = 1:size(ACCb,1)
    for j = 1:size(ACCb,2)
        if length(ACCb{i,j}) == 0
            HACCb = [HACCb,0,0];
        end
        for k = 1:length(ACCb{i,j})/2
            if ACCb{i,j}(2*k-1) == 0
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,0,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,0,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 1
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,0,1,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,0,1,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 2
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,0,1,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,0,1,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 3
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,0,1,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,0,1,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 4
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,0,1,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,0,1,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 5
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,0,1,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,0,1,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 6
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,0,0,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,0,0,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 7
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,0,1,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,0,1,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 8
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,0,0,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,0,0,1,0];          
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 9
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,0,1,1,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,0,1,1,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 10
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,0,0,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,0,0,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 11
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,0,0,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 12
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,0,1,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,0,1,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 13
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,0,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 14
                if ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCb{i,j}(2*k-1) == 15
                if ACCb{i,j}(2*k) == 0
                    HACCb = [HACCb,1,1,1,1,1,1,1,0,1,0];
                elseif ACCb{i,j}(2*k) == 1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1];
                elseif ACCb{i,j}(2*k) == -1
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0];
                elseif abs(ACCb{i,j}(2*k)) < 4
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-2;
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 0;
                        AC2 = ACCb{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 8
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-4;
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 1;
                        AC2 = ACCb{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 16
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-8;
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 2;
                        AC2 = ACCb{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 32
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-16;
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 3;
                        AC2 = ACCb{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 64
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-32;
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 4;
                        AC2 = ACCb{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 128
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-64;
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 5;
                        AC2 = ACCb{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 256
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-128;
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 6;
                        AC2 = ACCb{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 512
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-256;
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 7;
                        AC2 = ACCb{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCb{i,j}(2*k)) < 1024
                    HACCb = [HACCb,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0];
                    if ACCb{i,j}(2*k) > 0
                        HACCb = [HACCb,1];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-512;
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCb = [HACCb,0];
                        c = 8;
                        AC2 = ACCb{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCb = [HACCb, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            if k == length(ACCb{i,j})/2
                HACCb = [HACCb,0,0];
            end
        end
    end
end

for i = 1:size(ACCr,1)
    for j = 1:size(ACCr,2)
        if length(ACCr{i,j}) == 0
            HACCr = [HACCr,0,0];
        end
        for k = 1:length(ACCr{i,j})/2
            if ACCr{i,j}(2*k-1) == 0
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,0,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,0,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 1
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,0,1,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,0,1,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 2
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,0,1,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,0,1,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 3
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,0,1,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,0,1,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 4
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,0,1,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,0,1,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 5
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,0,1,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,0,1,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 6
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,0,0,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,0,0,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 7
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,0,1,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,0,1,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 8
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,0,0,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,0,0,1,0];          
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 9
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,0,1,1,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,0,1,1,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 10
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,0,0,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,0,0,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 11
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,0,0,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 12
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,0,1,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,0,1,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 13
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,0,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,0,0,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 14
                if ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            
            if ACCr{i,j}(2*k-1) == 15
                if ACCr{i,j}(2*k) == 0
                    HACCr = [HACCr,1,1,1,1,1,1,1,0,1,0];
                elseif ACCr{i,j}(2*k) == 1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1];
                elseif ACCr{i,j}(2*k) == -1
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0];
                elseif abs(ACCr{i,j}(2*k)) < 4
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-2;
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 0;
                        AC2 = ACCr{i,j}(2*k)-(-3);
                        for d = 1:1
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 8
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-4;
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 1;
                        AC2 = ACCr{i,j}(2*k)-(-7);
                        for d = 1:2
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 16
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-8;
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 2;
                        AC2 = ACCr{i,j}(2*k)-(-15);
                        for d = 1:3
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 32
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-16;
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 3;
                        AC2 = ACCr{i,j}(2*k)-(-31);
                        for d = 1:4
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 64
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-32;
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 4;
                        AC2 = ACCr{i,j}(2*k)-(-63);
                        for d = 1:5
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 128
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-64;
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 5;
                        AC2 = ACCr{i,j}(2*k)-(-127);
                        for d = 1:6
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 256
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-128;
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 6;
                        AC2 = ACCr{i,j}(2*k)-(-255);
                        for d = 1:7
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 512
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-256;
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 7;
                        AC2 = ACCr{i,j}(2*k)-(-511);
                        for d = 1:8
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                    
                elseif abs(ACCr{i,j}(2*k)) < 1024
                    HACCr = [HACCr,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0];
                    if ACCr{i,j}(2*k) > 0
                        HACCr = [HACCr,1];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-512;
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    else
                        HACCr = [HACCr,0];
                        c = 8;
                        AC2 = ACCr{i,j}(2*k)-(-1023);
                        for d = 1:9
                            HACCr = [HACCr, floor(AC2/2^c)];
                            AC2 = AC2 - 2^c * floor(AC2/2^c);
                            c = c-1;
                        end
                    end
                end
            end
            if k == length(ACCr{i,j})/2
                HACCr = [HACCr,0,0];
            end
        end
    end
end

end
