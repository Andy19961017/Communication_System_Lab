function x2 = inv_compression(HDCY, HDCCb, HDCCr, HACY, HACCb, HACCr, sz)
count = 1;
count2 = 0;
while count2 < sz*sz/64
        if HDCY(count:count+1) == [0,0]
            count = count+2;
            count2 = count2+1;
            DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 0;
        elseif HDCY(count:count+3) == [0,1,0,1]
            count = count+4;
            count2 = count2+1;
            DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 1;
        elseif HDCY(count:count+3) == [0,1,0,0]
            count = count+4;
            count2 = count2+1;
            DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -1;
        elseif HDCY(count:count+2) == [0,1,1]
            if HDCY(count+3) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 2 + dot(HDCY(count+4), [1]);
                count = count+5;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -3 + dot(HDCY(count+4), [1]);
                count = count+5;
            end
        elseif HDCY(count:count+2) == [1,0,0]
            if HDCY(count+3) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 4 + dot(HDCY(count+4:count+5), [2,1]);
                count = count+6;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -7 + dot(HDCY(count+4:count+5), [2,1]);
                count = count+6;
            end
        elseif HDCY(count:count+2) == [1,0,1]
            if HDCY(count+3) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 8 + dot(HDCY(count+4:count+6), [4,2,1]);
                count = count+7;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -15 + dot(HDCY(count+4:count+6), [4,2,1]);
                count = count+7;
            end
        elseif HDCY(count:count+2) == [1,1,0]
            if HDCY(count+3) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 16 + dot(HDCY(count+4:count+7), [8,4,2,1]);
                count = count+8;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -31 + dot(HDCY(count+4:count+7), [8,4,2,1]);
                count = count+8;
            end
        elseif HDCY(count:count+3) == [1,1,1,0]
            if HDCY(count+4) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 32 + dot(HDCY(count+5:count+9), [16,8,4,2,1]);
                count = count+10;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -63 + dot(HDCY(count+5:count+9), [16,8,4,2,1]);
                count = count+10;
            end     
        elseif HDCY(count:count+4) == [1,1,1,1,0]
            if HDCY(count+5) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 64 + dot(HDCY(count+6:count+11), [32,16,8,4,2,1]);
                count = count+12;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -127 + dot(HDCY(count+6:count+11), [32,16,8,4,2,1]);
                count = count+12;
            end 
        elseif HDCY(count:count+5) == [1,1,1,1,1,0]
            if HDCY(count+6) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 128 + dot(HDCY(count+7:count+13), [64,32,16,8,4,2,1]);
                count = count+14;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -255 + dot(HDCY(count+7:count+13), [64,32,16,8,4,2,1]);
                count = count+14;
            end 
        elseif HDCY(count:count+6) == [1,1,1,1,1,1,0]
            if HDCY(count+7) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 256 + dot(HDCY(count+8:count+15), [128,64,32,16,8,4,2,1]);
                count = count+16;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -511 + dot(HDCY(count+8:count+15), [128,64,32,16,8,4,2,1]);
                count = count+16;
            end 
        elseif HDCY(count:count+7) == [1,1,1,1,1,1,1,0]
            if HDCY(count+8) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 512 + dot(HDCY(count+9:count+17), [256,128,64,32,16,8,4,2,1]);
                count = count+18;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -1023 + dot(HDCY(count+9:count+17), [256,128,64,32,16,8,4,2,1]);
                count = count+18;
            end 
        elseif HDCY(count:count+8) == [1,1,1,1,1,1,1,1,0]
            if HDCY(count+9) == 1
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = 1024 + dot(HDCY(count+10:count+19), [512,256,128,64,32,16,8,4,2,1]);
                count = count+20;
            else
                count2 = count2+1;
                DCY2(ceil(count2/sz*8),mod(count2-1,sz/8)+1) = -2047 + dot(HDCY(count+10:count+19), [512,256,128,64,32,16,8,4,2,1]);
                count = count+20;
            end 
        end
end

count = 1;
count2 = 0;
while count2 < sz*sz/256
        if HDCCb(count:count+1) == [0,0]
            count = count+2;
            count2 = count2+1;
            DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 0;
        elseif HDCCb(count:count+2) == [0,1,1]
            count = count+3;
            count2 = count2+1;
            DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 1;
        elseif HDCCb(count:count+2) == [0,1,0]
            count = count+3;
            count2 = count2+1;
            DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -1;
        elseif HDCCb(count:count+1) == [1,0]
            if HDCCb(count+2) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 2 + dot(HDCCb(count+3), [1]);
                count = count+4;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -3 + dot(HDCCb(count+3), [1]);
                count = count+4;
            end
        elseif HDCCb(count:count+2) == [1,1,0]
            if HDCCb(count+3) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 4 + dot(HDCCb(count+4:count+5), [2,1]);
                count = count+6;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -7 + dot(HDCCb(count+4:count+5), [2,1]);
                count = count+6;
            end
        elseif HDCCb(count:count+3) == [1,1,1,0]
            if HDCCb(count+4) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 8 + dot(HDCCb(count+5:count+7), [4,2,1]);
                count = count+8;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -15 + dot(HDCCb(count+5:count+7), [4,2,1]);
                count = count+8;
            end
        elseif HDCCb(count:count+4) == [1,1,1,1,0]
            if HDCCb(count+5) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 16 + dot(HDCCb(count+6:count+9), [8,4,2,1]);
                count = count+10;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -31 + dot(HDCCb(count+6:count+9), [8,4,2,1]);
                count = count+10;
            end
        elseif HDCCb(count:count+5) == [1,1,1,1,1,0]
            if HDCCb(count+6) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 32 + dot(HDCCb(count+7:count+11), [16,8,4,2,1]);
                count = count+12;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -63 + dot(HDCCb(count+7:count+11), [16,8,4,2,1]);
                count = count+12;
            end     
        elseif HDCCb(count:count+6) == [1,1,1,1,1,1,0]
            if HDCCb(count+7) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 64 + dot(HDCCb(count+8:count+13), [32,16,8,4,2,1]);
                count = count+14;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -127 + dot(HDCCb(count+8:count+13), [32,16,8,4,2,1]);
                count = count+14;
            end 
        elseif HDCCb(count:count+7) == [1,1,1,1,1,1,1,0]
            if HDCCb(count+8) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 128 + dot(HDCCb(count+9:count+15), [64,32,16,8,4,2,1]);
                count = count+16;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -255 + dot(HDCCb(count+9:count+15), [64,32,16,8,4,2,1]);
                count = count+16;
            end 
        elseif HDCCb(count:count+8) == [1,1,1,1,1,1,1,1,0]
            if HDCCb(count+9) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 256 + dot(HDCCb(count+10:count+17), [128,64,32,16,8,4,2,1]);
                count = count+18;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -511 + dot(HDCCb(count+10:count+17), [128,64,32,16,8,4,2,1]);
                count = count+18;
            end 
        elseif HDCCb(count:count+9) == [1,1,1,1,1,1,1,1,1,0]
            if HDCCb(count+10) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 512 + dot(HDCCb(count+11:count+19), [256,128,64,32,16,8,4,2,1]);
                count = count+20;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -1023 + dot(HDCCb(count+11:count+19), [256,128,64,32,16,8,4,2,1]);
                count = count+20;
            end 
        elseif HDCCb(count:count+10) == [1,1,1,1,1,1,1,1,1,1,0]
            if HDCCb(count+11) == 1
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 1024 + dot(HDCCb(count+12:count+21), [512,256,128,64,32,16,8,4,2,1]);
                count = count+22;
            else
                count2 = count2+1;
                DCCb2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -2047 + dot(HDCCb(count+12:count+21), [512,256,128,64,32,16,8,4,2,1]);
                count = count+22;
            end 
        end
end

count = 1;
count2 = 0;
while count2 < sz*sz/256
        if HDCCr(count:count+1) == [0,0]
            count = count+2;
            count2 = count2+1;
            DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 0;
        elseif HDCCr(count:count+2) == [0,1,1]
            count = count+3;
            count2 = count2+1;
            DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 1;
        elseif HDCCr(count:count+2) == [0,1,0]
            count = count+3;
            count2 = count2+1;
            DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -1;
        elseif HDCCr(count:count+1) == [1,0]
            if HDCCr(count+2) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 2 + dot(HDCCr(count+3), [1]);
                count = count+4;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -3 + dot(HDCCr(count+3), [1]);
                count = count+4;
            end
        elseif HDCCr(count:count+2) == [1,1,0]
            if HDCCr(count+3) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 4 + dot(HDCCr(count+4:count+5), [2,1]);
                count = count+6;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -7 + dot(HDCCr(count+4:count+5), [2,1]);
                count = count+6;
            end
        elseif HDCCr(count:count+3) == [1,1,1,0]
            if HDCCr(count+4) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 8 + dot(HDCCr(count+5:count+7), [4,2,1]);
                count = count+8;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -15 + dot(HDCCr(count+5:count+7), [4,2,1]);
                count = count+8;
            end
        elseif HDCCr(count:count+4) == [1,1,1,1,0]
            if HDCCr(count+5) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 16 + dot(HDCCr(count+6:count+9), [8,4,2,1]);
                count = count+10;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -31 + dot(HDCCr(count+6:count+9), [8,4,2,1]);
                count = count+10;
            end
        elseif HDCCr(count:count+5) == [1,1,1,1,1,0]
            if HDCCr(count+6) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 32 + dot(HDCCr(count+7:count+11), [16,8,4,2,1]);
                count = count+12;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -63 + dot(HDCCr(count+7:count+11), [16,8,4,2,1]);
                count = count+12;
            end     
        elseif HDCCr(count:count+6) == [1,1,1,1,1,1,0]
            if HDCCr(count+7) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 64 + dot(HDCCr(count+8:count+13), [32,16,8,4,2,1]);
                count = count+14;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -127 + dot(HDCCr(count+8:count+13), [32,16,8,4,2,1]);
                count = count+14;
            end 
        elseif HDCCr(count:count+7) == [1,1,1,1,1,1,1,0]
            if HDCCr(count+8) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 128 + dot(HDCCr(count+9:count+15), [64,32,16,8,4,2,1]);
                count = count+16;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -255 + dot(HDCCr(count+9:count+15), [64,32,16,8,4,2,1]);
                count = count+16;
            end 
        elseif HDCCr(count:count+8) == [1,1,1,1,1,1,1,1,0]
            if HDCCr(count+9) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 256 + dot(HDCCr(count+10:count+17), [128,64,32,16,8,4,2,1]);
                count = count+18;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -511 + dot(HDCCr(count+10:count+17), [128,64,32,16,8,4,2,1]);
                count = count+18;
            end 
        elseif HDCCr(count:count+9) == [1,1,1,1,1,1,1,1,1,0]
            if HDCCr(count+10) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 512 + dot(HDCCr(count+11:count+19), [256,128,64,32,16,8,4,2,1]);
                count = count+20;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -1023 + dot(HDCCr(count+11:count+19), [256,128,64,32,16,8,4,2,1]);
                count = count+20;
            end 
        elseif HDCCr(count:count+10) == [1,1,1,1,1,1,1,1,1,1,0]
            if HDCCr(count+11) == 1
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = 1024 + dot(HDCCr(count+12:count+21), [512,256,128,64,32,16,8,4,2,1]);
                count = count+22;
            else
                count2 = count2+1;
                DCCr2(ceil(count2/sz*16),mod(count2-1,sz/16)+1) = -2047 + dot(HDCCr(count+12:count+21), [512,256,128,64,32,16,8,4,2,1]);
                count = count+22;
            end 
        end
