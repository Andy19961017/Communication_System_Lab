function ssim = SSIM(A,B,c1,c2)
A = double(A);
B = double(B);
muA = mean2(A);
muB = mean2(B);
A2 = A.^2;
B2 = B.^2;
muA2 = mean2(A2);
muB2 = mean2(B2);
sigmaA = muA2 - muA^2;
sigmaB = muB2 - muB^2;
AB = A.*B;
muAB = mean2(AB);
sigmaAB = muAB - muA*muB;
C1 = (c1*255)^2;
C2 = (c2*255)^2;
ssim = (2*muA*muB + C1) * (2*sigmaAB + C2) / (muA^2 + muB^2 + C1) / (sigmaA + sigmaB + C2);
end

