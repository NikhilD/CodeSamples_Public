function [motes, avgNeigh] = getNeigh(motes,noNeigh,obstacle,linkFailure,doLine)
numMotes = length(motes);
Tneighs = [];
for m = 1:numMotes
    if(noNeigh),break,end   
    pause(0.0025);
    motes(m).neighbors = [];
    [motes, neighbors] = getNeighbors(motes(m), motes, motes(m).neigh_radius, obstacle, linkFailure);
    numNeigh = length(neighbors);
    for n = 1:numNeigh
        if(doLine)
            x = [motes(m).x motes(neighbors(n)).x];
            y = [motes(m).y motes(neighbors(n)).y];            
            motes(m).conn(n).line = line(x,y,'Color','k');
        end
        motes(m).neighbors = [motes(m).neighbors neighbors(n)];
    end
    Tneighs = [Tneighs numNeigh];
end
avgNeigh = mean(Tneighs);

