function goAround_wSimAnn(point, start, dataPoints, colour)
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
prevPt = start;     tau = 2*zVals(row,col);     kerSize = 2;
rows = size(zVals,1);   cols = size(zVals,2);
kern.krow = getKernelLimits(row, rows, kerSize);
kern.kcol = getKernelLimits(col, cols, kerSize);
for i = 1:500
    while(1)
        [r,c,value,tau,nxDir] = getNextPt_wSA(zVals,row,col,kern,tau);    
        if(~isempty(nxDir))
            break;       
        end
    end
    nX = x_mesh(1,c);  nY = y_mesh(r,1);
    plotPt.x = nX + start.x; plotPt.y = nY + start.y;
    pause(0.0025); plotLine(prevPt, plotPt, colour);
    prevPt = plotPt;
    if(value==point.gradVal);
        broken = 1;
        break;
    else
        broken = 0;
    end        
    kern = getKernelRC(nxDir, r, c, rows, cols, kerSize);
    row = r; col = c;    
end
if(~broken)
    displ.value = value; disp(displ); disp(point);
end

function [r,c,value,tau,nxDir] = getNextPt_wSA(zVals,row,col,kern,tau)
% while(1)
    u = rand;
%     if(u<=0.2),break,end
% end
obtain = 0; r = 0; c = 0; value = 0; preVal = zVals(row,col);   
krow = kern.krow; kcol = kern.kcol; nxDir = [];
for kr = 1:length(krow)
    for kc = 1:length(kcol)
        zr = (row+krow(kr)); zc = (col+kcol(kc));                
        v = zVals(zr,zc);
        if(v>preVal)            
            obtain = 1;            
            break;
        elseif(preVal>v)
            dell = preVal - v;            
            R = exp(-dell/tau);            
            if(R<u)    
                tau = 0.99*tau;
                obtain = 1;
                break;            
            end
        else
            obtain = 0;
        end
    end
    if(obtain)
        r = zr; c = zc; value = v;
        nxDir = getMoveDir(r, row, c, col);
        break;
    end
end



function nxDir = getMoveDir(r, row, c, col)
nxDir = 'not';
if((r==row)||(c~=col))
    if(c<col)
        nxDir = 'left';
    else
        nxDir = 'right';
    end
end
if(strcmp(nxDir,'not'))
    if(r<row)
        nxDir = 'up';
    else
        nxDir = 'down';
    end
end


function kern = getKernelRC(nxDir, row, col, rows, cols, kerSize)
kern.krow = getKernelLimits(row, rows, kerSize);
kern.kcol = getKernelLimits(col, cols, kerSize);
switch(nxDir)
    case 'left'                
        kern.kcol(find(kern.kcol>0)) = [];
    case 'right'
        kern.kcol(find(kern.kcol<0)) = [];
    case 'up'
        kern.krow(find(kern.krow>0)) = [];
    case 'down'
        kern.krow(find(kern.krow<0)) = [];
end

