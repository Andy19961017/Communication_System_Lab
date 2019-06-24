function [HDCY, HDCCb, HDCCr, HACY, HACCb, HACCr] = compression16(x)
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

for a = 1:16
    for b = 1:16
        if a == 1
            C1(a,b) = 0.5/ 2* cos((2*b-1)*(a-1)*pi/32);
        else
            C1(a,b) = 0.5/ sqrt(2)* cos((2*b-1)*(a-1)*pi/32);
        end
    end
end
for a = 1:16
    for b = 1:16
            if b == 1
                C2(a,b) = 0.5/ 2* cos((2*a-1)*(b-1)*pi/32);
            else
                C2(a,b) = 0.5/ sqrt(2)* cos((2*a-1)*(b-1)*pi/32);
            end
    end
end
for a = 1:size(x,1)/16
    for b = 1:size(x,1)/16
        FY((16*a-15):16*a, (16*b-15):16*b) = C1* double(Y((16*a-15):16*a, (16*b-15):16*b))* C2;
    end
end
for a = 1:size(x,1)/32
    for b = 1:size(x,1)/32
        FCb((16*a-15):16*a, (16*b-15):16*b) = C1* double(Cb2((16*a-15):16*a, (16*b-15):16*b))* C2;
    end
end
for a = 1:size(x,1)/32
    for b = 1:size(x,1)/32
        FCr((16*a-15):16*a, (16*b-15):16*b) = C1* double(Cr2((16*a-15):16*a, (16*b-15):16*b))* C2;
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

QY2 = zeros(16);
QC2 = zeros(16);
for a = 1:8
    for b = 1:8
        QY2(2*a-1,2*b-1) = QY(a,b);
        QY2(2*a-1,2*b) = QY(a,b);
        QY2(2*a,2*b-1) = QY(a,b);
        QY2(2*a,2*b) = QY(a,b);
        QC2(2*a-1,2*b-1) = QC(a,b);
        QC2(2*a-1,2*b) = QC(a,b);
        QC2(2*a,2*b-1) = QC(a,b);
        QC2(2*a,2*b) = QC(a,b);
    end
end

for a = 1:size(x,1)/16
    for b = 1:size(x,1)/16
        FY2(16*a-15:16*a, 16*b-15:16*b) = round(FY(16*a-15:16*a, 16*b-15:16*b) ./ QY2);
    end
end
for a = 1:size(x,1)/32
    for b = 1:size(x,1)/32
        FCb2(16*a-15:16*a, 16*b-15:16*b) = round(FCb(16*a-15:16*a, 16*b-15:16*b) ./ QC2);
        FCr2(16*a-15:16*a, 16*b-15:16*b) = round(FCr(16*a-15:16*a, 16*b-15:16*b) ./ QC2);
    end
end

DCY(1,1) = FY2(1,1);
for a = 2:size(x,1)/16
    DCY(a,1) = FY2(16*a-15,1) - FY2(16*a-31,1);
end
for a = 1:size(x,1)/16
    for b = 2:size(x,1)/16
        DCY(a,b) = FY2(16*a-15,16*b-15) - FY2(16*a-15,16*b-31);
    end
end
DCCb(1,1) = FCb2(1,1);
for a = 2:size(x,1)/32
    DCCb(a,1) = FCb2(16*a-15,1) - FCb2(16*a-31,1);
end
for a = 1:size(x,1)/32
    for b = 2:size(x,1)/32
            DCCb(a,b) = FCb2(16*a-15,16*b-15) - FCb2(16*a-15,16*b-31);
    end
end
DCCr(1,1) = FCr2(1,1);
for a = 2:size(x,1)/32
    DCCr(a,1) = FCr2(16*a-15,1) - FCr2(16*a-31,1);
end
for a = 1:size(x,1)/32
    for b = 2:size(x,1)/32
            DCCr(a,b) = FCr2(16*a-15,16*b-15) - FCr2(16*a-15,16*b-31);
    end
end

