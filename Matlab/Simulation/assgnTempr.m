function motes = assgnTempr(motes, target)
numMotes = length(motes);

sigma = 5.67e-8;
source.x = target.x;    source.y = target.y;
source.Tm = 100;   % degC
source.Rn = sigma*((source.Tm)^4);

for m = 1:numMotes
    [actualDist, actualTempr] = getDistTempr(source, motes(m), sigma);
    motes(m).Tempr = actualTempr;
    motes(m).tgtDist = actualDist;
end


function [dist, tempr] = getDistTempr(source, mote, sigma)
dist = ObjectDist(source, mote);
tempr = getTempr(dist, source, sigma);


function tempr = getTempr(dist, source, sigma)
if(isempty(dist))
    tempr = 0;
    return;
end
if(dist<1)
    radN = source.Rn/(dist+1);
else
    radN = source.Rn/(dist^2); % if dist is less than one, radN will be greater than source.Rn, meaning tempr will be greater!
end
tempr = nthroot((radN/sigma), 4);

