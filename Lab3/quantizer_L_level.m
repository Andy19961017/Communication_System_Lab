function y = quantizer_L_level(x, x_max, L);
Delta = 2*x_max/L;
y=(floor(x/Delta)+0.5);
y(y>L/2)=L/2-0.5;
y(y<-L/2)=-L/2+0.5;
y=y*Delta;
end