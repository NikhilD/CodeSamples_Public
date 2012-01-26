function piezo= piezovalues(piezoval,start,finish)
piezo=[];
for g=start:1:finish
    piezo = [piezo piezoval(g)];    
end
