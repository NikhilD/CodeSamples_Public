function mote = rankGpn(motes,mote,beta)
neighs = mote.neighbors;    numNeigh = length(neighs);
if(numNeigh~=0)
    dum1gpm = ones(4,numNeigh)*(-1000);
    for n = 1:numNeigh
        mt = neighs(n);
        dum1gpm(1,n) = motes(mt).gpn;
        dum1gpm(2,n) = mt;
        dum1gpm(3,n) = mote.neighHC(mt);
        dum1gpm(4,n) = mote.rssScale(mt);
    end    
    [maxm, indm] = max(dum1gpm,[],2);
    maxgpn = maxm(1);   maxrss = maxm(4);
    if(maxgpn==0)
        maxgpn = 1;
    end
    dum2gpm = ones(2,numNeigh)*(-1000);
    for n = 1:numNeigh        
        dum2gpm(1,n) = dum1gpm(1,n)/maxgpn;
        dum2gpm(2,n) = dum1gpm(4,n)/maxrss;
        gpn = dum2gpm(1,n)^beta(3);
        rssi = dum2gpm(2,n)^beta(1);
        hc = dum1gpm(3,n)^beta(2);
        mote.neighRank(dum1gpm(2,n)) = ((gpn + rssi)/(hc)); %/2
    end    
end


