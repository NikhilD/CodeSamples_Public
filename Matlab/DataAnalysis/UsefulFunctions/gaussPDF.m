function outVal = gaussPDF(inVal,mean,stddev)
scale = 1/(sqrt(2*pi));     term1 = scale/stddev;
expdiv = 2*(stddev^2);
outVal = term1.*(exp(-(((inVal-mean)^2)./expdiv)));
    