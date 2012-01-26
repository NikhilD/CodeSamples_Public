function [motes,neighbors] = getNeighbors(me, motes, neigh_diameter, obstacle, linkFailure)
numMotes = length(motes);   id = [];     neigh_dist = [];
dist = ones(numMotes,1)*100000; 

for m = 1:numMotes
    if(motes(m).id ~= me.id)
        dist(m) = ObjectDist(motes(m), me);
        if (dist(m) < neigh_diameter)
            neigh_dist = [neigh_dist dist(m)];
            id = [id m];
        end
    end
end
if(~isempty(id))
    idlen = length(id);   neighbors = zeros(idlen,1);
    [unused, indxs] = sort(neigh_dist, 'ascend');
    for i = 1:idlen    
        neighbors(i) = id(indxs(i));
    end

    if(~isempty(obstacle))
        motes(me.id) = assignObstLenGen(motes, motes(me.id), neighbors, obstacle);
    end
    [motes, neighs] = getNeighRSS(motes, me.id, neighbors);
    neighbors = neighs;

    if(linkFailure~=0) 
        neighbors = dropLinks(linkFailure, neighbors);
    end
else
    neighbors = [];
end


function neighbors = dropLinks(failRate, neighs)
numNeigh = length(neighs);
numDrops = ceil(failRate*numNeigh);
neighbors = neighs;
if(numDrops>0)
    dropPts = fix(1 + numNeigh.*rand(numDrops,1));    
    neighbors(dropPts) = [];
end


