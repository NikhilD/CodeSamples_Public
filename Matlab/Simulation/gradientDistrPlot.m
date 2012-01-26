function nxPoint = gradientDistrPlot(motes, neighs, startLocn, obstPoints, rbfunction)
numPoints = length(neighs(1,:));   numObstPts = size(obstPoints,2);
X_inp = zeros(2,numPoints+1+numObstPts);    gradVal = zeros(1,numPoints+1+numObstPts);
temprVal = zeros(1,numPoints+1+numObstPts); altiVal = zeros(1,numPoints+1+numObstPts);    
dummy = zeros(1,numPoints);
[doExtraElem, plotLocn] = compareLocn(motes, neighs, startLocn);
for m = 1:numPoints
    mt = neighs(1,m);
    X_inp(1,m) = motes(mt).x - startLocn.x; 
    X_inp(2,m) = motes(mt).y - startLocn.y;    
    if(~numObstPts)
        gradVal(m) = motes(mt).gpn;
        temprVal(m) = motes(mt).Tempr;
        altiVal(m) = motes(mt).alti;
    else
        inObst = sum(motes(mt).inSqr) + sum(motes(mt).inTri);
        if(~inObst)
            gradVal(m) = motes(mt).gpn;
            temprVal(m) = motes(mt).Tempr;
            altiVal(m) = motes(mt).alti;
        else
            gradVal(m) = motes(mt).gpn/1e4;
            temprVal(m) = motes(mt).Tempr/1e4;
            altiVal(m) = motes(mt).alti/1e4;
        end
    end
    dummy(m) = motes(mt).gpn;
end
if(doExtraElem)
    X_inp(1,(numPoints+1))=0; X_inp(2,(numPoints+1))=0;       
    gradVal(numPoints+1) = (min(gradVal(1:numPoints))+max(gradVal(1:numPoints)))/2;     
    temprVal(numPoints+1) = (min(temprVal(1:numPoints))+max(temprVal(1:numPoints)))/2;
    if(strcmp(rbfunction,'invMultiQuadric'))
        gradVal(numPoints+1) = startLocn.gpn;     
        temprVal(numPoints+1) = startLocn.Tempr;
    end    
    altiVal(numPoints+1) = startLocn.Alti;
    plotLocn.gpn = gradVal(numPoints+1); plotLocn.Tempr = temprVal(numPoints+1);
    plotLocn.Alti = altiVal(numPoints+1);
    obstIdx = numPoints+1;
else
    X_inp(:,(numPoints+1)) = [];    obstIdx = numPoints;
    gradVal(numPoints+1) = [];      temprVal(numPoints+1) = [];
    altiVal(numPoints+1) = [];
end
for o = 1:numObstPts
    divsr = 1e5;
    X_inp(:,(obstIdx+o)) = obstPoints(:,o) - [startLocn.x; startLocn.y];
    gradVal(obstIdx+o) = min(gradVal(1:obstIdx))/divsr;
    temprVal(obstIdx+o) = min(temprVal(1:obstIdx))/divsr;
    altiVal(obstIdx+o) = min(altiVal(1:obstIdx))/divsr;
end
field.x1 = min(X_inp(1,:)); field.x2 = max(X_inp(1,:));
field.y1 = min(X_inp(2,:)); field.y2 = max(X_inp(2,:));

pause(0.25); [pointGPN, dataGPN, trainedgp] = doThinPlate_wRBFGrDe(field, X_inp, gradVal, 0, 8, rbfunction, plotLocn.gpn);
% pause(0.25); [pointTEMPR, dataTEMPR, trainedtmp] = doThinPlate_wRBFGrDe(field, X_inp, temprVal, 0, 8, rbfunction, plotLocn.Tempr);
% pause(0.25); [pointALTI, dataALTI, trainedalti] = doThinPlate_wRBFGrDe(field, X_inp, altiVal, 0, 8, rbfunction, plotLocn.Alti);
pointTEMPR = pointGPN;  trainedtmp = 1;     
pointALTI = pointGPN;   trainedalti = 1;

if((isnan(pointGPN.gradVal))||(isnan(pointTEMPR.gradVal))||(isnan(pointALTI.gradVal))||(~trainedgp)||(~trainedtmp)||(~trainedalti))
    [unused, indx] = max(dummy);
    nxPoint = motes(neighs(1,indx));
    return;
end
plotHist(dataGPN.zVals, 1);
% goAround_onMatrix(pointGPN, startLocn, dataGPN, rgb('Brown'));
% goAround_wAltitude(pointGPN, startLocn, dataGPN, dataALTI, rgb('Red'));

point.x  = (pointGPN.x + pointTEMPR.x) / 2;     point.y  = (pointGPN.y + pointTEMPR.y) / 2;
nxPoint.x = point.x + startLocn.x;  nxPoint.y = point.y + startLocn.y;
nxPoint.gpn = pointGPN.gradVal;    nxPoint.Tempr = pointTEMPR.gradVal;  nxPoint.Alti = pointALTI.gradVal;
nxPoint.id = 1;


function [doExtraElem, plotLocn] = compareLocn(motes, neighs, startLocn)
numPoints = length(neighs(1,:));     doExtraElem = 1;    plotLocn = [];
for m = 1:numPoints
    mt = neighs(1,m);
    if((motes(mt).x==startLocn.x)&&(motes(mt).y==startLocn.y)) 
        doExtraElem = 0;        
        plotLocn.gpn = motes(mt).gpn;     plotLocn.Tempr = motes(mt).Tempr; 
        plotLocn.Alti = motes(mt).alti; 
        break;
    end
end


function plotHist(gradVals, plotit)
rows = size(gradVals,1);
cols = size(gradVals,2);
values = reshape(gradVals, 1, (rows*cols));
if(plotit)
    figure; grid on; hold on;
    hist(values);
    hold off;
end