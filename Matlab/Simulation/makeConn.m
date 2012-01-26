function [nextlink, nxPoint] = makeConn(field, mote, motes, colour, nxPoint, tgtID, obstacle)
neighs = mote.neighbors;    global PLOTIT;
numNeigh = length(neighs);  nextlink = 0;
if(mote.visited==0)
    nextlink = 0;
    return;
end
if(numNeigh~=0)    
    switch(colour)
        case 'm'   
            stPoint = nxPoint;      
            [nxPoint, nextlink] = getNextPt_wRBF(motes, stPoint, tgtID, obstacle, 'thinPlate');
        case 'k'   
            stPoint = nxPoint;      
            [nxPoint, nextlink] = getNextPt_wRBF(motes, stPoint, tgtID, obstacle, 'gaussian');
        case 'b'   
            stPoint = nxPoint;      
            [nxPoint, nextlink] = getNextPt_wRBF(motes, stPoint, tgtID, obstacle, 'invMultiQuadric');
        otherwise
            dumGpn = ones(2,numNeigh)*(-1000);
            for n = 1:numNeigh
                mt = neighs(n);
                dumGpn(1,n) = motes(mt).gpn;
                dumGpn(2,n) = mt;
            end
            stPoint = mote;
            [maxgpn, dnext] = max(dumGpn,[],2);
            nextlink = dumGpn(2,dnext(1));
            nxPoint = motes(nextlink);
    end    
    if(nextlink==0)
        return;
    end
    if(isempty(nxPoint))
        nextlink=0;
        return;
    end    
    if(isempty(PLOTIT))
        pause(0.0025);
        figure(field.figMain);
        plotLine(stPoint, nxPoint ,colour);
    elseif(PLOTIT==1)
        pause(0.0025);
        figure(field.figMain);
        plotLine(stPoint, nxPoint, colour);
    end
end