ACY = cell(size(x,1)/16);
for a = 1:size(x,1)/16
for b = 1:size(x,1)/16
AC(1) = FY2(16*a-15,16*b-14);
AC(2) = FY2(16*a-14,16*b-15);
AC(3) = FY2(16*a-13,16*b-15);
AC(4) = FY2(16*a-14,16*b-14);
AC(5) = FY2(16*a-15,16*b-13);
AC(6) = FY2(16*a-15,16*b-12);
AC(7) = FY2(16*a-14,16*b-13);
AC(8) = FY2(16*a-13,16*b-14);
AC(9) = FY2(16*a-12,16*b-15);
AC(10) = FY2(16*a-11,16*b-15);
AC(11) = FY2(16*a-12,16*b-14);
AC(12) = FY2(16*a-13,16*b-13);
AC(13) = FY2(16*a-14,16*b-12);
AC(14) = FY2(16*a-15,16*b-11);
AC(15) = FY2(16*a-15,16*b-10);
AC(16) = FY2(16*a-14,16*b-11);
AC(17) = FY2(16*a-13,16*b-12);
AC(18) = FY2(16*a-12,16*b-13);
AC(19) = FY2(16*a-11,16*b-14);
AC(20) = FY2(16*a-10,16*b-15);
AC(21) = FY2(16*a-9,16*b-15);
AC(22) = FY2(16*a-10,16*b-14);
AC(23) = FY2(16*a-11,16*b-13);
AC(24) = FY2(16*a-12,16*b-12);
AC(25) = FY2(16*a-13,16*b-11);
AC(26) = FY2(16*a-14,16*b-10);
AC(27) = FY2(16*a-15,16*b-9);
AC(28) = FY2(16*a-15,16*b-8);
AC(29) = FY2(16*a-14,16*b-9);
AC(30) = FY2(16*a-13,16*b-10);
AC(31) = FY2(16*a-12,16*b-11);
AC(32) = FY2(16*a-11,16*b-12);
AC(33) = FY2(16*a-10,16*b-13);
AC(34) = FY2(16*a-9,16*b-14);
AC(35) = FY2(16*a-8,16*b-15);
AC(36) = FY2(16*a-7,16*b-15);
AC(37) = FY2(16*a-8,16*b-14);
AC(38) = FY2(16*a-9,16*b-13);
AC(39) = FY2(16*a-10,16*b-12);
AC(40) = FY2(16*a-11,16*b-11);
AC(41) = FY2(16*a-12,16*b-10);
AC(42) = FY2(16*a-13,16*b-9);
AC(43) = FY2(16*a-14,16*b-8);
AC(44) = FY2(16*a-15,16*b-7);
AC(45) = FY2(16*a-15,16*b-6);
AC(46) = FY2(16*a-14,16*b-7);
AC(47) = FY2(16*a-13,16*b-8);
AC(48) = FY2(16*a-12,16*b-9);
AC(49) = FY2(16*a-11,16*b-10);
AC(50) = FY2(16*a-10,16*b-11);
AC(51) = FY2(16*a-9,16*b-12);
AC(52) = FY2(16*a-8,16*b-13);
AC(53) = FY2(16*a-7,16*b-14);
AC(54) = FY2(16*a-6,16*b-15);
AC(55) = FY2(16*a-5,16*b-15);
AC(56) = FY2(16*a-6,16*b-14);
AC(57) = FY2(16*a-7,16*b-13);
AC(58) = FY2(16*a-8,16*b-12);
AC(59) = FY2(16*a-9,16*b-11);
AC(60) = FY2(16*a-10,16*b-10);
AC(61) = FY2(16*a-11,16*b-9);
AC(62) = FY2(16*a-12,16*b-8);
AC(63) = FY2(16*a-13,16*b-7);
AC(64) = FY2(16*a-14,16*b-6);
AC(65) = FY2(16*a-15,16*b-5);
AC(66) = FY2(16*a-15,16*b-4);
AC(67) = FY2(16*a-14,16*b-5);
AC(68) = FY2(16*a-13,16*b-6);
AC(69) = FY2(16*a-12,16*b-7);
AC(70) = FY2(16*a-11,16*b-8);
AC(71) = FY2(16*a-10,16*b-9);
AC(72) = FY2(16*a-9,16*b-10);
AC(73) = FY2(16*a-8,16*b-11);
AC(74) = FY2(16*a-7,16*b-12);
AC(75) = FY2(16*a-6,16*b-13);
AC(76) = FY2(16*a-5,16*b-14);
AC(77) = FY2(16*a-4,16*b-15);
AC(78) = FY2(16*a-3,16*b-15);
AC(79) = FY2(16*a-4,16*b-14);
AC(80) = FY2(16*a-5,16*b-13);
AC(81) = FY2(16*a-6,16*b-12);
AC(82) = FY2(16*a-7,16*b-11);
AC(83) = FY2(16*a-8,16*b-10);
AC(84) = FY2(16*a-9,16*b-9);
AC(85) = FY2(16*a-10,16*b-8);
AC(86) = FY2(16*a-11,16*b-7);
AC(87) = FY2(16*a-12,16*b-6);
AC(88) = FY2(16*a-13,16*b-5);
AC(89) = FY2(16*a-14,16*b-4);
AC(90) = FY2(16*a-15,16*b-3);
AC(91) = FY2(16*a-15,16*b-2);
AC(92) = FY2(16*a-14,16*b-3);
AC(93) = FY2(16*a-13,16*b-4);
AC(94) = FY2(16*a-12,16*b-5);
AC(95) = FY2(16*a-11,16*b-6);
AC(96) = FY2(16*a-10,16*b-7);
AC(97) = FY2(16*a-9,16*b-8);
AC(98) = FY2(16*a-8,16*b-9);
AC(99) = FY2(16*a-7,16*b-10);
AC(100) = FY2(16*a-6,16*b-11);
AC(101) = FY2(16*a-5,16*b-12);
AC(102) = FY2(16*a-4,16*b-13);
AC(103) = FY2(16*a-3,16*b-14);
AC(104) = FY2(16*a-2,16*b-15);
AC(105) = FY2(16*a-1,16*b-15);
AC(106) = FY2(16*a-2,16*b-14);
AC(107) = FY2(16*a-3,16*b-13);
AC(108) = FY2(16*a-4,16*b-12);
AC(109) = FY2(16*a-5,16*b-11);
AC(110) = FY2(16*a-6,16*b-10);
AC(111) = FY2(16*a-7,16*b-9);
AC(112) = FY2(16*a-8,16*b-8);
AC(113) = FY2(16*a-9,16*b-7);
AC(114) = FY2(16*a-10,16*b-6);
AC(115) = FY2(16*a-11,16*b-5);
AC(116) = FY2(16*a-12,16*b-4);
AC(117) = FY2(16*a-13,16*b-3);
AC(118) = FY2(16*a-14,16*b-2);
AC(119) = FY2(16*a-15,16*b-1);
AC(120) = FY2(16*a-15,16*b);
AC(121) = FY2(16*a-14,16*b-1);
AC(122) = FY2(16*a-13,16*b-2);
AC(123) = FY2(16*a-12,16*b-3);
AC(124) = FY2(16*a-11,16*b-4);
AC(125) = FY2(16*a-10,16*b-5);
AC(126) = FY2(16*a-9,16*b-6);
AC(127) = FY2(16*a-8,16*b-7);
AC(128) = FY2(16*a-7,16*b-8);
AC(129) = FY2(16*a-6,16*b-9);
AC(130) = FY2(16*a-5,16*b-10);
AC(131) = FY2(16*a-4,16*b-11);
AC(132) = FY2(16*a-3,16*b-12);
AC(133) = FY2(16*a-2,16*b-13);
AC(134) = FY2(16*a-1,16*b-14);
AC(135) = FY2(16*a,16*b-15);
AC(136) = FY2(16*a,16*b-14);
AC(137) = FY2(16*a-1,16*b-13);
AC(138) = FY2(16*a-2,16*b-12);
AC(139) = FY2(16*a-3,16*b-11);
AC(140) = FY2(16*a-4,16*b-10);
AC(141) = FY2(16*a-5,16*b-9);
AC(142) = FY2(16*a-6,16*b-8);
AC(143) = FY2(16*a-7,16*b-7);
AC(144) = FY2(16*a-8,16*b-6);
AC(145) = FY2(16*a-9,16*b-5);
AC(146) = FY2(16*a-10,16*b-4);
AC(147) = FY2(16*a-11,16*b-3);
AC(148) = FY2(16*a-12,16*b-2);
AC(149) = FY2(16*a-13,16*b-1);
AC(150) = FY2(16*a-14,16*b);
AC(151) = FY2(16*a-13,16*b);
AC(152) = FY2(16*a-12,16*b-1);
AC(153) = FY2(16*a-11,16*b-2);
AC(154) = FY2(16*a-10,16*b-3);
AC(155) = FY2(16*a-9,16*b-4);
AC(156) = FY2(16*a-8,16*b-5);
AC(157) = FY2(16*a-7,16*b-6);
AC(158) = FY2(16*a-6,16*b-7);
AC(159) = FY2(16*a-5,16*b-8);
AC(160) = FY2(16*a-4,16*b-9);
AC(161) = FY2(16*a-3,16*b-10);
AC(162) = FY2(16*a-2,16*b-11);
AC(163) = FY2(16*a-1,16*b-12);
AC(164) = FY2(16*a,16*b-13);
AC(165) = FY2(16*a,16*b-12);
AC(166) = FY2(16*a-1,16*b-11);
AC(167) = FY2(16*a-2,16*b-10);
AC(168) = FY2(16*a-3,16*b-9);
AC(169) = FY2(16*a-4,16*b-8);
AC(170) = FY2(16*a-5,16*b-7);
AC(171) = FY2(16*a-6,16*b-6);
AC(172) = FY2(16*a-7,16*b-5);
AC(173) = FY2(16*a-8,16*b-4);
AC(174) = FY2(16*a-9,16*b-3);
AC(175) = FY2(16*a-10,16*b-2);
AC(176) = FY2(16*a-11,16*b-1);
AC(177) = FY2(16*a-12,16*b);
AC(178) = FY2(16*a-11,16*b);
AC(179) = FY2(16*a-10,16*b-1);
AC(180) = FY2(16*a-9,16*b-2);
AC(181) = FY2(16*a-8,16*b-3);
AC(182) = FY2(16*a-7,16*b-4);
AC(183) = FY2(16*a-6,16*b-5);
AC(184) = FY2(16*a-5,16*b-6);
AC(185) = FY2(16*a-4,16*b-7);
AC(186) = FY2(16*a-3,16*b-8);
AC(187) = FY2(16*a-2,16*b-9);
AC(188) = FY2(16*a-1,16*b-10);
AC(189) = FY2(16*a,16*b-11);
AC(190) = FY2(16*a,16*b-10);
AC(191) = FY2(16*a-1,16*b-9);
AC(192) = FY2(16*a-2,16*b-8);
AC(193) = FY2(16*a-3,16*b-7);
AC(194) = FY2(16*a-4,16*b-6);
AC(195) = FY2(16*a-5,16*b-5);
AC(196) = FY2(16*a-6,16*b-4);
AC(197) = FY2(16*a-7,16*b-3);
AC(198) = FY2(16*a-8,16*b-2);
AC(199) = FY2(16*a-9,16*b-1);
AC(200) = FY2(16*a-10,16*b);
AC(201) = FY2(16*a-9,16*b);
AC(202) = FY2(16*a-8,16*b-1);
AC(203) = FY2(16*a-7,16*b-2);
AC(204) = FY2(16*a-6,16*b-3);
AC(205) = FY2(16*a-5,16*b-4);
AC(206) = FY2(16*a-4,16*b-5);
AC(207) = FY2(16*a-3,16*b-6);
AC(208) = FY2(16*a-2,16*b-7);
AC(209) = FY2(16*a-1,16*b-8);
AC(210) = FY2(16*a,16*b-9);
AC(211) = FY2(16*a,16*b-8);
AC(212) = FY2(16*a-1,16*b-7);
AC(213) = FY2(16*a-2,16*b-6);
AC(214) = FY2(16*a-3,16*b-5);
AC(215) = FY2(16*a-4,16*b-4);
AC(216) = FY2(16*a-5,16*b-3);
AC(217) = FY2(16*a-6,16*b-2);
AC(218) = FY2(16*a-7,16*b-1);
AC(219) = FY2(16*a-8,16*b);
AC(220) = FY2(16*a-7,16*b);
AC(221) = FY2(16*a-6,16*b-1);
AC(222) = FY2(16*a-5,16*b-2);
AC(223) = FY2(16*a-4,16*b-3);
AC(224) = FY2(16*a-3,16*b-4);
AC(225) = FY2(16*a-2,16*b-5);
AC(226) = FY2(16*a-1,16*b-6);
AC(227) = FY2(16*a,16*b-7);
AC(228) = FY2(16*a,16*b-6);
AC(229) = FY2(16*a-1,16*b-5);
AC(230) = FY2(16*a-2,16*b-4);
AC(231) = FY2(16*a-3,16*b-3);
AC(232) = FY2(16*a-4,16*b-2);
AC(233) = FY2(16*a-5,16*b-1);
AC(234) = FY2(16*a-6,16*b);
AC(235) = FY2(16*a-5,16*b);
AC(236) = FY2(16*a-4,16*b-1);
AC(237) = FY2(16*a-3,16*b-2);
AC(238) = FY2(16*a-2,16*b-3);
AC(239) = FY2(16*a-1,16*b-4);
AC(240) = FY2(16*a,16*b-5);
AC(241) = FY2(16*a,16*b-4);
AC(242) = FY2(16*a-1,16*b-3);
AC(243) = FY2(16*a-2,16*b-2);
AC(244) = FY2(16*a-3,16*b-1);
AC(245) = FY2(16*a-4,16*b);
AC(246) = FY2(16*a-3,16*b);
AC(247) = FY2(16*a-2,16*b-1);
AC(248) = FY2(16*a-1,16*b-2);
AC(249) = FY2(16*a,16*b-3);
AC(250) = FY2(16*a,16*b-2);
AC(251) = FY2(16*a-1,16*b-1);
AC(252) = FY2(16*a-2,16*b);
AC(253) = FY2(16*a-1,16*b);
AC(254) = FY2(16*a,16*b-1);
AC(255) = FY2(16*a,16*b);
count = 0;
for c = 1:255
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

