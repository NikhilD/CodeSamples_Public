function mote = rankGPdelta(mote, motes)
neighs = mote.neighbors; numNeigh = length(neighs);
delta = 0;
if(numNeigh~=0)
    for n = 1:numNeigh
        mt = neighs(n);
        gpd = motes(mt).gpnMod;  prob = mote.neighProb(n);        
        if((gpd~=0)&&(prob>delta))
            mote.gpdelRank(mt) = (gpd - mote.gpnMod)*prob;            
        end
    end
end
