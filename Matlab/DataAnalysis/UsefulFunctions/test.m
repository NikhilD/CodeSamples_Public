n2 = [11 11 11 10 10 9 9 9 7 7 5];
prev = n2(1);   diffr1 = prev;  j=0;
for u = 1:length(n2)
    diffr = prev - n2(u);
    if(diffr>diffr1)
        j=j+1;
        if(j>=2)
            prev = n2(u-1);
            diffr = prev - n2(u);
            j=0;
        end
    end    
    diffr1 = diffr;
end