ACCb = cell(size(x,1)/32);
for a = 1:size(x,1)/32
for b = 1:size(x,1)/32
AC(1) = FCb2(16*a-15,16*b-14);
AC(2) = FCb2(16*a-14,16*b-15);
AC(3) = FCb2(16*a-13,16*b-15);
AC(4) = FCb2(16*a-14,16*b-14);
AC(5) = FCb2(16*a-15,16*b-13);
AC(6) = FCb2(16*a-15,16*b-12);
AC(7) = FCb2(16*a-14,16*b-13);
AC(8) = FCb2(16*a-13,16*b-14);
AC(9) = FCb2(16*a-12,16*b-15);
AC(10) = FCb2(16*a-11,16*b-15);
AC(11) = FCb2(16*a-12,16*b-14);
AC(12) = FCb2(16*a-13,16*b-13);
AC(13) = FCb2(16*a-14,16*b-12);
AC(14) = FCb2(16*a-15,16*b-11);
AC(15) = FCb2(16*a-15,16*b-10);
AC(16) = FCb2(16*a-14,16*b-11);
AC(17) = FCb2(16*a-13,16*b-12);
AC(18) = FCb2(16*a-12,16*b-13);
AC(19) = FCb2(16*a-11,16*b-14);
AC(20) = FCb2(16*a-10,16*b-15);
AC(21) = FCb2(16*a-9,16*b-15);
AC(22) = FCb2(16*a-10,16*b-14);
AC(23) = FCb2(16*a-11,16*b-13);
AC(24) = FCb2(16*a-12,16*b-12);
AC(25) = FCb2(16*a-13,16*b-11);
AC(26) = FCb2(16*a-14,16*b-10);
AC(27) = FCb2(16*a-15,16*b-9);
AC(28) = FCb2(16*a-15,16*b-8);
AC(29) = FCb2(16*a-14,16*b-9);
AC(30) = FCb2(16*a-13,16*b-10);
AC(31) = FCb2(16*a-12,16*b-11);
AC(32) = FCb2(16*a-11,16*b-12);
AC(33) = FCb2(16*a-10,16*b-13);
AC(34) = FCb2(16*a-9,16*b-14);
AC(35) = FCb2(16*a-8,16*b-15);
AC(36) = FCb2(16*a-7,16*b-15);
AC(37) = FCb2(16*a-8,16*b-14);
AC(38) = FCb2(16*a-9,16*b-13);
AC(39) = FCb2(16*a-10,16*b-12);
AC(40) = FCb2(16*a-11,16*b-11);
AC(41) = FCb2(16*a-12,16*b-10);
AC(42) = FCb2(16*a-13,16*b-9);
AC(43) = FCb2(16*a-14,16*b-8);
AC(44) = FCb2(16*a-15,16*b-7);
AC(45) = FCb2(16*a-15,16*b-6);
AC(46) = FCb2(16*a-14,16*b-7);
AC(47) = FCb2(16*a-13,16*b-8);
AC(48) = FCb2(16*a-12,16*b-9);
AC(49) = FCb2(16*a-11,16*b-10);
AC(50) = FCb2(16*a-10,16*b-11);
AC(51) = FCb2(16*a-9,16*b-12);
AC(52) = FCb2(16*a-8,16*b-13);
AC(53) = FCb2(16*a-7,16*b-14);
AC(54) = FCb2(16*a-6,16*b-15);
AC(55) = FCb2(16*a-5,16*b-15);
AC(56) = FCb2(16*a-6,16*b-14);
AC(57) = FCb2(16*a-7,16*b-13);
AC(58) = FCb2(16*a-8,16*b-12);
AC(59) = FCb2(16*a-9,16*b-11);
AC(60) = FCb2(16*a-10,16*b-10);
AC(61) = FCb2(16*a-11,16*b-9);
AC(62) = FCb2(16*a-12,16*b-8);
AC(63) = FCb2(16*a-13,16*b-7);
AC(64) = FCb2(16*a-14,16*b-6);
AC(65) = FCb2(16*a-15,16*b-5);
AC(66) = FCb2(16*a-15,16*b-4);
AC(67) = FCb2(16*a-14,16*b-5);
AC(68) = FCb2(16*a-13,16*b-6);
AC(69) = FCb2(16*a-12,16*b-7);
AC(70) = FCb2(16*a-11,16*b-8);
AC(71) = FCb2(16*a-10,16*b-9);
AC(72) = FCb2(16*a-9,16*b-10);
AC(73) = FCb2(16*a-8,16*b-11);
AC(74) = FCb2(16*a-7,16*b-12);
AC(75) = FCb2(16*a-6,16*b-13);
AC(76) = FCb2(16*a-5,16*b-14);
AC(77) = FCb2(16*a-4,16*b-15);
AC(78) = FCb2(16*a-3,16*b-15);
AC(79) = FCb2(16*a-4,16*b-14);
AC(80) = FCb2(16*a-5,16*b-13);
AC(81) = FCb2(16*a-6,16*b-12);
AC(82) = FCb2(16*a-7,16*b-11);
AC(83) = FCb2(16*a-8,16*b-10);
AC(84) = FCb2(16*a-9,16*b-9);
AC(85) = FCb2(16*a-10,16*b-8);
AC(86) = FCb2(16*a-11,16*b-7);
AC(87) = FCb2(16*a-12,16*b-6);
AC(88) = FCb2(16*a-13,16*b-5);
AC(89) = FCb2(16*a-14,16*b-4);
AC(90) = FCb2(16*a-15,16*b-3);
AC(91) = FCb2(16*a-15,16*b-2);
AC(92) = FCb2(16*a-14,16*b-3);
AC(93) = FCb2(16*a-13,16*b-4);
AC(94) = FCb2(16*a-12,16*b-5);
AC(95) = FCb2(16*a-11,16*b-6);
AC(96) = FCb2(16*a-10,16*b-7);
AC(97) = FCb2(16*a-9,16*b-8);
AC(98) = FCb2(16*a-8,16*b-9);
AC(99) = FCb2(16*a-7,16*b-10);
AC(100) = FCb2(16*a-6,16*b-11);
AC(101) = FCb2(16*a-5,16*b-12);
AC(102) = FCb2(16*a-4,16*b-13);
AC(103) = FCb2(16*a-3,16*b-14);
AC(104) = FCb2(16*a-2,16*b-15);
AC(105) = FCb2(16*a-1,16*b-15);
AC(106) = FCb2(16*a-2,16*b-14);
AC(107) = FCb2(16*a-3,16*b-13);
AC(108) = FCb2(16*a-4,16*b-12);
AC(109) = FCb2(16*a-5,16*b-11);
AC(110) = FCb2(16*a-6,16*b-10);
AC(111) = FCb2(16*a-7,16*b-9);
AC(112) = FCb2(16*a-8,16*b-8);
AC(113) = FCb2(16*a-9,16*b-7);
AC(114) = FCb2(16*a-10,16*b-6);
AC(115) = FCb2(16*a-11,16*b-5);
AC(116) = FCb2(16*a-12,16*b-4);
AC(117) = FCb2(16*a-13,16*b-3);
AC(118) = FCb2(16*a-14,16*b-2);
AC(119) = FCb2(16*a-15,16*b-1);
AC(120) = FCb2(16*a-15,16*b);
AC(121) = FCb2(16*a-14,16*b-1);
AC(122) = FCb2(16*a-13,16*b-2);
AC(123) = FCb2(16*a-12,16*b-3);
AC(124) = FCb2(16*a-11,16*b-4);
AC(125) = FCb2(16*a-10,16*b-5);
AC(126) = FCb2(16*a-9,16*b-6);
AC(127) = FCb2(16*a-8,16*b-7);
AC(128) = FCb2(16*a-7,16*b-8);
AC(129) = FCb2(16*a-6,16*b-9);
AC(130) = FCb2(16*a-5,16*b-10);
AC(131) = FCb2(16*a-4,16*b-11);
AC(132) = FCb2(16*a-3,16*b-12);
AC(133) = FCb2(16*a-2,16*b-13);
AC(134) = FCb2(16*a-1,16*b-14);
AC(135) = FCb2(16*a,16*b-15);
AC(136) = FCb2(16*a,16*b-14);
AC(137) = FCb2(16*a-1,16*b-13);
AC(138) = FCb2(16*a-2,16*b-12);
AC(139) = FCb2(16*a-3,16*b-11);
AC(140) = FCb2(16*a-4,16*b-10);
AC(141) = FCb2(16*a-5,16*b-9);
AC(142) = FCb2(16*a-6,16*b-8);
AC(143) = FCb2(16*a-7,16*b-7);
AC(144) = FCb2(16*a-8,16*b-6);
AC(145) = FCb2(16*a-9,16*b-5);
AC(146) = FCb2(16*a-10,16*b-4);
AC(147) = FCb2(16*a-11,16*b-3);
AC(148) = FCb2(16*a-12,16*b-2);
AC(149) = FCb2(16*a-13,16*b-1);
AC(150) = FCb2(16*a-14,16*b);
AC(151) = FCb2(16*a-13,16*b);
AC(152) = FCb2(16*a-12,16*b-1);
AC(153) = FCb2(16*a-11,16*b-2);
AC(154) = FCb2(16*a-10,16*b-3);
AC(155) = FCb2(16*a-9,16*b-4);
AC(156) = FCb2(16*a-8,16*b-5);
AC(157) = FCb2(16*a-7,16*b-6);
AC(158) = FCb2(16*a-6,16*b-7);
AC(159) = FCb2(16*a-5,16*b-8);
AC(160) = FCb2(16*a-4,16*b-9);
AC(161) = FCb2(16*a-3,16*b-10);
AC(162) = FCb2(16*a-2,16*b-11);
AC(163) = FCb2(16*a-1,16*b-12);
AC(164) = FCb2(16*a,16*b-13);
AC(165) = FCb2(16*a,16*b-12);
AC(166) = FCb2(16*a-1,16*b-11);
AC(167) = FCb2(16*a-2,16*b-10);
AC(168) = FCb2(16*a-3,16*b-9);
AC(169) = FCb2(16*a-4,16*b-8);
AC(170) = FCb2(16*a-5,16*b-7);
AC(171) = FCb2(16*a-6,16*b-6);
AC(172) = FCb2(16*a-7,16*b-5);
AC(173) = FCb2(16*a-8,16*b-4);
AC(174) = FCb2(16*a-9,16*b-3);
AC(175) = FCb2(16*a-10,16*b-2);
AC(176) = FCb2(16*a-11,16*b-1);
AC(177) = FCb2(16*a-12,16*b);
AC(178) = FCb2(16*a-11,16*b);
AC(179) = FCb2(16*a-10,16*b-1);
AC(180) = FCb2(16*a-9,16*b-2);
AC(181) = FCb2(16*a-8,16*b-3);
AC(182) = FCb2(16*a-7,16*b-4);
AC(183) = FCb2(16*a-6,16*b-5);
AC(184) = FCb2(16*a-5,16*b-6);
AC(185) = FCb2(16*a-4,16*b-7);
AC(186) = FCb2(16*a-3,16*b-8);
AC(187) = FCb2(16*a-2,16*b-9);
AC(188) = FCb2(16*a-1,16*b-10);
AC(189) = FCb2(16*a,16*b-11);
AC(190) = FCb2(16*a,16*b-10);
AC(191) = FCb2(16*a-1,16*b-9);
AC(192) = FCb2(16*a-2,16*b-8);
AC(193) = FCb2(16*a-3,16*b-7);
AC(194) = FCb2(16*a-4,16*b-6);
AC(195) = FCb2(16*a-5,16*b-5);
AC(196) = FCb2(16*a-6,16*b-4);
AC(197) = FCb2(16*a-7,16*b-3);
AC(198) = FCb2(16*a-8,16*b-2);
AC(199) = FCb2(16*a-9,16*b-1);
AC(200) = FCb2(16*a-10,16*b);
AC(201) = FCb2(16*a-9,16*b);
AC(202) = FCb2(16*a-8,16*b-1);
AC(203) = FCb2(16*a-7,16*b-2);
AC(204) = FCb2(16*a-6,16*b-3);
AC(205) = FCb2(16*a-5,16*b-4);
AC(206) = FCb2(16*a-4,16*b-5);
AC(207) = FCb2(16*a-3,16*b-6);
AC(208) = FCb2(16*a-2,16*b-7);
AC(209) = FCb2(16*a-1,16*b-8);
AC(210) = FCb2(16*a,16*b-9);
AC(211) = FCb2(16*a,16*b-8);
AC(212) = FCb2(16*a-1,16*b-7);
AC(213) = FCb2(16*a-2,16*b-6);
AC(214) = FCb2(16*a-3,16*b-5);
AC(215) = FCb2(16*a-4,16*b-4);
AC(216) = FCb2(16*a-5,16*b-3);
AC(217) = FCb2(16*a-6,16*b-2);
AC(218) = FCb2(16*a-7,16*b-1);
AC(219) = FCb2(16*a-8,16*b);
AC(220) = FCb2(16*a-7,16*b);
AC(221) = FCb2(16*a-6,16*b-1);
AC(222) = FCb2(16*a-5,16*b-2);
AC(223) = FCb2(16*a-4,16*b-3);
AC(224) = FCb2(16*a-3,16*b-4);
AC(225) = FCb2(16*a-2,16*b-5);
AC(226) = FCb2(16*a-1,16*b-6);
AC(227) = FCb2(16*a,16*b-7);
AC(228) = FCb2(16*a,16*b-6);
AC(229) = FCb2(16*a-1,16*b-5);
AC(230) = FCb2(16*a-2,16*b-4);
AC(231) = FCb2(16*a-3,16*b-3);
AC(232) = FCb2(16*a-4,16*b-2);
AC(233) = FCb2(16*a-5,16*b-1);
AC(234) = FCb2(16*a-6,16*b);
AC(235) = FCb2(16*a-5,16*b);
AC(236) = FCb2(16*a-4,16*b-1);
AC(237) = FCb2(16*a-3,16*b-2);
AC(238) = FCb2(16*a-2,16*b-3);
AC(239) = FCb2(16*a-1,16*b-4);
AC(240) = FCb2(16*a,16*b-5);
AC(241) = FCb2(16*a,16*b-4);
AC(242) = FCb2(16*a-1,16*b-3);
AC(243) = FCb2(16*a-2,16*b-2);
AC(244) = FCb2(16*a-3,16*b-1);
AC(245) = FCb2(16*a-4,16*b);
AC(246) = FCb2(16*a-3,16*b);
AC(247) = FCb2(16*a-2,16*b-1);
AC(248) = FCb2(16*a-1,16*b-2);
AC(249) = FCb2(16*a,16*b-3);
AC(250) = FCb2(16*a,16*b-2);
AC(251) = FCb2(16*a-1,16*b-1);
AC(252) = FCb2(16*a-2,16*b);
AC(253) = FCb2(16*a-1,16*b);
AC(254) = FCb2(16*a,16*b-1);
AC(255) = FCb2(16*a,16*b);
count = 0;
for c = 1:255
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

