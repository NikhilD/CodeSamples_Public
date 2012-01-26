function [area, pathLen, shortest, numPath] = findArea(route, trace)
numPath = length(route);

switch(trace)
    case 'c'
        for n = 1:numPath
            path(n).data = route(n).node;
        end
    otherwise
        for n = 1:numPath
            path(n).data = route(n).locn;
        end        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find shortest path line eqn.
startNode.x = path(1).data.x;     startNode.y = path(1).data.y;
endNode.x = path(numPath).data.x; endNode.y = path(numPath).data.y;
shortest = ObjectDist(startNode, endNode);
denom = (endNode.x - startNode.x);
slope = (endNode.y - startNode.y)/denom;
interceptShrt = ((endNode.x*startNode.y)-(startNode.x*endNode.y))/denom;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

node(1).x = startNode.x;    node(1).y = startNode.y;
node(1).intercept = 0;
node(1).intersec.x = node(1).x;
node(1).intersec.y = node(1).y;

for i = 2:(numPath-1)
    node(i).x = path(i).data.x;   node(i).y = path(i).data.y;
    node(i).intercept = node(i).y - ((-slope)*node(i).x);       % the line perpendicular to the shortest path from the pathNode
    node(i).intersec.x = (node(i).intercept - interceptShrt)/(2*slope);
    node(i).intersec.y = (node(i).intercept + interceptShrt)/2;
end

node(numPath).x = endNode.x;    node(numPath).y = endNode.y;
node(numPath).intercept = 0;
node(numPath).intersec.x = node(numPath).x;
node(numPath).intersec.y = node(numPath).y;


% find pathLength
pathLengths = zeros(1,(numPath-1));
for i = 1:(numPath-1)
    pathLengths(i) = ObjectDist(node(i),node(i+1));
end
pathLen = sum(pathLengths);

% find Area Under Curve
areas = zeros(1,(numPath-1));
% areas(1) = areaTriangle(node(1),node(2));
for i = 1:(numPath-1)
    areas(i) = areaTrapeze(node(i),node(i+1));    
end
% areas(numPath-1) = areaTriangle(node(numPath),node(numPath-1));
area = sum(areas);
