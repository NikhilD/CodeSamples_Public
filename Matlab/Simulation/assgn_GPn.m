function [motes, gpvals, tgtID] = assgn_GPn(field,motes,target,obstacle,alpha,beta,writeXL,plotit)
%%%%%%%%%%%%%%%%%%%%%%%%
% Global variables... if run by external program
% global LEVEL;   global TGTID;
% tgtID = TGTID;      level = LEVEL;
%%%%%%%%%%%%%%%%%%%%%%%%

numMotes = length(motes);  maxAlgoIter = numMotes + 10;     ColIndex = 65;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uncomment the following lines up to the next "%%%%..." to run local program 
for j = 1:maxAlgoIter
    level(j).nodes = [];
end
[motes, tgtID] = getTarget(field, motes, target, obstacle,plotit);
level(1).nodes = tgtID;
level(2).nodes = motes(tgtID).neighbors;
[motes, level] = init_hops(field, motes, level, maxAlgoIter,plotit);
motes = assign_HC(motes);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

motes(tgtID).gpn = 100;

for t = 2:2
    motes(tgtID).visited = t;     
    for j = 2:maxAlgoIter
        numLvl = length(level(j).nodes);
        for nL = 1:numLvl
            k = level(j).nodes(nL);
            if(motes(k).visited==(t-1))
                motes(k).visited = t;
                motes(k) = calcGpn(motes,motes(k),alpha);     % scaling RSS and multiplying!
            end
        end
        ljp = level(j+1).nodes;
        if(isempty(ljp)),break,end
    end
    gpvals = writeGPn(motes, ColIndex, writeXL);
    ColIndex = ColIndex + 2;    
end
for m = 1:numMotes
    motes(m) = rankGpn(motes,motes(m),beta);
end



function gpvals = writeGPn(motes, Col, writeXL)
numMotes = length(motes); 
gpvals = zeros(1,numMotes);
for m = 1:numMotes
    gpvals(m) = motes(m).gpn;
end
if(writeXL)
    [sorted, indic] = sort(gpvals, 'descend');
    gpval = [sorted' indic'];
    a = char(Col); b = '1';
    v = strcat(a,b);
    xlswrite('GPnvals.xlsx', gpval, 'GPndata', v);
end

