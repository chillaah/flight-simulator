function plotcircle(r,x,y)
th = 0:pi/100:2*pi;
f = r * exp(1i*th) + x+1i*y;
plot(real(f), imag(f));
end