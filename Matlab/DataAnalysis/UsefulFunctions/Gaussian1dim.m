function GVector = Gaussian1dim()%mean,stddev,magnify,values,range)
mean = 0.8;       stddev = 0.4;
values = 75;    range = 4;
magnify = 1;
scale = 1/(sqrt(2*pi));     term1 = scale/stddev;
expdiv = 2*(stddev^2);
x = [];     y = [];
figure;
axis([-5 5 -5 5]);
axis square;
grid on;
hold on;
h = plot(0,0);
res = (2*range)/values;
for k = -range:res:range
    x = [x k];
    gaussian = term1*(exp(-(((k-mean)^2)/expdiv)));
    gaussian = gaussian*magnify;
    y = [y gaussian];
    set(h,'XData',x,'YData',y);
    pause(0.25);
end
GVector = y;
