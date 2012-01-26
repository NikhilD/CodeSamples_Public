function outVal = gaussPDF2(mean)
stddev = 0.4;
for i = 1:1000
    val = mean + (stddev*randn);
    if(val>0)
        break;
    end
end
outVal = val;
