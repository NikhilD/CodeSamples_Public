function signal = window(val,start,finish)
signal=[];
temp = [];
for g=start:1:finish
    temp = [temp val(g)];    
end

for k=1:(length(temp)-1)
    if(temp(k+1)~=temp(k))
        signal = [signal temp(k)];
    end        
end
