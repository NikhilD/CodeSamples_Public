function [area, pathLen, shortest, routeLen, fail] = RBFwNoise_main(nodes, fieldRge, rssNoise, angleNoise, numExpt, plotit)
global PLOTIT;  PLOTIT = plotit;
%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables... if run by external program
% global MOTES;   nodes = MOTES;  numMotes = length(nodes);
% global ALPHA;   global BETA;    alpha = ALPHA;  beta = BETA;
% global OBSTACLE;    obstacle = OBSTACLE;
% writeXL = 0;    target = 0;     
% 
% motes = modify_motes(numMotes, nodes, obstacle);
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uncomment the following lines up to the next "%%%%..." to run local program 
numMotes = length(nodes);     percentObst = 5;      
rfConfig.freq = 2.45e9;  rfConfig.model = 'friis';   rfConfig.rfPower = 0.5;   rfConfig.minRange = -15;   
rfConfig.ple = 1.5;    rfConfig.sigma = 5;    rfConfig.sensitivity = -85;  rfConfig.noise = rssNoise;
rfConfig.linkFailure = 0;   rfConfig.angleNoise = angleNoise;   
rfConfig.rxRate = 0.95;     rfConfig.loss = 1;   rfConfig.antnGain = 1;
obstFactor = 100;       altMax = 25;
doLine = 0;     writeXL = 0;    numTgts = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
% control indices
% alpha ~ calculation of GPn
% beta ~ neighborhood gradient control
% [forRSS forHC forGPn]
alpha = [1 0 1];
% beta = [0.001 0.001 0.8];
beta = [1 0 0.1];
%%%%%%%%%%%%%%%%%%%%%%%%%
field = makeField(fieldRge,fieldRge,plotit);     
target = makeTarget(field, numTgts, plotit);
obstacle = formObst(field, percentObst, obstFactor, plotit);
altitude = altMax*rand(1,numMotes);

motes = modify_motes(field, numMotes, nodes, rfConfig, obstacle, plotit);

for m = 1:numMotes
%     motes(m) =  plot_coord(field,numMotes,m,rfConfig,obstacle,plotit);    
    motes(m).alti = altitude(m);
    nr = rssTodist(rfConfig.sensitivity,motes(m).rfConfig);
    motes(m).neigh_radius = nr;
end
[motes, avgNeigh] = getNeigh(motes,0,obstacle,rfConfig.linkFailure,doLine);
% avgN = ['avgNeighs: ' num2str(avgNeigh)];   disp(avgN);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[motes, gpvals, targetID] = assgn_GPn(field,motes,target,obstacle,alpha,beta,writeXL,plotit);
motes = assgnTempr(motes, target);
[area, pathLen, shortest, routeLen, fail] = tracePath(field, motes, gpvals, targetID, obstacle);
% doThinPlateGlobal(field.x, motes, gpvals, route(1).point, route(2).point, 1);
displ = ['Nodes:' num2str(numMotes) ', RSSNoise%:' num2str(rssNoise) ', AngleNoise%:' num2str(angleNoise) ', Expt.:' num2str(numExpt)];
disp(displ);
brk = 1;



function [area, pathLen, shortest, routeLen, fail] = tracePath(field, motes, gpvals, tgtID, obstacle)
trace = ['c' 'm'];% 'k' 'b'];
indices = find(gpvals==0);
if(~isempty(indices))
    for i = 1:length(indices)
        gpvals(indices(i)) = 1000;
    end
end
% [minm, startNode] = min(gpvals);
startPt.x = (450/500)*field.x;    startPt.y = (25/500)*field.x;
startNode = getStartNode(motes, startPt, obstacle);
[area, pathLen, shortest, routeLen, fail] = traceNavi(field,motes,trace,tgtID,startNode,obstacle);



function [area, pathLen, shortest, routeLen, fail] = traceNavi(field,motes,trace,tgtID,startNode,obstacle)
if(isempty(obstacle))
    obst = 0;
else
    obst = 1;
end
numMotes = length(motes);   fail = ones(1,length(trace))*(-1);
area = zeros(1,length(trace));  pathLen = zeros(1,length(trace));  
shortest = zeros(1,length(trace));  routeLen = zeros(1,length(trace));
for j = 1:length(trace)    
    Nlink = startNode;      nxPoint = motes(Nlink);
    fail(j) = 0;    
    for m = 1:numMotes                
        route(j).point(m).node = motes(Nlink);  route(j).point(m).locn = nxPoint;
        [Nlink, nxPoint] = makeConn(field, motes(Nlink), motes, trace(j), nxPoint, tgtID, obstacle);
        if(Nlink==(-1))
            Nlink = startNode;
        end        
        if(Nlink==tgtID)            
            route(j).point(m+1).node = motes(Nlink);  route(j).point(m+1).locn = nxPoint;            
            [area(j), pathLen(j), shortest(j), routeLen(j)] = findArea(route(j).point, trace(j));
            break;
        elseif(Nlink==0)
            fail(j) = 1;  
            route(j).point(m+1).node = 0;  route(j).point(m+1).locn = nxPoint;            
            displ = ['       trace: ' trace(j)];
            disp(displ);
            break;
        end
    end    
end

