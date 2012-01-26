function goAround_wAltitude(point, start, dataGPN, dataALTI, colour)
x_mesh = dataGPN.xVals; y_mesh = dataGPN.yVals;   zVals = dataALTI.zVals;
X_mesh = dataGPN.xys;   
startPosn.locn = [0;0];  N = size(X_mesh,2);
dists = zeros(1,N);
for n = 1:N    
    dists(n)=sqrt(sum((startPosn.locn(:) - X_mesh(:,n)).^2));
end
[unused, indx] = min(dists);
[unused, col] = find((x_mesh==X_mesh(1,indx)),1);
[row, unused] = find((y_mesh==X_mesh(2,indx)),1);
prevPt = start;     kerSize = 1;
rowTot = size(zVals,1);   colTot = size(zVals,2);
for i = 1:100
    kern = getMoveKernel(row, col, dataGPN.Hrow, dataGPN.Hcol, rowTot, colTot, kerSize);
    if(isempty(kern.krow))
        return;
    end
    [r,c] = getNextPt_wSA(zVals,row,col,kern);
    value = dataGPN.zVals(r,c);
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
    row = r; col = c;    
end
if(~broken)
    displ.value = value;    displ.AmAt = [row col]; 
    displ.ToGo = [dataGPN.Hrow dataGPN.Hcol];    disp(displ);
    disp(point);
end


function [r,c] = getNextPt_wSA(zVals,row,col,kern)
obtain = 0; preVal = zVals(row,col);   
krow = kern.krow; kcol = kern.kcol;
lr = length(krow);  lc = length(kcol);
deltaPos = ones(lr,lc)*1000;    deltaNeg = ones(lr,lc)*-1000; 
deltaZrs = zeros(lr,lc); 
for kr = 1:lr
    for kc = 1:lc
        zr = (row+krow(kr)); zc = (col+kcol(kc));        
        v = zVals(zr,zc) - preVal;
        if(v>0)
            deltaPos(kr,kc) = v;            
        elseif(v<0)        
            deltaNeg(kr,kc) = v;        
        else
            deltaZrs(kr,kc) = 1;
        end
    end        
end
if(nnz(deltaZrs)==(lr*lc))
    [r,c] = randomMove(kern, row, col);
    return;
end
[pos,r,c] = getDelDir(deltaPos,kern,row,col,'pos');  
if(isempty(pos))
    [unused,r,c] = getDelDir(deltaNeg,kern,row,col,'neg');
end



function [bitVal, r, c] = getDelDir(delMtrx, kern, row, col, type)
bitVal = []; r = 0;  c = 0; posi = 0;
switch(type)
    case 'pos'
        posi = 1;
        [rs, cs] = find(delMtrx<(1000));
    case 'neg'
        [rs, cs] = find(delMtrx>(-1000));
end
if(~isempty(rs))
    rcVals = getActualRC(kern, row, col);
    sz = size(rcVals,1);
    if(posi)
        [mRows, rw] = min(delMtrx); [mCols, cl] = min(mRows);        
    else
        [mRows, rw] = max(delMtrx); [mCols, cl] = max(mRows);        
    end
    rs = rw(cl);    cs = cl;
    if(sz==1)
        rs = 1; cs = rw;
    end
    r = rcVals(rs,cs,1);    c = rcVals(rs,cs,2);
    bitVal = 1;
end



function [r,c] = randomMove(kern, row, col)
rcVals = getActualRC(kern, row, col);
dummy = reshape(rcVals,1,[]);   ar = [row;col];
lr = length(kern.krow);     lc = length(kern.kcol);
rcVals = [dummy(1:(lr*lc));dummy(((lr*lc)+1):(2*lr*lc))];
for i = 1:(lr*lc)
    if(rcVals(:,i)==ar(:,1))
        rcVals(:,i) = [];
        break;
    end
end
lv = length(rcVals(1,:));   num = ceil(1 + ((lv-1)*rand));
r = rcVals(1,num);  c = rcVals(2,num);



function rcVals = getActualRC(kern, row, col)
lr = length(kern.krow);     lc = length(kern.kcol);
rcVals = zeros(lr,lc,2);
for kr = 1:lr
    for kc = 1:lc
        zr = (row+kern.krow(kr)); zc = (col+kern.kcol(kc));                
        rcVals(kr,kc,1) = zr;   rcVals(kr,kc,2) = zc;        
    end
end



function kern = getMoveKernel(r, c, rowMax, colMax, rowTot, colTot, kerSize)
res1 = cmpVal(r, rowMax);
res2 = cmpVal(c, colMax);
nxDir = bitshift(res2, 4) + res1;
kern = getKernelRC(nxDir, r, c, rowTot, colTot, kerSize);



function kern = getKernelRC(nxDir, row, col, rows, cols, kerSize)
kern.krow = getKernelLimits(row, rows, kerSize);
kern.kcol = getKernelLimits(col, cols, kerSize);
switch(nxDir)
    case 0      % north-west
        kern.krow(find(kern.krow>0)) = [];
        kern.kcol(find(kern.kcol>0)) = [];
    case 1      % west        
        kern.kcol(find(kern.kcol>=0)) = [];
    case 2      % south-west
        kern.krow(find(kern.krow<0)) = [];
        kern.kcol(find(kern.kcol>0)) = [];
    case 16     % north
        kern.krow(find(kern.krow>=0)) = [];
    case 17     % reached
        kern.krow = []; kern.kcol = [];        
    case 18     % south
        kern.krow(find(kern.krow<=0)) = [];
    case 32     % north-east
        kern.krow(find(kern.krow>0)) = [];
        kern.kcol(find(kern.kcol<0)) = [];
    case 33     % east
        kern.kcol(find(kern.kcol<=0)) = [];
    case 34     % south-east
        kern.krow(find(kern.krow<0)) = [];
        kern.kcol(find(kern.kcol<0)) = [];
end



function res = cmpVal(v1, v2)
if(v2<v1)
    res = 0;
elseif(v1==v2)
    res = 1;
else
    res = 2;
end

