function mote = calcGpn(motes,mote,alpha)
neighs = mote.neighbors;    numNeigh = length(neighs);
if(numNeigh~=0)
    dumGpm = ones(7,numNeigh)*(-1000);
    for n = 1:numNeigh
        mt = neighs(n);
        [dumGpm(1,n), dumGpm(7,n)] = calcGpm(motes(mt).gpn,mote.neighHC(mt),mote.rfRSS(mt),alpha(1),alpha(2),alpha(3),mote.rfConfig.sensitivity,mote.rfConfig.minRange);
        mote.gpm(mt) = dumGpm(1,n);
        dumGpm(2,n) = mt;
        dumGpm(3,n) = mote.neighHC(mt);
        dumGpm(4,n) = mote.rfRSS(mt);
        dumGpm(5,n) = motes(mt).gpn;
        mote.gpdelta(mt) = motes(mt).gpn - mote.gpm(mt);
        dumGpm(6,n) = mote.gpdelta(mt);
        mote.rssScale(mt) = dumGpm(7,n);
    end
    [maxm, indm] = max(dumGpm,[],2);
    mote.gpn = maxm(1);
    mote.gpnMod = mote.gpn;
    delScale = dumGpm(6,:)./maxm(6);
    for n = 1:numNeigh
        mt = dumGpm(2,n);
        mote.gpdelScale(mt) = delScale(n);
    end
end



function [gpm, rssi] = calcGpm(recvdgpn,hopCnt,rss,alpha,beta,gamma,sensitivity,minRange)
% rssi = (10^(rss/100))^alpha;
rss = valueScaling(rss, minRange, sensitivity, 1, 0);
rssi = rss^alpha;
hc = ((hopCnt)^beta);
gpm = recvdgpn*((rssi/hc)^gamma);

