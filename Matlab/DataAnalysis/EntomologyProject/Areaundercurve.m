function area = Areaundercurve(x, y)
if  length(x)~=length(y)
    error('Vector elements do not agree!');
end
f = [];
for k = 1:1:(length(x)-1)
    d = y(k)*(x(k+1)-x(k));
    f = [f d];
end
area = sum(f);
