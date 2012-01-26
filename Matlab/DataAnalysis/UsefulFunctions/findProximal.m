function [values, indices] = findProximal(inArray, inValue, numProximities)
indices = zeros(1,numProximities);  values = zeros(1,numProximities);
len = length(inArray);  val = zeros(1,len);
for i=1:len
    val(i) = (inArray(i) - inValue)^2;
end
[~,indices(1)] = min(val);
values(1) = inArray(indices(1));
valx = max(val);    
for n = 2:numProximities
    val = ones(1,len)*(valx*100);
    for i = 1:len
        if(isempty(find((indices==i),1)))
            val(i) = (inArray(i) - inValue)^2;
        end
    end
    [~,indices(n)] = min(val);
    values(n) = inArray(indices(n));
end