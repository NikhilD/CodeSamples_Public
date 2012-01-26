function goAround(point, start, dataPoints, colour)
x_mesh = dataPoints.xVals; y_mesh = dataPoints.yVals;   zVals = dataPoints.zVals;
X_mesh = dataPoints.xys;
startPosn.locn = [0;0];  N = size(X_mesh,2);
dists = zeros(1,N);
for n = 1:N    
    dists(n)=sqrt(sum((startPosn.locn(:) - X_mesh(:,n)).^2));
end
[unused, indx] = min(dists);
[unused, col] = find((x_mesh==X_mesh(1,indx)),1);
[row, unused] = find((y_mesh==X_mesh(2,indx)),1);
prevPt = start;
while(1)
    kerSize = 1;    noHappen = 0;
    while(1)
        [r,c,value,obtain] = getNextPlotPoint(zVals,row,col,kerSize);
        if(obtain)
            break;
        else
            kerSize = kerSize + 1;
        end
        if(kerSize>size(zVals,2))
            noHappen = 1;
            break;
        end
    end        
    if(noHappen)
        break;
    end
    nX = x_mesh(1,c);  nY = y_mesh(r,1);
    plotPt.x = nX + start.x; plotPt.y = nY + start.y;
    plotLine(prevPt, plotPt, colour);
    prevPt = plotPt;
    if(value==point.gradVal);
        break;
    end    
    row = r; col = c;
end


function [r,c,value,obtain] = getNextPlotPoint(zVals,row,col,kerSize)
rows = size(zVals,1);   cols = size(zVals,2);
deltas = ones((2*kerSize)+1)*1000;  obtain = 0; r = 0; c = 0; value = 0;
krow = getKernelLimits(row, rows, kerSize);
kcol = getKernelLimits(col, cols, kerSize);
for kr = 1:length(krow)
    for kc = 1:length(kcol)
        zr = (row+krow(kr)); zc = (col+kcol(kc));        
        v = zVals(zr,zc) - zVals(row,col);
        if(v>0)
            dr = (krow(kr)+(kerSize+1));    dc = (kcol(kc)+(kerSize+1));
            deltas(dr,dc) = v;
            obtain = 1;
        end
    end
end
if(obtain)
%     [maxRows, rw] = max(deltas);     [maxCols, cl] = max(maxRows);
    [minRows, rw] = min(deltas);     [minCols, cl] = min(minRows);
    r = rw(cl)-(kerSize+1)+row; c = cl-(kerSize+1)+col;     
    value = zVals(r,c);
end



