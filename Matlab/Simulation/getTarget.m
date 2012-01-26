function [motes, indx] = getTarget(field, motes, target, obstacle, plotit)
numMotes = length(motes);   dist = ones(1,numMotes)*1000;
dummy = ones(1,numMotes)*1000;  useDist = 0;
for m = 1:numMotes
    dist(m) = ObjectDist(motes(m),target);    
    if(dist(m)<=target.radius)
        dummy(m) = dist(m);
    end
end
[mini, indi] = min(dummy);
[minj, indj] = min(dist);
if(isempty(obstacle))        
    if(mini<=target.radius)
        indx = indi;
    else
        indx = indj;
    end
else
    if(mini<=target.radius)
        for m = 1:numMotes
            [mini, indi] = min(dummy);
            if(mini<=target.radius)
                useDist = 0;
                inObst = sum(motes(indi).inSqr) + sum(motes(indi).inTri);
                if(inObst==0)
                    indx = indi;
                    break;
                else
                    dummy(indi) = 1000;
                end
            else
                useDist = 1;
                break;
            end
        end
    else
        for m = 1:numMotes
            [minj, indj] = min(dist);            
            inObst = sum(motes(indj).inSqr) + sum(motes(indj).inTri);
            if(inObst==0)
                indx = indj;
                break;
            else
                dist(indj) = 1000;
            end
        end
    end
end
if(useDist)
    for m = 1:numMotes
        [minj, indj] = min(dist);            
        inObst = sum(motes(indj).inSqr) + sum(motes(indj).inTri);
        if(inObst==0)
            indx = indj;
            break;
        else
            dist(indj) = 1000;
        end
    end
end
if(plotit)
    figure(field.figMain);
    R = 1; G = 0; B = 0;
    motes(indx).faceColor = [R G B];
    set(motes(indx).plot,'MarkerFaceColor', motes(indx).faceColor);
end
motes(indx).hopCnt = 0;
motes(indx).visited = 1;     

