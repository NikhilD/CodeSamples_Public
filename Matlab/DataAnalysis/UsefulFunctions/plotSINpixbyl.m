function plotSINpixbyl()
L = 200;    
for x = 1:L
    fn(x) = sin((pi*x)/L);    
end
plot((1:L),fn), grid on;
