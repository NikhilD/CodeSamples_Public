function GVector = gausscurve(width)
mean = 0;
GVector = [];
stddev = 1.25;
values = 49;
range = 5;
magnify = 2.5;
scale = 1/(sqrt(2*pi));
term1 = scale/stddev;
expdiv = 2*(stddev^2);
x = [];
y = [];
res = (2*range)/values;

for k = -range:res:range
    x = [x k];
    gaussian = term1*(exp(-(((k-mean)^2)/expdiv)));
    gaussian = gaussian*magnify;
    y = [y gaussian];
end
GVector = [GVector y];
if((width-1)>values)
    a = (width-1)-values;
    for g = 1:1:(a/2)
        GVector = [0 GVector 0];
    end
end
