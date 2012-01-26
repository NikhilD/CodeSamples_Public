function mote = modifyGpn(motes, mote)
neighs = mote.neighbors;    numNeigh = length(neighs);
if(numNeigh~=0)
    PGNeigh = [];
    for n = 1:numNeigh
        mt = neighs(n);
        if((mote.gpnMod<motes(mt).gpnMod)&&(mote.Obstwifi(mt)==0))           
           PGNeigh = [PGNeigh mt];
        end          
    end
    if(isempty(PGNeigh))
        mote.gpnMod = 0;
    end
end
