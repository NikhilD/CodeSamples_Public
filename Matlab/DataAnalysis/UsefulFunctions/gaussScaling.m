function GVector = gaussScaling(inVector,stddev,magnify,plotit)
numVals = length(inVector); meanVal = mean(inVector);
scale = 1/(sqrt(2*pi));
term1 = scale/stddev;
expdiv = 2*(stddev^2);
y = [];
if(plotit)
    inVect = sort(inVector);
else
    inVect = inVector;
end
for k = 1:numVals
    gaussian = term1*(exp(-(((inVect(k)-meanVal)^2)/expdiv)));
    gaussian = gaussian*magnify;
    y = [y gaussian];
end
GVector = y;
if(plotit)       
    plot(inVect,y), grid on;
end