end

ACY2 = cell(sz/8);
ACCb2 = cell(sz/16);
ACCr2 = cell(sz/16);

count = 1;
count2 = 1;
while count2 <= sz*sz/64
    if count <= length(HACY)-15
        a16 = dot(HACY(count:count+15), [32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1]);
    end
    if HACY(count:count+2) == [0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,1];
        count = count+3;
    elseif HACY(count:count+2) == [0,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,-1];
        count = count+3;
    elseif HACY(count:count+3) == [1,0,1,0]
        count2 = count2+1;
        count = count+4;
    elseif HACY(count:count+1) == [0,1]
        if HACY(count+2) == 1
            temp = 2+dot(HACY(count+3), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+4;
        else
            temp = -3+dot(HACY(count+3), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+4;
        end
    elseif HACY(count:count+4) == [1,1,0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,1];
        count = count+5;
    elseif HACY(count:count+4) == [1,1,0,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,-1];
        count = count+5;
    elseif HACY(count:count+5) == [1,1,1,0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,1];
        count = count+6;
    elseif HACY(count:count+5) == [1,1,1,0,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,-1];
        count = count+6;
    elseif HACY(count:count+2) == [1,0,0]
        if HACY(count+3) == 1
            temp = 4+dot(HACY(count+4:count+5), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+6;
        else
            temp = -7+dot(HACY(count+4:count+5), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+6;
        end
    elseif HACY(count:count+6) == [1,1,1,0,1,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,1];
        count = count+7;
    elseif HACY(count:count+6) == [1,1,1,0,1,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,-1];
        count = count+7;
    elseif HACY(count:count+6) == [1,1,1,0,1,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,1];
        count = count+7;
    elseif HACY(count:count+6) == [1,1,1,0,1,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,-1];
        count = count+7;
    elseif HACY(count:count+4) == [1,1,0,1,1]
        if HACY(count+5) == 1
            temp = 2+dot(HACY(count+6), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+7;
        else
            temp = -3+dot(HACY(count+6), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+7;
        end
    elseif HACY(count:count+7) == [1,1,1,1,0,1,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,1];
        count = count+8;
    elseif HACY(count:count+7) == [1,1,1,1,0,1,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,-1];
        count = count+8;
    elseif HACY(count:count+7) == [1,1,1,1,0,1,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,1];
        count = count+8;
    elseif HACY(count:count+3) == [1,0,1,1]
        if HACY(count+4) == 1
            temp = 8+dot(HACY(count+5:count+7), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+8;
        else
            temp = -15+dot(HACY(count+5:count+7), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+8;
        end
    elseif HACY(count:count+7) == [1,1,1,1,0,1,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,-1];
        count = count+8;
    elseif HACY(count:count+8) == [1,1,1,1,1,0,1,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,1];
        count = count+9;
    elseif HACY(count:count+8) == [1,1,1,1,1,0,1,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,-1];
        count = count+9;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,1];
        count = count+10;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,0,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,-1];
        count = count+10;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,0,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,1];
        count = count+10;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,0,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,-1];
        count = count+10;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,1,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,1];
        count = count+10;
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,1,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,-1];
        count = count+10;
    elseif HACY(count:count+4) == [1,1,0,1,0]
        if HACY(count+5) == 1
            temp = 16+dot(HACY(count+6:count+9), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+10;
        else
            temp = -31+dot(HACY(count+6:count+9), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+10;
        end
    elseif HACY(count:count+6) == [1,1,1,1,0,0,1]
        if HACY(count+7) == 1
            temp = 4+dot(HACY(count+8:count+9), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+10;
        else
            temp = -7+dot(HACY(count+8:count+9), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+10;
        end
    elseif HACY(count:count+7) == [1,1,1,1,1,0,0,1]
        if HACY(count+8) == 1
            temp = 2+dot(HACY(count+9), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+10;
        else
            temp = -3+dot(HACY(count+9), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+10;
        end    
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,0,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,1];
        count = count+11;
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,0,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,-1];
        count = count+11;
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,1,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,1];
        count = count+11;
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,1,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,-1];
        count = count+11;
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,1,0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,0];
        count = count+11;
    elseif HACY(count:count+8) == [1,1,1,1,1,0,1,1,1]
        if HACY(count+9) == 1
            temp = 2+dot(HACY(count+10), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+11;
        else
            temp = -3+dot(HACY(count+10), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+11;
        end
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,0,0,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,1];
        count = count+12;
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,0,0,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,-1];
        count = count+12;    
        elseif HACY(count:count+9) == [1,1,1,1,1,1,1,0,0,0]
        if HACY(count+10) == 1
            temp = 2+dot(HACY(count+11), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+12;
        else
            temp = -3+dot(HACY(count+11), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+12;
        end
        
    elseif HACY(count:count+6) == [1,1,1,1,0,0,0]
        if HACY(count+7) == 1
            temp = 32+dot(HACY(count+8:count+12), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+13;
        else
            temp = -63+dot(HACY(count+8:count+12), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+13;
        end
    elseif HACY(count:count+7) == [1,1,1,1,1,0,0,0]
        if HACY(count+8) == 1
            temp = 64+dot(HACY(count+9:count+14), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+15;
        else
            temp = -127+dot(HACY(count+9:count+14), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+15;
        end
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,1,1,0]
        if HACY(count+10) == 1
            temp = 128+dot(HACY(count+11:count+17), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+18;
        else
            temp = -255+dot(HACY(count+11:count+17), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+18;
        end
    elseif a16 == 65410
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+25;
        end
    elseif a16 == 65411
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},0,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+8) == [1,1,1,1,1,0,1,1,0]
        if HACY(count+9) == 1
            temp = 8+dot(HACY(count+10:count+12), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+13;
        else
            temp = -15+dot(HACY(count+10:count+12), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+13;
        end
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,1,1,0]
        if HACY(count+11) == 1
            temp = 16+dot(HACY(count+12:count+15), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+16;
        else
            temp = -31+dot(HACY(count+12:count+15), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+16;
        end    
    elseif a16 == 65412
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+22;
        end
    elseif a16 == 65413
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+23;
        end
    elseif a16 == 65414
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+24;
        end
    elseif a16 == 65415
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+25;
        end
    elseif a16 == 65416
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},1,temp];
            count = count+26;
        end
       
    elseif HACY(count:count+9) == [1,1,1,1,1,1,0,1,1,1]
        if HACY(count+10) == 1
            temp = 4+dot(HACY(count+11:count+12), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+13;
        else
            temp = -7+dot(HACY(count+11:count+12), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+13;
        end
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,0]
        if HACY(count+12) == 1
            temp = 8+dot(HACY(count+13:count+15), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+16;
        else
            temp = -15+dot(HACY(count+13:count+15), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+16;
        end
    elseif a16 == 65417
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+21;
        end    
    elseif a16 == 65418
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+22;
        end
    elseif a16 == 65419
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+23;
        end
    elseif a16 == 65420
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+24;
        end
    elseif a16 == 65421
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+25;
        end
    elseif a16 == 65422
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},2,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,1]
        if HACY(count+12) == 1
            temp = 4+dot(HACY(count+13:count+14), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+15;
        else
            temp = -7+dot(HACY(count+13:count+14), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+15;
        end
    elseif a16 == 65423
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+20;
        end
    elseif a16 == 65424
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+21;
        end    
    elseif a16 == 65425
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+22;
        end
    elseif a16 == 65426
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+23;
        end
    elseif a16 == 65427
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+24;
        end
    elseif a16 == 65428
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+25;
        end
    elseif a16 == 65429
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},3,temp];
            count = count+26;
        end
        

    elseif a16 == 65430
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+19;
        end
    elseif a16 == 65431
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+20;
        end
    elseif a16 == 65432
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+21;
        end    
    elseif a16 == 65433
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+22;
        end
    elseif a16 == 65434
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+23;
        end
    elseif a16 == 65435
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+24;
        end
    elseif a16 == 65436
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+25;
        end
    elseif a16 == 65437
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},4,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+10) == [1,1,1,1,1,1,1,0,1,1,1]
        if HACY(count+11) == 1
            temp = 2+dot(HACY(count+12), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+13;
        else
            temp = -3+dot(HACY(count+12), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+13;
        end
    elseif a16 == 65438
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+19;
        end
    elseif a16 == 65439
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+20;
        end
    elseif a16 == 65440
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+21;
        end    
    elseif a16 == 65441
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+22;
        end
    elseif a16 == 65442
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+23;
        end
    elseif a16 == 65443
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+24;
        end
    elseif a16 == 65444
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+25;
        end
    elseif a16 == 65445
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},5,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,0]
        if HACY(count+12) == 1
            temp = 2+dot(HACY(count+13), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+14;
        else
            temp = -3+dot(HACY(count+13), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+14;
        end
    elseif a16 == 65446
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+19;
        end
    elseif a16 == 65447
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+20;
        end
    elseif a16 == 65448
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+21;
        end    
    elseif a16 == 65449
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+22;
        end
    elseif a16 == 65450
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+23;
        end
    elseif a16 == 65451
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+24;
        end
    elseif a16 == 65452
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+25;
        end
    elseif a16 == 65453
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},6,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,1]
        if HACY(count+12) == 1
            temp = 2+dot(HACY(count+13), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+14;
        else
            temp = -3+dot(HACY(count+13), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+14;
        end
    elseif a16 == 65454
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+19;
        end
    elseif a16 == 65455
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+20;
        end
    elseif a16 == 65456
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+21;
        end    
    elseif a16 == 65457
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+22;
        end
    elseif a16 == 65458
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+23;
        end
    elseif a16 == 65459
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+24;
        end
    elseif a16 == 65460
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+25;
        end
    elseif a16 == 65461
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},7,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,0,0]
        if HACY(count+15) == 1
            temp = 2+dot(HACY(count+16), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+17;
        else
            temp = -3+dot(HACY(count+16), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+17;
        end
    elseif a16 == 65462
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+19;
        end
    elseif a16 == 65463
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+20;
        end
    elseif a16 == 65464
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+21;
        end    
    elseif a16 == 65465
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+22;
        end
    elseif a16 == 65466
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+23;
        end
    elseif a16 == 65467
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+24;
        end
    elseif a16 == 65468
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+25;
        end
    elseif a16 == 65469
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},8,temp];
            count = count+26;
        end
        
    elseif a16 == 65470
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+18;
        end
    elseif a16 == 65471
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+19;
        end
    elseif a16 == 65472
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+20;
        end
    elseif a16 == 65473
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+21;
        end    
    elseif a16 == 65474
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+22;
        end
    elseif a16 == 65475
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+23;
        end
    elseif a16 == 65476
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+24;
        end
    elseif a16 == 65477
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+25;
        end
    elseif a16 == 65478
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},9,temp];
            count = count+26;
        end
        
    elseif a16 == 65479
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+18;
        end
    elseif a16 == 65480
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+19;
        end
    elseif a16 == 65481
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+20;
        end
    elseif a16 == 65482
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+21;
        end    
    elseif a16 == 65483
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+22;
        end
    elseif a16 == 65484
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+23;
        end
    elseif a16 == 65485
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+24;
        end
    elseif a16 == 65486
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+25;
        end
    elseif a16 == 65487
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},10,temp];
            count = count+26;
        end
        
    elseif a16 == 65488
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+18;
        end
    elseif a16 == 65489
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+19;
        end
    elseif a16 == 65490
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+20;
        end
    elseif a16 == 65491
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+21;
        end    
    elseif a16 == 65492
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+22;
        end
    elseif a16 == 65493
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+23;
        end
    elseif a16 == 65494
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+24;
        end
    elseif a16 == 65495
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+25;
        end
    elseif a16 == 65496
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},11,temp];
            count = count+26;
        end
        
    elseif a16 == 65497
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+18;
        end
    elseif a16 == 65498
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+19;
        end
    elseif a16 == 65499
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+20;
        end
    elseif a16 == 65500
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+21;
        end    
    elseif a16 == 65501
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+22;
        end
    elseif a16 == 65502
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+23;
        end
    elseif a16 == 65503
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+24;
        end
    elseif a16 == 65504
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+25;
        end
    elseif a16 == 65505
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},12,temp];
            count = count+26;
        end
        
    elseif a16 == 65506
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+18;
        end
    elseif a16 == 65507
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+19;
        end
    elseif a16 == 65508
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+20;
        end
    elseif a16 == 65509
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+21;
        end    
    elseif a16 == 65510
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+22;
        end
    elseif a16 == 65511
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+23;
        end
    elseif a16 == 65512
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+24;
        end
    elseif a16 == 65513
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+25;
        end
    elseif a16 == 65514
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},13,temp];
            count = count+26;
        end
        
    elseif a16 == 65516
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+18;
        end
    elseif a16 == 65517
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+19;
        end
    elseif a16 == 65518
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+20;
        end
    elseif a16 == 65519
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+21;
        end    
    elseif a16 == 65520
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+22;
        end
    elseif a16 == 65521
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+23;
        end
    elseif a16 == 65522
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+24;
        end
    elseif a16 == 65523
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+25;
        end
    elseif a16 == 65524
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,temp];
            count = count+26;
        end
        
    elseif a16 == 65526
        if HACY(count+16) == 1
            temp = 2+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+18;
        else
            temp = -3+dot(HACY(count+17), [1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+18;
        end
    elseif a16 == 65527
        if HACY(count+16) == 1
            temp = 4+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+19;
        else
            temp = -7+dot(HACY(count+17:count+18), [2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+19;
        end
    elseif a16 == 65528
        if HACY(count+16) == 1
            temp = 8+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+20;
        else
            temp = -15+dot(HACY(count+17:count+19), [4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+20;
        end
    elseif a16 == 65529
        if HACY(count+16) == 1
            temp = 16+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+21;
        else
            temp = -31+dot(HACY(count+17:count+20), [8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+21;
        end    
    elseif a16 == 65530
        if HACY(count+16) == 1
            temp = 32+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+22;
        else
            temp = -63+dot(HACY(count+17:count+21), [16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+22;
        end
    elseif a16 == 65531
        if HACY(count+16) == 1
            temp = 64+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+23;
        else
            temp = -127+dot(HACY(count+17:count+22), [32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+23;
        end
    elseif a16 == 65532
        if HACY(count+16) == 1
            temp = 128+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+24;
        else
            temp = -255+dot(HACY(count+17:count+23), [64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+24;
        end
    elseif a16 == 65533
        if HACY(count+16) == 1
            temp = 256+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+25;
        else
            temp = -511+dot(HACY(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+25;
        end
    elseif a16 == 65534
        if HACY(count+16) == 1
            temp = 512+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+26;
        else
            temp = -1023+dot(HACY(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,temp];
            count = count+26;
        end
        
    elseif HACY(count:count+16) == [1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,1];
        count = count+17;
    elseif HACY(count:count+16) == [1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},14,-1];
        count = count+17;
    elseif HACY(count:count+16) == [1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,1];
        count = count+17;
    elseif HACY(count:count+16) == [1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,0]
        ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1} = [ACY2{ceil(count2/sz*8),mod(count2-1,sz/8)+1},15,-1];
        count = count+17;    
    end
end

count = 1;
count2 = 1;
while count2 <= sz*sz/256
    if count <= length(HACCb)-15
        a16 = dot(HACCb(count:count+15), [32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1]);
    end
    if HACCb(count:count+1) == [0,0]
        count2 = count2+1;
        count = count+2;
    elseif HACCb(count:count+2) == [0,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,1];
        count = count+3;
    elseif HACCb(count:count+2) == [0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,-1];
        count = count+3;
    elseif HACCb(count:count+4) == [1,0,1,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,1];
        count = count+5;
    elseif HACCb(count:count+4) == [1,0,1,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,-1];
        count = count+5;
    elseif HACCb(count:count+2) == [1,0,0]
        if HACCb(count+3) == 1
            temp = 2+dot(HACCb(count+4), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+5;
        else
            temp = -3+dot(HACCb(count+4), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+5;
        end
    elseif HACCb(count:count+5) == [1,1,0,1,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,1];
        count = count+6;
    elseif HACCb(count:count+5) == [1,1,0,1,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,-1];
        count = count+6;
    elseif HACCb(count:count+5) == [1,1,0,1,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,1];
        count = count+6;
    elseif HACCb(count:count+5) == [1,1,0,1,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,-1];
        count = count+6;
    elseif HACCb(count:count+6) == [1,1,1,0,1,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,1];
        count = count+7;
    elseif HACCb(count:count+6) == [1,1,1,0,1,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,-1];
        count = count+7;
    elseif HACCb(count:count+6) == [1,1,1,0,1,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,1];
        count = count+7;
    elseif HACCb(count:count+6) == [1,1,1,0,1,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,-1];
        count = count+7;
    elseif HACCb(count:count+3) == [1,0,1,0]
        if HACCb(count+4) == 1
            temp = 4+dot(HACCb(count+5:count+6), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+7;
        else
            temp = -7+dot(HACCb(count+5:count+6), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+7;
        end
    elseif HACCb(count:count+7) == [1,1,1,1,0,0,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,1];
        count = count+8;
    elseif HACCb(count:count+7) == [1,1,1,1,0,0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,-1];
        count = count+8;
    elseif HACCb(count:count+7) == [1,1,1,1,0,1,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,1];
        count = count+8;
    elseif HACCb(count:count+7) == [1,1,1,1,0,1,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,-1];
        count = count+8;
    elseif HACCb(count:count+5) == [1,1,1,0,0,1]
        if HACCb(count+6) == 1
            temp = 2+dot(HACCb(count+7), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+8;
        else
            temp = -3+dot(HACCb(count+7), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+8;
        end
    elseif HACCb(count:count+8) == [1,1,1,1,1,0,0,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,1];
        count = count+9;
    elseif HACCb(count:count+8) == [1,1,1,1,1,0,0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,-1];
        count = count+9;
    elseif HACCb(count:count+4) == [1,1,0,0,0]
        if HACCb(count+5) == 1
            temp = 8+dot(HACCb(count+6:count+8), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+9;
        else
            temp = -15+dot(HACCb(count+6:count+8), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+9;
        end
    elseif HACCb(count:count+9) == [1,1,1,1,1,0,1,1,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,0,1,1,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,-1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,0,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,0,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,-1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,0,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,-1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,1,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,1,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,-1];
        count = count+10;
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,1,0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,0];
        count = count+10;
    elseif HACCb(count:count+4) == [1,1,0,0,1]
        if HACCb(count+5) == 1
            temp = 16+dot(HACCb(count+6:count+9), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+10;
        else
            temp = -31+dot(HACCb(count+6:count+9), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+10;
        end
    elseif HACCb(count:count+7) == [1,1,1,1,0,1,1,1]
        if HACCb(count+8) == 1
            temp = 2+dot(HACCb(count+9), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+10;
        else
            temp = -3+dot(HACCb(count+9), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+10;
        end
    elseif HACCb(count:count+7) == [1,1,1,1,1,0,0,0]
        if HACCb(count+8) == 1
            temp = 2+dot(HACCb(count+9), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+10;
        else
            temp = -3+dot(HACCb(count+9), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+10;
        end    
    elseif HACCb(count:count+7) == [1,1,1,1,0,1,1,0]
        if HACCb(count+8) == 1
            temp = 4+dot(HACCb(count+9:count+10), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+11;
        else
            temp = -7+dot(HACCb(count+9:count+10), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+11;
        end
    elseif HACCb(count:count+8) == [1,1,1,1,1,0,1,1,0]
        if HACCb(count+9) == 1
            temp = 2+dot(HACCb(count+10), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+11;
        else
            temp = -3+dot(HACCb(count+10), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+11;
        end    
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,0,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,1];
        count = count+12;
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,0,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,-1];
        count = count+12;
    elseif HACCb(count:count+5) == [1,1,1,0,0,0]
        if HACCb(count+6) == 1
            temp = 32+dot(HACCb(count+7:count+11), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+12;
        else
            temp = -63+dot(HACCb(count+7:count+11), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+12;
        end
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,1,0,0,1]
        if HACCb(count+10) == 1
            temp = 2+dot(HACCb(count+11), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+12;
        else
            temp = -3+dot(HACCb(count+11), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+12;
        end    
    elseif HACCb(count:count+8) == [1,1,1,1,1,0,1,0,1]
        if HACCb(count+9) == 1
            temp = 8+dot(HACCb(count+10:count+12), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+13;
        else
            temp = -15+dot(HACCb(count+10:count+12), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+13;
        end
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,1,1,1]
        if HACCb(count+10) == 1
            temp = 4+dot(HACCb(count+11:count+12), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+13;
        else
            temp = -7+dot(HACCb(count+11:count+12), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+13;
        end
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,1,0,0,0]
        if HACCb(count+10) == 1
            temp = 4+dot(HACCb(count+11:count+12), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+13;
        else
            temp = -7+dot(HACCb(count+11:count+12), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+13;
        end
    elseif HACCb(count:count+10) == [1,1,1,1,1,1,1,0,1,1,1]
        if HACCb(count+11) == 1
            temp = 2+dot(HACCb(count+12), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+13;
        else
            temp = -3+dot(HACCb(count+12), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+13;
        end
    elseif HACCb(count:count+10) == [1,1,1,1,1,1,1,1,0,0,0]
        if HACCb(count+11) == 1
            temp = 2+dot(HACCb(count+12), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+13;
        else
            temp = -3+dot(HACCb(count+12), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+13;
        end    
    elseif HACCb(count:count+6) == [1,1,1,1,0,0,0]
        if HACCb(count+7) == 1
            temp = 64+dot(HACCb(count+8:count+13), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+14;
        else
            temp = -127+dot(HACCb(count+8:count+13), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+14;
        end    
    elseif HACCb(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,0,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,1];
        count = count+15;
    elseif HACCb(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,0,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,-1];
        count = count+15;    
    elseif HACCb(count:count+15) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,1];
        count = count+16;
    elseif HACCb(count:count+15) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0]
        ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,-1];
        count = count+16;
      
    elseif HACCb(count:count+8) == [1,1,1,1,1,0,1,0,0]
        if HACCb(count+9) == 1
            temp = 128+dot(HACCb(count+10:count+16), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+17;
        else
            temp = -255+dot(HACCb(count+10:count+16), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+17;
        end
    elseif HACCb(count:count+9) == [1,1,1,1,1,1,0,1,1,0]
        if HACCb(count+10) == 1
            temp = 256+dot(HACCb(count+11:count+28), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+19;
        else
            temp = -511+dot(HACCb(count+11:count+18), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+19;
        end
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,0]
        if HACCb(count+12) == 1
            temp = 512+dot(HACCb(count+13:count+21), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+22;
        else
            temp = -1023+dot(HACCb(count+13:count+21), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+22;
        end
            
    elseif HACCb(count:count+10) == [1,1,1,1,1,1,1,0,1,1,0]
        if HACCb(count+11) == 1
            temp = 16+dot(HACCb(count+12:count+15), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+16;
        else
            temp = -31+dot(HACCb(count+12:count+15), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+16;
        end    
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,1]
        if HACCb(count+12) == 1
            temp = 32+dot(HACCb(count+13:count+17), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+18;
        else
            temp = -63+dot(HACCb(count+13:count+17), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+18;
        end
    elseif a16 == 65416
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+23;
        end
    elseif a16 == 65417
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+24;
        end
    elseif a16 == 65418
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+25;
        end
    elseif a16 == 65419
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+26;
        end
        
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,0]
        if HACCb(count+12) == 1
            temp = 8+dot(HACCb(count+13:count+15), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+16;
        else
            temp = -15+dot(HACCb(count+13:count+15), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+16;
        end
    elseif HACCb(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,0]
        if HACCb(count+15) == 1
            temp = 16+dot(HACCb(count+16:count+19), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+20;
        else
            temp = -31+dot(HACCb(count+16:count+19), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+20;
        end    
    elseif a16 == 65420
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+22;
        end
    elseif a16 == 65421
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+23;
        end
    elseif a16 == 65422
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+24;
        end
    elseif a16 == 65423
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+25;
        end
    elseif a16 == 65424
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+26;
        end
    
    elseif HACCb(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,1]
        if HACCb(count+12) == 1
            temp = 8+dot(HACCb(count+13:count+15), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+16;
        else
            temp = -15+dot(HACCb(count+13:count+15), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+16;
        end
    elseif a16 == 65425
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+21;
        end    
    elseif a16 == 65426
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+22;
        end
    elseif a16 == 65427
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+23;
        end
    elseif a16 == 65428
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+24;
        end
    elseif a16 == 65429
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+25;
        end
    elseif a16 == 65430
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+26;
        end
           
    elseif a16 == 65431
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+19;
        end
    elseif a16 == 65432
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+20;
        end
    elseif a16 == 65433
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+21;
        end    
    elseif a16 == 65434
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+22;
        end
    elseif a16 == 65435
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+23;
        end
    elseif a16 == 65436
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+24;
        end
    elseif a16 == 65437
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+25;
        end
    elseif a16 == 65438
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+26;
        end
        
    elseif a16 == 65439
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+19;
        end
    elseif a16 == 65440
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+20;
        end
    elseif a16 == 65441
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+21;
        end    
    elseif a16 == 65442
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+22;
        end
    elseif a16 == 65443
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+23;
        end
    elseif a16 == 65444
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+24;
        end
    elseif a16 == 65445
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+25;
        end
    elseif a16 == 65446
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+26;
        end
        
    elseif a16 == 65447
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+19;
        end
    elseif a16 == 65448
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+20;
        end
    elseif a16 == 65449
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+21;
        end    
    elseif a16 == 65450
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+22;
        end
    elseif a16 == 65451
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+23;
        end
    elseif a16 == 65452
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+24;
        end
    elseif a16 == 65453
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+25;
        end
    elseif a16 == 65454
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+26;
        end
        
    elseif a16 == 65455
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+19;
        end
    elseif a16 == 65456
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+20;
        end
    elseif a16 == 65457
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+21;
        end    
    elseif a16 == 65458
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+22;
        end
    elseif a16 == 65459
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+23;
        end
    elseif a16 == 65460
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+24;
        end
    elseif a16 == 65461
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+25;
        end
    elseif a16 == 65462
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+26;
        end
        
    elseif a16 == 65463
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+18;
        end
    elseif a16 == 65464
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+19;
        end
    elseif a16 == 65465
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+20;
        end
    elseif a16 == 65466
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+21;
        end    
    elseif a16 == 65467
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+22;
        end
    elseif a16 == 65468
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+23;
        end
    elseif a16 == 65469
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+24;
        end
    elseif a16 == 65470
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+25;
        end
    elseif a16 == 65471
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+26;
        end
        
    elseif a16 == 65472
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+18;
        end
    elseif a16 == 65473
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+19;
        end
    elseif a16 == 65474
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+20;
        end
    elseif a16 == 65475
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+21;
        end    
    elseif a16 == 65476
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+22;
        end
    elseif a16 == 65477
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+23;
        end
    elseif a16 == 65478
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+24;
        end
    elseif a16 == 65479
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+25;
        end
    elseif a16 == 65480
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+26;
        end
        
    elseif a16 == 65481
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+18;
        end
    elseif a16 == 65482
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+19;
        end
    elseif a16 == 65483
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+20;
        end
    elseif a16 == 65484
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+21;
        end    
    elseif a16 == 65485
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+22;
        end
    elseif a16 == 65486
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+23;
        end
    elseif a16 == 65487
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+24;
        end
    elseif a16 == 65488
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+25;
        end
    elseif a16 == 65489
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+26;
        end
        
    elseif a16 == 65490
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+18;
        end
    elseif a16 == 65491
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+19;
        end
    elseif a16 == 65492
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+20;
        end
    elseif a16 == 65493
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+21;
        end    
    elseif a16 == 65494
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+22;
        end
    elseif a16 == 65495
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+23;
        end
    elseif a16 == 65496
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+24;
        end
    elseif a16 == 65497
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+25;
        end
    elseif a16 == 65498
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+26;
        end
        
    elseif a16 == 65499
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+18;
        end
    elseif a16 == 65500
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+19;
        end
    elseif a16 == 65501
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+20;
        end
    elseif a16 == 65502
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+21;
        end    
    elseif a16 == 65503
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+22;
        end
    elseif a16 == 65504
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+23;
        end
    elseif a16 == 65505
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+24;
        end
    elseif a16 == 65506
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+25;
        end
    elseif a16 == 65507
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+26;
        end
        
    elseif a16 == 65508
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+18;
        end
    elseif a16 == 65509
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+19;
        end
    elseif a16 == 65510
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+20;
        end
    elseif a16 == 65511
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+21;
        end    
    elseif a16 == 65512
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+22;
        end
    elseif a16 == 65513
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+23;
        end
    elseif a16 == 65514
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+24;
        end
    elseif a16 == 65515
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+25;
        end
    elseif a16 == 65516
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+26;
        end
        
    elseif a16 == 65517
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+18;
        end
    elseif a16 == 65518
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+19;
        end
    elseif a16 == 65519
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+20;
        end
    elseif a16 == 65520
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+21;
        end    
    elseif a16 == 65521
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+22;
        end
    elseif a16 == 65522
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+23;
        end
    elseif a16 == 65523
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+24;
        end
    elseif a16 == 65524
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+25;
        end
    elseif a16 == 65525
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        end
        
    elseif a16 == 65526
        if HACCb(count+16) == 1
            temp = 2+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+18;
        else
            temp = -3+dot(HACCb(count+17), [1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+18;
        end
    elseif a16 == 65527
        if HACCb(count+16) == 1
            temp = 4+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+19;
        else
            temp = -7+dot(HACCb(count+17:count+18), [2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+19;
        end
    elseif a16 == 65528
        if HACCb(count+16) == 1
            temp = 8+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+20;
        else
            temp = -15+dot(HACCb(count+17:count+19), [4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+20;
        end
    elseif a16 == 65529
        if HACCb(count+16) == 1
            temp = 16+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+21;
        else
            temp = -31+dot(HACCb(count+17:count+20), [8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+21;
        end    
    elseif a16 == 65530
        if HACCb(count+16) == 1
            temp = 32+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+22;
        else
            temp = -63+dot(HACCb(count+17:count+21), [16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+22;
        end
    elseif a16 == 65531
        if HACCb(count+16) == 1
            temp = 64+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+23;
        else
            temp = -127+dot(HACCb(count+17:count+22), [32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+23;
        end
    elseif a16 == 65532
        if HACCb(count+16) == 1
            temp = 128+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+24;
        else
            temp = -255+dot(HACCb(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+24;
        end
    elseif a16 == 65533
        if HACCb(count+16) == 1
            temp = 256+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+25;
        else
            temp = -511+dot(HACCb(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+25;
        end
    elseif a16 == 65534
        if HACCb(count+16) == 1
            temp = 512+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCb(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCb2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+26;
        end    
    end
end

count = 1;
count2 = 1;
while count2 <= sz*sz/256
    if count <= length(HACCr)-15
        a16 = dot(HACCr(count:count+15), [32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1]);
    end
    if HACCr(count:count+1) == [0,0]
        count2 = count2+1;
        count = count+2;
    elseif HACCr(count:count+2) == [0,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,1];
        count = count+3;
    elseif HACCr(count:count+2) == [0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,-1];
        count = count+3;
    elseif HACCr(count:count+4) == [1,0,1,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,1];
        count = count+5;
    elseif HACCr(count:count+4) == [1,0,1,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,-1];
        count = count+5;
    elseif HACCr(count:count+2) == [1,0,0]
        if HACCr(count+3) == 1
            temp = 2+dot(HACCr(count+4), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+5;
        else
            temp = -3+dot(HACCr(count+4), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+5;
        end
    elseif HACCr(count:count+5) == [1,1,0,1,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,1];
        count = count+6;
    elseif HACCr(count:count+5) == [1,1,0,1,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,-1];
        count = count+6;
    elseif HACCr(count:count+5) == [1,1,0,1,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,1];
        count = count+6;
    elseif HACCr(count:count+5) == [1,1,0,1,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,-1];
        count = count+6;
    elseif HACCr(count:count+6) == [1,1,1,0,1,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,1];
        count = count+7;
    elseif HACCr(count:count+6) == [1,1,1,0,1,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,-1];
        count = count+7;
    elseif HACCr(count:count+6) == [1,1,1,0,1,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,1];
        count = count+7;
    elseif HACCr(count:count+6) == [1,1,1,0,1,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,-1];
        count = count+7;
    elseif HACCr(count:count+3) == [1,0,1,0]
        if HACCr(count+4) == 1
            temp = 4+dot(HACCr(count+5:count+6), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+7;
        else
            temp = -7+dot(HACCr(count+5:count+6), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+7;
        end
    elseif HACCr(count:count+7) == [1,1,1,1,0,0,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,1];
        count = count+8;
    elseif HACCr(count:count+7) == [1,1,1,1,0,0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,-1];
        count = count+8;
    elseif HACCr(count:count+7) == [1,1,1,1,0,1,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,1];
        count = count+8;
    elseif HACCr(count:count+7) == [1,1,1,1,0,1,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,-1];
        count = count+8;
    elseif HACCr(count:count+5) == [1,1,1,0,0,1]
        if HACCr(count+6) == 1
            temp = 2+dot(HACCr(count+7), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+8;
        else
            temp = -3+dot(HACCr(count+7), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+8;
        end
    elseif HACCr(count:count+8) == [1,1,1,1,1,0,0,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,1];
        count = count+9;
    elseif HACCr(count:count+8) == [1,1,1,1,1,0,0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,-1];
        count = count+9;
    elseif HACCr(count:count+4) == [1,1,0,0,0]
        if HACCr(count+5) == 1
            temp = 8+dot(HACCr(count+6:count+8), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+9;
        else
            temp = -15+dot(HACCr(count+6:count+8), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+9;
        end
    elseif HACCr(count:count+9) == [1,1,1,1,1,0,1,1,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,0,1,1,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,-1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,0,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,0,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,-1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,0,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,-1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,1,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,1,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,-1];
        count = count+10;
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,1,0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,0];
        count = count+10;
    elseif HACCr(count:count+4) == [1,1,0,0,1]
        if HACCr(count+5) == 1
            temp = 16+dot(HACCr(count+6:count+9), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+10;
        else
            temp = -31+dot(HACCr(count+6:count+9), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+10;
        end
    elseif HACCr(count:count+7) == [1,1,1,1,0,1,1,1]
        if HACCr(count+8) == 1
            temp = 2+dot(HACCr(count+9), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+10;
        else
            temp = -3+dot(HACCr(count+9), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+10;
        end
    elseif HACCr(count:count+7) == [1,1,1,1,1,0,0,0]
        if HACCr(count+8) == 1
            temp = 2+dot(HACCr(count+9), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+10;
        else
            temp = -3+dot(HACCr(count+9), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+10;
        end    
    elseif HACCr(count:count+7) == [1,1,1,1,0,1,1,0]
        if HACCr(count+8) == 1
            temp = 4+dot(HACCr(count+9:count+10), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+11;
        else
            temp = -7+dot(HACCr(count+9:count+10), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+11;
        end
    elseif HACCr(count:count+8) == [1,1,1,1,1,0,1,1,0]
        if HACCr(count+9) == 1
            temp = 2+dot(HACCr(count+10), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+11;
        else
            temp = -3+dot(HACCr(count+10), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+11;
        end    
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,0,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,1];
        count = count+12;
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,0,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,-1];
        count = count+12;
    elseif HACCr(count:count+5) == [1,1,1,0,0,0]
        if HACCr(count+6) == 1
            temp = 32+dot(HACCr(count+7:count+11), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+12;
        else
            temp = -63+dot(HACCr(count+7:count+11), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+12;
        end
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,1,0,0,1]
        if HACCr(count+10) == 1
            temp = 2+dot(HACCr(count+11), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+12;
        else
            temp = -3+dot(HACCr(count+11), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+12;
        end    
    elseif HACCr(count:count+8) == [1,1,1,1,1,0,1,0,1]
        if HACCr(count+9) == 1
            temp = 8+dot(HACCr(count+10:count+12), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+13;
        else
            temp = -15+dot(HACCr(count+10:count+12), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+13;
        end
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,1,1,1]
        if HACCr(count+10) == 1
            temp = 4+dot(HACCr(count+11:count+12), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+13;
        else
            temp = -7+dot(HACCr(count+11:count+12), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+13;
        end
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,1,0,0,0]
        if HACCr(count+10) == 1
            temp = 4+dot(HACCr(count+11:count+12), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+13;
        else
            temp = -7+dot(HACCr(count+11:count+12), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+13;
        end
    elseif HACCr(count:count+10) == [1,1,1,1,1,1,1,0,1,1,1]
        if HACCr(count+11) == 1
            temp = 2+dot(HACCr(count+12), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+13;
        else
            temp = -3+dot(HACCr(count+12), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+13;
        end
    elseif HACCr(count:count+10) == [1,1,1,1,1,1,1,1,0,0,0]
        if HACCr(count+11) == 1
            temp = 2+dot(HACCr(count+12), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+13;
        else
            temp = -3+dot(HACCr(count+12), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+13;
        end    
    elseif HACCr(count:count+6) == [1,1,1,1,0,0,0]
        if HACCr(count+7) == 1
            temp = 64+dot(HACCr(count+8:count+13), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+14;
        else
            temp = -127+dot(HACCr(count+8:count+13), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+14;
        end    
    elseif HACCr(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,0,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,1];
        count = count+15;
    elseif HACCr(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,0,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,-1];
        count = count+15;    
    elseif HACCr(count:count+15) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,1];
        count = count+16;
    elseif HACCr(count:count+15) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,0]
        ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,-1];
        count = count+16;
      
    elseif HACCr(count:count+8) == [1,1,1,1,1,0,1,0,0]
        if HACCr(count+9) == 1
            temp = 128+dot(HACCr(count+10:count+16), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+17;
        else
            temp = -255+dot(HACCr(count+10:count+16), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+17;
        end
    elseif HACCr(count:count+9) == [1,1,1,1,1,1,0,1,1,0]
        if HACCr(count+10) == 1
            temp = 256+dot(HACCr(count+11:count+28), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+19;
        else
            temp = -511+dot(HACCr(count+11:count+18), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+19;
        end
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,0]
        if HACCr(count+12) == 1
            temp = 512+dot(HACCr(count+13:count+21), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+22;
        else
            temp = -1023+dot(HACCr(count+13:count+21), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},0,temp];
            count = count+22;
        end
            
    elseif HACCr(count:count+10) == [1,1,1,1,1,1,1,0,1,1,0]
        if HACCr(count+11) == 1
            temp = 16+dot(HACCr(count+12:count+15), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+16;
        else
            temp = -31+dot(HACCr(count+12:count+15), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+16;
        end    
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,1,0,1]
        if HACCr(count+12) == 1
            temp = 32+dot(HACCr(count+13:count+17), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+18;
        else
            temp = -63+dot(HACCr(count+13:count+17), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+18;
        end
    elseif a16 == 65416
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+23;
        end
    elseif a16 == 65417
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+24;
        end
    elseif a16 == 65418
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+25;
        end
    elseif a16 == 65419
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},1,temp];
            count = count+26;
        end
        
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,0]
        if HACCr(count+12) == 1
            temp = 8+dot(HACCr(count+13:count+15), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+16;
        else
            temp = -15+dot(HACCr(count+13:count+15), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+16;
        end
    elseif HACCr(count:count+14) == [1,1,1,1,1,1,1,1,1,0,0,0,0,1,0]
        if HACCr(count+15) == 1
            temp = 16+dot(HACCr(count+16:count+19), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+20;
        else
            temp = -31+dot(HACCr(count+16:count+19), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+20;
        end    
    elseif a16 == 65420
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+22;
        end
    elseif a16 == 65421
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+23;
        end
    elseif a16 == 65422
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+24;
        end
    elseif a16 == 65423
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+25;
        end
    elseif a16 == 65424
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},2,temp];
            count = count+26;
        end
    
    elseif HACCr(count:count+11) == [1,1,1,1,1,1,1,1,0,1,1,1]
        if HACCr(count+12) == 1
            temp = 8+dot(HACCr(count+13:count+15), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+16;
        else
            temp = -15+dot(HACCr(count+13:count+15), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+16;
        end
    elseif a16 == 65425
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+21;
        end    
    elseif a16 == 65426
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+22;
        end
    elseif a16 == 65427
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+23;
        end
    elseif a16 == 65428
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+24;
        end
    elseif a16 == 65429
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+25;
        end
    elseif a16 == 65430
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},3,temp];
            count = count+26;
        end
           
    elseif a16 == 65431
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+19;
        end
    elseif a16 == 65432
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+20;
        end
    elseif a16 == 65433
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+21;
        end    
    elseif a16 == 65434
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+22;
        end
    elseif a16 == 65435
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+23;
        end
    elseif a16 == 65436
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+24;
        end
    elseif a16 == 65437
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+25;
        end
    elseif a16 == 65438
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},4,temp];
            count = count+26;
        end
        
    elseif a16 == 65439
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+19;
        end
    elseif a16 == 65440
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+20;
        end
    elseif a16 == 65441
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+21;
        end    
    elseif a16 == 65442
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+22;
        end
    elseif a16 == 65443
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+23;
        end
    elseif a16 == 65444
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+24;
        end
    elseif a16 == 65445
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+25;
        end
    elseif a16 == 65446
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},5,temp];
            count = count+26;
        end
        
    elseif a16 == 65447
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+19;
        end
    elseif a16 == 65448
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+20;
        end
    elseif a16 == 65449
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+21;
        end    
    elseif a16 == 65450
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+22;
        end
    elseif a16 == 65451
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+23;
        end
    elseif a16 == 65452
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+24;
        end
    elseif a16 == 65453
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+25;
        end
    elseif a16 == 65454
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},6,temp];
            count = count+26;
        end
        
    elseif a16 == 65455
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+19;
        end
    elseif a16 == 65456
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+20;
        end
    elseif a16 == 65457
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+21;
        end    
    elseif a16 == 65458
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+22;
        end
    elseif a16 == 65459
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+23;
        end
    elseif a16 == 65460
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+24;
        end
    elseif a16 == 65461
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+25;
        end
    elseif a16 == 65462
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},7,temp];
            count = count+26;
        end
        
    elseif a16 == 65463
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+18;
        end
    elseif a16 == 65464
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+19;
        end
    elseif a16 == 65465
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+20;
        end
    elseif a16 == 65466
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+21;
        end    
    elseif a16 == 65467
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+22;
        end
    elseif a16 == 65468
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+23;
        end
    elseif a16 == 65469
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+24;
        end
    elseif a16 == 65470
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+25;
        end
    elseif a16 == 65471
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},8,temp];
            count = count+26;
        end
        
    elseif a16 == 65472
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+18;
        end
    elseif a16 == 65473
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+19;
        end
    elseif a16 == 65474
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+20;
        end
    elseif a16 == 65475
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+21;
        end    
    elseif a16 == 65476
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+22;
        end
    elseif a16 == 65477
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+23;
        end
    elseif a16 == 65478
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+24;
        end
    elseif a16 == 65479
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+25;
        end
    elseif a16 == 65480
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},9,temp];
            count = count+26;
        end
        
    elseif a16 == 65481
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+18;
        end
    elseif a16 == 65482
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+19;
        end
    elseif a16 == 65483
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+20;
        end
    elseif a16 == 65484
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+21;
        end    
    elseif a16 == 65485
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+22;
        end
    elseif a16 == 65486
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+23;
        end
    elseif a16 == 65487
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+24;
        end
    elseif a16 == 65488
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+25;
        end
    elseif a16 == 65489
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},10,temp];
            count = count+26;
        end
        
    elseif a16 == 65490
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+18;
        end
    elseif a16 == 65491
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+19;
        end
    elseif a16 == 65492
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+20;
        end
    elseif a16 == 65493
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+21;
        end    
    elseif a16 == 65494
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+22;
        end
    elseif a16 == 65495
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+23;
        end
    elseif a16 == 65496
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+24;
        end
    elseif a16 == 65497
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+25;
        end
    elseif a16 == 65498
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},11,temp];
            count = count+26;
        end
        
    elseif a16 == 65499
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+18;
        end
    elseif a16 == 65500
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+19;
        end
    elseif a16 == 65501
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+20;
        end
    elseif a16 == 65502
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+21;
        end    
    elseif a16 == 65503
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+22;
        end
    elseif a16 == 65504
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+23;
        end
    elseif a16 == 65505
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+24;
        end
    elseif a16 == 65506
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+25;
        end
    elseif a16 == 65507
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},12,temp];
            count = count+26;
        end
        
    elseif a16 == 65508
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+18;
        end
    elseif a16 == 65509
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+19;
        end
    elseif a16 == 65510
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+20;
        end
    elseif a16 == 65511
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+21;
        end    
    elseif a16 == 65512
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+22;
        end
    elseif a16 == 65513
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+23;
        end
    elseif a16 == 65514
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+24;
        end
    elseif a16 == 65515
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+25;
        end
    elseif a16 == 65516
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},13,temp];
            count = count+26;
        end
        
    elseif a16 == 65517
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+18;
        end
    elseif a16 == 65518
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+19;
        end
    elseif a16 == 65519
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+20;
        end
    elseif a16 == 65520
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+21;
        end    
    elseif a16 == 65521
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+22;
        end
    elseif a16 == 65522
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+23;
        end
    elseif a16 == 65523
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+24;
        end
    elseif a16 == 65524
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+25;
        end
    elseif a16 == 65525
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        end
        
    elseif a16 == 65526
        if HACCr(count+16) == 1
            temp = 2+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+18;
        else
            temp = -3+dot(HACCr(count+17), [1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+18;
        end
    elseif a16 == 65527
        if HACCr(count+16) == 1
            temp = 4+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+19;
        else
            temp = -7+dot(HACCr(count+17:count+18), [2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+19;
        end
    elseif a16 == 65528
        if HACCr(count+16) == 1
            temp = 8+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+20;
        else
            temp = -15+dot(HACCr(count+17:count+19), [4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+20;
        end
    elseif a16 == 65529
        if HACCr(count+16) == 1
            temp = 16+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+21;
        else
            temp = -31+dot(HACCr(count+17:count+20), [8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+21;
        end    
    elseif a16 == 65530
        if HACCr(count+16) == 1
            temp = 32+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+22;
        else
            temp = -63+dot(HACCr(count+17:count+21), [16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+22;
        end
    elseif a16 == 65531
        if HACCr(count+16) == 1
            temp = 64+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+23;
        else
            temp = -127+dot(HACCr(count+17:count+22), [32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+23;
        end
    elseif a16 == 65532
        if HACCr(count+16) == 1
            temp = 128+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+24;
        else
            temp = -255+dot(HACCr(count+17:count+23), [64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+24;
        end
    elseif a16 == 65533
        if HACCr(count+16) == 1
            temp = 256+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+25;
        else
            temp = -511+dot(HACCr(count+17:count+24), [128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},15,temp];
            count = count+25;
        end
    elseif a16 == 65534
        if HACCr(count+16) == 1
            temp = 512+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        else
            temp = -1023+dot(HACCr(count+17:count+25), [256,128,64,32,16,8,4,2,1]);
            ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1} = [ACCr2{ceil(count2/sz*16),mod(count2-1,sz/16)+1},14,temp];
            count = count+26;
        end    
    end
end

for i = 1:sz/8
    for j = 1:sz/8
        for k = 1:length(ACY2{i,j})/2-1
            if ACY2{i,j}(2*k-1)==15 && ACY2{i,j}(2*k)==0
                ACY2{i,j}(2*k-1) = 16+ACY2{i,j}(2*k+1);
                ACY2{i,j}(2*k:length(ACY2{i,j})-2) = ACY2{i,j}(2*k+2:length(ACY2{i,j}));
                ACY2{i,j}(length(ACY2{i,j})-1:length(ACY2{i,j})) = [];
            end
            if k*2 == length(ACY2{i,j})
                break;
            end
        end
    end
end

for i = 1:sz/16
    for j = 1:sz/16
        for k = 1:length(ACCb2{i,j})/2-1
            if ACCb2{i,j}(2*k-1)==15 && ACCb2{i,j}(2*k)==0
                ACCb2{i,j}(2*k-1) = 16+ACCb2{i,j}(2*k+1);
                ACCb2{i,j}(2*k:length(ACCb2{i,j})-2) = ACCb2{i,j}(2*k+2:length(ACCb2{i,j}));
                ACCb2{i,j}(length(ACCb2{i,j})-1:length(ACCb2{i,j})) = [];
            end
            if k*2 == length(ACCb2{i,j})
                break;
            end
        end
    end
end

for i = 1:sz/16
    for j = 1:sz/16
        for k = 1:length(ACCr2{i,j})/2-1
            if ACCr2{i,j}(2*k-1)==15 && ACCr2{i,j}(2*k)==0
                ACCr2{i,j}(2*k-1) = 16+ACCr2{i,j}(2*k+1);
                ACCr2{i,j}(2*k:length(ACCr2{i,j})-2) = ACCr2{i,j}(2*k+2:length(ACCr2{i,j}));
                ACCr2{i,j}(length(ACCr2{i,j})-1:length(ACCr2{i,j})) = [];
            end
            if k*2 == length(ACCr2{i,j})
                break;
            end
        end
    end
end

FY3 = zeros(size(DCY2,1)*8);
FCb3 = zeros(size(DCY2,1)*4);
FCr3 = zeros(size(DCY2,1)*4);
FY3(1,1) = DCY2(1,1);
for a = 2:size(DCY2,1)
    FY3(8*a-7,1) = DCY2(a,1) + FY3(8*a-15,1);
end
for a = 1:size(DCY2,1)
    for b = 2:size(DCY2,1)
        FY3(8*a-7,8*b-7) = DCY2(a,b) + FY3(8*a-7,8*b-15);
    end
end
FCb3(1,1) = DCCb2(1,1);
for a = 2:size(DCY2,1)/2
    FCb3(8*a-7,1) = DCCb2(a,1) + FCb3(8*a-15,1);
end
for a = 1:size(DCY2,1)/2
    for b = 2:size(DCY2,1)/2
        FCb3(8*a-7,8*b-7) = DCCb2(a,b) + FCb3(8*a-7,8*b-15);
    end
end
FCr3(1,1) = DCCr2(1,1);
for a = 2:size(DCY2,1)/2
    FCr3(8*a-7,1) = DCCr2(a,1) + FCr3(8*a-15,1);
end
for a = 1:size(DCY2,1)/2
    for b = 2:size(DCY2,1)/2
        FCr3(8*a-7,8*b-7) = DCCr2(a,b) + FCr3(8*a-7,8*b-15);
    end
end
 
for a = 1:size(DCY2,1)
    for b = 1:size(DCY2,1)
        AC = zeros(63,1);
        count = 1;
        count2 = 0;
        if ~isempty(ACY2{a,b})
            while ACY2{a,b}(2*count-1)~=0 || ACY2{a,b}(2*count)~=0
            for c = 1:ACY2{a,b}(2*count-1)
                AC(count2+c) = 0;
            end
            AC(count2+ACY2{a,b}(2*count-1)+1) = ACY2{a,b}(2*count);
            count2 = count2 + ACY2{a,b}(2*count-1) +1;
            count = count+1;
            if count*2-2 == length(ACY2{a,b})
                break
            end
            end
        end
FY3(8*a-7,8*b-6) = AC(1);
FY3(8*a-6,8*b-7) = AC(2);
FY3(8*a-5,8*b-7) = AC(3);
FY3(8*a-6,8*b-6) = AC(4);
FY3(8*a-7,8*b-5) = AC(5);
FY3(8*a-7,8*b-4) = AC(6);
FY3(8*a-6,8*b-5) = AC(7);
FY3(8*a-5,8*b-6) = AC(8);
FY3(8*a-4,8*b-7) = AC(9);
FY3(8*a-3,8*b-7) = AC(10);
FY3(8*a-4,8*b-6) = AC(11);
FY3(8*a-5,8*b-5) = AC(12);
FY3(8*a-6,8*b-4) = AC(13);
FY3(8*a-7,8*b-3) = AC(14);
FY3(8*a-7,8*b-2) = AC(15);
FY3(8*a-6,8*b-3) = AC(16);
FY3(8*a-5,8*b-4) = AC(17);
FY3(8*a-4,8*b-5) = AC(18);
FY3(8*a-3,8*b-6) = AC(19);
FY3(8*a-2,8*b-7) = AC(20);
FY3(8*a-1,8*b-7) = AC(21);
FY3(8*a-2,8*b-6) = AC(22);
FY3(8*a-3,8*b-5) = AC(23);
FY3(8*a-4,8*b-4) = AC(24);
FY3(8*a-5,8*b-3) = AC(25);
FY3(8*a-6,8*b-2) = AC(26);
FY3(8*a-7,8*b-1) = AC(27);
FY3(8*a-7,8*b) = AC(28);
FY3(8*a-6,8*b-1) = AC(29);
FY3(8*a-5,8*b-2) = AC(30);
FY3(8*a-4,8*b-3) = AC(31);
FY3(8*a-3,8*b-4) = AC(32);
FY3(8*a-2,8*b-5) = AC(33);
FY3(8*a-1,8*b-6) = AC(34);
FY3(8*a,8*b-7) = AC(35);
FY3(8*a,8*b-6) = AC(36);
FY3(8*a-1,8*b-5) = AC(37);
FY3(8*a-2,8*b-4) = AC(38);
FY3(8*a-3,8*b-3) = AC(39);
FY3(8*a-4,8*b-2) = AC(40);
FY3(8*a-5,8*b-1) = AC(41);
FY3(8*a-6,8*b) = AC(42);
FY3(8*a-5,8*b) = AC(43);
FY3(8*a-4,8*b-1) = AC(44);
FY3(8*a-3,8*b-2) = AC(45);
FY3(8*a-2,8*b-3) = AC(46);
FY3(8*a-1,8*b-4) = AC(47);
FY3(8*a,8*b-5) = AC(48);
FY3(8*a,8*b-4) = AC(49);
FY3(8*a-1,8*b-3) = AC(50);
FY3(8*a-2,8*b-2) = AC(51);
FY3(8*a-3,8*b-1) = AC(52);
FY3(8*a-4,8*b) = AC(53);
FY3(8*a-3,8*b) = AC(54);
FY3(8*a-2,8*b-1) = AC(55);
FY3(8*a-1,8*b-2) = AC(56);
FY3(8*a,8*b-3) = AC(57);
FY3(8*a,8*b-2) = AC(58);
FY3(8*a-1,8*b-1) = AC(59);
FY3(8*a-2,8*b) = AC(60);
FY3(8*a-1,8*b) = AC(61);
FY3(8*a,8*b-1) = AC(62);
FY3(8*a,8*b) = AC(63);    
    end
end
 
for a = 1:size(DCY2,1)/2
    for b = 1:size(DCY2,1)/2
        AC = zeros(63,1);
        count = 1;
        count2 = 0;
        if ~isempty(ACCb2{a,b})
            while ACCb2{a,b}(2*count-1)~=0 || ACCb2{a,b}(2*count)~=0
            for c = 1:ACCb2{a,b}(2*count-1)
                AC(count2+c) = 0;
            end
            AC(count2+ACCb2{a,b}(2*count-1)+1)=ACCb2{a,b}(2*count);
            count2 = count2 + +ACCb2{a,b}(2*count-1)+1;
            count = count+1;
            if count*2-2 == length(ACCb2{a,b})
                break
            end
            end
        end
FCb3(8*a-7,8*b-6) = AC(1);
FCb3(8*a-6,8*b-7) = AC(2);
FCb3(8*a-5,8*b-7) = AC(3);
FCb3(8*a-6,8*b-6) = AC(4);
FCb3(8*a-7,8*b-5) = AC(5);
FCb3(8*a-7,8*b-4) = AC(6);
FCb3(8*a-6,8*b-5) = AC(7);
FCb3(8*a-5,8*b-6) = AC(8);
FCb3(8*a-4,8*b-7) = AC(9);
FCb3(8*a-3,8*b-7) = AC(10);
FCb3(8*a-4,8*b-6) = AC(11);
FCb3(8*a-5,8*b-5) = AC(12);
FCb3(8*a-6,8*b-4) = AC(13);
FCb3(8*a-7,8*b-3) = AC(14);
FCb3(8*a-7,8*b-2) = AC(15);
FCb3(8*a-6,8*b-3) = AC(16);
FCb3(8*a-5,8*b-4) = AC(17);
FCb3(8*a-4,8*b-5) = AC(18);
FCb3(8*a-3,8*b-6) = AC(19);
FCb3(8*a-2,8*b-7) = AC(20);
FCb3(8*a-1,8*b-7) = AC(21);
FCb3(8*a-2,8*b-6) = AC(22);
FCb3(8*a-3,8*b-5) = AC(23);
FCb3(8*a-4,8*b-4) = AC(24);
FCb3(8*a-5,8*b-3) = AC(25);
FCb3(8*a-6,8*b-2) = AC(26);
FCb3(8*a-7,8*b-1) = AC(27);
FCb3(8*a-7,8*b) = AC(28);
FCb3(8*a-6,8*b-1) = AC(29);
FCb3(8*a-5,8*b-2) = AC(30);
FCb3(8*a-4,8*b-3) = AC(31);
FCb3(8*a-3,8*b-4) = AC(32);
FCb3(8*a-2,8*b-5) = AC(33);
FCb3(8*a-1,8*b-6) = AC(34);
FCb3(8*a,8*b-7) = AC(35);
FCb3(8*a,8*b-6) = AC(36);
FCb3(8*a-1,8*b-5) = AC(37);
FCb3(8*a-2,8*b-4) = AC(38);
FCb3(8*a-3,8*b-3) = AC(39);
FCb3(8*a-4,8*b-2) = AC(40);
FCb3(8*a-5,8*b-1) = AC(41);
FCb3(8*a-6,8*b) = AC(42);
FCb3(8*a-5,8*b) = AC(43);
FCb3(8*a-4,8*b-1) = AC(44);
FCb3(8*a-3,8*b-2) = AC(45);
FCb3(8*a-2,8*b-3) = AC(46);
FCb3(8*a-1,8*b-4) = AC(47);
FCb3(8*a,8*b-5) = AC(48);
FCb3(8*a,8*b-4) = AC(49);
FCb3(8*a-1,8*b-3) = AC(50);
FCb3(8*a-2,8*b-2) = AC(51);
FCb3(8*a-3,8*b-1) = AC(52);
FCb3(8*a-4,8*b) = AC(53);
FCb3(8*a-3,8*b) = AC(54);
FCb3(8*a-2,8*b-1) = AC(55);
FCb3(8*a-1,8*b-2) = AC(56);
FCb3(8*a,8*b-3) = AC(57);
FCb3(8*a,8*b-2) = AC(58);
FCb3(8*a-1,8*b-1) = AC(59);
FCb3(8*a-2,8*b) = AC(60);
FCb3(8*a-1,8*b) = AC(61);
FCb3(8*a,8*b-1) = AC(62);
FCb3(8*a,8*b) = AC(63);    
    end
end
 
for a = 1:size(DCY2,1)/2
    for b = 1:size(DCY2,1)/2
        AC = zeros(63,1);
        count = 1;
        count2 = 0;
        if ~isempty(ACCr2{a,b})
            while (ACCr2{a,b}(2*count-1)~=0 || ACCr2{a,b}(2*count)~=0)
            for c = 1:ACCr2{a,b}(2*count-1)
                AC(count2+c) = 0;
            end
            AC(count2+ACCr2{a,b}(2*count-1)+1)=ACCr2{a,b}(2*count);
            count2 = count2 + +ACCr2{a,b}(2*count-1)+1;
            count = count+1;
            if count*2-2 == length(ACCr2{a,b})
                break
            end
            end
        end
FCr3(8*a-7,8*b-6) = AC(1);
FCr3(8*a-6,8*b-7) = AC(2);
FCr3(8*a-5,8*b-7) = AC(3);
FCr3(8*a-6,8*b-6) = AC(4);
FCr3(8*a-7,8*b-5) = AC(5);
FCr3(8*a-7,8*b-4) = AC(6);
FCr3(8*a-6,8*b-5) = AC(7);
FCr3(8*a-5,8*b-6) = AC(8);
FCr3(8*a-4,8*b-7) = AC(9);
FCr3(8*a-3,8*b-7) = AC(10);
FCr3(8*a-4,8*b-6) = AC(11);
FCr3(8*a-5,8*b-5) = AC(12);
FCr3(8*a-6,8*b-4) = AC(13);
FCr3(8*a-7,8*b-3) = AC(14);
FCr3(8*a-7,8*b-2) = AC(15);
FCr3(8*a-6,8*b-3) = AC(16);
FCr3(8*a-5,8*b-4) = AC(17);
FCr3(8*a-4,8*b-5) = AC(18);
FCr3(8*a-3,8*b-6) = AC(19);
FCr3(8*a-2,8*b-7) = AC(20);
FCr3(8*a-1,8*b-7) = AC(21);
FCr3(8*a-2,8*b-6) = AC(22);
FCr3(8*a-3,8*b-5) = AC(23);
FCr3(8*a-4,8*b-4) = AC(24);
FCr3(8*a-5,8*b-3) = AC(25);
FCr3(8*a-6,8*b-2) = AC(26);
FCr3(8*a-7,8*b-1) = AC(27);
FCr3(8*a-7,8*b) = AC(28);
FCr3(8*a-6,8*b-1) = AC(29);
FCr3(8*a-5,8*b-2) = AC(30);
FCr3(8*a-4,8*b-3) = AC(31);
FCr3(8*a-3,8*b-4) = AC(32);
FCr3(8*a-2,8*b-5) = AC(33);
FCr3(8*a-1,8*b-6) = AC(34);
FCr3(8*a,8*b-7) = AC(35);
FCr3(8*a,8*b-6) = AC(36);
FCr3(8*a-1,8*b-5) = AC(37);
FCr3(8*a-2,8*b-4) = AC(38);
FCr3(8*a-3,8*b-3) = AC(39);
FCr3(8*a-4,8*b-2) = AC(40);
FCr3(8*a-5,8*b-1) = AC(41);
FCr3(8*a-6,8*b) = AC(42);
FCr3(8*a-5,8*b) = AC(43);
FCr3(8*a-4,8*b-1) = AC(44);
FCr3(8*a-3,8*b-2) = AC(45);
FCr3(8*a-2,8*b-3) = AC(46);
FCr3(8*a-1,8*b-4) = AC(47);
FCr3(8*a,8*b-5) = AC(48);
FCr3(8*a,8*b-4) = AC(49);
FCr3(8*a-1,8*b-3) = AC(50);
FCr3(8*a-2,8*b-2) = AC(51);
FCr3(8*a-3,8*b-1) = AC(52);
FCr3(8*a-4,8*b) = AC(53);
FCr3(8*a-3,8*b) = AC(54);
FCr3(8*a-2,8*b-1) = AC(55);
FCr3(8*a-1,8*b-2) = AC(56);
FCr3(8*a,8*b-3) = AC(57);
FCr3(8*a,8*b-2) = AC(58);
FCr3(8*a-1,8*b-1) = AC(59);
FCr3(8*a-2,8*b) = AC(60);
FCr3(8*a-1,8*b) = AC(61);
FCr3(8*a,8*b-1) = AC(62);
FCr3(8*a,8*b) = AC(63);    
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
for a = 1:size(DCY2,1)
    for b = 1:size(DCY2,1)
        FY4(8*a-7:8*a, 8*b-7:8*b) = FY3(8*a-7:8*a, 8*b-7:8*b) .* QY;
    end
end
for a = 1:size(DCY2,1)/2
    for b = 1:size(DCY2,1)/2
        FCb4(8*a-7:8*a, 8*b-7:8*b) = FCb3(8*a-7:8*a, 8*b-7:8*b) .* QC;
        FCr4(8*a-7:8*a, 8*b-7:8*b) = FCr3(8*a-7:8*a, 8*b-7:8*b) .* QC;
    end
end
 
 
for a = 1:8
    for b = 1:8
        if a == 1
            C1(a,b) = 0.5/ sqrt(2)* cos((2*b-1)*(a-1)*pi/16);
        else
            C1(a,b) = 0.5* cos((2*b-1)*(a-1)*pi/16);
        end
    end
end
for a = 1:8
    for b = 1:8
            if b == 1
                C2(a,b) = 0.5/ sqrt(2)* cos((2*a-1)*(b-1)*pi/16);
            else
                C2(a,b) = 0.5* cos((2*a-1)*(b-1)*pi/16);
            end
    end
end
for a = 1:size(DCY2,1)
for b = 1:size(DCY2,1)
Y3(8*a-7:8*a, 8*b-7:8*b) = C2* FY4(8*a-7:8*a, 8*b-7:8*b)* C1;
end
end
for a = 1:size(DCY2,1)/2
for b = 1:size(DCY2,1)/2
Cb3(8*a-7:8*a, 8*b-7:8*b) = C2* FCb4(8*a-7:8*a, 8*b-7:8*b)* C1;
end
end
for a = 1:size(DCY2,1)/2
for b = 1:size(DCY2,1)/2
Cr3(8*a-7:8*a, 8*b-7:8*b) = C2* FCr4(8*a-7:8*a, 8*b-7:8*b)* C1;
end
end
 
for a = 1:size(DCY2,1)*4
for b = 1:size(DCY2,1)*4
Cb4(2*a-1,2*b-1) = Cb3(a,b);
Cb4(2*a-1,2*b) = Cb3(a,b);
Cb4(2*a,2*b-1) = Cb3(a,b);
Cb4(2*a,2*b) = Cb3(a,b);
end
end
for a = 1:size(DCY2,1)*4
for b = 1:size(DCY2,1)*4
Cr4(2*a-1,2*b-1) = Cr3(a,b);
Cr4(2*a-1,2*b) = Cr3(a,b);
Cr4(2*a,2*b-1) = Cr3(a,b);
Cr4(2*a,2*b) = Cr3(a,b);
end
end
 
for a = 1:size(DCY2,1)*8
for b = 1:size(DCY2,1)*8
x2(a,b,1) = Y3(a,b) + 1.402*(Cr4(a,b)-128);
x2(a,b,2) = Y3(a,b) - 0.344*(Cb4(a,b)-128) - 0.714*(Cr4(a,b)-128);
x2(a,b,3) = Y3(a,b) + 1.772*(Cb4(a,b)-128);
end
end
x2 = uint8(x2);
end
