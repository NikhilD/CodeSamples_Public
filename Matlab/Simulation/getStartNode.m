function [indx, obst] = getStartNode(motes, target, obstacle)
numMotes = length(motes);   dist = ones(1,numMotes)*1000;
dummy = ones(1,numMotes)*1000;  useDist = 0;    radius = 30;
for m = 1:numMotes
    if(motes(m).visited~=0)
        dist(m) = ObjectDist(motes(m),target);    
        if(dist(m)<=radius)
            dummy(m) = dist(m);
        end
    end
end
[mini, indi] = min(dummy);
[minj, indj] = min(dist);
if(isempty(obstacle))  
    obst = 0;
    if(mini<=radius)
        indx = indi;
    else
        indx = indj;
    end
else
    obst = 1;
    if(mini<=radius)
        for m = 1:numMotes
            [mini, indi] = min(dummy);
            if(mini<=radius)
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