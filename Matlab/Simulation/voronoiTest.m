function voronoiTest()
data = load('data.mat');    plotit = 1;

numObstPoints = length(data.obstPoints);    obstPoints = zeros(2,numObstPoints);
rc = zeros(2,numObstPoints);
numPts = size(data.dataGPN.xVals,2);    dist = zeros(2,numPts);
startLocn = [data.startLocn.x; data.startLocn.y];

for o=1:numObstPoints
    obstPoints(:,o) = data.obstPoints(:,o) - startLocn;
    for n = 1:numPts
        dist(1,n) = abs(obstPoints(1,o) - data.dataGPN.xVals(1,n));
        dist(2,n) = abs(obstPoints(2,o) - data.dataGPN.yVals(n,1));
        shiftx(n,:) = data.dataGPN.xVals(n,:) + startLocn(1);
        shifty(:,n) = data.dataGPN.yVals(:,n) + startLocn(2);
    end
    [unused, col] = min(dist(1,:));   [unused, row] = min(dist(2,:));
    actualObst(:,o) = [data.dataGPN.xVals(1,col); data.dataGPN.yVals(row,1)] + startLocn;
    rc(:,o) = [row; col];
end
disp(actualObst);
overlay = zeros(numPts, numPts);    
overlay = populateOverlay(overlay, rc);
if(plotit)
%     plotSurface(shiftx,shifty,data.dataGPN.zVals);    
    plotSurface(shiftx,shifty,overlay);    
end
xs = data.obstPoints(1,:);   ys = data.obstPoints(2,:);   
% xs = [xs data.dataGPN.xVals(1,1) data.dataGPN.xVals(1,1) data.dataGPN.xVals(1,numPts) data.dataGPN.xVals(1,numPts)] + startLocn(1);
% ys = [ys data.dataGPN.yVals(1,1) data.dataGPN.yVals(numPts,1) data.dataGPN.yVals(1,1) data.dataGPN.yVals(numPts,1)] + startLocn(2);
figure; grid on; hold on;voronoi(xs,ys);hold off;
[vx,vy] = voronoi(xs, ys);

brk = 1;



function plotSurface(xVals, yVals, zVals)
figure; grid on; hold on;
surf(xVals, yVals, zVals);
colormap(jet); shading interp; lighting phong;
hold off;



function matrx = populateOverlay(matrx, obstRC)
numPts = size(matrx,2); threshold = 10;
numObsts = size(obstRC,2);  dists = zeros(1,(numObsts));
for n = 1:numPts
    for m = 1:numPts
        for o = 1:numObsts
            dists(o) = sqrt(sum((([n;m])-obstRC(:,o)).^2));
        end
%         dists(o+1) = sqrt(sum((([n;m])-([1;1])).^2));
%         dists(o+2) = sqrt(sum((([n;m])-([1;numPts])).^2));
%         dists(o+3) = sqrt(sum((([n;m])-([numPts;1])).^2));
%         dists(o+4) = sqrt(sum((([n;m])-([numPts;numPts])).^2));
        md = min(dists);
        if(md<threshold)
            matrx(n,m) = md;
        else
            matrx(n,m) = threshold;
        end
    end
end
