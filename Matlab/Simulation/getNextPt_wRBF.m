function [point, nextlink] = getNextPt_wRBF(motes, startLocn, tgtID, obstacle, rbfunction)
numMotes = length(motes);   nextlink = -1; i=1;
distToneigh = zeros(numMotes,1);    angleToneigh = zeros(numMotes,1); 
rssNeigh = zeros(numMotes,1);
neighData = [];
for m = 1:numMotes
    [unused, angleToneigh(m)] = ObjectDist(startLocn, motes(m));
    rssNeigh(m) = distTorss(motes(m),startLocn);
    distToneigh(m) = rssTodist(rssNeigh(m),motes(m).rfConfig);
    angleToneigh(m) = addNoise(motes(m).rfConfig.angleNoise,angleToneigh(m));
    if(distToneigh(m)<=motes(m).neigh_radius)        
        neighData(1,i) = m;
        neighData(2,i) = distToneigh(m);
        neighData(3,i) = angleToneigh(m);
        i=i+1;
    end
end
if(isempty(neighData))
    point = [];
    nextlink = 0;
    return;
end
if(~isempty(find((neighData(1,:)==tgtID), 1)))
    point = motes(tgtID);
    nextlink = tgtID;
    return;
end
obstPoints = [];
if(~isempty(obstacle))
    obstPoints = getObstPoints(motes(1).neigh_radius-50, startLocn, obstacle);
end

% point = gradientDistrPlot(motes, neighData, startLocn, obstPoints, rbfunction);
point = localInterp(motes, neighData, startLocn, obstPoints, rbfunction);


function obstPoints = getObstPoints(range, startLocn, obstacle)
startxy = [startLocn.x; startLocn.y];   obstPoints = [];
squares = obstacle.square;  triangles = obstacle.triangle;
numSqr = length(squares);   numTri = length(triangles);
for s = 1:numSqr
    XY = [squares(s).x; squares(s).y];    N = size(XY,2);
    dists = zeros(1,N);
    for n = 1:N    
        dists(n)=sqrt(sum((startxy(:) - XY(:,n)).^2));
        if(dists(n)<range)
            point = XY(:,n) - startxy(:);
            obstPoints = [obstPoints point];
        end
    end
end
for t = 1:numTri
    XY = [triangles(t).x; triangles(t).y];    N = size(XY,2);
    dists = zeros(1,N);
    for n = 1:N    
        dists(n)=sqrt(sum((startxy(:) - XY(:,n)).^2));
        if(dists(n)<range)
            point = XY(:,n) - startxy(:);
            obstPoints = [obstPoints point];
        end
    end
end
    


    

