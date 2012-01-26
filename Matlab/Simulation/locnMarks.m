function object = locnMarks(field, offset, obstacle)

numSqr = length(obstacle.square);
numTri = length(obstacle.triangle);

chk=0;
object.x = roundn(((rand*(field-offset))+offset),-3);
object.y = roundn(((rand*(field-offset))+offset),-3);
while(chk==0)        
    chk = onLine(object, obstacle.square, obstacle.triangle);
    if(chk==1)
        break;
    end        
    object.x = roundn(((rand*(field-offset))+offset),-3);
    object.y = roundn(((rand*(field-offset))+offset),-3);
end
for s = 1:numSqr    
    inSqr = insideSquare(obstacle.square(s), object);
    object.inSqr(s) = inSqr;
end
for t = 1:numTri
    inTri = insideTriangle(obstacle.triangle(t), object);
    object.inTri(t) = inTri;
end
brk = 1;
