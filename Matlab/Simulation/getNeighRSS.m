function [motes, neighs] = getNeighRSS(motes, me, neighbors)

numNeigh = length(neighbors);
neighs = [];

if(numNeigh~=0)
    for n = 1:numNeigh
        mt = neighbors(n);
        rssi = distTorss(motes(me),motes(mt));
        if(rssi>=motes(me).rfConfig.sensitivity)                
            motes(me).rfRSS(mt) = rssi;     
            neighs = [neighs mt];        
        end
    end    
end