function mic = micvalues(micval,start,finish)
mic=[];
for g=start:1:finish
    mic = [mic micval(g)];    
end