ACCr = cell(size(x,1)/32);
for a = 1:size(x,1)/32
for b = 1:size(x,1)/32
AC(1) = FCr2(16*a-15,16*b-14);
AC(2) = FCr2(16*a-14,16*b-15);
AC(3) = FCr2(16*a-13,16*b-15);
AC(4) = FCr2(16*a-14,16*b-14);
AC(5) = FCr2(16*a-15,16*b-13);
AC(6) = FCr2(16*a-15,16*b-12);
AC(7) = FCr2(16*a-14,16*b-13);
AC(8) = FCr2(16*a-13,16*b-14);
AC(9) = FCr2(16*a-12,16*b-15);
AC(10) = FCr2(16*a-11,16*b-15);
AC(11) = FCr2(16*a-12,16*b-14);
AC(12) = FCr2(16*a-13,16*b-13);
AC(13) = FCr2(16*a-14,16*b-12);
AC(14) = FCr2(16*a-15,16*b-11);
AC(15) = FCr2(16*a-15,16*b-10);
AC(16) = FCr2(16*a-14,16*b-11);
AC(17) = FCr2(16*a-13,16*b-12);
AC(18) = FCr2(16*a-12,16*b-13);
AC(19) = FCr2(16*a-11,16*b-14);
AC(20) = FCr2(16*a-10,16*b-15);
AC(21) = FCr2(16*a-9,16*b-15);
AC(22) = FCr2(16*a-10,16*b-14);
AC(23) = FCr2(16*a-11,16*b-13);
AC(24) = FCr2(16*a-12,16*b-12);
AC(25) = FCr2(16*a-13,16*b-11);
AC(26) = FCr2(16*a-14,16*b-10);
AC(27) = FCr2(16*a-15,16*b-9);
AC(28) = FCr2(16*a-15,16*b-8);
AC(29) = FCr2(16*a-14,16*b-9);
AC(30) = FCr2(16*a-13,16*b-10);
AC(31) = FCr2(16*a-12,16*b-11);
AC(32) = FCr2(16*a-11,16*b-12);
AC(33) = FCr2(16*a-10,16*b-13);
AC(34) = FCr2(16*a-9,16*b-14);
AC(35) = FCr2(16*a-8,16*b-15);
AC(36) = FCr2(16*a-7,16*b-15);
AC(37) = FCr2(16*a-8,16*b-14);
AC(38) = FCr2(16*a-9,16*b-13);
AC(39) = FCr2(16*a-10,16*b-12);
AC(40) = FCr2(16*a-11,16*b-11);
AC(41) = FCr2(16*a-12,16*b-10);
AC(42) = FCr2(16*a-13,16*b-9);
AC(43) = FCr2(16*a-14,16*b-8);
AC(44) = FCr2(16*a-15,16*b-7);
AC(45) = FCr2(16*a-15,16*b-6);
AC(46) = FCr2(16*a-14,16*b-7);
AC(47) = FCr2(16*a-13,16*b-8);
AC(48) = FCr2(16*a-12,16*b-9);
AC(49) = FCr2(16*a-11,16*b-10);
AC(50) = FCr2(16*a-10,16*b-11);
AC(51) = FCr2(16*a-9,16*b-12);
AC(52) = FCr2(16*a-8,16*b-13);
AC(53) = FCr2(16*a-7,16*b-14);
AC(54) = FCr2(16*a-6,16*b-15);
AC(55) = FCr2(16*a-5,16*b-15);
AC(56) = FCr2(16*a-6,16*b-14);
AC(57) = FCr2(16*a-7,16*b-13);
AC(58) = FCr2(16*a-8,16*b-12);
AC(59) = FCr2(16*a-9,16*b-11);
AC(60) = FCr2(16*a-10,16*b-10);
AC(61) = FCr2(16*a-11,16*b-9);
AC(62) = FCr2(16*a-12,16*b-8);
AC(63) = FCr2(16*a-13,16*b-7);
AC(64) = FCr2(16*a-14,16*b-6);
AC(65) = FCr2(16*a-15,16*b-5);
AC(66) = FCr2(16*a-15,16*b-4);
AC(67) = FCr2(16*a-14,16*b-5);
AC(68) = FCr2(16*a-13,16*b-6);
AC(69) = FCr2(16*a-12,16*b-7);
AC(70) = FCr2(16*a-11,16*b-8);
AC(71) = FCr2(16*a-10,16*b-9);
AC(72) = FCr2(16*a-9,16*b-10);
AC(73) = FCr2(16*a-8,16*b-11);
AC(74) = FCr2(16*a-7,16*b-12);
AC(75) = FCr2(16*a-6,16*b-13);
AC(76) = FCr2(16*a-5,16*b-14);
AC(77) = FCr2(16*a-4,16*b-15);
AC(78) = FCr2(16*a-3,16*b-15);
AC(79) = FCr2(16*a-4,16*b-14);
AC(80) = FCr2(16*a-5,16*b-13);
AC(81) = FCr2(16*a-6,16*b-12);
AC(82) = FCr2(16*a-7,16*b-11);
AC(83) = FCr2(16*a-8,16*b-10);
AC(84) = FCr2(16*a-9,16*b-9);
AC(85) = FCr2(16*a-10,16*b-8);
AC(86) = FCr2(16*a-11,16*b-7);
AC(87) = FCr2(16*a-12,16*b-6);
AC(88) = FCr2(16*a-13,16*b-5);
AC(89) = FCr2(16*a-14,16*b-4);
AC(90) = FCr2(16*a-15,16*b-3);
AC(91) = FCr2(16*a-15,16*b-2);
AC(92) = FCr2(16*a-14,16*b-3);
AC(93) = FCr2(16*a-13,16*b-4);
AC(94) = FCr2(16*a-12,16*b-5);
AC(95) = FCr2(16*a-11,16*b-6);
AC(96) = FCr2(16*a-10,16*b-7);
AC(97) = FCr2(16*a-9,16*b-8);
AC(98) = FCr2(16*a-8,16*b-9);
AC(99) = FCr2(16*a-7,16*b-10);
AC(100) = FCr2(16*a-6,16*b-11);
AC(101) = FCr2(16*a-5,16*b-12);
AC(102) = FCr2(16*a-4,16*b-13);
AC(103) = FCr2(16*a-3,16*b-14);
AC(104) = FCr2(16*a-2,16*b-15);
AC(105) = FCr2(16*a-1,16*b-15);
AC(106) = FCr2(16*a-2,16*b-14);
AC(107) = FCr2(16*a-3,16*b-13);
AC(108) = FCr2(16*a-4,16*b-12);
AC(109) = FCr2(16*a-5,16*b-11);
AC(110) = FCr2(16*a-6,16*b-10);
AC(111) = FCr2(16*a-7,16*b-9);
AC(112) = FCr2(16*a-8,16*b-8);
AC(113) = FCr2(16*a-9,16*b-7);
AC(114) = FCr2(16*a-10,16*b-6);
AC(115) = FCr2(16*a-11,16*b-5);
AC(116) = FCr2(16*a-12,16*b-4);
AC(117) = FCr2(16*a-13,16*b-3);
AC(118) = FCr2(16*a-14,16*b-2);
AC(119) = FCr2(16*a-15,16*b-1);
AC(120) = FCr2(16*a-15,16*b);
AC(121) = FCr2(16*a-14,16*b-1);
AC(122) = FCr2(16*a-13,16*b-2);
AC(123) = FCr2(16*a-12,16*b-3);
AC(124) = FCr2(16*a-11,16*b-4);
AC(125) = FCr2(16*a-10,16*b-5);
AC(126) = FCr2(16*a-9,16*b-6);
AC(127) = FCr2(16*a-8,16*b-7);
AC(128) = FCr2(16*a-7,16*b-8);
AC(129) = FCr2(16*a-6,16*b-9);
AC(130) = FCr2(16*a-5,16*b-10);
AC(131) = FCr2(16*a-4,16*b-11);
AC(132) = FCr2(16*a-3,16*b-12);
AC(133) = FCr2(16*a-2,16*b-13);
AC(134) = FCr2(16*a-1,16*b-14);
AC(135) = FCr2(16*a,16*b-15);
AC(136) = FCr2(16*a,16*b-14);
AC(137) = FCr2(16*a-1,16*b-13);
AC(138) = FCr2(16*a-2,16*b-12);
AC(139) = FCr2(16*a-3,16*b-11);
AC(140) = FCr2(16*a-4,16*b-10);
AC(141) = FCr2(16*a-5,16*b-9);
AC(142) = FCr2(16*a-6,16*b-8);
AC(143) = FCr2(16*a-7,16*b-7);
AC(144) = FCr2(16*a-8,16*b-6);
AC(145) = FCr2(16*a-9,16*b-5);
AC(146) = FCr2(16*a-10,16*b-4);
AC(147) = FCr2(16*a-11,16*b-3);
AC(148) = FCr2(16*a-12,16*b-2);
AC(149) = FCr2(16*a-13,16*b-1);
AC(150) = FCr2(16*a-14,16*b);
AC(151) = FCr2(16*a-13,16*b);
AC(152) = FCr2(16*a-12,16*b-1);
AC(153) = FCr2(16*a-11,16*b-2);
AC(154) = FCr2(16*a-10,16*b-3);
AC(155) = FCr2(16*a-9,16*b-4);
AC(156) = FCr2(16*a-8,16*b-5);
AC(157) = FCr2(16*a-7,16*b-6);
AC(158) = FCr2(16*a-6,16*b-7);
AC(159) = FCr2(16*a-5,16*b-8);
AC(160) = FCr2(16*a-4,16*b-9);
AC(161) = FCr2(16*a-3,16*b-10);
AC(162) = FCr2(16*a-2,16*b-11);
AC(163) = FCr2(16*a-1,16*b-12);
AC(164) = FCr2(16*a,16*b-13);
AC(165) = FCr2(16*a,16*b-12);
AC(166) = FCr2(16*a-1,16*b-11);
AC(167) = FCr2(16*a-2,16*b-10);
AC(168) = FCr2(16*a-3,16*b-9);
AC(169) = FCr2(16*a-4,16*b-8);
AC(170) = FCr2(16*a-5,16*b-7);
AC(171) = FCr2(16*a-6,16*b-6);
AC(172) = FCr2(16*a-7,16*b-5);
AC(173) = FCr2(16*a-8,16*b-4);
AC(174) = FCr2(16*a-9,16*b-3);
AC(175) = FCr2(16*a-10,16*b-2);
AC(176) = FCr2(16*a-11,16*b-1);
AC(177) = FCr2(16*a-12,16*b);
AC(178) = FCr2(16*a-11,16*b);
AC(179) = FCr2(16*a-10,16*b-1);
AC(180) = FCr2(16*a-9,16*b-2);
AC(181) = FCr2(16*a-8,16*b-3);
AC(182) = FCr2(16*a-7,16*b-4);
AC(183) = FCr2(16*a-6,16*b-5);
AC(184) = FCr2(16*a-5,16*b-6);
AC(185) = FCr2(16*a-4,16*b-7);
AC(186) = FCr2(16*a-3,16*b-8);
AC(187) = FCr2(16*a-2,16*b-9);
AC(188) = FCr2(16*a-1,16*b-10);
AC(189) = FCr2(16*a,16*b-11);
AC(190) = FCr2(16*a,16*b-10);
AC(191) = FCr2(16*a-1,16*b-9);
AC(192) = FCr2(16*a-2,16*b-8);
AC(193) = FCr2(16*a-3,16*b-7);
AC(194) = FCr2(16*a-4,16*b-6);
AC(195) = FCr2(16*a-5,16*b-5);
AC(196) = FCr2(16*a-6,16*b-4);
AC(197) = FCr2(16*a-7,16*b-3);
AC(198) = FCr2(16*a-8,16*b-2);
AC(199) = FCr2(16*a-9,16*b-1);
AC(200) = FCr2(16*a-10,16*b);
AC(201) = FCr2(16*a-9,16*b);
AC(202) = FCr2(16*a-8,16*b-1);
AC(203) = FCr2(16*a-7,16*b-2);
AC(204) = FCr2(16*a-6,16*b-3);
AC(205) = FCr2(16*a-5,16*b-4);
AC(206) = FCr2(16*a-4,16*b-5);
AC(207) = FCr2(16*a-3,16*b-6);
AC(208) = FCr2(16*a-2,16*b-7);
AC(209) = FCr2(16*a-1,16*b-8);
AC(210) = FCr2(16*a,16*b-9);
AC(211) = FCr2(16*a,16*b-8);
AC(212) = FCr2(16*a-1,16*b-7);
AC(213) = FCr2(16*a-2,16*b-6);
AC(214) = FCr2(16*a-3,16*b-5);
AC(215) = FCr2(16*a-4,16*b-4);
AC(216) = FCr2(16*a-5,16*b-3);
AC(217) = FCr2(16*a-6,16*b-2);
AC(218) = FCr2(16*a-7,16*b-1);
AC(219) = FCr2(16*a-8,16*b);
AC(220) = FCr2(16*a-7,16*b);
AC(221) = FCr2(16*a-6,16*b-1);
AC(222) = FCr2(16*a-5,16*b-2);
AC(223) = FCr2(16*a-4,16*b-3);
AC(224) = FCr2(16*a-3,16*b-4);
AC(225) = FCr2(16*a-2,16*b-5);
AC(226) = FCr2(16*a-1,16*b-6);
AC(227) = FCr2(16*a,16*b-7);
AC(228) = FCr2(16*a,16*b-6);
AC(229) = FCr2(16*a-1,16*b-5);
AC(230) = FCr2(16*a-2,16*b-4);
AC(231) = FCr2(16*a-3,16*b-3);
AC(232) = FCr2(16*a-4,16*b-2);
AC(233) = FCr2(16*a-5,16*b-1);
AC(234) = FCr2(16*a-6,16*b);
AC(235) = FCr2(16*a-5,16*b);
AC(236) = FCr2(16*a-4,16*b-1);
AC(237) = FCr2(16*a-3,16*b-2);
AC(238) = FCr2(16*a-2,16*b-3);
AC(239) = FCr2(16*a-1,16*b-4);
AC(240) = FCr2(16*a,16*b-5);
AC(241) = FCr2(16*a,16*b-4);
AC(242) = FCr2(16*a-1,16*b-3);
AC(243) = FCr2(16*a-2,16*b-2);
AC(244) = FCr2(16*a-3,16*b-1);
AC(245) = FCr2(16*a-4,16*b);
AC(246) = FCr2(16*a-3,16*b);
AC(247) = FCr2(16*a-2,16*b-1);
AC(248) = FCr2(16*a-1,16*b-2);
AC(249) = FCr2(16*a,16*b-3);
AC(250) = FCr2(16*a,16*b-2);
AC(251) = FCr2(16*a-1,16*b-1);
AC(252) = FCr2(16*a-2,16*b);
AC(253) = FCr2(16*a-1,16*b);
AC(254) = FCr2(16*a,16*b-1);
AC(255) = FCr2(16*a,16*b);
count = 0;
for c = 1:255
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
