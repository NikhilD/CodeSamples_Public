function motes = assign_HC(motes)
numMotes = length(motes);
for m = 1:numMotes    
    neighs = motes(m).neighbors;
    numNeigh = length(neighs);
    if(numNeigh~=0)
        for n = 1:numNeigh
            mt = neighs(n);                    
            motes(m).neighHC(mt) = motes(mt).hopCnt + 1; % this is because the calculation is for when I (i.e. 'm')...
        end
    end
end

