function locn = assignObstLenGen(motes, locn, neighbors, obstacle)

numNeigh = length(neighbors);
for n = 1:numNeigh
    mt = neighbors(n);
    [locn, obstlenS] = squareRSS(obstacle.square, motes, locn, mt);    
    [locn, obstlenT] = triangleRSS(obstacle.triangle, motes, locn, mt);        
    oblen = [obstlenS obstlenT];
    locn.Obstwifi(mt) = max(oblen);
end



function [locn, di] = squareRSS(square, motes, locn, neigh)
numSqr = length(square);
for s = 1:numSqr
    X1 = square(s).x;
    Y1 = square(s).y;
    X2 = [locn.x motes(neigh).x];
    Y2 = [locn.y motes(neigh).y];
    [X0,Y0,unused,unused] = intersections(X1,Y1,X2,Y2);
    if(length(X0)==2)
        pt1.x = X0(1); pt1.y = Y0(1);
        pt2.x = X0(2); pt2.y = Y0(2);            
        di(s) = ObjectDist(pt1, pt2);        
        locn.Obstwifi(neigh) = di(s);        
%         displ = ['Node:' num2str(locn.id) ', Neighbor:' num2str(neigh) ', ObstLen:' num2str(locn.Obstwifi(neigh))];
%         disp(displ);
    elseif(length(X0)==1)
        pt.x = X0(1); pt.y = Y0(1);
        [locn, di(s)] = findLink(motes, locn, neigh, pt, 'square');
%         displ = ['Node:' num2str(locn.id) ', Neighbor:' num2str(neigh) ', ObstLen:' num2str(locn.Obstwifi(neigh))];
%         disp(displ);
    else
        di(s) = 0;
        locn.Obstwifi(neigh) = di(s);
    end    
end



function [locn, di] = triangleRSS(triangle, motes, locn, neigh)
numTri = length(triangle);
for t = 1:numTri
    X1 = triangle(t).x;
    Y1 = triangle(t).y;
    X2 = [locn.x motes(neigh).x];
    Y2 = [locn.y motes(neigh).y];
    [X0,Y0,unused,unused] = intersections(X1,Y1,X2,Y2);
    if(length(X0)==2)
        pt1.x = X0(1); pt1.y = Y0(1);
        pt2.x = X0(2); pt2.y = Y0(2);            
        di(t) = ObjectDist(pt1, pt2);
        locn.Obstwifi(neigh) = di(t);
%         displ = ['Node:' num2str(locn.id) ', Neighbor:' num2str(neigh) ', ObstLen:' num2str(locn.Obstwifi(neigh))];
%         disp(displ);
    elseif(length(X0)==1)
        pt.x = X0(1); pt.y = Y0(1);
        [locn, di(t)] = findLink(motes, locn, neigh, pt, 'triangle');
%         displ = ['Node:' num2str(locn.id) ', Neighbor:' num2str(neigh) ', ObstLen:' num2str(locn.Obstwifi(neigh))];
%         disp(displ);
    else
        di(t) = 0;
        locn.Obstwifi(neigh) = di(t);
    end   
end



function [locn, di] = findLink(motes, locn, neigh, pt, type)
switch(type)
    case 'square'        
        pt1.x = motes(neigh).x; pt1.y = motes(neigh).y;
        di = ObjectDist(pt1, pt);
        locn.Obstwifi(neigh) = di;
    case 'triangle'
        pt1.x = motes(neigh).x; pt1.y = motes(neigh).y;
        di = ObjectDist(pt1, pt);
        locn.Obstwifi(neigh) = di;
end
    


