function connectCompo(point, start, dataPoints, colour, plotit)
x_mesh = dataPoints.xVals; y_mesh = dataPoints.yVals;   zVals = dataPoints.zVals;
X_mesh = dataPoints.xys;    tempMesh = zVals*0;
nodePosn.locn = [0;0];  N = size(X_mesh,2);
dists = zeros(1,N);
for n = 1:N    
    dists(n)=sqrt(sum((nodePosn.locn(:) - X_mesh(:,n)).^2));
end
[unused, indx] = min(dists);
[unused, colNode] = find((x_mesh==X_mesh(1,indx)),1);
[rowNode, unused] = find((y_mesh==X_mesh(2,indx)),1);
row = dataPoints.Hrow; col = dataPoints.Hcol;   kerSize = 1;
rowTot = size(zVals,1);   colTot = size(zVals,2);
for i=1:1000
    kern = getMoveKernel(row, col, rowNode, colNode, rowTot, colTot, kerSize);
    if(isempty(kern.krow))
        return;
    end
    [row,col,tempMesh] = assignLabels(zVals,tempMesh,row,col,kern);
    if((row==rowNode)&&(col==colNode))
        break;
    end
end
if(plotit)
    figure; grid on; hold on;
    surf(dataPoints.xVals,dataPoints.yVals,tempMesh);
    colormap(jet); shading interp; lighting phong;
    hold off;
end
brk = 1;


function [r,c,tempMesh] = assignLabels(zVals,tempMesh,row,col,kern)
preVal = zVals(row,col);   
krow = kern.krow; kcol = kern.kcol;
lr = length(krow);  lc = length(kcol);
deltas = ones(lr,lc)*-1000;
for kr = 1:lr
    for kc = 1:lc
        zr = (row+krow(kr)); zc = (col+kcol(kc));        
        v = zVals(zr,zc) - preVal;        
        deltas(kr,kc) = v;
        if(v==0)
            deltas(kr,kc)=-1000;
        end
    end        
end
% deltas = flipud(deltas);    % done since the matrix gets populated in the reverse order to the way the kernel is applied!
deltaSr = reshape(deltas, 1, (lr*lc));
[vals, inds] = sort(deltaSr, 'descend');
[rx, cx] = find(deltas==vals(1));
r = (row+krow(rx(1)));  c = (col+kcol(cx(1)));
tempMesh(r,c) = 10;
for i = 2:length(vals)
    [rs, cs] = find(deltas==vals(i));
    rx = (row+krow(rs(1))); cx = (col+kcol(cs(1)));
    if(tempMesh(rx,cx)<(10-i))
        tempMesh(rx,cx) = (10-i);
    end
end


function kern = getMoveKernel(r, c, rowNode, colNode, rowTot, colTot, kerSize)
res1 = cmpVal(rowNode, r);
res2 = cmpVal(colNode, c);
nxDir = bitshift(res2, 4) + res1;
kern = getKernelRC(nxDir, r, c, rowTot, colTot, kerSize);


function kern = getKernelRC(nxDir, row, col, rows, cols, kerSize)
kern.krow = getKernelLimits(row, rows, kerSize);
kern.kcol = getKernelLimits(col, cols, kerSize);
switch(nxDir)
%     case 34     % north-west
%         kern.krow(find(kern.krow>0)) = [];
%         kern.kcol(find(kern.kcol>0)) = [];
    case {32, 33, 34}     % west        
        kern.kcol(find(kern.kcol>=0)) = [];
%     case 32     % south-west
%         kern.krow(find(kern.krow<0)) = [];
%         kern.kcol(find(kern.kcol>0)) = [];
    case 18    % north
        kern.krow(find(kern.krow>=0)) = [];
    case 17     % reached
        kern.krow = []; kern.kcol = [];        
    case 16   % south
        kern.krow(find(kern.krow<=0)) = [];
%     case 2    % north-east
%         kern.krow(find(kern.krow>0)) = [];
%         kern.kcol(find(kern.kcol<0)) = [];
    case {0,1,2}   % east
        kern.kcol(find(kern.kcol<=0)) = [];
%     case 0    % south-east
%         kern.krow(find(kern.krow<0)) = [];
%         kern.kcol(find(kern.kcol<0)) = [];
end



function res = cmpVal(v1, v2)
if(v2<v1)
    res = 0;
elseif(v1==v2)
    res = 1;
else
    res = 2;
end